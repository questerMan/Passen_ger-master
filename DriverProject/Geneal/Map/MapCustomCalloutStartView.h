//
//  MapCustomCalloutView.h
//  GDAPI
//
//  Created by 开涛 on 15/7/26.
//  Copyright (c) 2015年 com.LHW.TESTGDAPI. All rights reserved.
//


#import <UIKit/UIKit.h>


//弹出气泡
@interface MapCustomCalloutStartView : UIButton


@property (strong, nonatomic)NSString *title;
@property (strong, nonatomic)NSString *subTitle;
@property (strong, nonatomic)NSString *distance;


//自动适应
- (void)autoStretchWidth;
@end
