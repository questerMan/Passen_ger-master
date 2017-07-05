//
//  PaySuccessUIObject.m
//  DriverProject
//
//  Created by 林镇杰 on 15/9/23.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "PaySuccessUIObject.h"
#define TIPS_FONT             [UIFont systemFontOfSize:15]
#define OTHER_LABEL_FONT      [UIFont systemFontOfSize:13]

@implementation PaySuccessUIObject
{
    UIImageView *logoImg;
    UILabel *logoLabel;
    UILabel *tips;
    UIView *line_check;
    UIView *line_invoice;
    
    NSString *starCount;
    BOOL isComment;
    BOOL isAction;
    int starNum;
    NSString *content;
}
-(void)initUiObjectWith:(NSDictionary *)dic
{
    //判断是否可评论
    if ([dic objectForKey:@"comment_body"] != nil && [[dic objectForKey:@"comment"] intValue] == 1) {
        isComment = NO;
        starNum = [[[dic objectForKey:@"comment_body"] objectForKey:@"star"] intValue];
        content = [[dic objectForKey:@"comment_body"] objectForKey:@"content"];
    }else{
        isComment = YES;
    }
    
    isAction = YES;
    
    self.bgView = [[UIView alloc]init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [_bgView.layer setBorderColor:COLOR_LINE.CGColor];
    [_bgView.layer setBorderWidth:0.5f];
    
    logoImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"check_circle_green"]];
    logoLabel = [UIFactory createLabel:@"支付成功" Font:TIPS_FONT];
    logoLabel.textAlignment = NSTextAlignmentCenter;
    
    tips = [UIFactory createLabel:@"¥" Font:OTHER_LABEL_FONT];
    tips.textColor = kUIColorFromRGB(0xf4942d);
    tips.textAlignment = NSTextAlignmentRight;
    
//    NSString *fee = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"fee"] intValue]];
    NSString *fee =  [NSString stringWithFormat:@"%@",  [dic objectForKey:@"fee"]];
    self.amountLabel = [UIFactory createLabel:fee Font:[UIFont systemFontOfSize:30]];
    _amountLabel.textColor = kUIColorFromRGB(0xf4942d);
    _amountLabel.textAlignment = NSTextAlignmentCenter;
    
    self.checkBtn = [UIFactory createButton:@"查看明细" BackgroundColor:[UIColor clearColor] andTitleColor:[UIColor grayColor]];
    _checkBtn.tag = 10010;
    [_checkBtn.titleLabel setFont:TIPS_FONT];
    [_checkBtn addTarget:self action:@selector(twoButonAction:) forControlEvents:UIControlEventTouchUpInside];
    line_check = [UIFactory createLineView];
    
    self.invoiceBtn = [UIFactory createButton:nil BackgroundColor:[UIColor clearColor] andTitleColor:[UIColor grayColor]];
    if ([[dic objectForKey:@"invoice"] intValue] == 1) {
        [_invoiceBtn setTitle:@"已索取手撕发票" forState:UIControlStateNormal];
        _isInvoice = NO;
    }else{
        [_invoiceBtn setTitle:@"索取发票" forState:UIControlStateNormal];
        _isInvoice = YES;
    }
    _invoiceBtn.tag = 10086;
    [_invoiceBtn.titleLabel setFont:TIPS_FONT];
    [_invoiceBtn addTarget:self action:@selector(twoButonAction:) forControlEvents:UIControlEventTouchUpInside];
    line_invoice = [UIFactory createLineView];
    
    self.starOne = [UIFactory createButton:[UIImage imageNamed:@"star_yellow"]];
    _starOne.tag = 1;
    [_starOne addTarget:self action:@selector(starButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.starTwo = [UIFactory createButton:[UIImage imageNamed:@"star_yellow"]];
    _starTwo.tag = 2;
    [_starTwo addTarget:self action:@selector(starButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.starThree = [UIFactory createButton:[UIImage imageNamed:@"star_yellow"]];
    _starThree.tag = 3;
    [_starThree addTarget:self action:@selector(starButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.starFour = [UIFactory createButton:[UIImage imageNamed:@"star_yellow"]];
    _starFour.tag = 4;
    [_starFour addTarget:self action:@selector(starButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.starFive = [UIFactory createButton:[UIImage imageNamed:@"star_yellow"]];
    _starFive.tag = 5;
    [_starFive addTarget:self action:@selector(starButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.evaluateText = [[UITextView alloc]init];
    _evaluateText.text = @" 在这里输入对司机的评论";
    [_evaluateText setFont:[UIFont systemFontOfSize:15]];
    _evaluateText.textColor = [UIColor lightGrayColor];
    [_evaluateText.layer setCornerRadius:5];
    [_evaluateText.layer setBorderWidth:0.5f];
    [_evaluateText.layer setBorderColor:COLOR_LINE.CGColor];
   
    self.submitBtn = [UIFactory createButton:@"提交评价" BackgroundColor:kUIColorFromRGB(0xf4942d) andTitleColor:[UIColor whiteColor]];
    [_submitBtn addTarget:self action:@selector(submitButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bgView addSubview:logoImg];
    [self.bgView addSubview:logoLabel];
    [self.bgView addSubview:tips];
    [self.bgView addSubview:_amountLabel];
    [self.bgView addSubview:_checkBtn];
    [self.bgView addSubview:line_check];
    [self.bgView addSubview:_invoiceBtn];
    [self.bgView addSubview:line_invoice];
    [self.bgView addSubview:_starOne];
    [self.bgView addSubview:_starTwo];
    [self.bgView addSubview:_starThree];
    [self.bgView addSubview:_starFour];
    [self.bgView addSubview:_starFive];
    [self.bgView addSubview:_evaluateText];
    [self.bgView addSubview:_submitBtn];
    
}

-(void)doAutoLayout
{
    [logoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.bgView).offset(20);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [logoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoImg.mas_bottom).offset(3);
        make.centerX.equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(70, 15));
    }];
    
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.bgView);
//        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    
    [tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.amountLabel.mas_left).offset(MATCHSIZE(-50));
        make.bottom.equalTo(self.amountLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tips.mas_bottom).offset(10);
        make.left.equalTo(self.bgView).offset(80);
        make.size.mas_equalTo(CGSizeMake(80, 20));
    }];
    
    [line_check mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.checkBtn.mas_bottom);
        make.width.equalTo(self.checkBtn);
        make.left.equalTo(self.checkBtn);
        make.height.mas_equalTo(@1);
    }];
    
    if (_isInvoice) {
        
        [self.invoiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bgView.mas_right).offset(-80);
            make.top.equalTo(self.checkBtn);
            make.size.equalTo(self.checkBtn);
        }];
    }else{
        
        [self.invoiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bgView.mas_right).offset(-50);
            make.top.equalTo(self.checkBtn);
            make.width.mas_equalTo(@110);
            make.height.mas_equalTo(@20);
        }];
    }
    
    
    [line_invoice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.invoiceBtn.mas_bottom);
        make.width.equalTo(self.invoiceBtn);
        make.left.equalTo(self.invoiceBtn);
        make.height.mas_equalTo(@1);
    }];
    
    [self.starThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(line_invoice.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.starTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.starThree.mas_left).offset(-10);
        make.top.equalTo(self.starThree);
        make.size.equalTo(self.starThree);
    }];
    
    [self.starOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.starTwo.mas_left).offset(-10);
        make.top.equalTo(self.starThree);
        make.size.equalTo(self.starThree);
    }];
    
    [self.starFour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.starThree.mas_right).offset(10);
        make.top.equalTo(self.starThree);
        make.size.equalTo(self.starThree);
    }];
    
    [self.starFive mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.starFour.mas_right).offset(10);
        make.top.equalTo(self.starThree);
        make.size.equalTo(self.starThree);
    }];
    
    [self.evaluateText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.starThree.mas_bottom).offset(15);
        make.left.equalTo(self.bgView).offset(10);
        make.right.equalTo(self.bgView).offset(-10);
        make.bottom.equalTo(self.submitBtn.mas_top).offset(-15);
    }];
    
    if (isComment) {
        //可评论
        [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView).offset(10);
            make.right.equalTo(self.bgView).offset(-10);
            make.bottom.equalTo(self.bgView).offset(-10);
            make.height.mas_equalTo(@40);
        }];
        
    }else{
        
        switch (starNum) {
            case 1:
                
                [self starButtonAction:self.starOne];
                break;
                
            case 2:
                
                [self starButtonAction:self.starTwo];
                break;
                
            case 3:
                
                [self starButtonAction:self.starThree];
                break;
                
            case 4:
                
                [self starButtonAction:self.starFour];
                break;
                
            case 5:
                
                [self starButtonAction:self.starFive];
                break;
            default:
                break;
        }
        isAction = NO;
        
        self.evaluateText.text = content;
        _evaluateText.textColor = [UIColor darkGrayColor];
        _evaluateText.editable = NO;
        
        [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView).offset(10);
            make.right.equalTo(self.bgView).offset(-10);
            make.top.equalTo(self.bgView.mas_bottom).offset(-1);
            make.height.mas_equalTo(@1);
        }];
    }
}

-(void)twoButonAction:(UIButton *)sender
{
    if (sender.tag == 10010) {
        
        [self.payDelegate checkTheOrderData];
    }else{
        
        if (self.isInvoice) {
            
            [self.payDelegate invoiceButtonActionWithAmount:self.amountLabel.text];
        }
    }
}

-(void)starButtonAction:(UIButton *)sender
{
    NSLog(@"ButtonTag:%ld",(long)sender.tag);

    if (isAction) {
        
        starCount = [NSString stringWithFormat:@"%ld",(long)sender.tag];
        
        [self.starOne setBackgroundImage:[UIImage imageNamed:@"star_border"] forState:UIControlStateNormal];
        [self.starTwo setBackgroundImage:[UIImage imageNamed:@"star_border"] forState:UIControlStateNormal];
        [self.starThree setBackgroundImage:[UIImage imageNamed:@"star_border"] forState:UIControlStateNormal];
        [self.starFour setBackgroundImage:[UIImage imageNamed:@"star_border"] forState:UIControlStateNormal];
        [self.starFive setBackgroundImage:[UIImage imageNamed:@"star_border"] forState:UIControlStateNormal];
        
        [self.payDelegate starButtonSelect:sender AndStarCount:starCount];
    }
    
}

-(void)submitButton
{
    [self.payDelegate submitTheOrderDateWithStarCount:starCount AndInputData:_evaluateText.text];
}

@end
