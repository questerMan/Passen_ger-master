//
//  CCBBaseViewController.m
//  CCB_Messager
//
//  Created by wuqinming on 13-12-12.
//  Copyright (c) 2013年 WuQinming. All rights reserved.
//

#import "CCBBaseViewController.h"

@interface CCBBaseViewController ()
{
    UIAlertView *hudAlert;
    BaseAlertView *loadingAlert;
}

@end

@implementation CCBBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [hudAlert release];
    [loadingAlert release];
    [super dealloc];
}

//- (void)showHUD
//{
//    if (hudAlert == nil) {
//        hudAlert = [[UIAlertView alloc] initWithTitle:nil
//                                             message: @"正在加载中"
//                                            delegate: self
//                                   cancelButtonTitle: nil
//                                   otherButtonTitles: nil];
//        
//        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//        activityView.frame = CGRectMake(120.f, 48.0f, 37.0f, 37.0f);
//        [hudAlert addSubview:activityView];
//        [activityView startAnimating];
//        [hudAlert show];
//    }
//}

- (void)hideHUD
{
    if (hudAlert) {
        [hudAlert dismissWithClickedButtonIndex:0 animated:YES];
        [hudAlert release];
        hudAlert = nil;
    }
}

//- (void)showHUDwithTitile:(NSString *)title content:(NSString *)content
//{
//    if (hudAlert == nil) {
//        hudAlert = [[UIAlertView alloc] initWithTitle:title
//                                              message: content
//                                             delegate: self
//                                    cancelButtonTitle: nil
//                                    otherButtonTitles: nil];
//        
//        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//        activityView.frame = CGRectMake(120.f, 48.0f, 37.0f, 37.0f);
//        [hudAlert addSubview:activityView];
//        [activityView startAnimating];
//        [hudAlert show];
//    }
//}

-(void)showWarningMessage:(NSString *)message{
    NSArray *BtnTitleArr = @[@"确定"];
    BaseAlertView *alert = [[BaseAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@",message] btnTitleArray:BtnTitleArr alertType:BaseAlertViewWarn];
    [alert show];
    [alert release];

}

-(void)showErrorMessage:(NSString *)message errorCode:(NSString *)errCode{
    NSArray *BtnTitleArr = @[@"确定"];
    NSString* errStr;
    if (errCode) {
        errStr=[NSString stringWithFormat:@"错误代码：%@",errCode];
    }else{
        errStr=nil;
    }
    BaseAlertView *alert = [[BaseAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@",message] btnTitleArray:BtnTitleArr alertType:BaseAlertViewError errorCode:errStr];
    [alert show];
    [alert release];
}

-(void)showOKMessage:(NSString *)message{
    NSArray *BtnTitleArr = @[@"确定"];
    BaseAlertView *alert = [[BaseAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@",message] btnTitleArray:BtnTitleArr alertType:BaseAlertViewOK];
    [alert show];
    [alert release];
}

//-(void)showHudwithMessage:(NSString *)message{
//    NSArray *BtnTitleArr = @[@"取消",@"确定"];
//    BaseAlertView *alert = [[BaseAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@",message] btnTitleArray:BtnTitleArr alertType:BaseAlertViewDefault];
//    [alert show];
//    [alert release];
//
//}
//
//-(void)showBigButtonHudwithMessge:(NSString *)message andButtonTitle:(NSString *)buttonTitle{
//    NSArray *BtnTitleArr = @[buttonTitle];
//    BaseAlertView *alert = [[BaseAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@",message] btnTitleArray:BtnTitleArr alertType:BaseAlertViewDefault];
//    [alert show];
//    [alert release];
//}
//
//-(void)showBigButtonHudwithErrorCode:(NSString *)code ErrorMessage:(NSString *)message andButtonTitle:(NSString *)buttonTitle{
//    NSArray *BtnTitleArr = @[buttonTitle];
//    NSString *alertStr;
//    if ([message length]>0) {
//        alertStr= [NSString stringWithFormat:@"%@\n%@",code,message];
//    }else{
//        alertStr=[NSString stringWithFormat:@"%@!",code];
//    }
//    BaseAlertView *alert = [[BaseAlertView alloc]initWithTitle:nil message:alertStr btnTitleArray:BtnTitleArr alertType:BaseAlertViewDefault];
//    [alert setMessageLabelTextAlignment:NSTextAlignmentCenter];
//    [alert show];
//    [alert release];
//}

-(void)showLoadingView{
    if (loadingAlert==nil) {
        loadingAlert=[[BaseAlertView alloc] initWithTitle:nil message:@"" btnTitleArray:nil alertType:BaseAlertViewLoading];
    }
    [loadingAlert show];
}

-(void)hideLoadingView{
    if (loadingAlert) {
        [loadingAlert hideLoading];
        [loadingAlert release];
        loadingAlert=nil;
    }
}
- (BOOL)bOKforNetwork
{
    return YES;
}

@end
