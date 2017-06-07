//
//  BlankPage.h
//  DriverProject
//
//  Created by 林镇杰 on 15/10/8.
//  Copyright © 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BlankPage;

@protocol BlankPageDelegate <NSObject>

@optional

-(void)loadDataAgain;

@end

@interface BlankPage : UIView

@property(assign)id<BlankPageDelegate>blankPageDelegate;

-(instancetype)initBlankPageFrame:(CGRect)frame WithImg:(UIImage *)tipsImg AndTips:(NSString *)tipsString;

@end
