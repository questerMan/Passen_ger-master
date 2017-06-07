//
//  MapView.h
//  DriverProject
//
//  Created by 开涛 on 15/9/25.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import <AMapSearchKit/AMapSearchObj.h>
#import <AMapSearchKit/AMapCommonObj.h>
#import "DDSearchManager.h"
//#import <AMapSearchKit/AMapSearchServices.h>

#import "MapCustomAnnotationView.h"

//暂时未用到
@protocol MyMapVieDidDelegate <NSObject>

- (void)mapViewFinishDidLoadingMap:(MAMapView *)map;

- (void)mapViewDidreverseGeographyCode:(MAMapView *)map;

@end

@interface MapView : UIView<MAMapViewDelegate,
                            CLLocationManagerDelegate,
                            AMapSearchDelegate,
                            MapCustomAnnotationViewDelegate,
                            DDSearchManagerDelegate>


@property(assign, nonatomic)MyMapType mapType;
@property(retain, nonatomic)MapCustomAnnotationView *annotationView;
@property(retain, nonatomic)MAPointAnnotation  *pointAnnotation;
@property(strong, nonatomic)RideModel *rModel;
@property(strong, nonatomic)NSMutableArray *driverAnnotationViews;
@property(assign)RideState driveState;
@property(assign)BOOL isManualDrag; //手动拖拽;
@property(assign)id<MapCustomAnnotationViewDelegate>delegate;
@property(assign)id<MyMapVieDidDelegate>myMapDelegate;

+ (MapView *)sharedInstanceWithFrame:(CGRect)frame;

//回到我的位置
- (CLLocationCoordinate2D)mapAtUserLoction;
//设置标注位置
- (void)setAnnotationLoction:(CLLocationCoordinate2D)userLoction manual:(BOOL)isManuaDrag;

//如果是map为home类型 设置气泡标题
- (void)setCalloutViewTitle;

//添加司机图标
-(void)showAllDriviers;
//移除司机图标
-(void)removeAllDriviers;

@end
