//
//  VariableView.m
//  GDAPI
//
//  Created by 开涛 on 15/7/26.
//  Copyright (c) 2015年 com.LHW.TESTGDAPI. All rights reserved.
//

#import "VariableView.h"

@implementation VariableView

+ (UILabel *)initLabelWithFrame:(CGRect)frame
                           text:(NSString *)text
                      textColor:(UIColor *)color
                       textFont:(NSInteger)font
{
    UILabel *lable = [[UILabel alloc]initWithFrame:frame];
    lable.text = text;
    lable.font = [UIFont systemFontOfSize:font];
    lable.textColor = color;
    return lable;
}

+ (void)autoAdaptHeightWithLable:(UILabel *)lable font:(NSInteger)fontSize
{
    lable.numberOfLines = 0;
    lable.font = [UIFont systemFontOfSize:fontSize];
    lable.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize sized = [lable sizeThatFits:CGSizeMake(lable.frame.size.width, MAXFLOAT)];
    lable.frame = CGRectMake(lable.frame.origin.x, lable.frame.origin.y, sized.width, sized.height);
}
@end
