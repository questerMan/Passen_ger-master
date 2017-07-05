//
//  OrderViewController.m
//  DriverProject
//
//  Created by 林镇杰 on 15/10/8.
//  Copyright © 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "OrderViewController.h"
#import "CommonPopView.h"
#import "PayController.h"
#import "PaySuccessController.h"
#import "CancelViewController.h"
#import "HomeViewController.h"
#import "LZJNavigationController.h"
#import "SocketOne.h"
#import "MBProgressHUD.h"

@interface OrderViewController ()<UIAlertViewDelegate,PopViewDelegate,MapCustomAnnotationViewDelegate,SocketOneDelegate>
{
    NSString *titleString;
    NSString *feeFree;
    NSInteger _flagOrder;
    NSInteger _flagCacel;
    NSInteger _flagDetial;
    NSInteger _clickCacel;
    NSInteger _flageDriver;
    NSDictionary  *_driverDic;
//    NSDictionary  *_processDataDic;
    PayController *payView;
    UIButton *cancelBtn;
    CLLocationCoordinate2D driverLocation;
}
@property(strong,nonatomic)MBProgressHUD *HUDView;
@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加地图
    self.mapView = [MapView sharedInstanceWithFrame:self.view.frame];
    //self.mapView.myMapDelegate = self;
    self.mapView.mapType = MyMapTypeOrder;
    [self.view addSubview:self.mapView];
    
   
    
    // Do any additional setup after loading the view.
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(0, 0, 50, 40);
//    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -25, 0.0, 0.0)];
//    [backBtn addTarget:self action:@selector(backToLastView) forControlEvents:UIControlEventTouchUpInside];
    
    cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, 70, 40);
    cancelBtn.tag = 1001;
    [cancelBtn setTitle:@"取消用车" forState:UIControlStateNormal];
    cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [cancelBtn setTitleColor:kUIColorFromRGB(0x212121) forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [cancelBtn addTarget:self action:@selector(cancelUseCarOrder:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
//    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
//    self.navigationItem.backBarButtonItem = item;
    
    self.navigationItem.hidesBackButton = YES;
    
    _clickCacel = 0;//没有点击取消
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }

    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
  
    //支付界面
    //payView = [[PayController alloc]init];
    
    //正在加载
    self.HUDView = [[MBProgressHUD alloc]initWithView:self.view];
    self.HUDView.labelText = @"获取订单中...";
    [self.view addSubview:self.HUDView];
   
}

-(void)viewWillAppear:(BOOL)animated
{
    self.mapView.mapType = MyMapTypeOrder;
    //移除所有司机图标
    [self.mapView removeAllDriviers];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backToLastView)];
}

-(void)viewDidAppear:(BOOL)animated
{
//    //移除所有司机图标
//    [self.mapView removeAllDriviers];
    [self initOpreation];
}
-(void)viewWillDisappear:(BOOL)animated
{
   
}

-(void)initOpreation
{
    if (self.ordermodel.newOrder) {
        [self runSocket];
        self.ordermodel.orderState = ORDER_STATUS_A;
        [self showCalloutByState];
        
    }else{
        [self.HUDView show:YES];
        [self getOrderDetail];
    }
    
    //设置标注位置
    [self.mapView mapAtUserLoction];
    //设置气泡隐藏
    //[self.mapView.annotationView setSelected:NO animated:NO];
    [self.mapView.annotationView setHidden:YES];
    //移除所有司机图标
    [self.mapView removeAllDriviers];
    
}

#pragma - 取消订单
-(void)cancelUseCarOrder:(UIButton *)sender
{
    NSInteger tag = sender.tag;
    //获取订单详情
    switch (tag) {
        case 1001:
        {
            _clickCacel = 1;
            [self getOrderDetail];
        }
            break;
        case 1002:
        {
            //投诉
            CancelViewController *cancel = [[CancelViewController alloc]init];
            NSArray *buttonArray = [NSArray arrayWithObjects:@"服务态度恶劣",@"司机迟到",@"绕路行驶",@"骚扰客人", nil];
            cancel.dateDic = [NSDictionary dictionaryWithObjectsAndKeys:@"投诉",Title_key,@"用车过程中遇到什么问题？",Question_key,buttonArray,ButtonArray_key,@"其他投诉理由",TextInput_key,@"提交",SubmitButton_key,self.ordermodel.orderID,@"orderID", nil];
            [self.navigationController pushViewController:cancel animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}

#pragma - 地图加载完成
-(void)mapViewFinishDidLoadingMap:(MAMapView *)map
{
    if (self.ordermodel.newOrder) {
        [self runSocket];
        self.ordermodel.orderState = ORDER_STATUS_A;
        [self showCalloutByState];
        
    }else{
        [self getOrderDetail];
    }
    [self.mapView.annotationView setHidden:YES];
    //移除所有司机图标
    [self.mapView removeAllDriviers];
}


#pragma - mark socket

-(void)runSocket
{
    [SocketOne sharedInstance].delegate = self;
    [SocketOne sharedInstance].orderID = self.ordermodel.orderID;
    NSString *ipString = [[UIFactory getNSUserDefaultsDataWithKey:@"socket"] objectForKey:@"ip"];
    NSString *portString = [[UIFactory getNSUserDefaultsDataWithKey:@"socket"] objectForKey:@"port"];
    [[SocketOne sharedInstance] connect:ipString withPort:[portString integerValue]];
    NSString *sendSocket=[NSString stringWithFormat:@"{\"action\":\"listen\",\"orderid\":\"%@\"}",self.ordermodel.orderID];
    [[SocketOne sharedInstance] send:sendSocket];
}

-(void)stopSocket
{
    [[SocketOne sharedInstance] disconnect];
}

#pragma - mark司机tip
-(void)showDriverTip:(NSDictionary *)driverDic
{
    CommonPopView *popView = [[CommonPopView alloc]initPopViewFrame:CGRectMake(0, 64, self.view.width, 80) AndDriverData:driverDic];
    NSLog(@"dic=============%@",driverDic);
    _driverDic = [[NSDictionary alloc]initWithDictionary:driverDic];
    popView.popDelegate = self;
    [self.view addSubview:popView];
}

#pragma - mark socketDelegate
-(void)socketResponseWithData:(NSDictionary *)dataDic
{

    NSString *action = [dataDic objectForKey:@"action"];
    NSLog(@"actionxxxxx:%@",action);
//    NSString *test = [dataDic objectForKey:@"test"];
    
    if([action isEqualToString:@"apply"]){//接单

        NSLog(@"接单:%@",dataDic);
        self.ordermodel.orderState = ORDER_STATUS_B;
        if (self.ordermodel.newOrder) {//新单需要获取司机信息
            self.driModel = [[driverModel alloc] init];
            self.driModel.dirverID = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"driver_id"]];
            [self getDriverDic];
        }
    }
    else if([action isEqualToString:@"setoff"]){//发车
        NSLog(@"司机出车:%@",dataDic);
        //终点
        driverLocation.latitude = [[dataDic objectForKey:@"lat"]floatValue];
        driverLocation.longitude = [[dataDic objectForKey:@"lon"]floatValue];
        NSLog(@"self.mapView.rModel.statr.lat:%f",self.mapView.rModel.startLocation.latitude);
        //self.mapView.rModel.endLocation = endLocation;
        [self.mapView setAnnotationLoction:driverLocation manual:YES];//设置标注位置为司机的位置
        self.mapView.pointAnnotation.coordinate = driverLocation;
        self.ordermodel.orderState = ORDER_STATUS_C;
    }
    else if([action isEqualToString:@"onway"]){
        NSLog(@"司机在路上:%@",dataDic);
        //终点
        driverLocation.latitude = [[dataDic objectForKey:@"lat"]floatValue];
        driverLocation.longitude = [[dataDic objectForKey:@"lon"]floatValue];
        //self.mapView.rModel.endLocation = endLocation;
        [self.mapView setAnnotationLoction:driverLocation manual:YES];//设置标注位置为司机的位置
        self.mapView.pointAnnotation.coordinate = driverLocation;
        self.ordermodel.orderState = ORDER_STATUS_C;
    }
    else if([action isEqualToString:@"arrived"]){
        NSLog(@"司机到达目的地:%@",dataDic);
        driverLocation.latitude = [[dataDic objectForKey:@"lat"]floatValue];
        driverLocation.longitude = [[dataDic objectForKey:@"lon"]floatValue];
        [self.mapView setAnnotationLoction:driverLocation manual:YES];//设置标注位置为司机的位置
        self.mapView.pointAnnotation.coordinate = driverLocation;
        self.ordermodel.orderState = ORDER_STATUS_D;
    }
    else if([action isEqualToString:@"geton"]){
        NSLog(@"乘客上车:%@",dataDic);
        self.title = @"行程中";
        driverLocation.latitude = [[dataDic objectForKey:@"lat"] floatValue];
        driverLocation.longitude = [[dataDic objectForKey:@"lon"] floatValue];
        
        NSString *fee = [dataDic objectForKey:@"fee"];
        NSString *km = [dataDic objectForKey:@"km"];
        NSString *min = [dataDic objectForKey:@"min"];
        
        [UIFactory SaveNSUserDefaultsWithData:fee AndKey:@"processfee"];
        [UIFactory SaveNSUserDefaultsWithData:km AndKey:@"km"];
        [UIFactory SaveNSUserDefaultsWithData:min AndKey:@"min"];
        
        [self.mapView setAnnotationLoction:driverLocation manual:YES];//设置标注位置为司机的位置
        self.mapView.pointAnnotation.coordinate = driverLocation;
        
        //设置标注信息
        [self.mapView.annotationView setAnnotationRideState:RideDrivingState];
        if (self.mapView.annotationView.drivingoutView) {
            if (![km floatValue]||![min floatValue]) {
                self.mapView.annotationView.drivingoutView.title = [NSMutableString stringWithFormat:@"0元"];//@"28元";
                self.mapView.annotationView.drivingoutView.subTitle = [NSMutableString stringWithFormat:@"0公里/0分钟"];
            }else{
                self.mapView.annotationView.drivingoutView.title = [NSMutableString stringWithFormat:@"%@元",fee];//@"28元";
                self.mapView.annotationView.drivingoutView.subTitle = [NSMutableString stringWithFormat:@"%@公里/%@分钟",km,min];//@"1公里/2分钟";
            }
           
            [self.mapView.annotationView.drivingoutView autoStretchWidth];
            [self.mapView.annotationView automaticAlignment];
        }
        
        self.ordermodel.orderState = ORDER_STATUS_E;
    }
    else if([action isEqualToString:@"process"]){
        NSLog(@"行驶中:%@",dataDic);
        self.title = @"行程中";
        driverLocation.latitude = [[dataDic objectForKey:@"lat"]floatValue];
        driverLocation.longitude = [[dataDic objectForKey:@"lon"]floatValue];
        [self.mapView setAnnotationLoction:driverLocation manual:YES];//设置标注位置为司机的位置
        self.mapView.pointAnnotation.coordinate = driverLocation;
        self.ordermodel.totalPrice = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"fee"]];
//        self.ordermodel.orderState = ORDER_STATUS_G;
        
        //设置标注信息
        NSString *fee = [dataDic objectForKey:@"fee"];
        NSString *km = [dataDic objectForKey:@"km"];
        NSString *min = [dataDic objectForKey:@"min"];
        
        [UIFactory SaveNSUserDefaultsWithData:fee AndKey:@"processfee"];
        [UIFactory SaveNSUserDefaultsWithData:km AndKey:@"km"];
        [UIFactory SaveNSUserDefaultsWithData:min AndKey:@"min"];
        
        [self.mapView.annotationView setAnnotationRideState:RideDrivingState];
        if (self.mapView.annotationView.drivingoutView) {
            self.mapView.annotationView.drivingoutView.title = [NSMutableString stringWithFormat:@"%@元",fee];//@"28元";
            self.mapView.annotationView.drivingoutView.subTitle = [NSMutableString stringWithFormat:@"%@公里/%@分钟",km,min];//@"1公里/2分钟";
            [self.mapView.annotationView.drivingoutView autoStretchWidth];
            [self.mapView.annotationView automaticAlignment];
        }
    }
    else if([action isEqualToString:@"getoff"]){
        NSLog(@"等待乘客付款:%@",dataDic);
        driverLocation.latitude = [[dataDic objectForKey:@"lat"]floatValue];
        driverLocation.longitude = [[dataDic objectForKey:@"lon"]floatValue];
        [self.mapView setAnnotationLoction:driverLocation manual:YES];//设置标注位置为司机的位置
        self.mapView.pointAnnotation.coordinate = driverLocation;
        self.ordermodel.totalPrice = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"fee"]];
        self.ordermodel.orderState = ORDER_STATUS_G;
    }
    else if([action isEqualToString:@"paid"]){
        NSLog(@"现金支付:%@",dataDic);
        self.ordermodel.orderState = ORDER_STATUS_H;
    }else if ([action isEqualToString:@"cancel"]){
        
        NSString *isFree = [dataDic objectForKey:@"is_free"];
        
        if ([isFree isEqualToString:@"1"]) {
            
            payView = [[PayController alloc]init];
            payView.pageType = PAYVIEW_PAGETYPE_PAYBEFORE;
            
            payView.orderNum = self.ordermodel.orderID;
            
            payView.allCost  = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"fee"]];;
            
            payView.driverDic = _driverDic;
            
            [self.navigationController pushViewController:payView animated:YES];
            
        }else{
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        [[SocketOne sharedInstance]disconnect];
        
        [self.mapView mapAtUserLoction];
        
    }
    else{
        self.ordermodel.orderState = ORDER_STATUS_K;
        // NSLog(@"ping:%@",dataDic);
    }
   

    [self showCalloutByState];
}

-(void)oneClick{
    
}

- (void)showCalloutByState
{
    
    
    switch (self.ordermodel.orderState) {
        case ORDER_STATUS_A:
        {
            self.title = @"正在呼叫";
            _mapView.driveState = RideStartState;
            [self.mapView.annotationView  setSelected:NO animated:NO];
            [self.mapView.annotationView  setHidden:YES];
            //[self.mapView.annotationView  setAnnotationRideState:RideWaitingState];
            //[self.mapView.annotationView  setSelected:NO animated:NO];
            //[self.mapView.annotationView  setNeedsDisplay];//重绘图标
            
        }
            break;
        case ORDER_STATUS_B:
        {
            self.title = @"司机已接单";
            _mapView.driveState = RideWaitingState;
            [self.mapView.annotationView setHidden:NO];
            [self.mapView.annotationView setAnnotationRideState:RideWaitingState];
            
            [self needsDispalyAnnotationView];
            if (self.mapView.annotationView.watingoutView) {
                [self.mapView.annotationView setSelected:YES animated:YES];
                self.mapView.annotationView.watingoutView.title = @"司机已接单";
                [self.mapView.annotationView.watingoutView autoStretchWidth];
                [self.mapView.annotationView automaticAlignment];
               }
        }
            break;
        case ORDER_STATUS_C:
        {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStylePlain target:self action:@selector(oneClick)];

            self.title = @"等待接驾";
            //计算距离和时间
            //司机坐标
            //self.mapView.annotationView.selected = YES;
            _mapView.driveState = RideWaitingState;
            [self needsDispalyAnnotationView];
            //[self.mapView.annotationView.watingoutView autoStretchWidth];
            [self.mapView.annotationView automaticAlignment];
            [self.mapView.annotationView setAnnotationRideState:RideWaitingState];
            
            if (self.mapView.rModel.startLocation.latitude && self.mapView.rModel.endLocation.latitude) {
                [self.mapView.rModel computationalDistanceAndTime:self.mapView.rModel.startLocation endLocation:driverLocation successBlock:^(float distance, float duration) {
                    //self.mapView.annotationView.selected = YES;
                    NSLog(@"%.1f公里/%.0f分钟",distance,duration);
                    self.mapView.annotationView.watingoutView.title = [NSString stringWithFormat:@"预计车辆%.0f分钟后到达",duration];
                    [self.mapView.annotationView automaticAlignment];
                } failure:^{
                    self.mapView.annotationView.watingoutView.title = @"正在前往目的地";
                    [self.mapView.annotationView automaticAlignment];
                }];
            }else{
                self.mapView.annotationView.watingoutView.title = @"正在前往目的地";
                [self.mapView.annotationView automaticAlignment];
            }
        }
            break;
        case ORDER_STATUS_D:
        {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStylePlain target:self action:@selector(oneClick)];

            self.title = @"车辆已到达";
            [self needsDispalyAnnotationView];
            _mapView.driveState = RideWaitingState;
            [self.mapView.annotationView setAnnotationRideState:RideWaitingState];
            if (self.mapView.annotationView.watingoutView) {
                self.mapView.annotationView.watingoutView.title = @"车辆已到达";
                [self.mapView.annotationView automaticAlignment];
            }
            if(cancelBtn.tag == 1001){
                cancelBtn.tag = 1002;
                [cancelBtn setTitle:@"投诉" forState:UIControlStateNormal];
            }
        }
            break;
        case ORDER_STATUS_E:
        {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStylePlain target:self action:@selector(oneClick)];

            self.title = @"行程中";
            //修改右边按钮
//            [self.mapView.annotationView setSelected:NO animated:NO];
//            [self.mapView.annotationView setSelected:YES animated:NO];
            _mapView.driveState = RideDrivingState;
            [self.mapView.annotationView setAnnotationRideState:RideDrivingState];
            //[self.mapView.annotationView.drivingoutView autoStretchWidth];
            [self.mapView.annotationView automaticAlignment];
            
            [self needsDispalyAnnotationView];
            if(cancelBtn.tag == 1001){
                cancelBtn.tag = 1002;
                [cancelBtn setTitle:@"投诉" forState:UIControlStateNormal];
            }
            
            
            NSString* fee = [UIFactory getNSUserDefaultsDataWithKey:@"processfee"];
            NSString* km = [UIFactory getNSUserDefaultsDataWithKey:@"km"];
            NSString* min = [UIFactory getNSUserDefaultsDataWithKey:@"min"];
            if ([fee isEqualToString:@" "]||[km isEqualToString:@" "]||[min isEqualToString:@" "]) {
                fee = @"0";
                km  = @"0";
                min = @"0";
            }
            
            if (self.mapView.annotationView.drivingoutView) {
            self.mapView.annotationView.drivingoutView.title = [NSMutableString stringWithFormat:@"%@元",[UIFactory getNSUserDefaultsDataWithKey:@"processfee"]];//@"28元";
            self.mapView.annotationView.drivingoutView.subTitle = [NSMutableString stringWithFormat:@"%@公里/%@分钟",[UIFactory getNSUserDefaultsDataWithKey:@"km"],[UIFactory getNSUserDefaultsDataWithKey:@"min"]];//@"1公里/2分钟";
            [self.mapView.annotationView.drivingoutView autoStretchWidth];
            [self.mapView.annotationView automaticAlignment];
            }
        }
            break;
        case ORDER_STATUS_G:
        {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStylePlain target:self action:@selector(oneClick)];

            //付款
           //[self needsDispalyAnnotationView];
            payView = [[PayController alloc]init];
            payView.pageType = PAYVIEW_PAGETYPE_PAYBEFORE;
            payView.orderNum = self.ordermodel.orderID;
            payView.allCost  = self.ordermodel.totalPrice;
            NSLog(@"dic-----------%@",_driverDic);
            payView.driverDic = _driverDic;
            NSLog(@"nav:%@",self.navigationController);
            [self.navigationController pushViewController:payView animated:YES];
            //[nav pushViewController:payView animated:YES];
//            [self presentViewController:payView animated:YES completion:^{
//                
//            }];
            [UIFactory SaveNSUserDefaultsWithData:@"0" AndKey:@"processfee"];
            [UIFactory SaveNSUserDefaultsWithData:@"0" AndKey:@"km"];
            [UIFactory SaveNSUserDefaultsWithData:@"0" AndKey:@"min"];
        }
            break;
        case ORDER_STATUS_H:
        {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStylePlain target:self action:@selector(oneClick)];

            //现金支付
            [self needsDispalyAnnotationView];
            [self stopSocket];
            [self.mapView mapAtUserLoction];//回到用户位置
            //[self.navigationController popToRootViewControllerAnimated:NO];
            PaySuccessController *paySuccess = [[PaySuccessController alloc]init];
            paySuccess.orderNum = self.ordermodel.orderID;
            paySuccess.payType = @"main";
            [self.navigationController pushViewController:paySuccess animated:YES];
            
            [UIFactory SaveNSUserDefaultsWithData:@"0" AndKey:@"processfee"];
            [UIFactory SaveNSUserDefaultsWithData:@"0" AndKey:@"km"];
            [UIFactory SaveNSUserDefaultsWithData:@"0" AndKey:@"min"];
        }
            break;
        case ORDER_STATUS_K:
        {
            
        }
            break;
            
        default:
            break;
    }

}

#pragma - mark 重绘图标
-(void)needsDispalyAnnotationView
{
    [self.mapView.annotationView  setHidden:NO];
    self.mapView.annotationView.image = [UIImage imageNamed:@"car"];
    [self.mapView.annotationView setNeedsDisplay];//重绘图标
    [self.view setNeedsDisplay];
}

#pragma - mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    if (buttonIndex == 0) {
//        
//        NSDictionary *driverDic = [NSDictionary dictionaryWithObjectsAndKeys:@"刘师傅",DRIVER_NAME_KEY,@"粤A**P45 大众辉腾",DRIVER_CAR_KEY,@"8",DRIVER_STAR_KEY,@"154单",DRIVER_ORDER_COUNT_KEY,@"18665751365",DRIVER_PHONE_NUMBER_KEY, nil];
//        CommonPopView *popView = [[CommonPopView alloc]initPopViewFrame:CGRectMake(0, 64, self.view.width, 80) AndDriverData:driverDic];
//        popView.popDelegate = self;
//        [self.view addSubview:popView];
//        
//        self.title = @"等待接驾";
//        self.navigationController.navigationItem.hidesBackButton = YES;
//        //[self.navigationItem setHidesBackButton:YES];
//        
//    }else if (buttonIndex == 1){
//        
//        self.title = @"司机已到达";
//        [self backToLastView];
//    }
    
    switch (alertView.tag) {
        case 101:
        {
            if (buttonIndex == 0) {
                //[self.navigationController popViewControllerAnimated:YES];
            }
            if (buttonIndex == 1) {
               [self cancelCall];
            }
        }
            break;
        case 102:
        {
            if (buttonIndex == 0) {
                [self cancelCall];
            }
        }
            break;
            case 103:
        {
            if (buttonIndex == 1) {
                //付款
                [self cancelCall];
                
            }
        }
            
        default:
            break;
    }
}

-(void)backToLastView
{
//
    [self stopSocket];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma - mark获取司机信息
-(void)getDriverDic
{
    QiFacade *facade;
    facade = [QiFacade sharedInstance];
    
    _flageDriver =[facade getDriverDataWithID:self.driModel.dirverID];
    [facade addHttpObserver:self tag:_flageDriver];
}

#pragma - mark 获取订单详情
-(void)getOrderDetail
{
    QiFacade *facade;
    facade = [QiFacade sharedInstance];

    _flagOrder =[facade getOrderDetailsWithID:self.ordermodel.orderID];
    [facade addHttpObserver:self tag:_flagOrder];
}

#pragma - mark 取消订单
-(void)cancelCall
{
    QiFacade *facade;
    facade = [QiFacade sharedInstance];
    _flagCacel = [facade putOrder:nil WithID:self.ordermodel.orderID];
    [facade addHttpObserver:self tag:_flagCacel];
}

#pragma - mark 网络请求回调
-(void)requestFinished:(NSDictionary *)response tag:(NSInteger)iRequestTag
{
    NSLog(@"成功55\n%@",response);
    
    if (_flagOrder != 0 && response != nil && iRequestTag == _flagOrder) {
        _flagOrder = 0;
        
        self.ordermodel.freeCancel = [NSString stringWithFormat:@"%@",[[response objectForKey:@"free_cancel"]objectForKey:@"free_cancel"]];
        feeFree = [NSString stringWithFormat:@"%@",[[response objectForKey:@"free_cancel"]objectForKey:@"cancel_fee"]];
        if (_clickCacel) {
            _clickCacel = 0;
            if ([self.ordermodel.freeCancel isEqualToString:@"1"]) {//免费取消
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"您确定取消本次用车吗?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    [alert show];
                alert.tag = 101;
                return;
            }else{//收费取消 跳转到收费页面
                NSLog(@"收费取消\n%@",response);
                NSString *cacelMsg = [NSString stringWithFormat:@"%@",[[response objectForKey:@"free_cancel"]objectForKey:@"cancel_msg"]];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:cacelMsg message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
                alert.tag = 103;
                
                return;
            }
        }
        
        if (self.ordermodel.newOrder) {
            
        }else{
            //未完成订单 发起socket
            //起点
            CLLocationCoordinate2D startLocation;
            startLocation.latitude = [[[response objectForKey:@"origin"]objectForKey:@"lat"]floatValue];
            startLocation.longitude = [[[response objectForKey:@"origin"]objectForKey:@"lon"]floatValue];
            self.mapView.rModel.startLocation = startLocation;
            
            //终点
            CLLocationCoordinate2D endLocation;
            driverLocation.latitude = [[[response objectForKey:@"dest"]objectForKey:@"lat"]floatValue];
            driverLocation.longitude = [[[response objectForKey:@"dest"]objectForKey:@"lon"]floatValue];
            self.mapView.rModel.endLocation = driverLocation;
            
            //当前状态
            
            //司机信息
            self.ordermodel.orderState = [[response objectForKey:@"status"]integerValue];
            NSDictionary *driverDic = [response objectForKey:@"driver"];
            if (!(self.ordermodel.orderState == ORDER_STATUS_A)) {
                [self showDriverTip:driverDic];
            }

            //
            self.ordermodel.orderState = [[response objectForKey:@"status"]integerValue];
            self.ordermodel.totalPrice = [NSString stringWithFormat:@"%@",[response objectForKey:@"fee"]];
            
            [self showCalloutByState];
            [self runSocket];
        }
    }else if (_flagCacel != 0 && response != nil && iRequestTag == _flagCacel){//直接取消
        _flagCacel = 0;
        //NSLog(@"直接取消订单:%@",response);
        NSInteger cancelTag = [[[response objectForKey:@"data"]objectForKey:@"free_cancel"] integerValue];
        if (cancelTag == 2) {
            NSLog(@"收费取消订单:%@",response);
            payView = [[PayController alloc]init];
            payView.pageType = PAYVIEW_PAGETYPE_PAYBEFORE;
            payView.orderNum = self.ordermodel.orderID;
            payView.allCost  = feeFree;
            payView.driverDic = _driverDic;
            [self.navigationController pushViewController:payView animated:YES];
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        [[SocketOne sharedInstance]disconnect];
        [self.mapView mapAtUserLoction];
        
    }else if (_flageDriver != 0 && response != nil && iRequestTag == _flageDriver){
        _flagCacel = 0;
        NSLog(@"司机详情");
        NSLog(@"司机详情\n%@",response);
        NSDictionary *driverDic = [response objectForKey:@"driver"];
        [self showDriverTip:response];
    }
    [self.HUDView hide:YES];
}
#pragma - mark 网络请求失败
-(void)requestFailed:(NSDictionary *)response tag:(NSInteger)iRequestTag
{
    NSString *msg = [response objectForKey:@"message"];
    NSLog(@"失败\n%@\n%@",response,msg);
    [self.HUDView hide:YES];
    
    //获取到详情后 发起socket
    if (_flagOrder != 0  && iRequestTag == _flagOrder) {
        NSLog(@"获取订单详情失败");
        _flagOrder = 0;
        [self initOpreation];//继续发起获取订单
    }
    if (_flagCacel != 0 && iRequestTag == _flagCacel) {
        NSLog(@"取消失败");
        _flagCacel = 0;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:msg message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        alert.tag = 103;
    }
}

#pragma - mark PopViewDelegate
-(void)popBtnDidRingUpByDriverPhoneNumber:(NSString *)phone
{
    [UIFactory callThePhone:phone];
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
