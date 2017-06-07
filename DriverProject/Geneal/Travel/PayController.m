//
//  PayController.m
//  DriverProject
//
//  Created by 林镇杰 on 15/9/22.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "PayController.h"
#import "CancelViewController.h"
#import "CommonPopView.h"
#import "QiFacade+getmodel.h"
#import "PaySuccessController.h"
#import "WebViewController.h"
#import "PayCell.h"
#import "SocketOne.h"
#import "WXApi.h"
#import "WXApiObject.h"

#define TIPS_FONT              [UIFont systemFontOfSize:13]
#define LABEL_CELL_FONT         [UIFont systemFontOfSize:16]

@interface PayController ()<PopViewDelegate,QiFacadeHttpRequestDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,WXApiDelegate>
{
    UITableView *payTable;
    UILabel *amount;
    UILabel *tips;
    NSDictionary *payDic;
}

@property(nonatomic, assign)NSInteger costFlag;
@property(nonatomic, assign)NSInteger payFlag;
@property(nonatomic, assign)NSInteger wxFlag;

@end

@implementation PayController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, 70, 40);
    [cancelBtn setTitleColor:kUIColorFromRGB(0x212121) forState:UIControlStateNormal];
    cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    
    if ([self.pageType isEqualToString:PAYVIEW_PAGETYPE_PAYBEFORE]) {
        
        self.title = @"支付车费";
        [cancelBtn setTitle:@"投诉" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(goToComplaintView) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        
        self.title = @"查看明细";
        [cancelBtn setTitle:@"计价规则" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(goToValuationView) forControlEvents:UIControlEventTouchUpInside];
        
//        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        backBtn.frame = CGRectMake(0, 0, 50, 40);
//        [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//        [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -25, 0.0, 0.0)];
//        [backBtn addTarget:self action:@selector(backToLastView) forControlEvents:UIControlEventTouchUpInside];
//        
//        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
//        self.navigationItem.leftBarButtonItem = item;
    }
    
    self.view.backgroundColor = BG_COLOR_VIEW;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    if ([self.pageType isEqualToString:PAYVIEW_PAGETYPE_PAYBEFORE]) {
        
        self.navigationItem.hidesBackButton = YES;
    }
    self.payArray = [NSMutableArray array];
    
    self.driverModel = [[driverModel alloc]init];
    
    [self loadPayDate];
    
    [self createTheCustomViewByType:self.pageType];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backToRootView)];
}

-(void)createTheCustomViewByType:(NSString *)pageType
{
    if ([pageType isEqualToString:PAYVIEW_PAGETYPE_PAYBEFORE]) {
        
        CommonPopView *popView = [[CommonPopView alloc]initPopViewFrame:CGRectMake(0, 64, self.view.width, 80) AndDriverData:self.driverDic];
        popView.popDelegate = self;
        [self.view addSubview:popView];
        
        CGFloat heigt_cell = self.payArray.count * 40 + popView.height;
        CGFloat heigt_view = self.view.height - popView.height - 154;
        
        if (heigt_cell > heigt_view) {
            
            payTable = [[UITableView alloc]initWithFrame:CGRectMake(0, popView.bottom + 10, self.view.width, heigt_view) style:UITableViewStylePlain];
            
        }else{
            
            payTable = [[UITableView alloc]initWithFrame:CGRectMake(0, popView.bottom + 10, self.view.width, heigt_view) style:UITableViewStylePlain];
        }
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height - 60, self.view.width, 60)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.borderWidth = 0.5f;
        bgView.layer.borderColor = COLOR_LINE.CGColor;
        
        UIButton *submitBtn = [UIFactory createButton:@"支付" BackgroundColor:kUIColorFromRGB(0xf4942d) andTitleColor:[UIColor whiteColor]];
        [submitBtn addTarget:self action:@selector(submitThePayData) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:bgView];
        [bgView addSubview:submitBtn];
        
        [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(bgView).with.insets(UIEdgeInsetsMake(10, 15, 10, 15));
        }];
        
    }else{
        
        payTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStylePlain];
        payTable.scrollEnabled = NO;
    }
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 60)];
    [headerView.layer setBorderColor:Dividingline_COLOR.CGColor];
    [headerView.layer setBorderWidth:0.5f];
    
    tips = [UIFactory createLabel:@"¥" Font:TIPS_FONT];
    tips.textColor = kUIColorFromRGB(0xf4942d);
    tips.textAlignment = NSTextAlignmentRight;
    
    NSString *cost = [NSString stringWithFormat:@"%d",[self.allCost intValue]];
    amount = [UIFactory createLabel:cost Font:[UIFont systemFontOfSize:28]];
    amount.textColor = kUIColorFromRGB(0xf4942d);
    amount.textAlignment = NSTextAlignmentCenter;
    
    [headerView addSubview:tips];
    [headerView addSubview:amount];

    [payTable.layer setBorderColor:COLOR_LINE.CGColor];
    [payTable.layer setBorderWidth:0.5f];
    payTable.tableHeaderView = headerView;
    payTable.tableFooterView = [[UIView alloc]init];
    payTable.tableFooterView.backgroundColor = RGB(249, 250, 251);
    payTable.delegate = self;
    payTable.dataSource = self;
    [self.view addSubview:payTable];
    
    [amount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(headerView);
        make.height.equalTo(headerView.mas_height).multipliedBy(0.5f);
        //make.width.equalTo(headerView.mas_width).multipliedBy(0.12f);
        make.width.mas_equalTo(@55);
    }];
    
    [tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(amount.mas_left);
        make.bottom.equalTo(amount.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
 
}

#pragma - mark 余额支付
-(void)balancePayDate
{
    QiFacade *facade;
    facade = [QiFacade sharedInstance];
    
    //获取当前时间
    NSString *time1970 = [NSString stringWithFormat:@"%lf",[[NSDate date] timeIntervalSince1970]];
    _payFlag = [facade postOrderPayOff:@" " Result:@"ture" Out_trade_no:time1970 Pay_type:@"3" WithID:self.orderNum];
    [facade addHttpObserver:self tag:_payFlag];
}

-(void)loadPayDate
{
    QiFacade *facade;
    facade = [QiFacade sharedInstance];
    _costFlag = [facade getOrderFeeWithID:self.orderNum];
    [facade addHttpObserver:self tag:_costFlag];
    [self showLoadingWithText:@"Loading..."];
}

-(void)loadPayDateFinish:(NSDictionary *)dic
{
    payDic = [NSDictionary dictionaryWithDictionary:dic];
    self.payArray = [dic objectForKey:@"format"];
    [payTable reloadData];
}

#pragma - mark 网络请求回调
- (void)requestFinished:(NSDictionary *)response tag:(NSInteger)iRequestTag
{
    [self dismissLoading];
   
    NSLog(@"成功\n%@",response);
    
    if (_costFlag != 0 && response != nil && iRequestTag == _costFlag) {
        
        _costFlag = 0;
        
        [self loadPayDateFinish:response];
        
    }else if (_payFlag != 0 && response != nil && iRequestTag == _payFlag){
        
        _payFlag = 0;
        
        if ([[response objectForKey:@"message"] isEqualToString:@"success"]) {
             [[SocketOne sharedInstance] disconnect];
            [self showTextOnlyWith:@"支付成功！！！"];
            
            [self performSelector:@selector(goToPaySuccessViewByType:) withObject:@"main" afterDelay:1.5f];
            
        }else{
            
            [self showTextOnlyWith:[response objectForKey:@"message"]];
        }
        
    }else if (_wxFlag != 0 && response != nil && iRequestTag == _wxFlag){
        
        _wxFlag = 0;
        
        if ([response objectForKey:@"paid"]) {
            
            [self showTextOnlyWith:@"本订单已支付"];
            [self goToPaySuccessViewByType:@"WX"];
            
        }else{
            
            [self wxPayActionWith:response];
        }
    }
}

-(void)requestFailed:(NSDictionary *)response tag:(NSInteger)iRequestTag
{
    [self dismissLoading];
    NSString *msg = [response objectForKey:@"message"];
    NSLog(@"失败\n%@",response);
    NSLog(@"失败\n%@", msg);
    
    
    if (_costFlag != 0 && response != nil && iRequestTag == _costFlag) {
        
        _costFlag = 0;
        
        [self showTextOnlyWith:@"加载失败"];
        
    }else if (_payFlag != 0 && response != nil && iRequestTag == _payFlag){
        
        _payFlag = 0;
        
        [self showTextOnlyWith:@"支付失败"];
        
    }else if (_wxFlag != 0 && response != nil && iRequestTag == _wxFlag){
        
        _wxFlag = 0;
        
        [self showTextOnlyWith:@"微信支付失败"];
    }
}

#pragma - mark 投诉
-(void)goToComplaintView
{
    //投诉
    CancelViewController *cancel = [[CancelViewController alloc]init];
    NSArray *buttonArray = [NSArray arrayWithObjects:@"服务态度恶劣",@"司机迟到",@"绕路行驶",@"骚扰客人", nil];
    cancel.dateDic = [NSDictionary dictionaryWithObjectsAndKeys:@"投诉",Title_key,@"用车过程中遇到什么问题？",Question_key,buttonArray,ButtonArray_key,@"其他投诉理由",TextInput_key,@"提交",SubmitButton_key,self.orderNum,@"orderID", nil];
    [self.navigationController pushViewController:cancel animated:YES];
}

#pragma - mark 计价规则
-(void)goToValuationView
{
    WebViewController *webView = [[WebViewController alloc]init];
    webView.webURL = VALUATION_RULES_API;
    webView.title = @"计价规则";
    [self.navigationController pushViewController:webView animated:YES];
}

-(void)submitThePayData
{
//    [self.navigationController popToRootViewControllerAnimated:YES];
    
    if ([UIFactory isCompany]) {
        NSString *fee = [NSString stringWithFormat:@"余额支付：(可用余额：%@)", [UIFactory getNSUserDefaultsDataWithKey:@"money"]];
        UIAlertView *payAlert = [[UIAlertView alloc]initWithTitle:@"选择支付方式" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:fee,@"微信支付", nil];
        
        payAlert.tag = 1008612;
        [payAlert show];
        
    }else{
        
        UIAlertView *payAlert = [[UIAlertView alloc]initWithTitle:@"微信支付" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"微信支付", nil];
        payAlert.tag = 10001;
        [payAlert show];
       
//        [self showTextOnlyWith:@"现金支付中..."];
//        [[SocketOne sharedInstance] disconnect];
//        [self performSelector:@selector(backToRootView) withObject:nil afterDelay:1.5];
    }
}

#pragma - mark UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.payArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    PayCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[PayCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:14]];
    cell.textLabel.text = [[self.payArray objectAtIndex:indexPath.row] objectForKey:@"desc"];
    cell.detailTextLabel.text = [[self.payArray objectAtIndex:indexPath.row] objectForKey:@"fee"];
    if ([[[self.payArray objectAtIndex:indexPath.row] objectForKey:@"color"] intValue] == 1) {
        
        cell.textLabel.textColor = kUIColorFromRGB(0xf4942d);
        cell.detailTextLabel.textColor = kUIColorFromRGB(0xf4942d);
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma - mark PopViewDelegate
-(void)popBtnDidRingUpByDriverPhoneNumber:(NSString *)phone
{
    [UIFactory callThePhone:phone];
}

#pragma - mark UIAlertVew Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 1008612) {
        
        if (buttonIndex == 0) {
            //现金支付
            
        }else if (buttonIndex == 1){
            //余额支付
            [self balancePayDate];
        }else{
            //微信支付
            [self loadWeiXinPayData];
        }
    }
    if (alertView.tag == 10001) {
        if (buttonIndex == 0) {
            //现金支付
            
        }else if (buttonIndex == 1){
            //微信支付
            [self loadWeiXinPayData];
        }
    }
}



#pragma - mark 微信支付
-(void)loadWeiXinPayData
{
    QiFacade *facade;
    facade = [QiFacade sharedInstance];
    _wxFlag = [facade getWePay:self.orderNum];
    [facade addHttpObserver:self tag:_wxFlag];
    [self showLoadingWithText:@"Loading..."];
}

-(void)wxPayActionWith:(NSDictionary *)_payDic
{
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = [_payDic objectForKey:@"partnerid"];
    request.prepayId = [_payDic objectForKey:@"prepayid"];
    request.package = [_payDic objectForKey:@"package"];
    request.nonceStr = [_payDic objectForKey:@"noncestr"];
    request.timeStamp = [[_payDic objectForKey:@"timestamp"] intValue];
    request.sign = [_payDic objectForKey:@"sign"];
    
    BOOL suc = [WXApi safeSendReq:request];
    if (suc) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(goToPaySuccessView:) name:NOTIFICATION_PAY_STATUS object:nil];
    }
    
    [[SocketOne sharedInstance] disconnect];
}

-(void)onResp:(BaseResp *)resp
{
    NSLog(@"微信的返回");
}


-(void)goToPaySuccessView:(NSNotification *)notification
{
    NSString *info = notification.object;
    NSLog(@"useifo:%@",info);
    if ([info isEqualToString:@"成功"]) {
//        PaySuccessController *paySuccess = [[PaySuccessController alloc]init];
//        paySuccess.payType = @"WX";
//        paySuccess.orderNum = self.orderNum;
//        
//        [self.navigationController pushViewController:paySuccess animated:YES];
        
        [self goToPaySuccessViewByType:@"WX"];
        
    }else if([info isEqualToString:@"取消"]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"您取消了本次支付" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else if([info isEqualToString:@"失败"]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"本次支付失败" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)goToPaySuccessViewByType:(NSString *)_payType
{
    PaySuccessController *paySuccess = [[PaySuccessController alloc]init];
    paySuccess.payType = _payType;
    paySuccess.orderNum = self.orderNum;
    [self.navigationController pushViewController:paySuccess animated:YES];
}

-(void)backToLastView
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 返回
-(void)backToRootView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    //停止socket
    [[SocketOne sharedInstance] disconnect];
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
