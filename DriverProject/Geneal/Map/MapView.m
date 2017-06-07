//
//  MapView.m
//  DriverProject
//
//  Created by 开涛 on 15/9/25.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "MapView.h"
#import <CoreLocation/CoreLocation.h>

#import "MADriverPointAnnotation.h"

@implementation MapView
{
    NSInteger      _startMap;
    MAMapView     *_mapView;
    UIImageView   *_fixeAnnotation;
    AMapSearchAPI *_search;
    CLLocationManager  *_locationManager;
    NSInteger           _counter;
    NSArray  *_pois;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//ios 8适应打开地图功能
- (void)openLocation
{
    //_startLocationCount = 1;
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.delegate = self;
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
#ifdef __IPHONE_8_0
        if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
        {
            [_locationManager performSelector:@selector(requestAlwaysAuthorization)];//用这个方法，plist中需要NSLocationAlwaysUsageDescription
        }
        
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
            [_locationManager performSelector:@selector(requestWhenInUseAuthorization)];//用这个方法，plist里要加字段NSLocationWhenInUseUsageDescription
        }
#endif
    }
}

//初始化单例

+ (MapView *)sharedInstanceWithFrame:(CGRect)frame {
    static dispatch_once_t pred;
    static MapView *instance = nil;
    dispatch_once(&pred, ^{instance = [[self alloc] initWithFrame:frame];});
    return instance;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        //IOS8打开地图
        [self openLocation];
        
        [MAMapServices sharedServices].apiKey = MAPAPIKEY;
        //[AMapSearchAPI sharedServices].apiKey = MAPAPIKEY;
        
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        _mapView.delegate = self;
        [self addSubview:_mapView];
        
        _mapView.rotateEnabled = NO;
        //启动标志位
        _startMap = 0;
        _isManualDrag = YES;
        //开启定位
        _mapView.touchPOIEnabled = NO;
        _mapView.showsUserLocation = NO;
        //定位模式
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        //初始化检索对象
        _search = [[AMapSearchAPI alloc] initWithSearchKey:MAPAPIKEY Delegate:self];
        _search.delegate = self;
        //初始化模型
        self.rModel = [[RideModel alloc] init];
        _mapView.customizeUserLocationAccuracyCircleRepresentation = YES;

        //大头针
        _pointAnnotation = [[MAPointAnnotation alloc] init];
        [_mapView addAnnotation:_pointAnnotation];
        
        //[self addDrivePois];
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _mapView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
}


#pragma -mark私有方法
////监听回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"乘车状态有了变化");
}


- (CLLocationCoordinate2D)mapAtUserLoction
{
    MAUserLocation *userLocation = _mapView.userLocation;
    CLLocationCoordinate2D center = userLocation.coordinate;
    
    [self setAnnotationLoction:center manual:YES];//设置标注位置
    [self showPointAnnotationWithUserLocation];//大头针指向用户位置处
    return center;
}

-(void)getFixedAnnotationView
{
    if (_fixeAnnotation == nil) {
        _fixeAnnotation = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_map_center_pin"]];
        _fixeAnnotation.frame = CGRectMake(110, 200, _annotationView.frame.size.width, _annotationView.frame.size.height);
        _fixeAnnotation.center = CGPointMake(_mapView.frame.size.width/2, _mapView.frame.size.height/2-15);
        NSLog(@"fixeAnnotation.frame:%f",_fixeAnnotation.frame.origin.x);
        [_mapView addSubview:_fixeAnnotation];
        [_mapView bringSubviewToFront:_fixeAnnotation];
    }
    [_fixeAnnotation setHidden:YES];
}

#pragma -mark设置地图中心位置位置
- (void)setAnnotationLoction:(CLLocationCoordinate2D)coordinate manual:(BOOL)isManuaDrag
{
    //_isManualDrag = 1;
    [_annotationView setHidden:NO];
    [_fixeAnnotation setHidden:YES];
    [_mapView setZoomLevel:16.2 animated:YES];
    _pointAnnotation.coordinate = coordinate;
    [_mapView setCenterCoordinate:coordinate animated:YES];
    if (_annotationView.selected == NO) {
         [_annotationView setSelected:YES animated:YES];
    }    
}

#pragma -mark设置气泡标题
- (void)setCalloutViewTitle
{
//    _annotationView.calloutView.title    = _rModel.startAddress;
//    _annotationView.calloutView.subTitle = _rModel.startAddressDetail;
    [_annotationView setSelected:YES animated:YES];
}

#pragma -mark  地图将要拖动
- (void)mapView:(MAMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    switch (self.mapType) {
        case MyMapTypeHome:
        {
            [_annotationView setHidden:YES];
            [_fixeAnnotation setHidden:NO];
            if (_isManualDrag) {
                NSLog(@"用户拖动");
            }else{
                NSLog(@"自动偏移");
            }
        }
            break;
        case MyMapTypeOrder:
        {
            
        }
            break;
        default:
            break;
    }
    
}

#pragma -mark地图区域改变完成后会调用此接口
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
     CLLocationCoordinate2D coordinate = [mapView convertPoint:CGPointMake(_mapView.frame.size.width/2, _mapView.frame.size.height/2)  toCoordinateFromView:_mapView];
    //CLLocationCoordinate2D coordinate = mapView.userLocation.location.coordinate;
    NSLog(@"当前坐标:%f/%f",coordinate.latitude,coordinate.longitude);
    //
    //[self mapAtUserLoction];
    switch (self.mapType) {
        case MyMapTypeHome:
        {
            if (_isManualDrag) {
                NSLog(@"用户拖动结束");
                _pointAnnotation.coordinate = coordinate;//设置大头针位置
                [_annotationView setHidden:NO];
                [_fixeAnnotation setHidden:YES];
                _annotationView.calloutView.title    = @"定位中...";
                _annotationView.calloutView.subTitle = @"";
                [_annotationView automaticAlignment];
                //逆地理编码
                [self reverseGeographyCode:coordinate];
                //_isManualDrag = 0;
                
            }else{
                NSLog(@"自动偏移结束");
                [_annotationView setHidden:NO];
                [_fixeAnnotation setHidden:YES];
                [_annotationView setSelected:YES animated:NO];
                [_annotationView automaticAlignment];
               //_pointAnnotation.coordinate = coordinate;
                _counter++;
                if (_counter > 1) {
                     _isManualDrag = 1;
                    _counter = 0;
                }else{
                   
                }
            }
        }
            break;
        case MyMapTypeOrder:
        {
            
        }
            break;
        default:
            break;
    }
}

#pragma -mark当位置更新时，会进定位回调，通过回调函数，能获取到定位点的经纬度坐标，示例代码如下：
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
   // CGPoint rect = [mapView convertCoordinate:mapView.centerCoordinate toPointToView:self];
   // NSLog(@"point:%f",rect.x);
    
    if (_startMap == 0) {
        _startMap = 1;
        [self mapAtUserLoction];

//        if (self.mapType == MyMapTypeOrder) {
//            [self.myMapDelegate mapViewFinishDidLoadingMap:mapView];
//        }
        
    }
}


#pragma -mark每次定位成功加载了地图
-(void)mapViewDidFinishLoadingMap:(MAMapView *)mapView dataSize:(NSInteger)dataSize
{
    NSLog(@"成功加载");
    CLLocationCoordinate2D coordinate = [mapView convertPoint:CGPointMake(_mapView.frame.size.width/2, _mapView.frame.size.height/2)  toCoordinateFromView:_mapView];
    //CLLocationCoordinate2D coordinate = mapView.userLocation.location.coordinate;
    NSLog(@"当前坐标2:%f/%f",coordinate.latitude,coordinate.longitude);
}

-(void)mapViewWillStartLoadingMap:(MAMapView *)mapView
{
    
}

-(void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
}

- (void)mapView:(MAMapView *)mapView didAnnotationViewCalloutTapped:(MAAnnotationView *)view
{
    
}

#pragma -mark 获取云图司机数据
- (void)getCloudIndo
{
    CGFloat lat = _mapView.userLocation.location.coordinate.latitude;
    CGFloat lon = _mapView.userLocation.location.coordinate.longitude;

    [DDSearchManager sharedInstance].delegate = self;
    
    [[DDSearchManager sharedInstance]searchCloudWithLocation:lat longitude:lon];
}

#pragma -mark 云图搜索回调
-(void)searchCloudResponse:(id)response
{
    NSLog(@"云数据:%@",response);
    AMapCloudSearchResponse *cloudResponse = (AMapCloudSearchResponse *)response;
    [_mapView removeAnnotations:_driverAnnotationViews];
    _driverAnnotationViews = [[NSMutableArray alloc]init];
    NSArray *pois = cloudResponse.POIs;
    for (AMapCloudPOI *poi in pois) {
        AMapCloudPoint *loc = poi.location;
        NSString *lat = [NSString stringWithFormat:@"%lf",loc.latitude];
        NSString *lon = [NSString stringWithFormat:@"%lf",loc.longitude];
        NSLog(@"lat:%@,lon:%@",lat,lon);
        
        MADriverPointAnnotation *annotation = [[MADriverPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = loc.latitude;
        coor.longitude = loc.longitude;
        annotation.coordinate = coor;
        [_mapView addAnnotation:annotation];
        [_driverAnnotationViews addObject:annotation];
    }
   
//    CLLocationCoordinate2D coordinate = [_mapView convertPoint:CGPointMake(_mapView.frame.size.width/2, _mapView.frame.size.height/2)  toCoordinateFromView:_mapView];
//    [self setAnnotationLoction:coordinate manual:YES];
    if(self.mapType == MyMapTypeOrder){
        [self removeAllDriviers];
    }
}

-(void)showAllDriviers
{
    [_mapView addAnnotations:_driverAnnotationViews];
}
-(void)removeAllDriviers
{
    [_mapView removeAnnotations:_driverAnnotationViews];
}
#pragma -mark 自定义大头针
//大头针
- (void)showPointAnnotationWithUserLocation
{
    if (_pointAnnotation == nil) {
        _pointAnnotation = [[MAPointAnnotation alloc] init];
        [_mapView addAnnotation:_pointAnnotation];
    }
    MAUserLocation *userLocation = _mapView.userLocation;
    CLLocationCoordinate2D coordinate = userLocation.coordinate;
    _pointAnnotation.coordinate = coordinate;
}

#pragma -mark添加大头针（自定义标注）
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        
        if ([annotation isKindOfClass:[MADriverPointAnnotation class]]) {
            static NSString *reuseIndetifier = @"annotationReuseIndetifier";
            MAAnnotationView *driverAnnotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
            if (driverAnnotationView == nil)
            {
                driverAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                                    reuseIdentifier:reuseIndetifier];
                
                driverAnnotationView.image = [UIImage imageNamed:@"car"];
                
            }
            //设置中⼼心点偏移，使得标注底部中间点成为经纬度对应点
            //driverAnnotationView.centerOffset = CGPointMake(0, -15);
            driverAnnotationView.canShowCallout= NO;        //设置气泡可以弹出，默认为NO
            driverAnnotationView.draggable = NO;            //设置标注可以拖动，默认为NO
            driverAnnotationView.selected  = NO ;           //设置标注被选中
            //driverAnnotationView.annotationDelegate = _delegate;//地址搜索代理设置
            return driverAnnotationView;
        }
        
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        _annotationView = (MapCustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (_annotationView == nil)
        {
            _annotationView = [[MapCustomAnnotationView alloc] initWithAnnotation:annotation
                                                                 reuseIdentifier:reuseIndetifier];
            
            _annotationView.image = [UIImage imageNamed:@"icon_map_center_pin"];
            
            //监听值的变化
            //[self addObserver:self forKeyPath:@"driveState" options:0 context:nil];
            
        }
        //设置中⼼心点偏移，使得标注底部中间点成为经纬度对应点
        _annotationView.centerOffset = CGPointMake(0, -15);
        _annotationView.rideState = RideStartState;
        _annotationView.canShowCallout= NO;        //设置气泡可以弹出，默认为NO
        _annotationView.draggable = NO;            //设置标注可以拖动，默认为NO
        _annotationView.selected  = NO ;           //设置标注被选中
        _annotationView.annotationDelegate = _delegate;//地址搜索代理设置
        [self getFixedAnnotationView];
        
        return _annotationView;
    }
    if(annotation == mapView.userLocation){
        NSLog(@"这是小蓝点");
    }
   
    
    return nil;
}



#pragma -mark逆地理编码 获取地址
//逆地理编码
- (void)reverseGeographyCode:(CLLocationCoordinate2D)coor
{
    AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    regeoRequest.location = [AMapGeoPoint locationWithLatitude:coor.latitude longitude:coor.longitude];
    regeoRequest.radius = 10000;
    regeoRequest.requireExtension = YES;

    //发起逆地理编码
    [_search AMapReGoecodeSearch: regeoRequest];
}

#pragma -mark实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil) {
        
        //处理搜索结果
        CLLocationCoordinate2D cood;
        NSString *address0 = response.regeocode.formattedAddress;
        NSString *address1 = response.regeocode.addressComponent.neighborhood?:@"";//社区
        NSString *address2 = response.regeocode.addressComponent.streetNumber.street?:@"";//街道
        NSString *address3 = response.regeocode.addressComponent.streetNumber.number?:@"";//门牌号
        NSArray  *pois      = response.regeocode.pois;
        _pois = pois;
        NSLog(@"address_daolu:%@,%@,距离:%f公里", address2,address3);
        NSLog(@"address0:%@", address0);
        _mapView.delegate = self;
        if (pois.count == 0 && address0.length == 0) {
            NSLog(@"fuck ni lao mu");
            _mapView.delegate = nil;
            CLLocationCoordinate2D center = [self mapAtUserLoction];
            [self reverseGeographyCode:center];
            return;
        }
        
        
        AMapPOI  *apoi = [pois objectAtIndex:0];
        NSString *name = apoi.name;
        NSString *address = apoi.address;
        NSString *businessArea = apoi.businessArea?:@"";
        
        //起始经纬度
        cood.latitude  = (double)apoi.location.latitude;
        cood.longitude = (double)apoi.location.longitude;
        self.rModel.startLocation = cood;
        self.rModel.startAddress  = name;
        if (address.length) {
            self.rModel.startAddressDetail = [NSString stringWithFormat:@"%@%@",businessArea,address];
        }else{
            self.rModel.startAddressDetail = [NSString stringWithFormat:@"%@%@",address2,address3];
        }
        
        //自定义标注设置
        _annotationView.rideModel = self.rModel;
        _annotationView.rideState = RideStartState;
        [_annotationView setSelected:YES animated:YES];
        [_annotationView setHidden:NO];
        [_annotationView automaticAlignment];
        
         //CLLocationCoordinate2D coordinate = [_mapView convertPoint:CGPointMake(_mapView.frame.size.width/2, _mapView.frame.size.height/2)  toCoordinateFromView:_mapView];
        //汽车标注
        [self getCloudIndo];
        if(self.mapType == MyMapTypeOrder){
            _annotationView.rideState = self.driveState;
            //[_annotationView setHidden:YES];
            [_annotationView setSelected:YES animated:YES];
            [_annotationView automaticAlignment];
            [_annotationView setHidden:NO];
        }
        
        [self.myMapDelegate mapViewDidreverseGeographyCode:_mapView];
        
    }else{
        NSLog(@"ReGeo is nil");
       
        CLLocationCoordinate2D center = [self mapAtUserLoction];
        [self reverseGeographyCode:center];
    }
}



@end
