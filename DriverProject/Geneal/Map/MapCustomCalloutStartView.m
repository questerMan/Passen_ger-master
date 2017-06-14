//
//  MapCustomCalloutView.m
//  GDAPI
//
//  Created by 开涛 on 15/7/26.
//  Copyright (c) 2015年 com.LHW.TESTGDAPI. All rights reserved.
//

#import "MapCustomCalloutStartView.h"

@implementation MapCustomCalloutStartView
{
    UILabel     *_titleLable;
    UILabel     *_subTitleLable;
    UIImageView *_accessoryImageView;
    UIImageView *_arrow;
    CALayer     *_highLightLayer;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _titleLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 25)];
        _titleLable.text = [NSString stringWithFormat:@"定位中..."];
        _titleLable.font = [UIFont boldSystemFontOfSize:14];
        _titleLable.textColor = kUIColorFromRGB(0x4caf50);
//        _titleLable.textColor = [UIColor colorWithHexString:@"#4caf50"];
        _titleLable.userInteractionEnabled = NO;
        [_titleLable autoStretchWidth];
        [self addSubview:_titleLable];
        
        _subTitleLable = [[UILabel alloc]initWithFrame:CGRectMake(_titleLable.frame.origin.x, _titleLable.frame.size.height+_titleLable.frame.origin.y, 100, 25)];
        _subTitleLable.text = [NSString stringWithFormat:@"最快%@分钟接驾 车程%@公里",self.subTitle,self.distance];
        _subTitleLable.font = [UIFont systemFontOfSize:13];
        _subTitleLable.textColor = [UIColor grayColor];;
        _subTitleLable.userInteractionEnabled = NO;
        [_subTitleLable autoStretchWidth];
        [self addSubview:_subTitleLable];
        
        self.frame  = CGRectMake(frame.origin.x, frame.origin.y, _titleLable.frame.size.width+20, _titleLable.frame.size.height*2+30);
        self.backgroundColor = [UIColor clearColor];
        //self.layer.cornerRadius = 5;
        
        //小箭头
        _arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rightbutton"]];
        _arrow.frame = CGRectMake(self.frame.size.width - 15, 10, 25, 25);
        [self addSubview:_arrow];
        _arrow.userInteractionEnabled = NO;
        self.userInteractionEnabled = YES;
        [self autoStretchWidth];
//        _highLightLayer = [CALayer layer];
//        _highLightLayer.frame = self.bounds;
//        _highLightLayer.backgroundColor = [UIColor clearColor].CGColor;
//        [self.layer addSublayer:_highLightLayer];
        
        
//        CALayer *_lineLayer = [CALayer layer];
//        _lineLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
//        _lineLayer.frame = CGRectMake(0, frame.size.height, frame.size.width, 1);
//        _lineLayer.hidden = NO;
//        [self.layer addSublayer:_lineLayer];
        
    }
    return self;
}


//重写高亮设置
/*
- (void)setHighlighted:(BOOL)highlighted
{
    [self setHighlighted:highlighted];
    
     _highLightLayer.frame = self.bounds;
    if (highlighted)
    {
        _highLightLayer.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.4].CGColor;
    }
    else
    {
        _highLightLayer.backgroundColor = [UIColor clearColor].CGColor;
    }
}
*/
- (void)autoStretchWidth
{
    [_titleLable autoStretchWidth];
    [_subTitleLable autoStretchWidth];
    CGFloat width;
    if (_titleLable.frame.size.width > _subTitleLable.frame.size.width) {
        if (_titleLable.frame.size.width > (SCREEN_W - MATCHSIZE(20))) {
            _titleLable.width = SCREEN_W - MATCHSIZE(100);
        }
        width = _titleLable.frame.size.width;
    }else {
        if (_subTitleLable.frame.size.width > (SCREEN_W - MATCHSIZE(20))) {
            _subTitleLable.width = SCREEN_W - MATCHSIZE(100);
        }
        width = _subTitleLable.frame.size.width;
    }
    
    self.frame  = CGRectMake(self.frame.origin.x, self.frame.origin.y, width+40, _titleLable.frame.size.height+_subTitleLable.frame.size.height+30);
    _arrow.center = CGPointMake(self.frame.size.width -15, self.frame.size.height/2-5);
    [self setNeedsDisplay];
}

- (void)setTitle:(NSString *)title
{
    _titleLable.text = [NSString stringWithFormat:@"%@",title];
    if (title.length == 0) {
        _titleLable.text = @"定位中...";
    }
}

- (void)setSubTitle:(NSString *)subTitle
{
    _subTitleLable.text = [NSString stringWithFormat:@"%@",subTitle];
    if (subTitle.length == 0) {
        _subTitleLable.text = @"";
    }
}

- (void)drawRect:(CGRect)rect
{
    
    //[self drawInContext:UIGraphicsGetCurrentContext()];
    
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
//    self.layer.borderWidth = 1;
//    self.layer.borderColor = [[UIColor blackColor] CGColor];
    
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
    
}

- (void)drawInContext:(CGContextRef)context
{
    
    CGContextSetLineWidth(context, 1.0);
    CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:0.98 alpha:1.0].CGColor);
    
    [self getDrawPath:context];
    CGContextFillPath(context);
    
}

- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    CGFloat radius = 6.0;
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect)-kArrorHeight;
    
    CGContextMoveToPoint(context, midx+kArrorHeight, maxy);
    CGContextAddLineToPoint(context,midx, maxy+kArrorHeight);
    CGContextAddLineToPoint(context,midx-kArrorHeight, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
