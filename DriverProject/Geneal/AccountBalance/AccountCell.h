//
//  AccountCell.h
//  DriverProject
//
//  Created by 林镇杰 on 15/9/22.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountModel.h"
#import "FETableViewCell.h"

@interface AccountCell : FETableViewCell

@property(nonatomic, strong)UILabel *name;

@property(nonatomic, strong)UILabel *time;

@property(nonatomic, strong)UILabel *amount;

@property(nonatomic, retain)AccountModel *accountModel;

@end
