//
//  CouponCell.h
//  DriverProject
//
//  Created by 林镇杰 on 15/9/13.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>
#import "CouponModel.h"

@interface CouponCell : UITableViewCell
{
    UIView *customView;         //自定义的背景View
    UIImageView *tipsImg;       //前端示意图片
    UILabel *symbolLabel;       //人民币图标
    UILabel *moneyLabel;        //金额
    UIView *line;               //竖线
    UILabel *couponType;        //优惠券类型
    UILabel *timeLabel;         //有效期
    UILabel *conditionLabel;    //使用条件
}

@property(nonatomic, retain)CouponModel *couponModel;
@end
