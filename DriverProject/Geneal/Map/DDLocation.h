//
//  DDLocation.h
//  TripDemo
//
//  Created by xiaoming han on 15/4/2.
//  Copyright (c) 2015年 AutoNavi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/**
 *  封装位置信息。
 */
@interface DDLocation : NSObject<NSCopying>

//@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) double coordinateLat;
@property (nonatomic, assign) double coordinateLon;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *cityCode;
@property (nonatomic, strong) NSString *address;


@end
