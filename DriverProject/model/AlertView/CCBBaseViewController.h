//
//  CCBBaseViewController.h
//  CCB_Messager
//
//  Created by wuqinming on 13-12-12.
//  Copyright (c) 2013年 WuQinming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseAlertView.h"


#define UI_SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

@interface CCBBaseViewController : UIViewController

- (BOOL)bOKforNetwork;

//- (void)showHUD;
- (void)hideHUD;

//- (void)showHUDwithTitile:(NSString *)title content:(NSString *)content;

//- (void)showHudwithMessage:(NSString *)message;

- (void)showLoadingView;

- (void)hideLoadingView;

//- (void)showBigButtonHudwithMessge:(NSString *)message andButtonTitle:(NSString *)buttonTitle;

//-(void)showBigButtonHudwithErrorCode:(NSString *)code ErrorMessage:(NSString *)message andButtonTitle:(NSString *)buttonTitle;

-(void)showWarningMessage:(NSString *)message;

-(void)showErrorMessage:(NSString *)message errorCode:(NSString *)errCode;

-(void)showOKMessage:(NSString *)message;


@end
