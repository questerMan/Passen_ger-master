//
//  PaySuccessUIObject.h
//  DriverProject
//
//  Created by 林镇杰 on 15/9/23.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PaySuccessDelegate <NSObject>

-(void)starButtonSelect:(UIButton *)btn AndStarCount:(NSString *)count;

-(void)checkTheOrderData;

-(void)invoiceButtonActionWithAmount:(NSString *)amount;

-(void)submitTheOrderDateWithStarCount:(NSString *)count AndInputData:(NSString *)input;

@end

@interface PaySuccessUIObject : NSObject

@property(nonatomic, strong)UIView *bgView;

@property(nonatomic, strong)UILabel *amountLabel;

@property(nonatomic, strong)UIButton *checkBtn;

@property(nonatomic, strong)UIButton *invoiceBtn;

@property(nonatomic, strong)UIButton *starOne;

@property(nonatomic, strong)UIButton *starTwo;

@property(nonatomic, strong)UIButton *starThree;

@property(nonatomic, strong)UIButton *starFour;

@property(nonatomic, strong)UIButton *starFive;

@property(nonatomic, strong)UITextView *evaluateText;

@property(nonatomic, strong)UIButton *submitBtn;

@property(nonatomic, assign)id<PaySuccessDelegate>payDelegate;

@property(nonatomic,assign)BOOL isInvoice;

-(void)initUiObjectWith:(NSDictionary *)dic;

-(void)doAutoLayout;

@end
