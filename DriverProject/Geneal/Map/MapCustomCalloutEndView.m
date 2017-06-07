//
//  MapCustomCalloutEndView.m
//  GDAPI
//
//  Created by 开涛 on 15/7/30.
//  Copyright (c) 2015年 com.LHW.TESTGDAPI. All rights reserved.
//

#import "MapCustomCalloutEndView.h"
#import "VariableView.h"

@implementation MapCustomCalloutEndView
{
    UILabel *_startLabel;
    UILabel *_endLabel;
    UILabel *_costLabel;
    UILabel *_distanceLabel;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        _startLabel = [VariableView initLabelWithFrame:CGRectMake(10, 10, 220, 20) text:@"从 羊城花园东门" textColor:[UIColor blackColor] textFont:13];
        [self addSubview:_startLabel];
        
        _endLabel = [VariableView initLabelWithFrame:CGRectMake(_startLabel.frame.origin.x, _startLabel.frame.origin.y+_startLabel.frame.size.height, 220, 20) text:@"到 广州某个很偏僻的角落" textColor:[UIColor blackColor] textFont:13];
        [self addSubview:_endLabel];
        
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = [[UIColor lightGrayColor]CGColor];
        layer.frame = CGRectMake(_startLabel.frame.origin.x, _endLabel.frame.origin.y+_endLabel.frame.size.height+5, _endLabel.frame.size.width-20, 1);
        [self.layer addSublayer:layer];
        
        _costLabel = [VariableView initLabelWithFrame:CGRectMake(_startLabel.frame.origin.x, layer.frame.origin.y+5, 90, 20) text:@"约20元" textColor:[UIColor orangeColor] textFont:20];
        [self addSubview:_costLabel];
        
        _distanceLabel = [VariableView initLabelWithFrame:CGRectMake(_costLabel.frame.size.width, _costLabel.frame.origin.y, _costLabel.frame.size.width+10, _costLabel.frame.size.height) text:@"约15公里" textColor:[UIColor orangeColor] textFont:20];
        [self addSubview:_distanceLabel];
        
        self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1.0];
        self.layer.cornerRadius = 5;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,220, 90);
    }
    return self;
}
-(void)setStartLocation:(NSString *)startLocation
{
    _startLabel.text = [NSString stringWithFormat:@"从 %@",startLocation];
}
-(void)setEndLocation:(NSString *)endLocation
{
    _endLabel.text = [NSString stringWithFormat:@"到 %@",endLocation];
}
-(void)setDistance:(NSString *)distance
{
    _distanceLabel.text = [NSString stringWithFormat:@"约%@公里",distance];
}
-(void)setCost:(NSString *)cost
{
    _costLabel.text = [NSString stringWithFormat:@"约%@元",cost];
}
//宽度适应
- (void)autoStretchWidth
{
//    [_titleLable autoStretchWidth];
//    [_subTitleLable autoStretchWidth];
//    CGFloat width;
//    if (_titleLable.frame.size.width > _subTitleLable.frame.size.width) {
//        width = _titleLable.frame.size.width;
//    }else {
//        width = _subTitleLable.frame.size.width;
//    }
//    self.frame  = CGRectMake(self.frame.origin.x, self.frame.origin.y, width+20, _titleLable.frame.size.height+_subTitleLable.frame.size.height+30);
}
@end
