//
//  ConfirmListView.h
//  ConfirmList
//
//  Created by 开涛 on 15/9/19.
//  Copyright (c) 2015年 com.LHW.Location. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ConfirmListViewType) {
    ConfirmListViewType_call = 0,
    ConfirmListViewType_appointment = 1,
};

//回调方法可以自己改改 要传出来的数据
@protocol ConfirmListViewDelegate <NSObject>

//点击按钮
- (void)buttonClickDelegate:(id)data viewType:(ConfirmListViewType)type;

//传出选中所在组 和 所在行
- (void)didSelectRowAtSection:(NSInteger)section andRow:(NSInteger)row data:(id)data;
//点击背景弹回
-(void)tapViewResignFirstRespinderDelegate;
@end

@interface ConfirmListView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic)NSString *bookTime;
@property (strong, nonatomic)NSString *bookCar;
@property (strong, nonatomic)NSString *phoneNum;
@property (strong, nonatomic)NSString *startPoint;
@property (strong, nonatomic)NSString *endPoint;
@property (strong, nonatomic)NSString *cost;
@property (strong, nonatomic)UITableView *confirmTable;
@property (assign) id<ConfirmListViewDelegate>confirmDelegate;
-(instancetype)initConfirmListViewWithType:(ConfirmListViewType)type showView:(UIView *)view;
//弹回
-(void)tapViewResignFirstRespinder;
@end
