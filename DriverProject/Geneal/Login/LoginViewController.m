//
//  LoginViewController.m
//  DriverProject
//
//  Created by 林镇杰 on 15/9/13.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "LoginViewController.h"
#import "ForgetViewController.h"
#import "UserInfoController.h"
#import "RegisterController.h"
#import "QiFacade+postdemol.h"
#import "WebViewController.h"

#define LABEL_TEXT_FONT     [UIFont fontWithName:@"Arial" size:13]

@interface LoginViewController ()<UITextFieldDelegate,QiFacadeHttpRequestDelegate>
{
    UIView *nameView;
    UIView *passwordView;
    UIButton *loginBtn;
    UIButton *registerBtn;
    UIButton *forgetBtn;
    UIButton *codeBtn;
    UIButton *checkBox;
    UILabel *userLabel;
    UIButton *userAgreementBtn;
    UITextField *input_Name;
    UITextField *input_Pass;
    NSMutableDictionary *userInputDic;
    BOOL isCheck;
}

@property(nonatomic, assign)NSInteger flag;
@property(nonatomic, assign)NSInteger codeFlag;
@property(nonatomic, assign)NSInteger loginFlag;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kUIColorFromRGB(0x3ab48f);
    self.title = @"登录";
    userInputDic = [NSMutableDictionary dictionary];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    //添加点击界面
    UITapGestureRecognizer *tapViewRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapViewResignFirstRespinder)];
    [self.view addGestureRecognizer:tapViewRecognizer];
    [self createTheCustomView];
}

-(void)tapViewResignFirstRespinder
{
    [self.view endEditing:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)createTheCustomView
{
    UIButton *backBtn = [UIFactory createButton:[UIImage imageNamed:@"back_white"]];
    [backBtn addTarget:self action:@selector(backToRootView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(30);
        make.left.equalTo(self.view).offset(10);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
    UIImageView *logoImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logon_alpha"]];
    [self.view addSubview:logoImg];
    
    [logoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        if (iPhone5 || iPhone4) {
            make.top.equalTo(self.view.mas_top).with.offset(80);
        }else{
            make.top.equalTo(self.view.mas_top).with.offset(100);
        }
        make.width.equalTo(self.view.mas_width).multipliedBy(0.55f);
        make.height.equalTo(logoImg.mas_width).multipliedBy(0.63f);
    }];
    
    loginBtn = [UIFactory createButton:@"登录" BackgroundColor:kUIColorFromRGB(0xf4942d) andTitleColor:[UIColor whiteColor]];
    [loginBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    registerBtn = [UIFactory createButton:@"使用手机短信登录" BackgroundColor:[UIColor clearColor] andTitleColor:[UIColor whiteColor]];
    registerBtn.hidden = YES;
    [registerBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [registerBtn addTarget:self action:@selector(registerButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
//    forgetBtn = [UIFactory createButton:@"忘记密码" BackgroundColor:[UIColor clearColor] andTitleColor:[UIColor whiteColor]];
//    [forgetBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
//    [forgetBtn addTarget:self action:@selector(forgetPasswordButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    checkBox = [UIFactory createButton:[UIImage imageNamed:@"hook_yes"]];
    [checkBox addTarget:self action:@selector(confirmUserAgreement) forControlEvents:UIControlEventTouchUpInside];
    isCheck = YES;
    userLabel = [UIFactory createLabel:@"点击登录，即表示你同意" Font:[UIFont systemFontOfSize:13]];
    userLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    userAgreementBtn = [UIFactory createButton:@"《用户协议》" BackgroundColor:[UIColor clearColor] andTitleColor:kUIColorFromRGB(0xf4942d)];
    [userAgreementBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    userAgreementBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [userAgreementBtn addTarget:self action:@selector(openUserAgreement) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:loginBtn];
    [self.view addSubview:registerBtn];
    [self.view addSubview:checkBox];
    [self.view addSubview:userLabel];
    [self.view addSubview:userAgreementBtn];
    
    [self createTheCustomInputView];
    [self setLayoutForView];
}

-(void)setLayoutForView
{
//    [forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.view.mas_right).offset(-80);
//        make.width.equalTo(self.view.mas_width).multipliedBy(0.2f);
//        make.bottom.equalTo(self.view.mas_bottom).with.offset(- 15);
//        make.height.equalTo(@35);
//    }];
    
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.5f);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(- 100);
        make.height.equalTo(@35);
    }];
    
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.85f);
        make.height.equalTo(self.view.mas_height).multipliedBy(0.08f);
        make.bottom.equalTo(registerBtn.mas_top).with.offset(-30);
    }];
    
    [passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(loginBtn.mas_top).with.offset(-10);
        make.height.equalTo(loginBtn.mas_height);
        make.width.equalTo(loginBtn.mas_width);
    }];
    
    [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passwordView);
        make.width.equalTo(passwordView.mas_width).multipliedBy(0.7f);
        make.height.equalTo(passwordView.mas_height);
        make.bottom.equalTo(passwordView.mas_top).with.offset(-10);
    }];
    
    [checkBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginBtn);
        make.top.equalTo(loginBtn.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(0, 15));
    }];
    
    [userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(checkBox.mas_right).offset(3);
        make.top.equalTo(checkBox);
        make.height.equalTo(checkBox);
        make.width.mas_equalTo(@150);
    }];
    
    [userAgreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userLabel.mas_right);
        make.top.equalTo(userLabel);
        make.height.equalTo(userLabel);
        make.right.equalTo(self.view).with.offset(-20);
    }];}

/**
 *  创建一个自定义的输入View
 *
 *  @param type 001：UserName  002：Password
 *
 *  @return 自定义的view
 */
-(void)createTheCustomInputView
{
    nameView = [[UIView alloc] init];
    
    UIImageView *logo_Name = [[UIImageView alloc]init];
    
    input_Name = [[UITextField alloc]init];
    input_Name.textColor = [UIColor whiteColor];
    input_Name.keyboardType = UIKeyboardTypePhonePad;
    input_Name.delegate = self;
    input_Name.tag = 001;
    input_Name.text = [[UIFactory getNSUserDefaultsDataWithKey:@"phone"] isEqualToString:NULL_DATA]?@"":[UIFactory getNSUserDefaultsDataWithKey:@"phone"];
    
    UIView *line_Name = [[UIView alloc]init];
    line_Name.backgroundColor = [UIColor whiteColor];
    
    [logo_Name setImage:[UIImage imageNamed:@"login_name"]];
    input_Name.placeholder = @"手机号码";
    
    codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    codeBtn.layer.masksToBounds = YES;
    codeBtn.layer.cornerRadius = 3;
    codeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [codeBtn setBackgroundColor:kUIColorFromRGB(0xf4942d)];
    [codeBtn setTitle:@"验证" forState:UIControlStateNormal];
    [codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [codeBtn addTarget:self action:@selector(getVerificationCode) forControlEvents:UIControlEventTouchUpInside];
    
    
    [userAgreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userLabel.mas_right);
        make.top.equalTo(userLabel);
        make.height.equalTo(userLabel);
        make.right.equalTo(self.view).with.offset(-20);
    }];

    
    [nameView addSubview:logo_Name];
    [nameView addSubview:input_Name];
    [nameView addSubview:line_Name];
    
    [self.view addSubview:nameView];
    [self.view addSubview:codeBtn];
    
   
    [codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(loginBtn.mas_right);
        make.width.equalTo(loginBtn.mas_width).multipliedBy(0.22f);
        make.height.equalTo(loginBtn.mas_width).multipliedBy(0.12f);;
        make.bottom.equalTo(logo_Name.mas_bottom).with.offset(4);
    }];
    
    [logo_Name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(nameView);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [input_Name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(logo_Name.mas_right).with.offset(15);
        make.top.equalTo(logo_Name.mas_top);
        make.height.equalTo(logo_Name.mas_height);
        make.width.equalTo(nameView.mas_width).multipliedBy(0.8f);
    }];
    
    [line_Name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logo_Name.mas_bottom).with.offset(2);
        make.left.equalTo(logo_Name.mas_left);
        make.height.mas_equalTo(@0.5f);
        make.width.equalTo(nameView.mas_width);
    }];
    
    
    passwordView = [[UIView alloc] init];
    
    UIImageView *logo_Pass = [[UIImageView alloc] init];
    
    input_Pass = [[UITextField alloc]init];
    input_Pass.textColor = [UIColor whiteColor];
    input_Pass.secureTextEntry = NO;
    input_Pass.keyboardType = UIKeyboardTypeNumberPad;
    input_Pass.delegate = self;
    input_Pass.tag = 002;
    
    UIView *line_Pass = [[UIView alloc]init];
    line_Pass.backgroundColor = [UIColor whiteColor];
    
    [logo_Pass setImage:[UIImage imageNamed:@"login_password"]];
    input_Pass.placeholder = @"验证码";
    
    [passwordView addSubview:logo_Pass];
    [passwordView addSubview:input_Pass];
    [passwordView addSubview:line_Pass];
    [self.view addSubview:passwordView];
    
    [logo_Pass mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(passwordView);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [input_Pass mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(logo_Pass.mas_right).with.offset(15);
        make.top.equalTo(logo_Pass.mas_top);
        make.height.equalTo(logo_Pass.mas_height);
        make.width.equalTo(passwordView.mas_width).multipliedBy(0.8f);
    }];
    
    [line_Pass mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logo_Pass.mas_bottom).with.offset(2);
        make.height.mas_equalTo(@0.5f);
        make.left.equalTo(logo_Pass.mas_left);
        make.width.equalTo(passwordView.mas_width);
    }];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![textField.text  isEqualToString: @""] || textField.text != nil) {
        
        if (textField.tag == 001) {
            [userInputDic setObject:textField.text forKey:@"username"];
            
        }else if (textField.tag == 002){
            [userInputDic setObject:textField.text forKey:@"password"];
            
        }
    }
}

/*
-(void)loginBtnAction
{
 
    if ([[userInputDic objectForKey:@"username"] length] == 0) {
        
        [self showTextOnlyWith:@"请输入用户名"];
        return;
    }
    if ([[userInputDic objectForKey:@"password"] length] == 0) {
        
        [self showTextOnlyWith:@"请输入密码"];
        return;
    }
    if ([[userInputDic objectForKey:@"username"] length] < 6) {
        
        [self showTextOnlyWith:@"用户名应为6-20位数字或字母"];
        return;
    }
//    if ([[userInputDic objectForKey:@"password"] length] < 6) {
//        
//        [self showTextOnlyWith:@"密码长度必须为6-14位数字或字母"];
//        return;
//    }

    QiFacade *facade;
    facade = [QiFacade sharedInstance];
    _flag = [facade postLogon:[userInputDic objectForKey:@"username"] password:[userInputDic objectForKey:@"password"]];
    [facade addHttpObserver:self tag:_flag];
    [self showLoadingWithText:@"登录中..."];
}
 
*/

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

-(void)loginBtnAction
{
    if ([input_Name.text length] == 0 || ([input_Name.text length] < 11)) {
        
        [self showTextOnlyWith:@"请输入正确的手机号码"];
        return;
    }
    if ([input_Pass.text length] == 0) {
        
        [self showTextOnlyWith:@"请输入验证码"];
        return;
    }
    if (isCheck == NO) {
        [self showTextOnlyWith:@"登录需同意《用户协议》"];
        return;
    }

    QiFacade *facade;
    NSString *phone = input_Name.text;
    NSString *password = input_Pass.text;
    [self showLoadingWithText:@"正在登录..."];
    facade = [QiFacade sharedInstance];
    _loginFlag = [facade postRegist:phone password:password vcode:password];
    [facade addHttpObserver:self tag:_loginFlag];

}


-(void)getVerificationCode
{
    if ([input_Name.text length] == 0 || ([input_Name.text length] <11)) {
        
        [self showTextOnlyWith:@"请输入正确的手机号码以便获取验证码"];
        return;
    }
    
        [self verifyEvent];
        QiFacade *facade;
        facade = [QiFacade sharedInstance];
        _codeFlag = [facade postGetCodeWithphone:input_Name.text];
        [facade addHttpObserver:self tag:_codeFlag];
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
                [codeBtn setTitle:@"验证" forState:UIControlStateNormal];
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

#pragma - mark 网络请求回调
-(void)requestFinished:(NSDictionary *)response tag:(NSInteger)iRequestTag
{
    [self dismissLoading];
    
    NSLog(@"成功11\n%@",response);
    
    if (_flag != 0 && response != nil && iRequestTag == _flag) {
        
        _flag = 0;
        
        NSData *loginData = [NSKeyedArchiver archivedDataWithRootObject:response];
        [UIFactory SaveNSUserDefaultsWithData:loginData AndKey:@"LoginData"];
        [UIFactory SaveNSUserDefaultsWithData:[response objectForKey:@"access_token"] AndKey:@"access_token"];
        [UIFactory SaveNSUserDefaultsWithData:[response objectForKey:@"uuid"] AndKey:@"uuid"];
        [UIFactory SaveNSUserDefaultsWithData:[response objectForKey:@"phone"] AndKey:@"phone"];
        [UIFactory SaveNSUserDefaultsWithData:[response objectForKey:@"nickname"] AndKey:@"nickname"];
        [UIFactory SaveNSUserDefaultsWithData:[response objectForKey:@"company_address"] AndKey:@"company_address"];
        [UIFactory SaveNSUserDefaultsWithData:[response objectForKey:@"company_address_lat"] AndKey:@"company_address_lat"];
        [UIFactory SaveNSUserDefaultsWithData:[response objectForKey:@"company_address_lon"] AndKey:@"company_address_lon"];
        [UIFactory SaveNSUserDefaultsWithData:[response objectForKey:@"home_address"] AndKey:@"home_address"];
        [UIFactory SaveNSUserDefaultsWithData:[response objectForKey:@"home_address_lat"] AndKey:@"home_address_lat"];
        [UIFactory SaveNSUserDefaultsWithData:[response objectForKey:@"home_address_lon"] AndKey:@"home_address_lon"];
        [UIFactory SaveNSUserDefaultsWithData:[response objectForKey:@"invoice_money"] AndKey:@"invoice_money"];
        [UIFactory SaveNSUserDefaultsWithData:[response objectForKey:@"money"] AndKey:@"money"];
        [UIFactory SaveNSUserDefaultsWithData:[response objectForKey:@"fee"] AndKey:@"fee"];
        [UIFactory SaveNSUserDefaultsWithData:[response objectForKey:@"socket"] AndKey:@"socket"];
        
        if ([response objectForKey:@"company"] != nil) {
            [UIFactory SaveNSUserDefaultsWithData:[response objectForKey:@"company"] AndKey:@"company"];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOGIN_SUCCESS object:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
//        UserInfoController *userInfo = [[UserInfoController alloc]init];
//        [self.navigationController pushViewController:userInfo animated:YES];
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
    [self dismissLoading];
    
    NSLog(@"失败\n%@",response);
    
    if (_flag != 0 && response != nil && iRequestTag == _flag) {
        
        _flag = 0;
        
        [self showTextOnlyWith:[response objectForKey:@"message"]];
    }
    
    if (_codeFlag != 0 && response != nil && iRequestTag == _codeFlag) {
        
        _codeFlag = 0;
        
        [self showTextOnlyWith:[response objectForKey:@"message"]];
    }
    if (_loginFlag != 0 && response != nil && iRequestTag == _loginFlag) {
        
        _codeFlag = 0;
        
        [self showTextOnlyWith:[response objectForKey:@"message"]];
    }
}

-(void)registerButtonAction
{
    RegisterController *registerV = [[RegisterController alloc]init];
    [self.navigationController pushViewController:registerV animated:YES];
}

-(void)forgetPasswordButtonAction
{
    ForgetViewController *forget = [[ForgetViewController alloc]init];
    [self.navigationController pushViewController:forget animated:YES];
}

-(void)backToRootView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
