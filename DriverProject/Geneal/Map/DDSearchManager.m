//
//  DDSearchManager.m
//  TripDemo
//
//  Created by xiaoming han on 15/4/3.
//  Copyright (c) 2015年 AutoNavi. All rights reserved.
//

#import "DDSearchManager.h"

@interface DDSearchManager ()<AMapSearchDelegate,AMapCloudDelegate>
{
    AMapSearchAPI *_search;
    AMapCloudAPI  *_cloud;
    NSMapTable    *_mapTableXKT;
}
@end

@implementation DDSearchManager

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _search  = [[AMapSearchAPI alloc] initWithSearchKey:MAPAPIKEY Delegate:self];
        _cloud = [[AMapCloudAPI alloc] initWithCloudKey:MAPAPIKEY delegate:self];
        
        _mapTableXKT = [[NSMapTable alloc]initWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsCopyIn capacity:0];
    }
    return self;
}


- (void)searchForRequest:(id)request completionBlock:(DDSearchCompletionBlock)block
{
    if ([request isKindOfClass:[AMapPlaceSearchRequest class]])
    {
        [_search AMapPlaceSearch:request];
    }
    else if ([request isKindOfClass:[AMapInputTipsSearchRequest class]])
    {
        [_search AMapInputTipsSearch:request];
    }
    else if ([request isKindOfClass:[AMapGeocodeSearchRequest class]])
    {
        [_search AMapGeocodeSearch:request];
    }
    else if ([request isKindOfClass:[AMapReGeocodeSearchRequest class]])
    {
        [_search AMapReGoecodeSearch:request];
    }
    else if ([request isKindOfClass:[AMapNavigationSearchRequest class]])
    {
        [_search AMapNavigationSearch:request];
    }
    else
    {
        NSLog(@"unsupported request");
        return;
    }
    
    [_mapTableXKT setObject:block forKey:request];
}

#pragma mark - Helpers

- (void)performBlockWithRequest:(id)request withResponse:(id)response
{
     NSString *tou = [NSString stringWithFormat:@"%@",[_mapTableXKT class]];
     NSLog(@"obj:%@",tou);

    DDSearchCompletionBlock block = [(NSMapTable *)_mapTableXKT objectForKey:request];
    if (block)
    {
        block(request, response, nil);
    }
    
    [_mapTableXKT removeObjectForKey:request];
}

#pragma mark - AMapSearchDelegate

- (void)searchRequest:(id)request didFailWithError:(NSError *)error
{
    DDSearchCompletionBlock block = [_mapTableXKT objectForKey:request];
    
    if (block)
    {
        block(request, nil, error);
    }
    
    [_mapTableXKT removeObjectForKey:request];
}

- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{
    [self performBlockWithRequest:request withResponse:response];
}

-(void)onNavigationSearchDone:(AMapNavigationSearchRequest *)request response:(AMapNavigationSearchResponse *)response
{
    [self performBlockWithRequest:request withResponse:response];
}

//-(void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
//{
//    [self performBlockWithRequest:request withResponse:response];
//}

- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    [self performBlockWithRequest:request withResponse:response];
}

- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    [self performBlockWithRequest:request withResponse:response];
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    [self performBlockWithRequest:request withResponse:response];
}

//- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
//{
//    [self performBlockWithRequest:request withResponse:response];
//}


#pragma -mark 云图搜索
- (void)searchCloudWithLocation:(CGFloat)lat longitude:(CGFloat)lon
{
    AMapCloudPlaceAroundSearchRequest *placeAround = [[AMapCloudPlaceAroundSearchRequest alloc] init];
    [placeAround setTableID:CLOUDTABLEID];
    AMapCloudPoint *centerPoint = [AMapCloudPoint locationWithLatitude:lat longitude:lon];
    [placeAround setRadius:CLOUDRDIUS];
    [placeAround setCenter:centerPoint];
    [placeAround setOffset:100];
    [placeAround setPage:1];
    [_cloud AMapCloudPlaceAroundSearch:placeAround];
}


-(void)onCloudPlaceAroundSearchDone:(AMapCloudPlaceAroundSearchRequest *)request response:(AMapCloudSearchResponse *)response
{
    //_cloudBlock(request,response);
    [self.delegate searchCloudResponse:response];
}

@end
