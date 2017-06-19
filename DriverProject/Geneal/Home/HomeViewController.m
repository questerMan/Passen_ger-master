//
//  HomeViewController.m
//  DriverProject
//
//  Created by 林镇杰 on 15/9/6.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "HomeViewController.h"
#import "LZJNavigationController.h"
#import "TravelDetailsController.h"
#import "newLoginViewController.h"
#import "CouponViewController.h"
#import "InvoiceViewController.h"
#import "BookTypeController.h"
#import "ChooseController.h"
#import "CostViewController.h"
#import "PayController.h"
#import "PaySuccessController.h"
#import "AddressSelectController.h"
#import "AddressSelectController.h"
#import "OrderViewController.h"
#import "TravelDetailsController.h"
#import "OrderModel.h"
#import "REFrostedViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

#define USECAR_BUTTON_TAG 10010
#define BOOKCAR_BUTTON_TAG 10086
@interface HomeViewController ()<ConfirmListViewDelegate,UIPickerViewDelegate,PopViewDelegate,MapCustomAnnotationViewDelegate,AddressSelectControllerDelegate,CostDelegate,ChooseDelegate,BookTypeDelegate,MyMapVieDidDelegate>
{
    UIButton *tapItemBtn;
    UIButton *useCarBtn;
    UIButton *bookCarBtn;
    UIView   *pickerBgView;
    NSString *bookTimeStr;
    NSInteger pickTimer;
    NSInteger DidreverseGeographyCodeCount;
    //MapView  *mapView;
    OrderModel  *orderModel;//订单模型
}

@property(nonatomic, assign)NSInteger flag;
@property(nonatomic, assign)NSInteger flagOrder;
@property(nonatomic, assign)NSInteger flagCost;
@property(nonatomic, assign)NSInteger flagCarType;
@property(nonatomic, strong)MBProgressHUD *HUDView;
@end

@implementation HomeViewController
@synthesize mapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"+++______+++%@",[NSUserDefaults standardUserDefaults]);
    //添加地图
    mapView = [MapView sharedInstanceWithFrame:self.view.frame];
    mapView.delegate = self;
    mapView.mapType = MyMapTypeHome;
    mapView.myMapDelegate = self;
    [self.view addSubview:mapView];
    
    orderModel = [[OrderModel alloc] init];
    DidreverseGeographyCodeCount = 0;
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.title = @"丽新出行";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_black"] style:UIBarButtonItemStylePlain target:(LZJNavigationController *)self.navigationController action:@selector(showMenu)];

    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
    back.title = @"";
    self.navigationItem.backBarButtonItem = back;
    
    tapItemBtn = [UIFactory createButton:@"收起" BackgroundColor:[UIColor clearColor] andTitleColor:kUIColorFromRGB(0xf4942d)];
    tapItemBtn.frame = CGRectMake(0, 0, 70, 40);
    tapItemBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [tapItemBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [tapItemBtn addTarget:self action:@selector(tapViewResignConfirmListView) forControlEvents:UIControlEventTouchUpInside];
    
//    //后台获取最新的用户信息
//    [GCDQueue executeInGlobalQueue:^{
//        
//        if (![[UIFactory getNSUserDefaultsDataWithKey:@"uuid"] isEqualToString:NULL_DATA] && ![[UIFactory getNSUserDefaultsDataWithKey:@"access_token"] isEqualToString:NULL_DATA]) {
//            
//            NSLog(@"UUID:%@\nToken:%@",[UIFactory getNSUserDefaultsDataWithKey:@"uuid"],[UIFactory getNSUserDefaultsDataWithKey:@"access_token"]);
//            
//            [self getUserData];
//        }
//    }];
    //[self getUserData];
    
    /*
    NSDictionary *driverDic = [NSDictionary dictionaryWithObjectsAndKeys:@"刘师傅",DRIVER_NAME_KEY,@"粤A**P45 大众辉腾",DRIVER_CAR_KEY,@"8",DRIVER_STAR_KEY,@"154单",DRIVER_ORDER_COUNT_KEY,@"18665751365",DRIVER_PHONE_NUMBER_KEY, nil];
    CommonPopView *popView = [[CommonPopView alloc]initPopViewFrame:CGRectMake(0, 64, self.view.width, 80) AndDriverData:driverDic];
    popView.popDelegate = self;
    [self.view addSubview:popView];
    */
    
//    UIView *bottonView = [[UIView alloc]initWithFrame:CGRectZero];//CGRectMake(0, KScreenHeight - 70 - 64, KScreenWidth, 70)
//    bottonView.backgroundColor = [UIColor whiteColor];
    
    useCarBtn = [UIFactory createButton:@"现在用车" BackgroundColor:kUIColorFromRGB(0x3ab48f) andTitleColor:[UIColor whiteColor]];
    useCarBtn.frame = CGRectMake(10, SCREEN_H - 60 , KScreenWidth * 2/3, 50);
    useCarBtn.tag = USECAR_BUTTON_TAG;
    useCarBtn.hidden = YES;
    
    [useCarBtn addTarget:self action:@selector(bottonButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    bookCarBtn = [UIFactory createButton:@"预约用车" BackgroundColor:kUIColorFromRGB(0xf4942d) andTitleColor:[UIColor whiteColor]];
    bookCarBtn.frame = CGRectMake(80, useCarBtn.top, KScreenWidth - 160, useCarBtn.height);
    [bookCarBtn.layer setCornerRadius:25];
    bookCarBtn.tag = BOOKCAR_BUTTON_TAG;
    [bookCarBtn addTarget:self action:@selector(bottonButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //定位点
   // UIButton *useLoctionBtn = [UIFactory createButton:[UIImage imageNamed:@"button_home_locate"]];
    
    UIButton *useLoctionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    useLoctionBtn.frame = CGRectMake(10, SCREEN_H - 100, 40, 40);
    //[useLoctionBtn setBackgroundColor:[UIColor redColor]];
    [useLoctionBtn setBackgroundImage:[UIImage imageNamed:@"button_home_locate"] forState:UIControlStateNormal];
    [useLoctionBtn addTarget:self action:@selector(userLoctionClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    [self.view addSubview:bottonView];
    [self.view addSubview:useCarBtn];
    [self.view addSubview:bookCarBtn];
    [self.view addSubview:useLoctionBtn];
    
//    [bottonView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view);
//        make.left.equalTo(self.view);
//        make.height.mas_equalTo(@70);
//        make.width.equalTo(self.view);
//    }];
    
    [useLoctionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);;
        make.bottom.equalTo(self.view.mas_bottom).offset(-100);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];

    //[self showLoadingWithText:@"获取个人信息中..."];
    
    if ([UIFactory isLoginOrNot]) {
        [self getUserData];
    }
    _HUDView = [[MBProgressHUD alloc]initWithView:self.view];
    self.HUDView.labelText = @"获取个人信息中...";
    [self.view addSubview:self.HUDView];
    
    
    //接收推送点击通知刷新界面
    [self crateNotification];

}
- (void)crateNotification
{
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(refreshData) name:@"NEWS_REFRESH" object:nil];
}
//通知中心不会保留（retain）监听器对象，在通知中心注册过的对象，必须在该对象释放前取消注册。否则，当相应的通知再次出现时，通知中心仍然会向该监听器发送消息。因为相应的监听器对象已经被释放了，所以可能会导致应用崩溃
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.mapView.myMapDelegate = self;
    [self.navigationController setNavigationBarHidden:NO];
    self.mapView.mapType = MyMapTypeHome;
    [self.view insertSubview:self.mapView atIndex:0];
    [self.mapView.annotationView setAnnotationRideState:RideStartState];
    self.mapView.annotationView.annotationDelegate = self;
    self.mapView.annotationView.enabled = YES;
    self.mapView.annotationView.image = [UIImage imageNamed:@"icon_map_center_pin"];
    //当登录了 但是 token没保存的时候
    NSString *token = [UIFactory getNSUserDefaultsDataWithKey:@"access_token"];
    
    if ((!token || token.length == 0) && ([UIFactory isLoginOrNot])) {
        [self getUserData];
    }
    NSArray *cartypes = [UIFactory getNSUserDefaultsDataWithKey:@"carTypes"];
    if (mapView.rModel.carType && [cartypes isKindOfClass:[NSArray class]] && cartypes.count) {
    }else{
        if ([UIFactory isLoginOrNot] && !token) {
            [self getCarType];
        }
    }
    [self.mapView showAllDriviers];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
    
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"refresh"] style:UIBarButtonItemStyleDone target:self action:@selector(refreshData)];
    
    
}
//刷新查看是否有进行的单
-(void)refreshData{
    [self getUserData];
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

#pragma kaitao_code ------------------
//点击回到用户位置
-(void)userLoctionClick:(id)sender
{
    [mapView mapAtUserLoction];
}

#pragma - 完成逆地理编码
-(void)mapViewDidreverseGeographyCode:(MAMapView *)map
{
//    if ([UIFactory isLoginOrNot] && DidreverseGeographyCodeCount == 0) {
//        DidreverseGeographyCodeCount++;
//        [self getUserData];
//    }
}

#pragma -mark 进入搜索
-(void)pushToSearchViewController:(SearchType)status andAddress:(NSString *)address
{
    if (mapView.driveState == 1) {
        mapView.driveState = 2;
    }else{
        mapView.driveState = 1;
    }
    
    AddressSelectController *searchController = [[AddressSelectController alloc] init];
    searchController.delegate = self;
    searchController.text = address;
    searchController.city = @"guangzhou";
    searchController.searchType = status;
    searchController.coordinateLocation = mapView.rModel.startLocation;
    //[[UIApplication sharedApplication].keyWindow.rootViewController.navigationController pushViewController:searchController animated:YES];
//    HomeViewController *home = [[HomeViewController alloc]init];
//    LZJNavigationController *navigation = [[LZJNavigationController alloc]initWithRootViewController:home];
//    self.frostedViewController.contentViewController = navigation;
    [self.navigationController pushViewController:searchController animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

#pragma searchViewControllerDelegate 选中一个地址后的回调
-(void)searchViewController:(UITableView *)table didSelectLocation:(DDLocation *)searchLocation searchType:(SearchType)type
{
    NSLog(@"搜索结果:%@",searchLocation);
    switch (type) {
        case SearchStart:
            mapView.isManualDrag = 0;
            _confirmListView.startPoint = searchLocation.name;
            mapView.rModel.startAddress = searchLocation.name;
            mapView.rModel.startAddressDetail = searchLocation.address;
            
            CLLocationCoordinate2D locationstart;
            locationstart.latitude = searchLocation.coordinateLat;
            locationstart.longitude = searchLocation.coordinateLon;
            mapView.rModel.startLocation = locationstart;
            [mapView setAnnotationLoction:locationstart manual:NO];
            
            break;
            
        case SearchEnd:
            _confirmListView.endPoint = searchLocation.name;
            mapView.rModel.endAddress  = searchLocation.name;
            mapView.rModel.endAddressDetail = searchLocation.address;
            
            CLLocationCoordinate2D locationend;
            locationend.latitude = searchLocation.coordinateLat;
            locationend.longitude = searchLocation.coordinateLon;
            mapView.rModel.endLocation = locationend;
            break;
            
        default:
            break;
    }

    //保存常用地址
    [self saveRegularAddress:searchLocation];
   
    
    //计算费用
    NSLog(@"s:%@",_confirmListView.startPoint);
    if ( mapView.rModel.startAddress &&  mapView.rModel.endAddress) {
        [self computationalCostWithType];
        
    }
}


#pragma -mark 保存常用地址
-(NSArray *)saveRegularAddress:(DDLocation *)address
{
    //取数据
    NSMutableArray *allAdress;
    NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:[UIFactory dataFilePath:@"commonAddress"]];
    //NSArray *arr = [userd objectForKey:@"commonlyAddress4"];
    
    if (arr && arr.count) {
        for (NSDictionary *locData in arr) {
            NSLog(@"lo:%@",locData);
            if ([[locData objectForKey:@"name"] isEqualToString:address.name]) {
                return arr;
            }
        }
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (!arr || (arr.count == 0)) {
        allAdress = [[NSMutableArray alloc]init];
    }else{
        allAdress = [[NSMutableArray alloc]initWithArray:arr];
    }
    [dic setObject:address.name forKey:@"name"];
    [dic setObject:address.cityCode?:@"020" forKey:@"cityCode"];
    [dic setObject:address.address forKey:@"address"];
    [dic setObject:[NSNumber numberWithFloat:address.coordinateLon] forKey:@"coordinateLon"];
    [dic setObject:[NSNumber numberWithFloat:address.coordinateLat] forKey:@"coordinateLat"];
    
    [allAdress insertObject:dic atIndex:0];
    if (allAdress.count > 20) {
        [allAdress removeLastObject];
    }
    else{
    }
    
    //存数据
    NSString *fileName = [UIFactory dataFilePath:@"commonAddress"];
    BOOL is = [NSKeyedArchiver archiveRootObject:allAdress toFile:fileName];
    
    
    //[userd setObject:allAdress forKey:@"commonlyAddress4"];
    //[userd synchronize];

    
    return allAdress;
}



#pragma -mark 登入检测
#pragma - mark UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        newLoginViewController *login = [[newLoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    }
}

#pragma -mark 点击预约/直接呼叫
-(void)bottonButtonAction:(UIButton *)sender
{
    //登入检测
    if (![UIFactory isLoginOrNot]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您尚未登录您的帐号，您是想现在登录吗？" delegate:self cancelButtonTitle:@"暂不登录" otherButtonTitles:@"登录", nil];
        [alert show];
        return;
    }
    if (_flag) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"正在获取用户资料" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
    NSLog(@"UIButton Tag : %ld\n屏幕高度:%f",(long)sender.tag,KScreenHeight);
    
    if (sender.tag == USECAR_BUTTON_TAG) {
        
        self.confirmListView = [[ConfirmListView alloc]initConfirmListViewWithType:ConfirmListViewType_call showView:self.view];
        _confirmListView.confirmDelegate = self;
        _confirmListView.startPoint = mapView.rModel.startAddress?:@"在哪儿";
        _confirmListView.endPoint   = mapView.rModel.endAddress?:@"去哪儿";
        _confirmListView.cost       = @"费用预估";
        _confirmListView.phoneNum   = @"选择联系人";
        mapView.rModel.orderType    = OrderTypeImmediately;
        
    }else{
        
        if (KScreenHeight == 480) {
            UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:tapItemBtn];
            self.navigationItem.rightBarButtonItem = rightItem;
        }
        self.confirmListView = [[ConfirmListView alloc]initConfirmListViewWithType:ConfirmListViewType_appointment  showView:self.view];
        _confirmListView.confirmDelegate = self;
        _confirmListView.bookTime   = mapView.rModel.preTime?[NSDate getStingTimeWithTime1970:[mapView.rModel.preTime doubleValue]]:@"预约时间";
        _confirmListView.startPoint = mapView.rModel.startAddress?:@"在哪儿";
        _confirmListView.endPoint   = mapView.rModel.endAddress?:@"去哪儿";
        _confirmListView.cost       = @"费用预估";
        _confirmListView.phoneNum   = @"选择联系人";
        if (!mapView.rModel.orderType || (mapView.rModel.orderType == OrderTypeImmediately)) {
            mapView.rModel.orderType = OrderTypeBook;
        }
        
        switch (mapView.rModel.orderType) {
            case OrderTypeBook:
            {
                _confirmListView.bookCar = @"预约专车";
            }
                break;
            case OrderTypePick:
            {
                NSString *time = mapView.rModel.flightDate;
                NSString *num = mapView.rModel.flightNum;
                _confirmListView.bookCar = [NSString stringWithFormat:@"%@ %@ %@",@"接机",time,num];
            }
                break;
            case OrderTypeGive:
            {
                _confirmListView.bookCar = @"送机";
            }
                break;
            default:
            {
                _confirmListView.bookCar = @"预约专车";
            }
                break;
        }
    }
    if (mapView.rModel.passengerPhone) {
        self.confirmListView.phoneNum = mapView.rModel.passengerPhone?[NSString stringWithFormat:@"%@(%@)",mapView.rModel.passengerPhone,mapView.rModel.passenger]:mapView.rModel.passengerPhone;
    }
    //用户号码和名字
    NSString *nickname = [UIFactory getNSUserDefaultsDataWithKey:@"nickname"];
    NSString *userPhone = [UIFactory getNSUserDefaultsDataWithKey:@"phone"];
    NSString *defaultCarType = [UIFactory getNSUserDefaultsDataWithKey:@"defaultCarType"];
    _confirmListView.phoneNum = [NSString stringWithFormat:@"%@(%@)",userPhone,nickname];
    mapView.rModel.passengerPhone = userPhone;
    mapView.rModel.passenger = nickname?:@"";
    mapView.rModel.carType = defaultCarType;
    
    //计算费用
    if ( mapView.rModel.startAddress &&  mapView.rModel.endAddress) {
        [self computationalCostWithType];
    }
}

-(void)tapViewResignConfirmListView
{
    self.navigationItem.rightBarButtonItem = nil;
    [self.confirmListView tapViewResignFirstRespinder];
}

#pragma - mark 获取最新的个人资料
-(void)getUserData
{
    [self.HUDView show:YES];
    QiFacade *facade;
    facade = [QiFacade sharedInstance];
    _flag = [facade getAccountData];
    [facade addHttpObserver:self tag:_flag];
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
}


#pragma -mark 获取车型
-(void)getCarType
{
    QiFacade *facade;
    facade = [QiFacade sharedInstance];
    _flagCarType = [facade getCarData];
    [facade addHttpObserver:self tag:_flagCarType];
}

#pragma - mark 计算费用
-(void)computationalCostWithType
{
    CLLocationCoordinate2D start = self.mapView.rModel.startLocation;
    CLLocationCoordinate2D end   = self.mapView.rModel.endLocation;
    [mapView.rModel computationalDistanceAndTime:start
                                 endLocation:end
     successBlock:^(float distance, float duration) {
        QiFacade *facade;
        facade = [QiFacade sharedInstance];
         if (!mapView.rModel.carType || mapView.rModel.carType.length == 0 || [mapView.rModel.carType isEqualToString:@" "]) {
             mapView.rModel.carType = @"1";
         }
        _flagCost = [facade postFee: [NSString stringWithFormat:@"%f",distance]
                           Time: [NSString stringWithFormat:@"%f",duration]
                           Type: [NSString stringWithFormat:@"%lu",(unsigned long)mapView.rModel.orderType]
                        CarType: [NSString stringWithFormat:@"%@",mapView.rModel.carType]
                            Tip:@"0"];
        [facade addHttpObserver:self tag:_flagCost];
        mapView.rModel.distance = [NSString stringWithFormat:@"%.1f",distance];
        mapView.rModel.time     = [NSString stringWithFormat:@"%.1f",duration];
    } failure:^{
        mapView.rModel.cost    = [NSString stringWithFormat:@"0"];
        _confirmListView.cost  = @"费用预估失败";
    }];
}

#pragma - mark 跳转到预约类型选择
-(void)orderGoing
{
    OrderViewController *order = [[OrderViewController alloc]init];
    order.ordermodel = orderModel;
    [self.navigationController pushViewController:order animated:YES];
}

#pragma - mark 呼叫/预约专车
-(void)useCarWithType:(OrderType)order
{
    QiFacade *facade;
    facade = [QiFacade sharedInstance];
    //时间
    NSString *pre_time = mapView.rModel.preTime?:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    NSString *pre_drive_time = mapView.rModel.time;
    //估算距离
    NSString *pre_distance = mapView.rModel.distance;
    //地址
    NSString *origin   = mapView.rModel.startAddress;
    NSString *destination = mapView.rModel.endAddress;
    NSString *ori_lat = [NSString stringWithFormat:@"%f",mapView.rModel.startLocation.latitude];
    NSString *ori_lon = [NSString stringWithFormat:@"%f",mapView.rModel.startLocation.longitude];
    
    NSString *origin_detail   = mapView.rModel.startAddressDetail;
    NSString *destination_detail   = mapView.rModel.endAddressDetail;
    NSString *des_lat = [NSString stringWithFormat:@"%f",mapView.rModel.endLocation.latitude];;
    NSString *des_lon = [NSString stringWithFormat:@"%f",mapView.rModel.endLocation.longitude];;
    //个人信息
    NSString *real_passenger = mapView.rModel.passenger;
    NSString *real_phone     = mapView.rModel.passengerPhone;
    NSString *send_sms       = mapView.rModel.isSend?(@"1"):(@"0");
    //用车类型
    NSString *type     = [NSString stringWithFormat:@"%lu",(unsigned long)order];
    NSString *car_type = [NSString stringWithFormat:@"%@",mapView.rModel.carType];
    NSString *flight_no = mapView.rModel.flightNum?:@"";
    NSString *flight_date = mapView.rModel.flightDate?:@"";
    
    if (!mapView.rModel.carType || mapView.rModel.carType.length == 0) {
        [self getCarType];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"呼叫失败" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
//    
    _flagOrder = [facade postOrder:pre_time
                            Origin:origin
                       Destination:destination
                     Origin_detail:origin_detail
                destination_detail:destination_detail
                    Real_passenger:real_passenger
                        Real_phone:real_phone
                              Type:type
                       Flight_date:flight_date
                         Flight_no:flight_no
                      Pre_distance:pre_distance
                    Pre_drive_time:pre_drive_time
                          Car_type:car_type
                          Send_sms:send_sms
                           Des_lon:des_lon
                           Des_lat:des_lat
                           Ori_lat:ori_lat
                           Ori_lon:ori_lon];
    [facade addHttpObserver:self tag:_flagOrder];
}

#pragma - mark 网络请求回调
-(void)requestFinished:(NSDictionary *)response tag:(NSInteger)iRequestTag
{
   //[self dismissLoading];
    [self.HUDView hide:YES];
    if (_flag != 0 && response != nil && iRequestTag == _flag) {
        NSLog(@"获取用户资料成功\n%@",response);
        _flag = 0;
        NSString *executing_order = [NSString stringWithFormat:@"%@",[response objectForKey:@"executing_order"]];
        NSLog(@"executing_order:%@",executing_order);
        [self getUserDataFinish:response];
        [self getCarType];
        if ([executing_order integerValue] > 0) {
            orderModel.orderID = executing_order;
            orderModel.newOrder = NO;
            [self orderGoing];//进入订单 .
        }else{
            orderModel.newOrder = YES;
        }
    }
    
    //获取车型
    if (_flagCarType != 0 && response != nil && iRequestTag == _flagCarType) {
         NSLog(@"查看车型成功\n%@",response);
        _flagCarType = 0;
        //默认车型
        NSArray *arr = (NSArray *)response;
        NSDictionary *carTypeDic = [arr objectAtIndex:0];
        NSString *defualtype = [NSString stringWithFormat:@"%@",[carTypeDic objectForKey:@"type"]];
        mapView.rModel.carType = defualtype;
        //保存全部车型
        [UIFactory SaveNSUserDefaultsWithData:response AndKey:@"carTypes"];
        //保存默认车型
        [UIFactory SaveNSUserDefaultsWithData:defualtype AndKey:@"defaultCarType"];
    }
    
    //呼叫/预约专车
    if (_flagOrder != 0 && response != nil && iRequestTag == _flagOrder) {
        NSLog(@"呼叫/预约成功\n%@",response);
        _flagOrder = 0;
        OrderViewController *order = [[OrderViewController alloc]init];
        orderModel.orderState = ORDER_STATUS_A;//状态0
        orderModel.orderID = [[response objectForKey:@"data"]objectForKey:@"order_id"];//id
        orderModel.newOrder = YES;
        order.ordermodel = orderModel;

        if (mapView.rModel.orderType > OrderTypeImmediately) {
            [self pushTravelDetaisController];
        }else{
            [self.navigationController pushViewController:order animated:YES];
        }
    }
    
    //费用预估
    if (_flagCost != 0 && response != nil && iRequestTag == _flagCost) {
        _flagCost = 0;
        NSLog(@"费用预估：%@",response);
        NSString *cost = [[response objectForKey:@"data"] objectForKey:@"fee"];
        mapView.rModel.cost = [NSString stringWithFormat:@"%@",cost];
        mapView.rModel.preferential = [[response objectForKey:@"data"]objectForKey:@"reduce_fee"];
        _confirmListView.cost       = [NSString stringWithFormat:@"预估费用(%@元)",cost];
    }
    
}

-(void)requestFailed:(NSDictionary *)response tag:(NSInteger)iRequestTag
{

     [self.HUDView hide:YES];

    NSString *msg = [response objectForKey:@"message"];
    NSLog(@"失败77\n%@",response );
    
    if (_flag != 0 && response != nil && iRequestTag == _flag) {
        
        _flag = 0;
        
        NSLog(@"获取用户资料失败：%@",[response objectForKey:@"message"]);
        
        if ([[response objectForKey:@"code"] intValue] == 102 || [[response objectForKey:@"message"] isEqualToString:@"无效的授权资料"]) {
            [UIFactory DeleteAllSaveTokenNSUserDefaults];
        }
    }
    
    //费用预估
    if (_flagCost != 0  && iRequestTag == _flagCost) {
        _flagCost = 0;
        NSLog(@"费用预估失败：%@",[response objectForKey:@"message"]);
        mapView.rModel.cost = @"0";
        _confirmListView.cost  = @"费用预估失败";
    }
    
    //呼叫专车
    if (_flagOrder != 0 && response != nil && iRequestTag == _flagOrder) {
        
        _flagOrder = 0;
        NSString *msg = [response objectForKey:@"message"];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:msg message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        alert.tag = 109;
        [alert show];
        
    }
    
    
}

#pragma - mark 预约成功
- (void)pushTravelDetaisController
{
    TravelDetailsController *traveView = [[TravelDetailsController alloc]init];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:orderModel.orderID,@"id", nil];
    traveView.detailDic = dic;
    traveView.isBook = YES;
    traveView.delegate = self;
    [self.navigationController pushViewController:traveView animated:YES];
}

#pragma mark - TravelDetailsControllerDelegate重新获取网络请求，有单开启长链接
-(void)refreshHomeView{
    //重新获取网络请求，有单开启长链接
    [self getUserData];
}

#pragma - mark ConfirmListViewDelegate
-(void)buttonClickDelegate:(id)data viewType:(ConfirmListViewType)type
{
    NSLog(@"clcik button");
    
    if (mapView.rModel.passengerPhone.length == 0||
        mapView.rModel.startAddress.length   == 0||
        mapView.rModel.endAddress.length     == 0||
        mapView.rModel.cost == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请完善资料" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    switch (type) {
        case ConfirmListViewType_call:
        {
            mapView.rModel.orderType = OrderTypeImmediately;
        }
            break;
        case ConfirmListViewType_appointment:
        {
            if (mapView.rModel.preTime.length == 0) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请完善资料" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
        }
            break;
        default:
            break;
    }
    [_confirmListView tapViewResignFirstRespinder];
    [self useCarWithType:mapView.rModel.orderType];
}

-(void)didSelectRowAtSection:(NSInteger)section andRow:(NSInteger)row data:(id)data
{
    NSLog(@"section:%ld,row:%ld",(long)section,(long)row);
    BookTypeController *book = [[BookTypeController alloc] init];
    ChooseController *choose = [[ChooseController alloc] init];
    CostViewController *cost = [[CostViewController alloc] init];
    switch (section) {
        case 0:
            
            switch (row) {
                case 0:
                    //预约时间
                    if (pickTimer == 0) {
                        [self showTimePickerView];
                    }
                    break;
                   
                case 1:
                    //预约用车
                    book.flightDate = mapView.rModel.flightDate;
                    book.type = mapView.rModel.orderType;
                    book.flightNum = mapView.rModel.flightNum;
                    book.bookTypeDelegate = self;
                    [self.navigationController pushViewController:book animated:YES];
                    break;
                    
                default:
                    break;
            }
            break;
        
        case 1:
            
            switch (row) {
                case 0:
                    //电话号码
                    choose.chooseDelegate = self;
                    [self.navigationController pushViewController:choose animated:YES];
                    break;
                    
                case 1:
                    //出发地点
                    //[self.navigationController pushViewController:address animated:YES];
                    [self pushToSearchViewController:SearchStart andAddress:mapView.rModel.startAddress];
                    break;
                    
                case 2:
                    NSLog(@"_confirmListView.endPoint:%@",_confirmListView.endPoint);
                    //到达地点
                    [self pushToSearchViewController:SearchEnd andAddress:mapView.rModel.endAddress];
                    break;
                    
                case 3:
                {
                    //费用预估
                    if (!self.mapView.rModel.startLocation.latitude || !self.mapView.rModel.endLocation.latitude) {
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请选择起点或终点" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                        return;
                    }
                    cost.costDelegate = self;
                    cost.rideModel = self.mapView.rModel;
                    NSArray *cartypes = [UIFactory getNSUserDefaultsDataWithKey:@"carTypes"];
                    if (mapView.rModel.carType && [cartypes isKindOfClass:[NSArray class]] && cartypes.count) {
                        [self.navigationController pushViewController:cost animated:YES];
                    }else{
                        [self getCarType];
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"正在获取车型" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                }
                    break;
                    
                default:
                    break;
            }
            break;
        default:
            break;
    }
    
    //[self.confirmListView removeFromSuperview];
}

#pragma - mark BookTypeDelegate
-(void)loadBookTypeDataWithType:(NSString *)type AndOther:(NSDictionary *)otherDic
{
   
    mapView.rModel.orderType =  [[otherDic objectForKey:@"type"]integerValue];
    mapView.rModel.flightDate = [otherDic objectForKey:@"flightDate"];
    mapView.rModel.flightNum =  [otherDic objectForKey:@"flightNum"];
    self.confirmListView.bookCar = type;
}

#pragma - mark CostDelegate
-(void)loadCostDataWith:(NSString *)money carType:(NSString *)cartype
{
    self.confirmListView.cost = money;
    mapView.rModel.carType = cartype;
    
}

#pragma - mark ChooseDelegate
-(void)loadChooseResultWith:(NSString *)phone name:(NSString *)name AndIsMessage:(BOOL)isMessage
{
    self.confirmListView.phoneNum = name?[NSString stringWithFormat:@"%@(%@)",phone,name]:phone;
    mapView.rModel.passenger = name;
    mapView.rModel.passengerPhone = phone;
    mapView.rModel.isSend = isMessage;
}

#pragma - mark PopViewDelegate
-(void)popBtnDidRingUpByDriverPhoneNumber:(NSString *)phone
{
    [UIFactory callThePhone:phone];
}

#pragma - mark 预约时间选择
-(void)showTimePickerView
{
    pickerBgView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height - 250, self.view.width, 250)];
    pickerBgView.backgroundColor = [UIColor whiteColor];
    [pickerBgView.layer setBorderWidth:0.5f];
    [pickerBgView.layer setBorderColor:COLOR_LINE.CGColor];
    [self.view addSubview:pickerBgView];
    pickTimer = 1;
    
    NSDate *date = [NSDate date];
    UIDatePicker *datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 50, pickerBgView.width, 216)];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    //datePicker.minuteInterval = 5;
    datePicker.minimumDate = date;
    NSDate *minDate = [[NSDate alloc] initWithTimeIntervalSinceNow:60*60];;
    NSDate *maxDate = [[NSDate alloc] initWithTimeIntervalSinceNow:60*60*24*7];;
    
    datePicker.minimumDate = minDate;
    datePicker.maximumDate = maxDate;
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    [pickerBgView addSubview:datePicker];
    
    UIButton *sureBtn = [UIFactory createButton:@"确定" BackgroundColor:[UIColor clearColor] andTitleColor:kUIColorFromRGB(0xf4942d)];
    sureBtn.tag = 1122;
    sureBtn.frame = CGRectMake(pickerBgView.width-70, 10, 60, 20);
    [sureBtn addTarget:self action:@selector(pickerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [pickerBgView addSubview:sureBtn];
    
    UIButton *cancelBtn = [UIFactory createButton:@"取消" BackgroundColor:[UIColor clearColor] andTitleColor:kUIColorFromRGB(0xf4942d)];
    cancelBtn.tag = 3344;
    cancelBtn.frame = CGRectMake(10, 10, 60, 20);
    [cancelBtn addTarget:self action:@selector(pickerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [pickerBgView addSubview:cancelBtn];
    
//    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(pickerBgView.mas_right).offset(-10);
//        make.top.equalTo(pickerBgView.mas_top).offset(10);
//        make.size.mas_equalTo(CGSizeMake(60, 40));
//    }];
//    
//    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(pickerBgView.mas_left).offset(10);
//        make.top.equalTo(pickerBgView.mas_top).offset(10);
//        make.size.mas_equalTo(CGSizeMake(60, 40));
//    }];
    
    if ([UIApplication sharedApplication].keyWindow.rootViewController.navigationController) {
        [[UIApplication sharedApplication].keyWindow.rootViewController.navigationController.view addSubview:pickerBgView];
    }else{
        [[UIApplication sharedApplication].keyWindow addSubview:pickerBgView];
    }
}

#pragma -mark 选择预约时间
-(void)pickerButtonAction:(UIButton *)sender
{
    if (sender.tag == 1122) {
        
        if (![bookTimeStr isEqualToString:@""]) {
            if (bookTimeStr == nil) {
                NSDate *minDate = [[NSDate alloc] initWithTimeIntervalSinceNow:60*60];
                NSTimeInterval time = [minDate timeIntervalSince1970];
                NSLog(@"nnnnn:%@",minDate);
                bookTimeStr = [NSDate getStingTimeWithTime1970:time];
            }
            [self.confirmListView setBookTime:bookTimeStr];
            NSString *preTime = [NSString stringWithFormat:@"%.0f",[NSDate getTimeFor1970WithTimeSting:bookTimeStr]];
            mapView.rModel.preTime = preTime;
            NSLog(@"preTime- %@",preTime);
        }
        
    }
    [UIView animateWithDuration:.3 animations:^{
        pickerBgView.frame = CGRectMake(0, self.view.frame.size.height, pickerBgView.frame.size.width, pickerBgView.frame.size.height);
        
    }completion:^(BOOL finished) {
        [pickerBgView removeFromSuperview];
        pickTimer = 0;
    }];
}
#pragma -mark 点击背景弹回的时候 时间表也弹回
-(void)tapViewResignFirstRespinderDelegate
{
    [UIView animateWithDuration:.3 animations:^{
        pickerBgView.frame = CGRectMake(0, self.view.frame.size.height, pickerBgView.frame.size.width, pickerBgView.frame.size.height);
        
    }completion:^(BOOL finished) {
        [pickerBgView removeFromSuperview];
        pickTimer = 0;
    }];
}

-(void)dateChanged:(id)sender
{
    UIDatePicker* control = (UIDatePicker*)sender;
    NSDate* _date = control.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    bookTimeStr = [dateFormatter stringFromDate:_date];
    
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
