//
//  RideModel.m
//  DriverProject
//
//  Created by 开涛 on 15/9/29.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "RideModel.h"

@implementation RideModel


-(NSDictionary *)attributeMapDictionary{
    
    NSDictionary *mapAtt = @{
                             @"startLocation":@"startLocation",
                             @"endLocation":@"endLocation",
                             @"subTitle":@"subTitle",
                             @"cost":@"cost",
                             @"distance":@"distance",
                             @"time":@"time"
                             };
    return mapAtt;
}

-(void)setAttributes:(NSDictionary *)dataDic{
    
    //将字典的映射关系填充到当前的对象属性上
    [super setAttributes:dataDic];
    
}


//
-(void)computationalDistanceAndTime:(CLLocationCoordinate2D)startLocation
                        endLocation:(CLLocationCoordinate2D)endLocation
                       successBlock:(void(^)(float distance,float duration))successBlock
                            failure:(void(^)())failureBlock
{
    AMapGeoPoint *start = [AMapGeoPoint locationWithLatitude:startLocation.latitude longitude:startLocation.longitude];
    AMapGeoPoint *end = [AMapGeoPoint locationWithLatitude:endLocation.latitude longitude:endLocation.longitude];
    
    AMapNavigationSearchRequest *request = [[AMapNavigationSearchRequest alloc] init];
    request.strategy = 0;
    request.origin = start;
    request.destination = end;
    request.city = @"广州";
    request.searchType = AMapSearchType_NaviDrive;
    
    [[DDSearchManager sharedInstance] searchForRequest:request completionBlock:^(id request, id response, NSError *error) {
        AMapNavigationSearchResponse *aResponse = (AMapNavigationSearchResponse *)response;
        AMapRoute *route = aResponse.route;
        if (route.paths.count == 0) {
            failureBlock();
            return ;
        }
        
        for (AMapPath *path in route.paths) {
            float dis = (float)path.distance/1000;
            float time = (float)path.duration/60;
            NSLog(@"距离：%f公里，耗时：%f分钟",dis,time);
            
            if (dis && time)
            {
                successBlock(dis,time);
                break;
            }else{
                
            }
        }
        
        
    }];
}


@end
