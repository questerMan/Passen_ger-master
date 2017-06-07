//
//  MapCustomCalloutDrivingView.h
//  DriverProject
//
//  Created by 开涛 on 15/10/4.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapCustomCalloutDrivingView : UIButton

@property (strong, nonatomic)NSString *title;
@property (strong, nonatomic)NSString *subTitle;

- (void)autoStretchWidth;
@end
