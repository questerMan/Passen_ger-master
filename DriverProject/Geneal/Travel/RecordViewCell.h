//
//  RecordViewCell.h
//  DriverProject
//
//  Created by 林镇杰 on 15/9/11.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>
#import "RecordModel.h"
#import "FETableViewCell.h"

@protocol RecordCellDelegate <NSObject>

@optional

-(void)reloadRecordTableViewDelegate;

@end

@interface RecordViewCell : FETableViewCell
{
    UILabel *timeLabel;
    UIImageView *orderType;
    UIImageView *startImg;
    UIImageView *endImg;
    UILabel *startLabel;
    UILabel *endLabel;
    UILabel *orederStatus;
}

@property(nonatomic,assign)id<RecordCellDelegate>delegate;
@property(nonatomic, retain)RecordModel *recordModel;
@property(nonatomic,copy)NSString *cellType;
@property(nonatomic, retain)NSMutableArray *viewArray;

@end
