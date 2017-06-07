//
//  MapCustomCalloutDrivingView.m
//  DriverProject
//
//  Created by 开涛 on 15/10/4.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "MapCustomCalloutDrivingView.h"

@implementation MapCustomCalloutDrivingView

{
    UILabel *_titleLable;
    UILabel *_subTitleLable;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _titleLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 50, 25)];
        _titleLable.text = [NSString stringWithFormat:@"0元"];
        _titleLable.font = [UIFont boldSystemFontOfSize:20];
        _titleLable.textColor = [UIColor blackColor];
        _titleLable.userInteractionEnabled = YES;
        _titleLable.textAlignment= NSTextAlignmentLeft;
        [_titleLable autoStretchWidth];
        [self addSubview:_titleLable];
        
        _subTitleLable = [[UILabel alloc]initWithFrame:CGRectMake(15, _titleLable.frame.size.height, 50, 25)];
        _subTitleLable.text = [NSString stringWithFormat:@"0公里/0分钟"];
        _subTitleLable.font = [UIFont systemFontOfSize:14];
        _subTitleLable.textColor = [UIColor grayColor];
        _subTitleLable.userInteractionEnabled = YES;
        _subTitleLable.textAlignment= NSTextAlignmentLeft;
        [_subTitleLable autoStretchWidth];
        [self addSubview:_subTitleLable];
        
    }
    return self;
}

- (void)autoStretchWidth
{
    [_titleLable autoStretchWidth];
    [_subTitleLable autoStretchWidth];
    
    self.frame  = CGRectMake(self.frame.origin.x, self.frame.origin.y, _subTitleLable.frame.size.width+30, _titleLable.frame.size.height+_subTitleLable.frame.size.height+20);
    [self setNeedsDisplay];
}
- (void)setTitle:(NSString *)title
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:title];
    [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(@"#4caf50") range:NSMakeRange(0,title.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(0,title.length)];
    _titleLable.attributedText = str;
    [self autoStretchWidth];
}


- (void)setSubTitle:(NSString *)subTitle
{
    _subTitleLable.text = subTitle;
    [self autoStretchWidth];
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 1.0);
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [UIColor colorWithWhite:0.98 alpha:1.0].CGColor);
    
    CGRect rrect = self.bounds;
    CGFloat radius = 6.0;
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect)-kArrorHeight;
    
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), midx+kArrorHeight, maxy);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(),midx, maxy+kArrorHeight);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(),midx-kArrorHeight, maxy);
    
    CGContextAddArcToPoint(UIGraphicsGetCurrentContext(), minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(UIGraphicsGetCurrentContext(), minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(UIGraphicsGetCurrentContext(), maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(UIGraphicsGetCurrentContext(), maxx, maxy, midx, maxy, radius);
    CGContextClosePath(UIGraphicsGetCurrentContext());
    
    CGContextFillPath(UIGraphicsGetCurrentContext());
    
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    //    self.layer.borderWidth = 1;
    //    self.layer.borderColor = [[UIColor blackColor] CGColor];
}


@end
