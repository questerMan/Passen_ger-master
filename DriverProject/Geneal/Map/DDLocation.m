//
//  DDLocation.m
//  TripDemo
//
//  Created by xiaoming han on 15/4/2.
//  Copyright (c) 2015年 AutoNavi. All rights reserved.
//

#import "DDLocation.h"

@implementation DDLocation

- (NSString *)description
{
    return [NSString stringWithFormat:@"name:%@, cityCode:%@, address:%@, coordinate:%f, %f", self.name, self.cityCode, self.address, self.coordinateLat, self.coordinateLon];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.cityCode forKey:@"cityCode"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeDouble:self.coordinateLat forKey:@"coordinateLat"];
    [aCoder encodeDouble:self.coordinateLon forKey:@"coordinateLon"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.cityCode = [aDecoder decodeObjectForKey:@"cityCode"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.coordinateLat = [aDecoder decodeDoubleForKey:@"coordinateLat"];
        self.coordinateLon = [aDecoder decodeDoubleForKey:@"coordinateLon"];
    }
    return self;
}


@end
