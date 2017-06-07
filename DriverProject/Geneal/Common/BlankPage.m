//
//  BlankPage.m
//  DriverProject
//
//  Created by 林镇杰 on 15/10/8.
//  Copyright © 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "BlankPage.h"

@implementation BlankPage
{
    UIImageView *tipsImgView;
    UILabel *tipsLabel;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

-(instancetype)initBlankPageFrame:(CGRect)frame WithImg:(UIImage *)tipsImg AndTips:(NSString *)tipsString
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        tipsImgView = [[UIImageView alloc]initWithImage:tipsImg];
        tipsImgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageAction)];
        [tipsImgView addGestureRecognizer:tap];
        
        tipsLabel = [UIFactory createLabel:tipsString Font:[UIFont systemFontOfSize:12]];
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        tipsLabel.textColor = [UIColor lightGrayColor];
        
        [self addSubview:tipsImgView];
        [self addSubview:tipsLabel];
        
        [self drawView:frame];
    }
    
    return self;
}

-(void)drawView:(CGRect)frame
{
    [tipsImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(76, 76));
    }];
    
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsImgView.mas_bottom).offset(5);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(150, 20));
    }];
}

-(void)imageAction
{
    [self.blankPageDelegate loadDataAgain];
}

@end
