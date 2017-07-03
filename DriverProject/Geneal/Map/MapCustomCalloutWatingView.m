//
//  MapCustomCalloutWatingView.m
//  DriverProject
//
//  Created by 开涛 on 15/10/4.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "MapCustomCalloutWatingView.h"

@implementation MapCustomCalloutWatingView
{
    UILabel *_titleLable;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _titleLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 100, 25)];
        _titleLable.text = [NSString stringWithFormat:@"1公里/2分钟"];
        _titleLable.font = [UIFont systemFontOfSize:14];
        _titleLable.textColor = [UIColor blackColor];
        _titleLable.userInteractionEnabled = YES;
        _titleLable.textAlignment= NSTextAlignmentCenter;
        [_titleLable autoStretchWidth];
        [self addSubview:_titleLable];
        
//        self.backgroundColor = [UIColor colorWithWhite:.98 alpha:1];
//        self.layer.cornerRadius = 5;
        
    }
    return self;
}

- (void)autoStretchWidth
{
    [_titleLable autoStretchWidth];

    self.frame  = CGRectMake(self.frame.origin.x, self.frame.origin.y, _titleLable.frame.size.width+30, _titleLable.frame.size.height+30);
    [self setNeedsDisplay];
}
- (void)setTitle:(NSString *)title
{
    _title = title;
    NSString *ti = @"车辆已到达";
    if (![title isEqualToString:ti]) {
        NSRange range = [title rangeOfString:@"/"];
        if (range.length) {
            NSRange r1 = [title rangeOfString:@"公"];
            NSRange r2 = [title rangeOfString:@"/"];
            NSRange r3 = [title rangeOfString:@"分"];
            NSRange rx = NSMakeRange(0,r1.location);
            NSRange ry = NSMakeRange((r2.location+1),(r3.location-r2.location-1));
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:title];
            [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(@"#4caf50") range:rx];
            [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(@"#4caf50") range:ry];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0] range:rx];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0] range:ry];
            _titleLable.attributedText = str;
            _titleLable.text = title;
        }else{
            _titleLable.text = title;
            _titleLable.font = [UIFont systemFontOfSize:14];
        }
        
    }else{
        _titleLable.text = title;
        _titleLable.font = [UIFont systemFontOfSize:14];
    }
    if (title.length == 0) {
        _titleLable.text = @"定位中...";
    }
    [self autoStretchWidth];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
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
