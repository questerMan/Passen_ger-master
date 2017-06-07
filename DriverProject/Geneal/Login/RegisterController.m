//
//  RegisterController.m
//  DriverProject
//
//  Created by 林镇杰 on 15/9/23.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "RegisterController.h"
#import "QiFacade+postdemol.h"
#import "HomeViewController.h"
#import "WebViewController.h"

@interface RegisterController ()<UITextFieldDelegate,QiFacadeHttpRequestDelegate>
{
    UITextField *phoneNumber;
    UITextField *codeNumber;
    UITextField *password;
    UIView *line_phone;
    UIView *line_code;
    UIView *line_password;
    UIButton *codeBtn;
    UIButton *setBtn;
    UIButton *checkBox;
    UILabel *userLabel;
    UIButton *userAgreementBtn;
    BOOL isCheck;
}

@property(nonatomic, assign)NSInteger registerFlag;

@property(nonatomic, assign)NSInteger codeFlag;

@property(nonatomic, assign)NSInteger loginFlag;

@end

@implementation RegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"使用手机短信登录";
    self.view.backgroundColor = [UIColor whiteColor];//RGB(249, 250, 251);
    [self.navigationController setNavigationBarHidden:NO];
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(0, 0, 50, 40);
//    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -25, 0.0, 0.0)];
//    [backBtn addTarget:self action:@selector(backToLastView) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *leftitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = leftitem;
    
    UILabel *tips = [UIFactory createLabel:@"验证您的手机号码并登陆" Font:[UIFont systemFontOfSize:13]];
    tips.textColor = [UIColor lightGrayColor];
    
    phoneNumber = [[UITextField alloc]init];
    phoneNumber.keyboardType = UIKeyboardTypePhonePad;
    phoneNumber.placeholder = @"手机号";
    phoneNumber.delegate = self;
    
    line_phone = [[UIView alloc]init];
    line_phone.backgroundColor = RGB(241, 148, 44);
    
    codeBtn = [UIFactory createButton:@"发送验证码" BackgroundColor:RGB(241, 148, 44) andTitleColor:[UIColor whiteColor]];
    [codeBtn addTarget:self action:@selector(getVerificationCode) forControlEvents:UIControlEventTouchUpInside];
    
    codeNumber = [[UITextField alloc]init];
    codeNumber.keyboardType = UIKeyboardTypePhonePad;
    codeNumber.placeholder = @"验证码";
    codeNumber.delegate = self;
    
    line_code = [[UIView alloc]init];
    line_code.backgroundColor = [UIColor lightGrayColor];
    
    password = [[UITextField alloc]init];
    password.secureTextEntry = YES;
    password.placeholder = @"密码";
    password.delegate = self;
    
    line_password = [[UIView alloc]init];
    line_password.backgroundColor = [UIColor lightGrayColor];
    
    setBtn = [UIFactory createButton:@"确定" BackgroundColor:RGB(241, 148, 44) andTitleColor:[UIColor whiteColor]];
    [setBtn addTarget:self action:@selector(submitRegisterData) forControlEvents:UIControlEventTouchUpInside];
    
    checkBox = [UIFactory createButton:[UIImage imageNamed:@"hook_yes"]];
    [checkBox addTarget:self action:@selector(confirmUserAgreement) forControlEvents:UIControlEventTouchUpInside];
    isCheck = YES;
    
    userLabel = [UIFactory createLabel:@"我已阅读并同意" Font:[UIFont systemFontOfSize:13]];
    
    userAgreementBtn = [UIFactory createButton:@"《用户协议》" BackgroundColor:[UIColor clearColor] andTitleColor:kUIColorFromRGB(0xf4942d)];
    [userAgreementBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    userAgreementBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [userAgreementBtn addTarget:self action:@selector(openUserAgreement) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:tips];
    [self.view addSubview:phoneNumber];
    [self.view addSubview:line_phone];
    [self.view addSubview:codeBtn];
    [self.view addSubview:codeNumber];
    [self.view addSubview:line_code];
    [self.view addSubview:password];
    [self.view addSubview:line_password];
    [self.view addSubview:setBtn];
    [self.view addSubview:checkBox];
    [self.view addSubview:userLabel];
    [self.view addSubview:userAgreementBtn];
    
    [tips mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.width.equalTo(self.view.mas_width).multipliedBy(0.35f);
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
        make.height.mas_equalTo(@0.5f);
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
        make.height.mas_equalTo(@0.5f);
    }];
    
    [password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line_code.mas_bottom).with.offset(15);
        make.left.and.right.equalTo(codeNumber);
        make.height.equalTo(phoneNumber.mas_height);
    }];
    
    [line_password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(password.mas_bottom).with.offset(1);
        make.left.and.right.equalTo(codeNumber);
        make.height.mas_equalTo(@0.5f);
    }];
    
    [setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line_password.mas_bottom).with.offset(30);
        make.left.and.right.equalTo(codeNumber);
        make.height.mas_equalTo(@40);
    }];
    
    [checkBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
        make.top.equalTo(setBtn.mas_bottom).offset(30);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(checkBox.mas_right).offset(3);
        make.top.equalTo(checkBox);
        make.height.equalTo(checkBox);
        make.width.mas_equalTo(@95);
    }];
    
    [userAgreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userLabel.mas_right);
        make.top.equalTo(userLabel);
        make.height.equalTo(userLabel);
        make.right.equalTo(self.view).with.offset(-20);
    }];
}

/**
 *  获取验证码
 */
- (void)verifyEvent
{
    //启动倒计时
    __block int timeout = 60;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                codeBtn.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSLog(@"____%@",strTime);
                [codeBtn setTitle:[NSString stringWithFormat:@"%@秒",strTime] forState:UIControlStateNormal];
                codeBtn.userInteractionEnabled = NO;
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}

-(void)getVerificationCode
{
    if (![phoneNumber.text isEqualToString:@""] && phoneNumber.text != nil) {
        
        [self verifyEvent];
        
        QiFacade *facade;
        facade = [QiFacade sharedInstance];
        _codeFlag = [facade postGetCodeWithphone:phoneNumber.text];
        [facade addHttpObserver:self tag:_codeFlag];
        
    }else{
        [self showTextOnlyWith:@"请输入您的手机号码以便获取验证码"];
    }
}

/**
 *  注册
 */
-(void)submitRegisterData
{
    if (!isCheck) {
        
        [self showTextOnlyWith:@"请先确认并同意《用户协议》"];
        return;
        
    }
    
    if (![codeNumber.text isEqualToString:@""] && ![password.text isEqualToString:@""] && password.text.length >= 6) {
        
        [self showLoadingWithText:@"注册中..."];
        QiFacade *facade;
        facade = [QiFacade sharedInstance];
        _registerFlag = [facade postRegist:phoneNumber.text password:password.text vcode:codeNumber.text];
        [facade addHttpObserver:self tag:_registerFlag];
    }
}

//确认用户协议
-(void)confirmUserAgreement
{
    
    if (isCheck) {
        
        [checkBox setBackgroundImage:[UIImage imageNamed:@"hook_no"] forState:UIControlStateNormal];
    }else{
        
        [checkBox setBackgroundImage:[UIImage imageNamed:@"hook_yes"] forState:UIControlStateNormal];
    }
    
    isCheck = !isCheck;
}

//打开用户协议
-(void)openUserAgreement
{
    WebViewController *webView = [[WebViewController alloc]init];
    webView.webURL = USER_AGREEMENT_API;
    webView.title = @"用户协议";
    [self.navigationController pushViewController:webView animated:YES];
}

/**
 *  登录
 */
-(void)loginAccount
{
    QiFacade *facade;
    facade = [QiFacade sharedInstance];
    _loginFlag = [facade postLogon:phoneNumber.text password:password.text];
    [facade addHttpObserver:self tag:_loginFlag];
    [self showLoadingWithText:@"登录中..."];
}

-(void)requestFinished:(NSDictionary *)response tag:(NSInteger)iRequestTag
{
    NSLog(@"成功\n%@",response);
    
    if (_registerFlag != 0 && response != nil && iRequestTag == _registerFlag) {
        
        [self dismissLoading];
        
        _registerFlag = 0;
        
        [UIFactory SaveNSUserDefaultsWithData:[response objectForKey:@"access_token"] AndKey:@"access_token"];
        [UIFactory SaveNSUserDefaultsWithData:[response objectForKey:@"uuid"] AndKey:@"uuid"];
        [UIFactory SaveNSUserDefaultsWithData:[response objectForKey:@"phone"] AndKey:@"phone"];
        [UIFactory SaveNSUserDefaultsWithData:[response objectForKey:@"nickname"] AndKey:@"nickname"];
        
        [self showTextOnlyWith:@"注册成功，现立刻登录！！！"];
        
        [self performSelector:@selector(loginAccount) withObject:nil afterDelay:1.5f];
    }
    if (_codeFlag != 0 && response != nil && iRequestTag == _codeFlag) {
        
        _codeFlag = 0;
        
        if ([[response objectForKey:@"message"] isEqualToString:@"success"]) {
            
            [self showTextOnlyWith:@"验证码发送成功，短信马上送到！！！"];
            
        }else{
            
            [self showTextOnlyWith:[response objectForKey:@"message"]];
        }
    }
    if (_loginFlag != 0 && response != nil && iRequestTag == _loginFlag) {
        
        [self dismissLoading];
        
        _loginFlag = 0;
        
        NSData *loginData = [NSKeyedArchiver archivedDataWithRootObject:response];
        [UIFactory SaveNSUserDefaultsWithData:loginData AndKey:@"LoginData"];
        [UIFactory SaveNSUserDefaultsWithData:[response objectForKey:@"access_token"] AndKey:@"access_token"];
        [UIFactory SaveNSUserDefaultsWithData:[response objectForKey:@"uuid"] AndKey:@"uuid"];
        [UIFactory SaveNSUserDefaultsWithData:[response objectForKey:@"phone"] AndKey:@"phone"];
        [UIFactory SaveNSUserDefaultsWithData:[response objectForKey:@"nickname"] AndKey:@"nickname"];
        [UIFactory SaveNSUserDefaultsWithData:[response objectForKey:@"company_address"] AndKey:@"company_address"];
        [UIFactory SaveNSUserDefaultsWithData:[response objectForKey:@"home_address"] AndKey:@"home_address"];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOGIN_SUCCESS object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)requestFailed:(NSDictionary *)response tag:(NSInteger)iRequestTag
{
    
    NSLog(@"失败\n%@",response);
    
    if (_registerFlag != 0 && response != nil && iRequestTag == _registerFlag) {
        
        [self dismissLoading];
        
        _registerFlag = 0;
        
        [self showTextOnlyWith:[response objectForKey:@"message"]];
    }
    if (_codeFlag != 0 && response != nil && iRequestTag == _codeFlag) {
        
        _codeFlag = 0;
        
        [self showTextOnlyWith:[response objectForKey:@"message"]];
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
