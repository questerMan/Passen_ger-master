//
//  InvoiceUIobject.m
//  DriverProject
//
//  Created by 林镇杰 on 15/9/14.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "InvoiceUIobject.h"

#define TIPS_LABEL_FONT       [UIFont systemFontOfSize:12]
#define TIPS_AMOUNT_FONT      [UIFont systemFontOfSize:12]
#define OTHER_LABEL_FONT      [UIFont systemFontOfSize:15]
@implementation InvoiceUIobject
{
    UIView *line_a;
    UIView *line_b;
    UIView *line_c;
}

-(void)initUiObjectWith:(NSDictionary *)dic
{
    
    self.bgView = [[UIScrollView alloc]init];
    
    self.tipsLabel = [UIFactory createLabel:@"请填写发票所需信息" Font:TIPS_LABEL_FONT];
    _tipsLabel.textColor = [UIColor lightGrayColor];
    
    self.firstView = [[UIView alloc]init];
    _firstView.backgroundColor = [UIColor whiteColor];
    _firstView.layer.borderWidth = 0.5f;
    _firstView.layer.borderColor = COLOR_LINE.CGColor;
    
    self.secondView = [[UIView alloc]init];
    _secondView.backgroundColor = [UIColor whiteColor];
    _secondView.layer.borderWidth = 0.5f;
    _secondView.layer.borderColor = COLOR_LINE.CGColor;
    
    self.titleLabel = [UIFactory createLabel:@"发票抬头：" Font:OTHER_LABEL_FONT];
    _titleLabel.textAlignment = NSTextAlignmentRight;
    
    self.titleField = [[UITextField alloc]init];
    _titleField.placeholder = @"请填写发票抬头";
    [_titleField setFont:OTHER_LABEL_FONT];
    
    self.amountLabel = [UIFactory createLabel:@"发票金额：" Font:OTHER_LABEL_FONT];
    _amountLabel.textAlignment = NSTextAlignmentRight;
    
    self.amountField = [[UITextField alloc]init];
    _amountField.placeholder = @"请填写发票金额";
    _amountField.keyboardType = UIKeyboardTypeNumberPad;
    [_amountField setFont:OTHER_LABEL_FONT];
    
    self.tipsAmountLabel = [UIFactory createLabel:nil Font:TIPS_AMOUNT_FONT];
    _tipsAmountLabel.textColor = kUIColorFromRGB(0xf4942d);
    
    self.addressLabel = [UIFactory createLabel:@"邮寄地址：" Font:OTHER_LABEL_FONT];
    _addressLabel.textAlignment = NSTextAlignmentRight;
    
    self.addressField = [[UITextField alloc]init];
    _addressField.placeholder = @"请填写邮寄地址";
    [_addressField setFont:OTHER_LABEL_FONT];
    
    self.consigneeLabel = [UIFactory createLabel:@"收件人：" Font:OTHER_LABEL_FONT];
    _consigneeLabel.textAlignment = NSTextAlignmentRight;
    
    self.consigneeField = [[UITextField alloc]init];
    _consigneeField.placeholder = @"请填写收件人";
    [_consigneeField setFont:OTHER_LABEL_FONT];
    
    self.phoneLabel = [UIFactory createLabel:@"联系电话：" Font:OTHER_LABEL_FONT];
    _phoneLabel.textAlignment = NSTextAlignmentRight;
    
    self.phoneField = [[UITextField alloc]init];
    _phoneField.placeholder = @"请填写联系电话";
    _phoneField.keyboardType = UIKeyboardTypeNumberPad;
    [_phoneField setFont:OTHER_LABEL_FONT];
    
    self.longTipsView = [[UITextView alloc]init];
    _longTipsView.textColor = kUIColorFromRGB(0x727272);
    [_longTipsView setFont:TIPS_AMOUNT_FONT];
    _longTipsView.backgroundColor = [UIColor clearColor];
    _longTipsView.text = @"尊敬的乘客：您申请的发票将在7个工作日内寄出。同一天内（00：00-24：00）申请发票合计金额满500元免邮，暂不支持港、澳、台地区邮寄。请正确填写发票内容与收件信息，以确保您正常使用。感谢您的支持与配合。";
    _longTipsView.editable = NO;
    
    self.thirdView = [[UIView alloc]init];
    _thirdView.backgroundColor = [UIColor whiteColor];
    _thirdView.layer.borderWidth = 0.5f;
    _thirdView.layer.borderColor = COLOR_LINE.CGColor;
    
    self.submitBtn = [UIFactory createButton:@"提交" BackgroundColor:kUIColorFromRGB(0xf4942d) andTitleColor:[UIColor whiteColor]];
    
    line_a = [UIFactory createLineView];
    
    line_b = [UIFactory createLineView];
    
    line_c = [UIFactory createLineView];
    
    [self.bgView addSubview:_tipsLabel];
    [self.bgView addSubview:_firstView];
    [self.bgView addSubview:_tipsAmountLabel];
    [self.bgView addSubview:_secondView];
    [self.bgView addSubview:_longTipsView];
    [self.bgView addSubview:_thirdView];
    
    [self.firstView addSubview:_titleLabel];
    [self.firstView addSubview:_titleField];
    [self.firstView addSubview:line_a];
    [self.firstView addSubview:_amountLabel];
    [self.firstView addSubview:_amountField];
    
    [self.secondView addSubview:_addressLabel];
    [self.secondView addSubview:_addressField];
    [self.secondView addSubview:line_b];
    [self.secondView addSubview:_consigneeLabel];
    [self.secondView addSubview:_consigneeField];
    [self.secondView addSubview:line_c];
    [self.secondView addSubview:_phoneLabel];
    [self.secondView addSubview:_phoneField];
    
    [self.thirdView addSubview:_submitBtn];
}

-(void)doAutoLayout
{
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(5);
        make.left.equalTo(self.bgView).offset(20);
        make.right.equalTo(self.bgView).offset(-10);
        make.height.mas_equalTo(@20);
    }];
    
#pragma - mark 第一个自定义View
    [self.firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView);
        make.width.equalTo(self.bgView);
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(3);
        make.height.equalTo(self.bgView).multipliedBy(0.16f);
    }];
  
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(self.firstView);
        make.height.equalTo(self.firstView.mas_height).multipliedBy(0.5f);
        make.width.equalTo(self.firstView.mas_width).multipliedBy(0.3f);
    }];
    
    [self.titleField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.equalTo(self.firstView);
        make.left.equalTo(self.titleLabel.mas_right);
        make.height.equalTo(self.titleLabel);
    }];
    
    [line_a mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.firstView);
        make.left.and.right.equalTo(self.firstView);
        make.height.mas_equalTo(@0.5);
    }];
    
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstView);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(1);
        make.height.equalTo(self.firstView.mas_height).multipliedBy(0.49f);
        make.width.equalTo(self.firstView.mas_width).multipliedBy(0.3f);
    }];
    
    [self.amountField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.amountLabel);
        make.right.equalTo(self.firstView.mas_right);
        make.left.equalTo(self.amountLabel.mas_right);
        make.height.equalTo(self.amountLabel);
    }];
    
    NSString *amountStr = [NSString stringWithFormat:@"(最高可开金额：%@元）",[UIFactory getNSUserDefaultsDataWithKey:@"invoice_money"]];
    _tipsAmountLabel.text = amountStr;
    [self.tipsAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstView.mas_bottom).offset(3);
        make.left.height.and.width.equalTo(self.tipsLabel);
    }];
    
#pragma - mark 第二个自定义View

    [self.secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipsAmountLabel.mas_bottom).offset(3);
        make.left.and.width.equalTo(self.firstView);
        make.height.equalTo(self.bgView.mas_height).multipliedBy(0.24f);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(self.secondView);
        make.height.equalTo(self.secondView.mas_height).multipliedBy(0.34f);
        make.width.equalTo(self.secondView.mas_width).multipliedBy(0.3f);
    }];
    
    [self.addressField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.equalTo(self.secondView);
        make.left.equalTo(self.addressLabel.mas_right);
        make.height.equalTo(self.addressLabel);
    }];
    
    [line_b mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressLabel.mas_bottom);
        make.left.and.right.equalTo(self.secondView);
        make.height.mas_equalTo(@0.5);
    }];
    
    [self.consigneeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.secondView);
        make.top.equalTo(self.addressLabel.mas_bottom).offset(1);
        make.height.equalTo(self.secondView.mas_height).multipliedBy(0.33f);
        make.width.equalTo(self.secondView.mas_width).multipliedBy(0.3f);
    }];
    
    [self.consigneeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.consigneeLabel);
        make.right.equalTo(self.secondView.mas_right);
        make.left.equalTo(self.consigneeLabel.mas_right);
        make.height.equalTo(self.consigneeLabel);
    }];
    
    [line_c mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.consigneeLabel.mas_bottom);
        make.left.and.right.equalTo(self.secondView);
        make.height.mas_equalTo(@0.5);
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.secondView);
        make.top.equalTo(self.consigneeLabel.mas_bottom).offset(1);
        make.height.equalTo(self.secondView.mas_height).multipliedBy(0.33f);
        make.width.equalTo(self.secondView.mas_width).multipliedBy(0.3f);
    }];
    
    [self.phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneLabel);
        make.right.equalTo(self.secondView.mas_right);
        make.left.equalTo(self.phoneLabel.mas_right);
        make.height.equalTo(self.phoneLabel);
    }];
    
    [self.longTipsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secondView.mas_bottom);
        make.left.equalTo(self.secondView.mas_left).offset(10);
        make.right.equalTo(self.secondView.mas_right).offset(-10);
        make.height.equalTo(self.bgView).multipliedBy(0.2f);
    }];
    
#pragma - mark 第三个自定义View
//    [self.thirdView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(self.bgView.mas_width);
//        make.left.equalTo(self.bgView);
//        make.top.equalTo(self.bgView.mas_bottom).multipliedBy(1.18f);
////        make.height.equalTo(self.bgView).multipliedBy(0.12f);
//        make.height.mas_equalTo(@80);
//    }];
    
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.thirdView).with.insets(UIEdgeInsetsMake(10, 15, 10, 15));
    }];
    
}





@end
