//
//  newLoginViewController.m
//  广汽丽新
//
//  Created by mac on 17/3/31.
//  Copyright © 2017年 广州市优玩科技有限公司. All rights reserved.
//

#import "newLoginViewController.h"
#import "ForgetViewController.h"
#import "UserInfoController.h"
#import "RegisterController.h"
#import "QiFacade+postdemol.h"
#import "WebViewController.h"

#define LABEL_TEXT_FONT     [UIFont fontWithName:@"Arial" size:13]

@interface newLoginViewController ()<UITextFieldDelegate,QiFacadeHttpRequestDelegate>

@property(nonatomic, strong) UIImageView *bgImg;

@property(nonatomic, strong) UIButton *backBtn;

@property(nonatomic, strong) UIImageView *logoImg;

@property(nonatomic, strong) UIView *middleView;

@property(nonatomic, strong) UIButton *loginBtn;

@property(nonatomic, strong) UIButton *checkBox;

@property(nonatomic, strong) UILabel *userLabel;

@property(nonatomic, strong) UIButton *userAgreementBtn;

@property(nonatomic, strong) NSMutableDictionary *userInputDic;

@property(nonatomic, strong) UIView *nameView;

@property(nonatomic, strong) UITextField *input_Name;

@property(nonatomic, strong) UIView *line_Name;

@property(nonatomic, strong) UIButton *codeBtn;

@property(nonatomic, strong) UIImageView *logo_Name;

@property(nonatomic, strong) UIView *passwordView;

@property(nonatomic, strong) UIImageView *logo_Pass;

@property(nonatomic, strong) UITextField *input_Pass;

@property(nonatomic, strong) UIView *line_Pass;


@property(nonatomic, assign)NSInteger flag;
@property(nonatomic, assign)NSInteger codeFlag;
@property(nonatomic, assign)NSInteger loginFlag;
@property(nonatomic, assign)BOOL isCheck;
@end

@implementation newLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录";
    _userInputDic = [NSMutableDictionary dictionary];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    //添加点击界面
    UITapGestureRecognizer *tapViewRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapViewResignFirstRespinder)];
    [self.view addGestureRecognizer:tapViewRecognizer];
    
    [self creatUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)creatUI{
    
    UIImageView *bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    [self.view addSubview:bgImg];
    self.bgImg = bgImg;
    
    UIButton *backBtn = [UIFactory createButton:[UIImage imageNamed:@"back_white"]];
    [backBtn addTarget:self action:@selector(backToRootView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    self.backBtn = backBtn;
    
    UIImageView *logoImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo-"]];
    [self.view addSubview:logoImg];
    self.logoImg = logoImg;
    
    UIView *middleView = [[UIView alloc] init];
    middleView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.25];
    [self.view addSubview:middleView];
    self.middleView = middleView;
    
    _nameView = [[UIView alloc] init];
    _nameView.backgroundColor = [UIColor clearColor];
    [self.middleView addSubview:_nameView];
    
    _input_Name = [[UITextField alloc] init];
    _input_Name.textColor = [UIColor whiteColor];
    _input_Name.keyboardType = UIKeyboardTypePhonePad;
    _input_Name.delegate = self;
    _input_Name.tag = 001;
    _input_Name.text = [[UIFactory getNSUserDefaultsDataWithKey:@"phone"] isEqualToString:NULL_DATA]?@"":[UIFactory getNSUserDefaultsDataWithKey:@"phone"];
    _input_Name.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号码" attributes:@{NSForegroundColorAttributeName : UIColorFromRGB(@"#b5c0c1"),NSFontAttributeName : [UIFont systemFontOfSize:MATCHSIZE(32)]}];
    _input_Name.textAlignment = NSTextAlignmentCenter;
    _input_Name.font = [UIFont systemFontOfSize:MATCHSIZE(32)];
    [_nameView addSubview:_input_Name];
    
    _line_Name = [[UIView alloc]init];
    _line_Name.backgroundColor = UIColorFromRGB(@"#f68332");
    [_nameView addSubview:_line_Name];
    
    _logo_Name = [[UIImageView alloc] init];
    [_logo_Name setImage:[UIImage imageNamed:@"user"]];
    [_nameView addSubview:_logo_Name];
    
    _codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _codeBtn.layer.masksToBounds = YES;
    _codeBtn.layer.cornerRadius = MATCHSIZE(8);
    _codeBtn.titleLabel.font = [UIFont systemFontOfSize:MATCHSIZE(32)];
    [_codeBtn setBackgroundColor:UIColorFromRGB(@"#f68332")];
    [_codeBtn setTitle:@"验证" forState:UIControlStateNormal];
    [_codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_codeBtn addTarget:self action:@selector(getVerificationCode) forControlEvents:UIControlEventTouchUpInside];
    [self.middleView addSubview:_codeBtn];
    

    _passwordView = [[UIView alloc] init];
    [self.middleView addSubview:_passwordView];
    
    _logo_Pass = [[UIImageView alloc] init];
    [_logo_Pass setImage:[UIImage imageNamed:@"auth-code"]];
    [_passwordView addSubview:_logo_Pass];
    
    _input_Pass = [[UITextField alloc] init];
    _input_Pass.textColor = [UIColor whiteColor];
    _input_Pass.secureTextEntry = NO;
    _input_Pass.keyboardType = UIKeyboardTypeNumberPad;
    _input_Pass.delegate = self;
    _input_Pass.tag = 002;
    _input_Pass.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"验证码" attributes:@{NSForegroundColorAttributeName : UIColorFromRGB(@"#b5c0c1"),NSFontAttributeName : [UIFont systemFontOfSize:MATCHSIZE(32)]}];
    _input_Pass.font = [UIFont systemFontOfSize:MATCHSIZE(32)];
    _input_Pass.textAlignment = NSTextAlignmentCenter;
    [_passwordView addSubview:_input_Pass];
    
    _line_Pass = [[UIView alloc] init];
    _line_Pass.backgroundColor = UIColorFromRGB(@"#f68332");
    [_passwordView addSubview:_line_Pass];
    
    _checkBox = [UIFactory createButton:[UIImage imageNamed:@"hook_yes"]];
    [_checkBox addTarget:self action:@selector(confirmUserAgreement) forControlEvents:UIControlEventTouchUpInside];
    _isCheck = YES;
    UILabel* userLabel = [UIFactory createLabel:@"点击登录，即表示你同意" Font:[UIFont systemFontOfSize:MATCHSIZE(22)]];
    userLabel.textColor = [UIColor colorWithWhite:1 alpha:1.0];
    [self.view addSubview:userLabel];
    self.userLabel = userLabel;
    
    _userAgreementBtn = [UIFactory createButton:@"《用户协议》" BackgroundColor:[UIColor clearColor] andTitleColor:kUIColorFromRGB(0xf4942d)];
    [_userAgreementBtn.titleLabel setFont:[UIFont systemFontOfSize:MATCHSIZE(22)]];
    _userAgreementBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_userAgreementBtn addTarget:self action:@selector(openUserAgreement) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_userAgreementBtn];
    
    _loginBtn = [UIButton buttonWithType:0];
    [_loginBtn setAttributedTitle:[[NSAttributedString alloc] initWithString:@"登录" attributes:@{NSForegroundColorAttributeName : UIColorFromRGB(@"#f68332"),NSFontAttributeName : [UIFont systemFontOfSize:MATCHSIZE(36)]}] forState:0];
    _loginBtn.backgroundColor = [UIColor clearColor];
    _loginBtn.layer.cornerRadius = MATCHSIZE(34);
    _loginBtn.layer.masksToBounds = YES;
    _loginBtn.layer.borderWidth = MATCHSIZE(2);
    _loginBtn.layer.borderColor = UIColorFromRGB(@"#f68332").CGColor;
    [_loginBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.top.offset(0);
        make.bottom.offset(0);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(30);
        make.left.equalTo(self.view).offset(10);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
    [self.logoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(MATCHSIZE(126));
        make.centerX.offset(0);
    }];
    
    [self.middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoImg.mas_bottom).offset(MATCHSIZE(52));
        make.centerX.offset(0);
        make.width.offset(MATCHSIZE(530));
        make.height.offset(MATCHSIZE(322));
    }];
    
    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(MATCHSIZE(24));
        make.top.offset(MATCHSIZE(42));
        make.width.offset(MATCHSIZE(344));
        make.height.offset(MATCHSIZE(80));
    }];
    
    [self.logo_Name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(0);
    }];
    
    [self.input_Name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logo_Name.mas_right).offset(MATCHSIZE(0));
        make.right.offset(0);
        make.centerY.offset(0);
        make.height.offset(MATCHSIZE(40));
    }];
    
    [self.line_Name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(MATCHSIZE(2));
    }];
    
    [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(MATCHSIZE(-22));
        make.width.offset(MATCHSIZE(98));
        make.height.offset(MATCHSIZE(52));
        make.bottom.equalTo(self.nameView.mas_bottom);
    }];
    
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameView.mas_bottom).offset(MATCHSIZE(62));
        make.left.offset(MATCHSIZE(24));
        make.width.offset(MATCHSIZE(344));
        make.height.offset(MATCHSIZE(80));
    }];
    
    [self.logo_Pass mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(0);
    }];
    
    [self.input_Pass mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logo_Pass.mas_right).offset(MATCHSIZE(0));
        make.right.offset(0);
        make.centerY.offset(0);
        make.height.offset(MATCHSIZE(40));
    }];
    
    [self.line_Pass mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(MATCHSIZE(2));
    }];
    
    [self.userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.middleView.mas_bottom).offset(MATCHSIZE(30));
        make.left.equalTo(self.middleView.mas_left).offset(MATCHSIZE(24));
    }];
    
    [self.userAgreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userLabel).offset(MATCHSIZE(-12));
        make.left.equalTo(self.userLabel.mas_right);
    }];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.middleView.mas_bottom).offset(MATCHSIZE(160));
        make.centerX.offset(0);
        make.width.offset(MATCHSIZE(388));
        make.height.offset(MATCHSIZE(68));
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![textField.text  isEqualToString: @""] || textField.text != nil) {
        
        if (textField.tag == 001) {
            //[_userInputDic setObject:textField.text forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:@"username"];
        }else if (textField.tag == 002){
            
            // [_userInputDic setObject:textField.text forKey:@"password"];
            [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:@"password"];
  
        }
    }
}
-(void)backToRootView
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)tapViewResignFirstRespinder
{
    [self.view endEditing:YES];
}

#pragma - mark 网络请求回调
- (void)requestFinished:(NSDictionary *)response tag:(NSInteger)iRequestTag
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
//        [UIFactory SaveNSUserDefaultsWithData:[response objectForKey:@"company_address"] AndKey:@"company_address"];
//        [UIFactory SaveNSUserDefaultsWithData:[response objectForKey:@"home_address"] AndKey:@"home_address"];
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


//打开用户协议
-(void)openUserAgreement
{
    WebViewController *webView = [[WebViewController alloc]init];
    webView.webURL = USER_AGREEMENT_API;
    webView.title = @"用户协议";
    [self.navigationController pushViewController:webView animated:YES];
}

-(void)getVerificationCode
{
    if ([_input_Name.text length] == 0 || ([_input_Name.text length] <11)) {
        
        [self showTextOnlyWith:@"请输入正确的手机号码以便获取验证码"];
        return;
    }
    
    [self verifyEvent];
    QiFacade *facade;
    facade = [QiFacade sharedInstance];
    _codeFlag = [facade postGetCodeWithphone:_input_Name.text];
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
                [_codeBtn setTitle:@"验证" forState:UIControlStateNormal];
                _codeBtn.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSLog(@"____%@",strTime);
                [_codeBtn setTitle:[NSString stringWithFormat:@"%@秒",strTime] forState:UIControlStateNormal];
                _codeBtn.userInteractionEnabled = NO;
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}


-(void)loginBtnAction
{
    if ([_input_Name.text length] == 0 || ([_input_Name.text length] < 11)) {
        
        [self showTextOnlyWith:@"请输入正确的手机号码"];
        return;
    }
    if ([_input_Pass.text length] == 0) {
        
        [self showTextOnlyWith:@"请输入验证码"];
        return;
    }
    if (_isCheck == NO) {
        [self showTextOnlyWith:@"登录需同意《用户协议》"];
        return;
    }
    
    QiFacade *facade;
    NSString *phone = _input_Name.text;
    NSString *password = _input_Pass.text;
    [self showLoadingWithText:@"正在登录..."];
    facade = [QiFacade sharedInstance];
    _loginFlag = [facade postRegist:phone password:password vcode:password];
    [facade addHttpObserver:self tag:_loginFlag];
    
}

//确认用户协议
-(void)confirmUserAgreement
{
    if (_isCheck) {
        
        [_checkBox setBackgroundImage:[UIImage imageNamed:@"hook_no"] forState:UIControlStateNormal];
    }else{
        
        [_checkBox setBackgroundImage:[UIImage imageNamed:@"hook_yes"] forState:UIControlStateNormal];
    }
    
    _isCheck = !_isCheck;
}

@end
