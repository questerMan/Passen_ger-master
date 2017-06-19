//
//  UserInfoController.m
//  DriverProject
//
//  Created by 林镇杰 on 15/9/18.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "UserInfoController.h"
#import "QiFacade+putmodel.h"
#import "QiFacade+getmodel.h"
#import "QiFacade+Deletemodel.h"
#import "SettingCell.h"
#import "AddressSelectController.h"

#define ALERTVIEW_NAME_TAG          10010
#define ALERTVIEW_HOME_TAG          10011
#define ALERTVIEW_COMPANY_TAG       10012
#define ALERTVIEW_EXIT_TAG          10013

@interface UserInfoController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,QiFacadeHttpRequestDelegate,AddressSelectControllerDelegate>
{
    
    UITableView *userTable;
    UIButton *exitBtn;
    UIView *companyView;
    NSString *updateType;
}

@property(nonatomic, retain)NSMutableArray *imgArray;
@property(nonatomic, retain)NSMutableArray *userArray;
@property(nonatomic, assign)NSInteger flag;
@property(nonatomic, assign)NSInteger outFlag;
@property(nonatomic, assign)NSInteger updateFlag;

@end

@implementation UserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"账户信息";
    self.view.backgroundColor = RGB(249, 250, 251);
    
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(0, 0, 50, 40);
//    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -25, 0.0, 0.0)];
//    [backBtn addTarget:self action:@selector(backToLastView) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *leftitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = leftitem;
    
    _imgArray = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"call_darkgray"],[UIImage imageNamed:@"account_circle_mix"],[UIImage imageNamed:@"home_black"],[UIImage imageNamed:@"location_city"], nil];
    
    NSString *home;
    if (![[UIFactory getNSUserDefaultsDataWithKey:@"home_address"] isEqualToString:NULL_DATA] && [[UIFactory getNSUserDefaultsDataWithKey:@"home_address"] length] > 0) {
        
        home = [[UIFactory getNSUserDefaultsDataWithKey:@"home_address"] isEqualToString:NULL_DATA] ? @"家庭地址": [UIFactory getNSUserDefaultsDataWithKey:@"home_address"];
    }else{
        
        home = @"家庭地址";
    }
    
    NSString *company;
    if (![[UIFactory getNSUserDefaultsDataWithKey:@"company_address"] isEqualToString:NULL_DATA] && [[UIFactory getNSUserDefaultsDataWithKey:@"company_address"] length] > 0) {
        
        company = [[UIFactory getNSUserDefaultsDataWithKey:@"company_address"] isEqualToString:NULL_DATA] ? @"公司地址": [UIFactory getNSUserDefaultsDataWithKey:@"company_address"];
    }else{
        
        company = @"公司地址";
    }
    NSLog(@"home:%@\ncompany:%@",[UIFactory getNSUserDefaultsDataWithKey:@"home_address"],[UIFactory getNSUserDefaultsDataWithKey:@"company_address"]);
    
    _userArray = [NSMutableArray arrayWithObjects:[UIFactory getNSUserDefaultsDataWithKey:@"phone"],[UIFactory getNSUserDefaultsDataWithKey:@"nickname"],home,company, nil];
    
    self.userInfoArray = [NSMutableArray arrayWithObjects:_imgArray,_userArray, nil];
    
    userTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, 230) style:UITableViewStylePlain];
    userTable.contentInset = UIEdgeInsetsMake(-44, 0, 0, 0);
    userTable.backgroundColor = [UIColor clearColor];
    userTable.delegate = self;
    userTable.dataSource = self;
    userTable.scrollEnabled = NO;
    [userTable.layer setBorderWidth:0.5f];
    [userTable.layer setBorderColor:Dividingline_COLOR.CGColor];
    [userTable scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    [self.view addSubview:userTable];
    
    exitBtn = [UIFactory createButton:@"退出" BackgroundColor:[UIColor whiteColor] andTitleColor:[UIColor blackColor]];
    [exitBtn.layer setBorderWidth:0.5f];
    [exitBtn.layer setBorderColor:RGB(181, 182, 183).CGColor];
    exitBtn.frame = CGRectMake(10, self.view.height - 60, self.view.width - 20, 50);
    [exitBtn addTarget:self action:@selector(ExitTheAccounts) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exitBtn];
    
    if (![[UIFactory getNSUserDefaultsDataWithKey:@"company"] isEqualToString:NULL_DATA]) {
        
        [self createCompanyView];
    }
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationFailureAction:) name:NOTIFICATION_LOGIN_FAILURE object:nil];
}

-(void)notificationFailureAction:(NSNotification *)notification
{
    if ([notification.object isEqualToString:@"102"]) {
        [self dismissLoading];
    }
}

-(void)createCompanyView
{
    companyView = [[UIView alloc]initWithFrame:CGRectMake(0, userTable.bottom + 20, self.view.width, 50)];
    companyView.backgroundColor = [UIColor whiteColor];
    [companyView.layer setBorderColor:Dividingline_COLOR.CGColor];
    [companyView.layer setBorderWidth:0.5f];
    
    UIImageView *companyImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"business_darkgray"]];
    
    UILabel *companyLabel = [UIFactory createLabel:[UIFactory getNSUserDefaultsDataWithKey:@"company"] Font:[UIFont systemFontOfSize:17]];
    
    [self.view addSubview:companyView];
    [companyView addSubview:companyImg];
    [companyView addSubview:companyLabel];
    
    [companyImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(companyView.mas_left).offset(15);
        make.centerY.equalTo(companyView);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(companyImg.mas_right).offset(18);
        make.right.equalTo(companyView.mas_right).offset(-10);
        make.centerY.equalTo(companyView);
        make.height.mas_equalTo(@25);
        make.size.mas_equalTo(CGSizeMake(35, 25));
    }];
    
}

/**
 *  退出账户
 */
-(void)ExitTheAccounts
{
    UIAlertView *exitAlert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您确定现在退出该帐号吗？" delegate:self cancelButtonTitle:@"暂不退出" otherButtonTitles:@"确定", nil];
    exitAlert.tag = ALERTVIEW_EXIT_TAG;
    [exitAlert show];
    
}

#pragma - mark 获取最新的个人资料
-(void)getUserData
{
    QiFacade *facade;
    facade = [QiFacade sharedInstance];
    _updateFlag = [facade getAccountData];
    [facade addHttpObserver:self tag:_updateFlag];
}

-(void)getUserDataFinish:(NSDictionary *)dataDic
{
    NSLog(@"%@",dataDic);
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:dataDic];
    [UIFactory DeleteAllSaveTokenNSUserDefaults];
    
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

    NSString *home;
    if (![[UIFactory getNSUserDefaultsDataWithKey:@"home_address"] isEqualToString:NULL_DATA] && [[UIFactory getNSUserDefaultsDataWithKey:@"home_address"] length] > 0) {
        
        home = [[UIFactory getNSUserDefaultsDataWithKey:@"home_address"] isEqualToString:NULL_DATA]?@"家庭地址": [UIFactory getNSUserDefaultsDataWithKey:@"home_address"];
    }else{
        
        home = @"家庭地址";
    }
    
    NSString *company;
    if (![[UIFactory getNSUserDefaultsDataWithKey:@"company_address"] isEqualToString:NULL_DATA] && [[UIFactory getNSUserDefaultsDataWithKey:@"company_address"] length] > 0) {
        
        company = [[UIFactory getNSUserDefaultsDataWithKey:@"company_address"] isEqualToString:NULL_DATA]?@"公司地址": [UIFactory getNSUserDefaultsDataWithKey:@"company_address"];
    }else{
        
        company = @"公司地址";
    }
    
    _userArray = [NSMutableArray arrayWithObjects:[UIFactory getNSUserDefaultsDataWithKey:@"phone"],[UIFactory getNSUserDefaultsDataWithKey:@"nickname"],home,company, nil];
    [self.userInfoArray replaceObjectAtIndex:1 withObject:_userArray];
    [userTable reloadData];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat height = userTable.frame.size.height;
    CGFloat distanceFromButton = userTable.contentSize.height - userTable.contentOffset.y;
    if (distanceFromButton == height)
    {
        NSLog(@"=====滑动到底了");
//        [userTable setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
    if (userTable.contentOffset.y == 0)
    {
        NSLog(@"=====滑动到顶了");
    }
}

#pragma - mark UITableView DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 10)];
    
    header.backgroundColor = [UIColor clearColor];
    [header.layer setBorderWidth:1.0f/[[UIScreen mainScreen]scale]];
    [header.layer setBorderColor:Dividingline_COLOR.CGColor];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 0;
        
    }else{
        return 10;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSLog(@"%ld\n%@",(long)indexPath.row,self.userInfoArray);
    if (indexPath.section == 0) {
        
        if (indexPath.row == 1) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.imageView.image = [[self.userInfoArray objectAtIndex:0] objectAtIndex:indexPath.row];
        cell.textLabel.text = [[self.userInfoArray objectAtIndex:1] objectAtIndex:indexPath.row];
        
    }else{
        
        cell.imageView.image = [[self.userInfoArray objectAtIndex:0] objectAtIndex:indexPath.row + 2];
        cell.textLabel.text = [[self.userInfoArray objectAtIndex:1] objectAtIndex:indexPath.row + 2];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    
    if (indexPath.row == 0 && indexPath.section == 0) {
        cell.showTopSeperateLine = YES;
    }else{
        cell.showTopSeperateLine = NO;
    }
    
    if (indexPath.row == 1 && indexPath.section == 0) {
        cell.showSeperateLine = NO;
    }
    
    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
    return cell;
}

#pragma - mark UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1 && indexPath.section == 0) {
        
        updateType = @"name";
        UIAlertView *nameAlert = [[UIAlertView alloc]initWithTitle:@"修改名字" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        nameAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [nameAlert textFieldAtIndex:0].text = [UIFactory getNSUserDefaultsDataWithKey:@"nickname"];
        nameAlert.tag = ALERTVIEW_NAME_TAG;
        [nameAlert show];
        
    }else if (indexPath.section == 1 && indexPath.row == 0){
        
        updateType = @"home";
        AddressSelectController *searchController = [[AddressSelectController alloc] init];
        searchController.delegate = self;
//        searchController.text = address;//可以不写
        searchController.city = @"广州";//可以不写
        searchController.searchType = 0;//searchTypeEnd
//        searchController.coordinateLocation = mapView.rModel.startLocation;//可以不写
        [self.navigationController pushViewController:searchController animated:YES];
        
    }else if (indexPath.section == 1 && indexPath.row == 1){
        
        updateType = @"company";
        AddressSelectController *searchController = [[AddressSelectController alloc] init];
        searchController.delegate = self;
        //        searchController.text = address;//可以不写
        searchController.city = @"广州";//可以不写
        searchController.searchType = 1;//searchTypeEnd
        //        searchController.coordinateLocation = mapView.rModel.startLocation;//可以不写
        [self.navigationController pushViewController:searchController animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma - mark AlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == ALERTVIEW_NAME_TAG) {
        
        if (buttonIndex == 1) {
            NSString *name = [alertView textFieldAtIndex:0].text;
            if (![name isEqualToString:@""]) {
                
                [[alertView textFieldAtIndex:0]resignFirstResponder];
                
                [self showLoadingWithText:@"修改资料中"];
                
                [UIFactory SaveNSUserDefaultsWithData:name AndKey:@"nickname"];
                
                QiFacade *facade;
                facade = [QiFacade sharedInstance];
                _flag = [facade putAccountData:name Home_address:[UIFactory getNSUserDefaultsDataWithKey:@"home_address"] Company_address:[UIFactory getNSUserDefaultsDataWithKey:@"company_address"] Home_address_lon:[UIFactory getNSUserDefaultsDataWithKey:@"home_address_lon"] Home_address_lat:[UIFactory getNSUserDefaultsDataWithKey:@"home_address_lat"] Company_address_lat:[UIFactory getNSUserDefaultsDataWithKey:@"company_address_lat"] Company_address_lon:[UIFactory getNSUserDefaultsDataWithKey:@"company_address_lon"]];
                [facade addHttpObserver:self tag:_flag];
            }
        }
        
    }else if (alertView.tag == ALERTVIEW_EXIT_TAG){
        
        if (buttonIndex == 1) {
            
            QiFacade *facade;
            facade = [QiFacade sharedInstance];
            _outFlag = [facade deleteAccountSignOut];
            [facade addHttpObserver:self tag:_outFlag];
        }
        
    }
    
}

#pragma - mark AddressSelectControllerDelegate
- (void)searchViewController:(UITableView *)table didSelectLocation:(DDLocation *)searchLocation searchType:(SearchType)type
{
    NSLog(@"搜索结果:%lu\n具体结果展示：%@",(unsigned long)type,searchLocation);
    
    [self showLoadingWithText:@"修改资料中"];
    QiFacade *facade;
    facade = [QiFacade sharedInstance];
    
    switch (type) {
        case SearchStart:
            
            _flag = [facade putAccountData:[UIFactory getNSUserDefaultsDataWithKey:@"nickname"] Home_address:searchLocation.name Company_address:[UIFactory getNSUserDefaultsDataWithKey:@"company_address"] Home_address_lon:[NSString stringWithFormat:@"%f",searchLocation.coordinateLon] Home_address_lat:[NSString stringWithFormat:@"%f",searchLocation.coordinateLat] Company_address_lat:[UIFactory getNSUserDefaultsDataWithKey:@"company_address_lat"] Company_address_lon:[UIFactory getNSUserDefaultsDataWithKey:@"company_address_lon"]];
            [facade addHttpObserver:self tag:_flag];
            
            break;
            
        case SearchEnd:
            
            _flag = [facade putAccountData:[UIFactory getNSUserDefaultsDataWithKey:@"nickname"] Home_address:[UIFactory getNSUserDefaultsDataWithKey:@"home_address"] Company_address:searchLocation.name Home_address_lon:[UIFactory getNSUserDefaultsDataWithKey:@"home_address_lon"] Home_address_lat:[UIFactory getNSUserDefaultsDataWithKey:@"home_address_lat"] Company_address_lat:[NSString stringWithFormat:@"%f",searchLocation.coordinateLat] Company_address_lon:[NSString stringWithFormat:@"%f",searchLocation.coordinateLon]];
            [facade addHttpObserver:self tag:_flag];
            
            break;
            
        default:
            break;
    }
}

#pragma - mark 网络请求回调
-(void)requestFinished:(NSDictionary *)response tag:(NSInteger)iRequestTag
{
    
    [self dismissLoading];
    
    NSLog(@"成功33\n%@",response);
    
    if (_flag != 0 && response != nil && iRequestTag == _flag) {
        
        _flag = 0;
        
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_USER_DATA_CHANGE object:nil];
//        [[self.userInfoArray objectAtIndex:1] replaceObjectAtIndex:1 withObject:[UIFactory getNSUserDefaultsDataWithKey:@"nickname"]];
//        [userTable reloadData];
        [self getUserData];
        
    }
    
    if (_outFlag != 0 && response != nil && iRequestTag == _outFlag) {
        
        _outFlag = 0;
        
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOGIN_FAILURE object:nil];
        [UIFactory DeleteAllSaveTokenNSUserDefaults];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    if (_updateFlag != 0 && response != nil && iRequestTag == _updateFlag) {
        
        _updateFlag = 0;
        
        [self getUserDataFinish:response];
    }
}

-(void)requestFailed:(NSDictionary *)response tag:(NSInteger)iRequestTag
{
    NSLog(@"失败\n%@",response);

    if (_flag != 0 && iRequestTag == _flag) {
        
        _flag = 0;
        
        if (response != nil) {
            
            [self showTextOnlyWith:[response objectForKey:@"message"]];
            
        }else{
            
            [self showTextOnlyWith:@"名字修改失败"];
        }
        
        
    }else if (_outFlag != 0 && response != nil && iRequestTag == _outFlag){
        
        _outFlag = 0;
        
        if (response != nil) {
            
            [self showTextOnlyWith:[response objectForKey:@"message"]];
            
        }else{
            
            [self showTextOnlyWith:@"账户退出失败"];
        }
    }else if (_updateFlag != 0 && response != nil && iRequestTag == _updateFlag){
        
        _updateFlag = 0;
        
        if (response != nil) {
            
            [self showTextOnlyWith:[response objectForKey:@"message"]];
            
        }else{
            
            [self showTextOnlyWith:@"账户信息更新失败"];
        }
    }
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
