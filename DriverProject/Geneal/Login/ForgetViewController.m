//
//  ForgetViewController.m
//  DriverProject
//
//  Created by 林镇杰 on 15/9/13.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "ForgetViewController.h"
#import "QiFacade+postdemol.h"

#define SEC 60

@interface ForgetViewController ()<UITextFieldDelegate,QiFacadeHttpRequestDelegate>
{
    UITextField *phoneNumber;
    UITextField *codeNumber;
    UITextField *password;
    UIView *line_phone;
    UIView *line_code;
    UIView *line_password;
    UIButton *codeBtn;
    UIButton *setBtn;
}

@property(nonatomic, assign)NSInteger setFlag;

@property(nonatomic, assign)NSInteger codeFlag;

@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"忘记密码";
    self.view.backgroundColor = RGB(249, 250, 251);
    [self.navigationController setNavigationBarHidden:NO];
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(0, 0, 50, 40);
//    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -25, 0.0, 0.0)];
//    [backBtn addTarget:self action:@selector(backToLastView) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *leftitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = leftitem;
    
    UILabel *tips = [UIFactory createLabel:@"请验证您的手机号码并重置密码" Font:[UIFont systemFontOfSize:13]];
    tips.textColor = [UIColor lightGrayColor];
    
    phoneNumber = [[UITextField alloc]init];
    phoneNumber.keyboardType = UIKeyboardTypePhonePad;
    phoneNumber.placeholder = @"手机号";
    phoneNumber.delegate = self;
    
    line_phone = [[UIView alloc]init];
    line_phone.backgroundColor = RGB(241, 148, 44);
    
    codeBtn = [UIFactory createButton:@"验证" BackgroundColor:RGB(241, 148, 44) andTitleColor:[UIColor whiteColor]];
    [codeBtn addTarget:self action:@selector(getVerificationCode) forControlEvents:UIControlEventTouchUpInside];
    
    codeNumber = [[UITextField alloc]init];
    codeNumber.keyboardType = UIKeyboardTypePhonePad;
    codeNumber.placeholder = @"验证码";
    codeNumber.delegate = self;
    
    line_code = [[UIView alloc]init];
    line_code.backgroundColor = [UIColor lightGrayColor];
    
    password = [[UITextField alloc]init];
    password.secureTextEntry = YES;
    password.placeholder = @"新密码";
    password.delegate = self;
    
    line_password = [[UIView alloc]init];
    line_password.backgroundColor = [UIColor lightGrayColor];
    
    setBtn = [UIFactory createButton:@"重设密码" BackgroundColor:RGB(241, 148, 44) andTitleColor:[UIColor whiteColor]];
    [setBtn addTarget:self action:@selector(setPasswordAgain) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:tips];
    [self.view addSubview:phoneNumber];
    [self.view addSubview:line_phone];
    [self.view addSubview:codeBtn];
    [self.view addSubview:codeNumber];
    [self.view addSubview:line_code];
    [self.view addSubview:password];
    [self.view addSubview:line_password];
    [self.view addSubview:setBtn];
    
    [tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).with.offset(74);
        make.left.and.right.equalTo(self.view).with.offset(20);
        make.height.mas_equalTo(@15);
    }];
    
    [self setLayoutForView];
}

-(void)setLayoutForView
{
    [codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(100);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.25f);
        make.height.mas_equalTo(@30);
    }];
    
    [phoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeBtn.mas_top);
        make.left.mas_equalTo(@20);
        make.right.equalTo(codeBtn.mas_left).with.offset(-5);
        make.height.equalTo(codeBtn.mas_height).with.offset(-2);
    }];
    
    [line_phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneNumber.mas_bottom).with.offset(1);
        make.left.and.width.equalTo(phoneNumber);
        make.height.mas_equalTo(@1);
    }];
    
    [codeNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line_phone.mas_bottom).with.offset(15);
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.height.equalTo(phoneNumber.mas_height);
    }];
    
    [line_code mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeNumber.mas_bottom).with.offset(1);
        make.left.and.right.equalTo(codeNumber);
        make.height.mas_equalTo(@1);
    }];
    
    [password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line_code.mas_bottom).with.offset(15);
        make.left.and.right.equalTo(codeNumber);
        make.height.equalTo(phoneNumber.mas_height);
    }];
    
    [line_password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(password.mas_bottom).with.offset(1);
        make.left.and.right.equalTo(codeNumber);
        make.height.mas_equalTo(@1);
    }];
    
    [setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line_password.mas_bottom).with.offset(30);
        make.left.and.right.equalTo(codeNumber);
        make.height.mas_equalTo(@40);
    }];
}

/**
 *  获取验证码
 */
-(void)getVerificationCode{
    
    if (![phoneNumber.text isEqualToString:@""] && phoneNumber.text != nil) {
        QiFacade *facade;
        facade = [QiFacade sharedInstance];
        _codeFlag = [facade postGetCodeWithphone:phoneNumber.text];
        [facade addHttpObserver:self tag:_codeFlag];
        
    }else{
        [self showTextOnlyWith:@"请输入您的手机号码以便获取验证码"];
    }
    
}

/**
 *  重设密码
 */
-(void)setPasswordAgain
{
    if (![codeNumber.text isEqualToString:@""] && ![password.text isEqualToString:@""] && password.text.length >= 6) {
        
        [self showLoadingWithText:@"重设密码中..."];
        QiFacade *facade;
        facade = [QiFacade sharedInstance];
        _setFlag = [facade postForgetPassord:phoneNumber.text password:password.text vcode:codeNumber.text];
        [facade addHttpObserver:self tag:_setFlag];
    }
}

-(void)requestFinished:(NSDictionary *)response tag:(NSInteger)iRequestTag
{
    NSLog(@"成功\n%@",response);
    
    if (_setFlag != 0 && response != nil && iRequestTag == _setFlag) {
        
        [self dismissLoading];
        
        _setFlag = 0;
        
        [self showTextOnlyWith:@"密码重设成功，请立刻登录！！！"];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    if (_codeFlag != 0 && response != nil && iRequestTag == _codeFlag) {
        
        _codeFlag = 0;
        
        if ([[response objectForKey:@"message"] isEqualToString:@"success"]) {
            
            [self showTextOnlyWith:@"验证码发送成功，短信马上送到！！！"];
            
        }else{
            
            [self showTextOnlyWith:[response objectForKey:@"message"]];
        }
    }
}

-(void)requestFailed:(NSDictionary *)response tag:(NSInteger)iRequestTag
{
    
    NSLog(@"失败55\n%@",response);
    
    if (_setFlag != 0 && response != nil && iRequestTag == _setFlag) {
        
        [self dismissLoading];
        
        _setFlag = 0;
        
        [self showTextOnlyWith:[response objectForKey:@"message"]];
    }
    if (_codeFlag != 0 && response != nil && iRequestTag == _codeFlag) {
        
        _codeFlag = 0;
        
        [self showTextOnlyWith:[response objectForKey:@"message"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

-(void)backToLastView
{
    [self.navigationController popViewControllerAnimated:YES];
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
