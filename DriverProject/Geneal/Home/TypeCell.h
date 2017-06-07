//
//  TypeCell.h
//  DriverProject
//
//  Created by 林镇杰 on 15/9/20.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TypeModel.h"

@interface TypeCell : UITableViewCell

@property(nonatomic, strong)UIImageView *logoImg;

@property(nonatomic, strong)UILabel *typeTitle;

@property(nonatomic, strong)UIImageView *statusImg;

@property(nonatomic, copy)NSString *celltype;

@property(nonatomic,retain)TypeModel *typeModel;
@end
