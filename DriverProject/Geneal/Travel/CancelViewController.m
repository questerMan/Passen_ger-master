//
//  CancelViewController.m
//  DriverProject
//
//  Created by 林镇杰 on 15/9/6.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "CancelViewController.h"

#define Button_Height 40
#define Button_Interval 10

@interface CancelViewController ()<QiFacadeHttpRequestDelegate,UIAlertViewDelegate>
{
    UITextView *otherText;
    
    NSMutableString *reasonString;
    
}

@property(nonatomic, assign)NSInteger cancelFlag;
@property(nonatomic, assign)NSInteger complainFlag;
@property(nonatomic, assign)NSInteger feedbackFlag;

@end

@implementation CancelViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = [self.dateDic objectForKey:Title_key];//@"取消原因";
    self.view.backgroundColor = RGB(247, 249, 250);
    
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(0, 0, 50, 40);
//    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -25, 0.0, 0.0)];
//    [backBtn addTarget:self action:@selector(backToLastView) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = item;
    
    reasonString = [NSMutableString string];
    
    [self createCustomView];
}

-(void)createCustomView
{
    UILabel *question = [[UILabel alloc]initWithFrame:CGRectMake(20, 30 + kHeight_Navbar, self.view.width - 40, 20)];
    question.textAlignment = NSTextAlignmentCenter;
    question.textColor = [UIColor lightGrayColor];
    question.text = [self.dateDic objectForKey:Question_key];//@"请告诉我们您取消的原因，我们会不断改进！";
    [question setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:question];
    
    NSArray *questionArray = [self.dateDic objectForKey:ButtonArray_key];//[NSArray arrayWithObjects:@"我改变行程，暂时不需要用车",@"司机告诉我需要等很久",@"司机无法来接我",@"我选择了别的出行方式", nil];
    
    if (questionArray.count > 0) {
        
        for (int i = 0; i < questionArray.count; i ++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundColor:RGB(254, 255, 255)];
            button.frame = CGRectMake(question.origin.x, question.bottom + i * Button_Height + (i +1)*Button_Interval, question.width, Button_Height);
            [button.layer setMasksToBounds:YES];
            [button.layer setCornerRadius:8.0f];
            [button.layer setBorderWidth:1];
            [button.layer setBorderColor:RGB(230, 231, 233).CGColor];
            NSString *title = [questionArray objectAtIndex:i];
            [button setTitle:title forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.tag = i;
            [button addTarget:self action:@selector(questionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button];
        }
        
        otherText = [[UITextView alloc]initWithFrame:CGRectMake(question.origin.x, question.bottom +  6 * Button_Interval + 4 * Button_Height, question.width, 2 * Button_Height)];
        
    }else{
        
        question.hidden = YES;
        otherText = [[UITextView alloc]initWithFrame:CGRectMake(10, 30 + kHeight_Navbar, self.view.width - 20, 4 * Button_Height)];
    }
        
    otherText.backgroundColor = [UIColor whiteColor];
    [otherText.layer setMasksToBounds:YES];
    [otherText.layer setCornerRadius:8.0f];
    [otherText.layer setBorderWidth:1];
    [otherText.layer setBorderColor:RGB(230, 231, 233).CGColor];
    otherText.text = [self.dateDic objectForKey:TextInput_key];//@"填写其他原因";
    [otherText setFont:[UIFont systemFontOfSize:15]];
    otherText.textColor = [UIColor lightGrayColor];
    otherText.delegate = self;
    [self.view addSubview:otherText];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(question.origin.x, kBounds_Screen.size.height - Button_Height - Button_Interval, question.width, Button_Height);
    confirmBtn.tag = 4;
    [confirmBtn.layer setMasksToBounds:YES];
    [confirmBtn.layer setCornerRadius:8.0f];
    [confirmBtn setBackgroundColor:kUIColorFromRGB(0xf4942d)];
    [confirmBtn setTitle:[self.dateDic objectForKey:SubmitButton_key] forState:UIControlStateNormal];//@"确定取消"
    [confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
}

/**
 *  原因按钮实现方法
 *
 *  @param sender Button
 */
-(void)questionButtonAction:(UIButton *)sender
{
    NSLog(@"%ld\n%@",(long)sender.tag,sender.titleLabel.text);
    reasonString = (NSMutableString *)sender.titleLabel.text;
    
    for (UIView *view in self.view.subviews) {
        
        if ([view isKindOfClass:[UIButton class]]) {
            
            UIButton *button = (UIButton *)view;
            
            if (button.tag >= 0 && button.tag <= 3) {
                
                NSLog(@"button title : %@",button.titleLabel.text);
                
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [button.layer setBorderColor:RGB(230, 231, 233).CGColor];
            }
        }
    }
    
    [sender setTitleColor:kUIColorFromRGB(0xf4942d) forState:UIControlStateNormal];
    [sender.layer setBorderColor:kUIColorFromRGB(0xf4942d).CGColor];
}

/**
 *  确定取消实现方法
 *
 *  @param sender Button
 */
-(void)cancelButtonAction:(UIButton *)sender
{
    if ([[self.dateDic objectForKey:Title_key] isEqualToString:@"取消原因"]) {
        
        [self cancelOrderWithReason:reasonString];
        
    }else if ([[self.dateDic objectForKey:Title_key] isEqualToString:@"投诉"]){
        
        if (reasonString.length < 1) {
            
            [self showTextOnlyWith:@"请输入您的投诉理由，我们会尽快为您处理！！！"];
        }else{
            
            [self complainDriverWithReason:reasonString];
        }
    }else if ([[self.dateDic objectForKey:Title_key] isEqualToString:@"反馈建议"]){
        
        if (reasonString.length < 1) {
            
            [self showTextOnlyWith:@"请输入您宝贵的建议！！！"];
        }else{
            
            [self feedbackWithText:reasonString];
        }
    }
}

//取消订单
-(void)cancelOrderWithReason:(NSString *)reason
{
    QiFacade *facade;
    facade = [QiFacade sharedInstance];
    _cancelFlag = [facade putOrder:reason WithID:[self.dateDic objectForKey:@"orderID"]];
    [facade addHttpObserver:self tag:_cancelFlag];
    [self showLoadingWithText:@"订单取消中..."];
}

//投诉
-(void)complainDriverWithReason:(NSString *)reason
{
    QiFacade *facade;
    facade = [QiFacade sharedInstance];
    _complainFlag = [facade postOrderComplain:reason WithID:[self.dateDic objectForKey:@"orderID"]];
    [facade addHttpObserver:self tag:_complainFlag];
    [self showLoadingWithText:@"投诉提交中..."];
}

//反馈建议
-(void)feedbackWithText:(NSString *)reason
{
    QiFacade *facade;
    facade = [QiFacade sharedInstance];
    _feedbackFlag = [facade postFeedback:reason];
    [facade addHttpObserver:self tag:_feedbackFlag];
    [self showLoadingWithText:@"反馈提交中..."];
}

#pragma - mark 网络请求回调
-(void)requestFinished:(NSDictionary *)response tag:(NSInteger)iRequestTag
{
    [self dismissLoading];
    
    NSLog(@"成功\n%@",response);
    
    if (_cancelFlag != 0 && response != nil && iRequestTag == _cancelFlag) {
        
        _cancelFlag = 0;

        if ([[response objectForKey:@"message"] isEqualToString:@"success"]) {
            
            [self showTextOnlyWith:@"订单取消成功！！！"];
            
            [self performSelector:@selector(backToLastView) withObject:nil afterDelay:1.5f];
            
        }else{
            
            [self showTextOnlyWith:[response objectForKey:@"message"]];
        }
        
    }else if (_complainFlag != 0 && response != nil && iRequestTag == _complainFlag){
        
        _complainFlag = 0;
        
        if ([[response objectForKey:@"message"] isEqualToString:@"success"]) {
            
            [self showTextOnlyWith:@"投诉成功！！！"];
            
            [self performSelector:@selector(backToLastView) withObject:nil afterDelay:1.5f];
            
        }else{
            
            [self showTextOnlyWith:[response objectForKey:@"message"]];
        }
        
    }else if (_feedbackFlag != 0 && response != nil && iRequestTag == _feedbackFlag){
        
        _feedbackFlag = 0;
        
        if ([[response objectForKey:@"code"] intValue] == 1 || [[response objectForKey:@"message"] isEqualToString:@"success"]) {
            
            [self showTextOnlyWith:@"反馈提交成功，非常感谢您宝贵的建议！"];
            
            [self performSelector:@selector(backToLastView) withObject:nil afterDelay:1.5f];
        }
    }
        
}

-(void)requestFailed:(NSDictionary *)response tag:(NSInteger)iRequestTag
{
    [self dismissLoading];
    
    NSLog(@"失败22\n%@",response);
    
    
    if (_cancelFlag != 0 && response != nil && iRequestTag == _cancelFlag) {
        
        _cancelFlag = 0;
        
        [self showTextOnlyWith:@"订单取消失败"];
        
    }else if (_complainFlag != 0 && response != nil && iRequestTag == _complainFlag){
        
        _complainFlag = 0;
        
        [self showTextOnlyWith:@"投诉提交失败"];
        
    }else if (_feedbackFlag != 0 && response != nil && iRequestTag == _feedbackFlag){
        
        _feedbackFlag = 0;

        [self showTextOnlyWith:@"反馈提交失败"];
        
    }
}

#pragma - mark UITextView Delegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:[self.dateDic objectForKey:TextInput_key]]) {
        textView.textColor = [UIColor blackColor];
        textView.text = @"";
    }
    
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = [self.dateDic objectForKey:TextInput_key];
        textView.textColor = [UIColor lightGrayColor];
        
    }else{
        
        if (reasonString.length <= 1) {
            
            [reasonString appendString:textView.text];
        }
    }

}

-(void)backToLastView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
