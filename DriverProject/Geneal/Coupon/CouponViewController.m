//
//  CouponViewController.m
//  DriverProject
//
//  Created by 林镇杰 on 15/9/13.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "CouponViewController.h"
#import "CouponCell.h"
#import "MJRefresh.h"
#import "BlankPage.h"

#define PER_PAGE        @"10"
#define LABEL_FONT              [UIFont systemFontOfSize:12]

@interface CouponViewController ()<UITableViewDataSource,UITableViewDelegate,BlankPageDelegate>
{
    UITableView *couponTable;
    int page;
    BOOL isMore;
}

@property(nonatomic, assign)NSInteger flag;

@property(nonatomic, strong)BlankPage *blankPage;

@end

@implementation CouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"优惠券";
    self.view.backgroundColor = RGB(249, 250, 251);
    
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(0, 0, 50, 40);
//    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -25, 0.0, 0.0)];
//    [backBtn addTarget:self action:@selector(backToLastView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 70, 40);
    [rightBtn setTitle:@"使用规则" forState:UIControlStateNormal];
    [rightBtn setTitleColor:kUIColorFromRGB(0x212121) forState:UIControlStateNormal];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [rightBtn addTarget:self action:@selector(goToUseRuleView) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    //self.navigationItem.rightBarButtonItem = rightItem;
    
//    UIBarButtonItem *leftitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = leftitem;
    
    page = 1;
    self.couponArray = [NSMutableArray array];
    self.couponListArray = [NSMutableArray array];
    
    [self createCouponListTableView];
    
    [self loadCouponDataWithPage:page];
}

-(void)createCouponListTableView
{
    couponTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, self.view.width, self.view.height) style:UITableViewStylePlain];
    couponTable.tableFooterView = [[UIView alloc]init];
    couponTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    couponTable.backgroundColor = [UIColor clearColor];
    couponTable.delegate = self;
    couponTable.dataSource = self;
    [self.view addSubview: couponTable];
    
    __weak UITableView *tableView = couponTable;
    
    // 下拉刷新
    tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        page = 1;
        isMore = NO;
        
        [self loadCouponDataWithPage:page];
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
        
        [self loadCouponDataWithPage:page];
        // 结束刷新
        [tableView.footer endRefreshing];
        [tableView reloadData];
    }];
}

-(void)loadDataAgain
{
    [self loadCouponDataWithPage:page];
}

-(void)loadCouponDataWithPage:(int)page_number
{
    QiFacade *facade;
    facade = [QiFacade sharedInstance];
    _flag = [facade getCoupons:[NSString stringWithFormat:@"%d",page_number] Per_page:PER_PAGE];
    [facade addHttpObserver:self tag:_flag];
//    [self showLoadingWithText:@"Loading..."];
    
    /*
    //测试数据
    NSDictionary *test1 = [NSDictionary dictionaryWithObjectsAndKeys:@"YES",@"isOverDate",@"20",@"money",@"首单优惠",@"couponType",@"有效期至2015-8-31",@"endtime", nil];
    NSDictionary *test2 = [NSDictionary dictionaryWithObjectsAndKeys:@"YES",@"isOverDate",@"30",@"money",@"国庆大典",@"couponType",@"有效期至2015-8-31",@"endtime", nil];
    NSDictionary *test3 = [NSDictionary dictionaryWithObjectsAndKeys:@"YES",@"isOverDate",@"20",@"money",@"中秋同欢",@"couponType",@"有效期至2015-8-31",@"endtime", nil];
    NSDictionary *test4 = [NSDictionary dictionaryWithObjectsAndKeys:@"YES",@"isOverDate",@"20",@"money",@"代金券",@"couponType",@"有效期至2015-8-31",@"endtime",@"满50元可用",@"condition", nil];
    NSDictionary *test5 = [NSDictionary dictionaryWithObjectsAndKeys:@"NO",@"isOverDate",@"20",@"money",@"撸出翔",@"couponType",@"有效期至2015-8-31",@"endtime", nil];
    NSDictionary *test6 = [NSDictionary dictionaryWithObjectsAndKeys:@"NO",@"isOverDate",@"20",@"money",@"代金券",@"couponType",@"有效期至2015-8-31",@"endtime",@"满50元可用",@"condition", nil];
    NSArray *testArray = [NSArray arrayWithObjects:test1,test2,test3,test4,test5,test6, nil];
    
    for (int i = 0; i < testArray.count; i ++) {
        
        CouponModel *couponModel = [[CouponModel alloc]initWithDataDic:[testArray objectAtIndex:i]];
        [self.couponArray addObject:couponModel];
    }
    
    [couponTable reloadData];
     */
}

-(void)loadCounponDataFinish:(NSDictionary *)dataDic
{
    
    NSArray *content = [dataDic objectForKey:@"content"];
    
    if (isMore) {
        if (content.count == 0) {
            
            [self showTextOnlyWith:@"已没有更多记录"];
            
            return;
        }
    }else{
        
        if (content.count == 0) {
            
            self.blankPage = [[BlankPage alloc]initBlankPageFrame:CGRectMake(0, 100, self.view.width, 200) WithImg:[UIImage imageNamed:@"couponIcon"] AndTips:@"暂无优惠券"];
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
        CouponModel *couponModel = [[CouponModel alloc]initWithDataDic:info];
        [array addObject:couponModel];
    }
    
    if (isMore) {
        
        [self.couponArray addObjectsFromArray:untreatedArray];
        [self.couponListArray addObjectsFromArray:array];
        
    }else{
        
        self.couponArray = untreatedArray;
        self.couponListArray = array;
    }
    
    [couponTable reloadData];
    
}

-(void)goToUseRuleView
{
    
}

#pragma - mark 网络请求回调
-(void)requestFinished:(NSDictionary *)response tag:(NSInteger)iRequestTag
{
    [self dismissLoading];
    
    NSLog(@"成功55\n%@",response);
    
    if (_flag != 0 && response != nil && iRequestTag == _flag) {
        
        _flag = 0;
        
        [self loadCounponDataFinish:response];
    }
    
}

-(void)requestFailed:(NSDictionary *)response tag:(NSInteger)iRequestTag
{
    [self dismissLoading];
    
    NSLog(@"失败44\n%@",response);
    
    if (_flag != 0 && response != nil && iRequestTag == _flag) {
        
        _flag = 0;
        
        [self showTextOnlyWith:[response objectForKey:@"message"]];
    }
    
}

-(void)backToLastView
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma - mark UITableView DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.couponArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    CouponCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[CouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.couponModel = [self.couponListArray objectAtIndex:indexPath.row];
    [cell setNeedsLayout];
    
    return cell;
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
