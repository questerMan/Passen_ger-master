//
//  HistoryViewController.m
//  DriverProject
//
//  Created by 林镇杰 on 15/9/15.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "HistoryViewController.h"
#import "BlankPage.h"

#define PER_PAGE            @"10"

@interface HistoryViewController ()<UITableViewDataSource,UITableViewDelegate,BlankPageDelegate>
{
    UITableView *invoiceTable;
    
    int page;
    BOOL isMore;
}

@property(nonatomic, assign)NSInteger flag;

@property(nonatomic, strong)BlankPage *blankPage;

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发票历史";
    self.view.backgroundColor = RGB(249, 250, 251);
    
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(0, 0, 50, 40);
//    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -25, 0.0, 0.0)];
//    [backBtn addTarget:self action:@selector(backToLastView) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *leftitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = leftitem;
    
    invoiceTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStylePlain];
    
    invoiceTable.tableFooterView = [[UIView alloc]init];
    invoiceTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    invoiceTable.backgroundColor = [UIColor whiteColor];
    invoiceTable.delegate = self;
    invoiceTable.dataSource = self;
    [self.view addSubview:invoiceTable];
    
    __weak UITableView *tableView = invoiceTable;
    
    // 下拉刷新
    tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        page = 1;
        isMore = NO;
        
        [self loadInvoiceDataWithPage:page];
        // 结束刷新
        [tableView.header endRefreshing];
        [tableView reloadData];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.header.automaticallyChangeAlpha = YES;
    
    // 上拉加载
    tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        page = page + 1;
        isMore = YES;
        
        [self loadInvoiceDataWithPage:page];
        // 结束刷新
        [tableView.footer endRefreshing];
        [tableView reloadData];
    }];

    self.invoiceArray = [NSMutableArray array];
    self.invoiceListArray = [NSMutableArray array];
    page = 1;
    [self loadInvoiceDataWithPage:page];
}

#pragma - mark BlankPageDelegate
-(void)loadDataAgain
{
    [self loadInvoiceDataWithPage:page];
}

-(void)loadInvoiceDataWithPage:(int)page_number
{
    QiFacade *facade;
    facade = [QiFacade sharedInstance];
    _flag = [facade getInvoice:[NSString stringWithFormat:@"%d",page_number] Per_page:PER_PAGE];
    [facade addHttpObserver:self tag:_flag];
//    [self showLoadingWithText:@"Loading..."];
}

-(void)loadInvoiceDataFinish:(NSDictionary *)dataDic
{
    NSArray *content = [dataDic objectForKey:@"content"];
    
    if (isMore) {
        if (content.count == 0) {
            
            [self showTextOnlyWith:@"已没有更多记录"];
            
            return;
        }
    }else{
        
        if (content.count == 0) {
            
            self.blankPage = [[BlankPage alloc]initBlankPageFrame:CGRectMake(0, 100, self.view.width, 200) WithImg:[UIImage imageNamed:@"invoiceIcon"] AndTips:@"暂无开票历史"];
            _blankPage.blankPageDelegate = self;
            [self.view addSubview:_blankPage];
            
            return;
        }
    }
    
    NSMutableArray *untreatedArray = [NSMutableArray arrayWithCapacity:content.count];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:content.count];
    
    for (int i = 0; i < content.count; i ++) {
        
        NSDictionary *info = [content objectAtIndex:i];
        [untreatedArray addObject:info];
        InvoiceModel *invoiceModel = [[InvoiceModel alloc]initWithDataDic:info];
        [array addObject:invoiceModel];
    }
    
    if (isMore) {
        
        [self.invoiceArray addObjectsFromArray:untreatedArray];
        [self.invoiceListArray addObjectsFromArray:array];
        
    }else{
        
        self.invoiceArray = untreatedArray;
        self.invoiceListArray = array;
    }
    
    //    self.recordListArray = self.recordArray;
    
    [invoiceTable reloadData];
}

-(void)backToLastView
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma - mark UITableView DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.invoiceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    InvoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[InvoiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.invoiceModel = [self.invoiceListArray objectAtIndex:indexPath.row];
    [cell setNeedsLayout];
    
    return cell;
}

#pragma - mark 网络请求回调
-(void)requestFinished:(NSDictionary *)response tag:(NSInteger)iRequestTag
{
    [self dismissLoading];
    
    NSLog(@"成功\n%@",response);
    
    if (_flag != 0 && response != nil && iRequestTag == _flag) {
        
        _flag = 0;
        
        [self loadInvoiceDataFinish:response];
    }
    
}

-(void)requestFailed:(NSDictionary *)response tag:(NSInteger)iRequestTag
{
    [self dismissLoading];
    
    NSLog(@"失败66\n%@",response);
    
    if (_flag != 0 && response != nil && iRequestTag == _flag) {
        
        _flag = 0;
        
        [self showTextOnlyWith:[response objectForKey:@"message"]];
    }
}

#pragma - mark UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
