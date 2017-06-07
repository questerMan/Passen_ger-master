//
//  InvoiceUIobject.h
//  DriverProject
//
//  Created by 林镇杰 on 15/9/14.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Masonry.h>

@interface InvoiceUIobject : NSObject

@property(nonatomic, strong)UIScrollView *bgView;               //页面底部的ScrollView

@property(nonatomic, strong)UILabel *tipsLabel;                 //第一行提示语

@property(nonatomic, strong)UIView *firstView;                  //第一个白色底部View

@property(nonatomic, strong)UIView *secondView;                 //第二个白色底部View

@property(nonatomic, strong)UILabel *titleLabel;                //发票抬头

@property(nonatomic ,strong)UITextField *titleField;            //抬头输入

@property(nonatomic, strong)UILabel *amountLabel;               //发票金额

@property(nonatomic ,strong)UITextField *amountField;           //金额输入

@property(nonatomic, strong)UILabel *tipsAmountLabel;           //提示最高可开金额

@property(nonatomic, strong)UILabel *addressLabel;              //邮寄地址

@property(nonatomic ,strong)UITextField *addressField;          //地址输入

@property(nonatomic, strong)UILabel *consigneeLabel;            //收件人

@property(nonatomic ,strong)UITextField *consigneeField;        //收件人输入

@property(nonatomic, strong)UILabel *phoneLabel;                //联系电话

@property(nonatomic ,strong)UITextField *phoneField;            //电话输入

@property(nonatomic, strong)UITextView *longTipsView;           //底部大段提示

@property(nonatomic, strong)UIView *thirdView;                  //按钮底部的View

@property(nonatomic, strong)UIButton *submitBtn;                //提交按钮


-(void)initUiObjectWith:(NSDictionary *)dic;

-(void)doAutoLayout;

@end
