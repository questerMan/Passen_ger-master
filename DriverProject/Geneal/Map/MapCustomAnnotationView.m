//
//  MapCustomAnnotationView.m
//  GDAPI
//
//  Created by 开涛 on 15/7/26.
//  Copyright (c) 2015年 com.LHW.TESTGDAPI. All rights reserved.
//

#import "MapCustomAnnotationView.h"


@interface MapCustomAnnotationView ()<UIGestureRecognizerDelegate>

//@property (nonatomic, strong, readwrite) MapCustomCalloutStartView *calloutView;
//@property (nonatomic, strong, readwrite) MapCustomCalloutEndView   *endCalloutView;

@end

@implementation MapCustomAnnotationView



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
//    if (self.selected == selected)
//    {
//        return;
//    }
    
    if (selected)
    {
        switch (self.rideState) {
            case RideStartState:
            {
                [self.watingoutView removeFromSuperview];
                [self.drivingoutView removeFromSuperview];
                [self.endCalloutView removeFromSuperview];
                if (self.calloutView == nil)
                {
                    self.calloutView = [[MapCustomCalloutStartView alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
                    self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                          -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
                    [self.calloutView addTarget:self action:@selector(locationPushToSearchViewControler:) forControlEvents:UIControlEventTouchUpInside];
                }
                
                self.calloutView.title = self.rideModel.startAddress;
                self.calloutView.subTitle = self.rideModel.startAddressDetail;
                
                [self addSubview:self.calloutView];
                
            }
                
                break;
            case RideWaitingState:
            {
                [self.calloutView removeFromSuperview];
                [self.drivingoutView removeFromSuperview];
                [self.endCalloutView removeFromSuperview];
                if (self.watingoutView == nil)
                {
                    self.watingoutView = [[MapCustomCalloutWatingView alloc] initWithFrame:CGRectMake(0, 0, 120, 50)];
                    
                    self.watingoutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x, CGRectGetHeight(self.watingoutView.bounds) / 2.f + self.calloutOffset.y);
                }
                 //self.watingoutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x, CGRectGetHeight(self.watingoutView.bounds) / 2.f + self.calloutOffset.y);
               
                if (!self.watingoutView.title.length) {
                    self.watingoutView.title = [NSString stringWithFormat:@"正在前往"];
                }
                [self automaticAlignment];
                [self addSubview:self.watingoutView];
            }
                break;
                
                case RideArriveState:
            {
                [self.calloutView removeFromSuperview];
                [self.drivingoutView removeFromSuperview];
                [self.endCalloutView removeFromSuperview];
                if (self.watingoutView == nil)
                {
                    self.watingoutView = [[MapCustomCalloutWatingView alloc] initWithFrame:CGRectMake(0, 0, 120, 50)];
                    
                    self.watingoutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x, CGRectGetHeight(self.watingoutView.bounds) / 2.f + self.calloutOffset.y);
                }
                self.watingoutView.title = [NSString stringWithFormat:@"司机已到达"];
                [self addSubview:self.watingoutView];
                
            }
                break;
                
                case RideDrivingState:
            {
                [self.calloutView removeFromSuperview];
                [self.watingoutView removeFromSuperview];
                [self.endCalloutView removeFromSuperview];
                if (self.drivingoutView == nil)
                {
                    self.drivingoutView = [[MapCustomCalloutDrivingView alloc] initWithFrame:CGRectMake(0, 0, 120, 50)];
                    
                    self.drivingoutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x, CGRectGetHeight(self.drivingoutView.bounds) / 2.f + self.calloutOffset.y);
                }
                self.drivingoutView.title = [NSString stringWithFormat:@"0元"];
                self.drivingoutView.subTitle = [NSString stringWithFormat:@"0公里/0分钟"];
                [self addSubview:self.drivingoutView];
            }
                break;
            default:
                break;
        }
        
    }
    else
    {
        [self.calloutView removeFromSuperview];
        [self.watingoutView removeFromSuperview];
        [self.drivingoutView removeFromSuperview];
        [self.endCalloutView removeFromSuperview];
    }
    
    //[super setSelected:selected animated:animated];
}

-(void)setAnnotationRideState:(RideState)rideState
{
    self.rideState = rideState;
    [self setSelected:YES animated:NO];
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
//    if (self.rideState == RideWaitingState ||
//        self.rideState == RideArriveState ||
//        self.rideState == RideDrivingState)
//    {
//        return NO;
//    }
    return YES;
}

- (void)locationPushToSearchViewControler:(id)sender
{
    if ([self.annotationDelegate respondsToSelector:@selector(pushToSearchViewController:andAddress:)]) {
    
    [self.annotationDelegate pushToSearchViewController:SearchStart  andAddress:self.rideModel.startAddress];
        
    }
}

- (void)automaticAlignment
{
    
    switch (self.rideState) {
        case RideStartState:
            [self.calloutView autoStretchWidth];
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,-CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
            break;
        case RideWaitingState:
        case RideArriveState:
            [self.watingoutView autoStretchWidth];
            self.watingoutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,-CGRectGetHeight(self.watingoutView.bounds) / 2.f + self.calloutOffset.y);
            break;

        case RideDrivingState:
            [self.drivingoutView autoStretchWidth];
            self.drivingoutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,-CGRectGetHeight(self.drivingoutView.bounds) / 2.f + self.calloutOffset.y);
            break;
            
        default:
            break;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
