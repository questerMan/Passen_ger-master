//
//  DDSearchViewController.h
//  TripDemo
//
//  Created by xiaoming han on 15/4/3.
//  Copyright (c) 2015年 AutoNavi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DDLocation.h"
@class DDSearchViewController;

//类型
//typedef NS_ENUM(NSUInteger, SearchType) {
//    SearchStart = 0,//起始
//    SearchEnd        //结束
//};

@protocol DDSearchViewControllerDelegate <NSObject>
@optional

- (void)searchViewController:(DDSearchViewController *)searchViewController didSelectLocation:(DDLocation *)searchLocation searchType:(SearchType)type;

@end

/**
 *  搜索地点的视图控制器。使用UISearchBar，对关键字进行搜索，得到相关POI信息。
 */
@interface DDSearchViewController : UIViewController

@property (nonatomic, assign) id<DDSearchViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *city;
@property (assign) SearchType searchType;


@end
