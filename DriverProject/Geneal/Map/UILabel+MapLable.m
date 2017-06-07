//
//  UILabel+MapLable.m
//  GDAPI
//
//  Created by 开涛 on 15/7/26.
//  Copyright (c) 2015年 com.LHW.TESTGDAPI. All rights reserved.
//

#import "UILabel+MapLable.h"

@implementation UILabel (MapLable)


- (void)autoStretchWidth
{
    self.numberOfLines = 0;
    self.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize sized = [self sizeThatFits:CGSizeMake(ViewWidth,self.frame.size.height)];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, sized.width, sized.height);
}
@end
