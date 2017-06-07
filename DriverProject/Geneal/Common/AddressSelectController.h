//
//  AddressSelectController.h
//  DriverProject
//
//  Created by 林镇杰 on 15/9/28.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "BesaViewController.h"
#import "DDLocation.h"
#import "DDSearchManager.h"

@class AddressSelectController;


@protocol AddressSelectControllerDelegate <NSObject>
@optional

- (void)searchViewController:(UITableView *)table didSelectLocation:(DDLocation *)searchLocation searchType:(SearchType)type;

@end

@interface AddressSelectController : BesaViewController


@property(nonatomic, copy)NSString *addressString;

@property (nonatomic, assign) id<AddressSelectControllerDelegate> delegate;
@property (nonatomic, assign) CLLocationCoordinate2D coordinateLocation;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *city;
@property (assign) SearchType searchType;
@end
