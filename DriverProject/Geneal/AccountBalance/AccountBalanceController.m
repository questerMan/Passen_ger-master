//
//  AccountBalanceController.m
//  DriverProject
//
//  Created by 林镇杰 on 15/9/22.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "AccountBalanceController.h"
#import "BlankPage.h"
#import "PaySuccessController.h"

#define LABEL_FONT              [UIFont systemFontOfSize:12]
#define LABEL_CELL_FONT         [UIFont systemFontOfSize:16]
#define PER_PAGE            @"10"
@interface AccountBalanceController ()<UITableViewDataSource,UITableViewDelegate,BlankPageDelegate>
{
    UILabel *amountLabel;
    UITableView *accountTable;
    int page;
    BOOL isMore;
}

@property(nonatomic, assign)NSInteger flag;
@property(nonatomic, assign)NSInteger userFlag;

@property(nonatomic, strong)BlankPage *blankPage;

@end

@implementation AccountBalanceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"账户余额";
    self.view.backgroundColor = RGB(249, 250, 251);
    
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(0, 0, 50, 40);
//    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -25, 0.0, 0.0)];
//    [backBtn addTarget:self action:@selector(backToLastView) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = leftitem;
    
    self.accountArray = [NSMutableArray array];
    
    self.accountListArray = [NSMutableArray array];
    
    page = 1;
    
    [self getUserData];
}

-(void)createTheCustomView
{
    UIView *amountBG= [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, 100)];
    amountBG.backgroundColor = [UIColor whiteColor];
    amountBG.layer.borderWidth = 0.5f;
    amountBG.layer.borderColor = COLOR_LINE.CGColor;
    [self.view addSubview:amountBG];
    
    UILabel *tips = [UIFactory createLabel:@"可用余额" Font:LABEL_FONT];
    tips.textAlignment = NSTextAlignmentCenter;
    
    amountLabel = [UIFactory createLabel:self.amountString Font:[UIFont systemFontOfSize:30]];//
    amountLabel.textAlignment = NSTextAlignmentCenter;
    amountLabel.textColor = kUIColorFromRGB(0xf4942d);
    
    [amountBG addSubview:tips];
    [amountBG addSubview:amountLabel];
    
    [tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(amountBG);
        make.top.equalTo(amountBG).offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 15));
    }];
    
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tips.mas_bottom);
        make.centerX.equalTo(amountBG);
        make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
    
    UILabel *incomeTips = [UIFactory createLabel:@"收支明细" Font:[UIFont systemFontOfSize:14]];
    incomeTips.textColor = [UIColor lightGrayColor];
    [self.view addSubview:incomeTips];
    [incomeTips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.top.equalTo(amountBG.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 15));
    }];
    
    accountTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    accountTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [accountTable.layer setBorderColor:COLOR_LINE.CGColor];
    [accountTable.layer setBorderWidth:0.5f];
    accountTable.tableFooterView = [[UIView alloc]init];
    accountTable.tableFooterView.backgroundColor = RGB(249, 250, 251);
    accountTable.delegate = self;
    accountTable.dataSource = self;
    [self.view addSubview:accountTable];
    
    [accountTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(incomeTips.mas_bottom).offset(5);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    __weak UITableView *tableView = accountTable;
    
    // 下拉刷新
    tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        page = 1;
        isMore = NO;
        
        [self loadAccountDataWithPage:page];
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
        
        [self loadAccountDataWithPage:page];
        // 结束刷新
        [tableView.footer endRefreshing];
        [tableView reloadData];
    }];
    
    [self loadAccountDataWithPage:page];
}

#pragma - mark BlankPageDelegate
-(void)loadDataAgain
{
    [self loadAccountDataWithPage:page];
}

-(void)loadAccountDataWithPage:(int)page_number
{
    QiFacade *facade;
    facade = [QiFacade sharedInstance];
    _flag = [facade getBalance:[NSString stringWithFormat:@"%d",page_number] Per_page:PER_PAGE];
    [facade addHttpObserver:self tag:_flag];
//    [self showLoadingWithText:@"加载中..."];
}

-(void)loadAccountDataFinish:(NSDictionary *)dataDic
{
    NSArray *content = [dataDic objectForKey:@"content"];
    
    if (isMore) {
        if (content.count == 0) {
            
            [self showTextOnlyWith:@"已没有更多记录"];
            
            return;
        }
    }else{
        
        if (content.count == 0) {
                        
            self.blankPage = [[BlankPage alloc]initBlankPageFrame:CGRectMake(0, 200, self.view.width, 200) WithImg:[UIImage imageNamed:@"accountIcon"] AndTips:@"暂无收支明细"];
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
        AccountModel *accountModel = [[AccountModel alloc]initWithDataDic:info];
        [array addObject:accountModel];
    }
    
    if (isMore) {
        
        [self.accountArray addObjectsFromArray:untreatedArray];
        [self.accountListArray addObjectsFromArray:array];
        
    }else{
        
        self.accountArray = untreatedArray;
        self.accountListArray = array;
    }
    
    [accountTable reloadData];
}

#pragma - mark 获取最新的个人资料
-(void)getUserData
{
    [self showLoadingWithText:@"加载中..."];
    QiFacade *facade;
    facade = [QiFacade sharedInstance];
    _userFlag = [facade getAccountData];
    [facade addHttpObserver:self tag:_userFlag];
}

-(void)getUserDataFinish:(NSDictionary *)dataDic
{
    NSLog(@"%@",dataDic);
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:dataDic];
    [UIFactory DeleteAllSaveDataNSUserDefaults];
    
    [UIFactory SaveNSUserDefaultsWithData:userData AndKey:@"userData"];
    [UIFactory SaveNSUserDefaultsWithData:[dataDic objectForKey:@"access_token"] AndKey:@"access_token"];
    [UIFactory SaveNSUserDefaultsWithData:[dataDic objectForKey:@"uuid"] AndKey:@"uuid"];
    [UIFactory SaveNSUserDefaultsWithData:[dataDic objectForKey:@"phone"] AndKey:@"phone"];
    [UIFactory SaveNSUserDefaultsWithData:[dataDic objectForKey:@"nickname"] AndKey:@"nickname"];
    [UIFactory SaveNSUserDefaultsWithData:[dataDic objectForKey:@"company_address"] AndKey:@"company_address"];
    [UIFactory SaveNSUserDefaultsWithData:[dataDic objectForKey:@"company_address_detail"] AndKey:@"company_address_detail"];
    [UIFactory SaveNSUserDefaultsWithData:[dataDic objectForKey:@"company_address_lat"] AndKey:@"company_address_lat"];
    [UIFactory SaveNSUserDefaultsWithData:[dataDic objectForKey:@"company_address_lon"] AndKey:@"company_address_lon"];
    [UIFactory SaveNSUserDefaultsWithData:[dataDic objectForKey:@"home_address"] AndKey:@"home_address"];
    [UIFactory SaveNSUserDefaultsWithData:[dataDic objectForKey:@"home_address_detail"] AndKey:@"home_address_detail"];
    [UIFactory SaveNSUserDefaultsWithData:[dataDic objectForKey:@"home_address_lat"] AndKey:@"home_address_lat"];
    [UIFactory SaveNSUserDefaultsWithData:[dataDic objectForKey:@"home_address_lon"] AndKey:@"home_address_lon"];
    [UIFactory SaveNSUserDefaultsWithData:[dataDic objectForKey:@"invoice_money"] AndKey:@"invoice_money"];
    [UIFactory SaveNSUserDefaultsWithData:[dataDic objectForKey:@"money"] AndKey:@"money"];
    [UIFactory SaveNSUserDefaultsWithData:[dataDic objectForKey:@"fee"] AndKey:@"fee"];
    [UIFactory SaveNSUserDefaultsWithData:[dataDic objectForKey:@"socket"] AndKey:@"socket"];
    
    if ([dataDic objectForKey:@"company"] != nil) {
        [UIFactory SaveNSUserDefaultsWithData:[dataDic objectForKey:@"company"] AndKey:@"company"];
    }
    
    self.amountString = [UIFactory getNSUserDefaultsDataWithKey:@"money"];
    
    [self createTheCustomView];
    
}

#pragma - mark 网络请求回调
-(void)requestFinished:(NSDictionary *)response tag:(NSInteger)iRequestTag
{
    [self dismissLoading];
    
    NSLog(@"成功44\n%@",response);
    
    if (_flag != 0 && response != nil && iRequestTag == _flag) {
        
        _flag = 0;
        
        [self loadAccountDataFinish:response];
    }
    
    if (_userFlag != 0 && response != nil && iRequestTag == _userFlag) {
        NSLog(@"获取用户资料成功\n%@",response);
        _userFlag = 0;
        
        [self getUserDataFinish:response];
    }
    
}

-(void)requestFailed:(NSDictionary *)response tag:(NSInteger)iRequestTag
{
    [self dismissLoading];
    
    NSLog(@"失败11\n%@",response);
    
    if (_flag != 0 && response != nil && iRequestTag == _flag) {
        
        _flag = 0;
        
        [self showTextOnlyWith:[response objectForKey:@"message"]];
    }
}

#pragma - mark UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.accountArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    AccountCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[AccountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.accountModel = [self.accountListArray objectAtIndex:indexPath.row];
    [cell setNeedsLayout];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *orderID = [[self.accountArray objectAtIndex:indexPath.row] objectForKey:@"order_id"];
    if (orderID.length > 1) {
        
        PaySuccessController *paySuccess = [[PaySuccessController alloc]init];
        paySuccess.orderNum = orderID;
        [self.navigationController pushViewController:paySuccess animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)backToLastView
{
    
    [self.navigationController popViewControllerAnimated:YES];
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
