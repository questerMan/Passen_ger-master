//
//  CommonPopView.h
//  DriverProject
//
//  Created by 林镇杰 on 15/9/17.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommonPopView;

@protocol PopViewDelegate <NSObject>

@required

-(void)popBtnDidRingUpByDriverPhoneNumber:(NSString *)phone;

@end

@interface CommonPopView : UIView
{
    
}

@property(nonatomic, assign)id<PopViewDelegate>popDelegate;

-(instancetype)initPopViewFrame:(CGRect)frame AndDriverData:(NSDictionary *)data;
@end
