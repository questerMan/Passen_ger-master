//
//  PaySuccessController.m
//  DriverProject
//
//  Created by 林镇杰 on 15/9/23.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "PaySuccessController.h"
#import "CommonPopView.h"
#import "PaySuccessUIObject.h"
#import "QiFacade+postdemol.h"
#import "QiFacade+getmodel.h"
#import "CancelViewController.h"
#import "PayController.h"

@interface PaySuccessController ()<PopViewDelegate,PaySuccessDelegate,UITextViewDelegate,QiFacadeHttpRequestDelegate>
{
    NSString *starCount;
}
@property(nonatomic, strong)PaySuccessUIObject *payUIObject;

@property(nonatomic, assign)NSInteger detailFlag;

@property(nonatomic, assign)NSInteger submitFlag;

@property(nonatomic, assign)NSInteger checkFlag;

@property(nonatomic, assign)NSInteger invoiceFlag;

@end

@implementation PaySuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"行程详情";
    self.view.backgroundColor = BG_COLOR_VIEW;
    
    if ([self.payType isEqualToString:@"WX"]) {
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, 0, 50, 40);
        [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -25, 0.0, 0.0)];
        [backBtn addTarget:self action:@selector(backToLastView) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
        self.navigationItem.leftBarButtonItem = item;

    }
    
    if ([self.payType isEqualToString:@"main"]) {
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, 0, 50, 40);
        [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -25, 0.0, 0.0)];
        [backBtn addTarget:self action:@selector(backToRootView) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
        self.navigationItem.leftBarButtonItem = item;
        
    }
    
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, 70, 40);
    [cancelBtn setTitle:@"投诉" forState:UIControlStateNormal];
    cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [cancelBtn setTitleColor:kUIColorFromRGB(0x727272) forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [cancelBtn addTarget:self action:@selector(goToComplaintView) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    starCount = @"5";
    
    [self loadTravelDetailDataWithOrder:self.orderNum];
}

-(void)createTheCustomViewWith:(NSDictionary *)dic
{
    self.paySuccessDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    NSDictionary *driverDic = [dic objectForKey:@"driver"];
    //[NSDictionary dictionaryWithObjectsAndKeys:@"刘师傅",DRIVER_NAME_KEY,@"粤A**P45 大众辉腾",DRIVER_CAR_KEY,@"8",DRIVER_STAR_KEY,@"154单",DRIVER_ORDER_COUNT_KEY,@"18665751365",DRIVER_PHONE_NUMBER_KEY, nil];
    CommonPopView *popView = [[CommonPopView alloc]initPopViewFrame:CGRectMake(0, 64, self.view.width, 80) AndDriverData:driverDic];
    popView.popDelegate = self;
    [self.view addSubview:popView];
    
    self.payUIObject = [[PaySuccessUIObject alloc]init];
    [_payUIObject initUiObjectWith:dic];
    _payUIObject.payDelegate = self;
    _payUIObject.bgView.frame = CGRectMake(0, popView.bottom + 10, self.view.width, self.view.height - popView.height - 74);
    [self.view addSubview:_payUIObject.bgView];
    [_payUIObject doAutoLayout];
    _payUIObject.evaluateText.delegate = self;
}

#pragma - mark PopViewDelegate
-(void)popBtnDidRingUpByDriverPhoneNumber:(NSString *)phone
{
    [UIFactory callThePhone:phone];
}

#pragma - mark PaySuccessDelegate
-(void)starButtonSelect:(UIButton *)btn AndStarCount:(NSString *)count
{
    starCount = count;
    
    
    switch ([starCount intValue]) {
        case 1:
            
            [_payUIObject.starOne setBackgroundImage:[UIImage imageNamed:@"star_yellow"] forState:UIControlStateNormal];
            break;
        
        case 2:
            
            [_payUIObject.starOne setBackgroundImage:[UIImage imageNamed:@"star_yellow"] forState:UIControlStateNormal];
            [_payUIObject.starTwo setBackgroundImage:[UIImage imageNamed:@"star_yellow"] forState:UIControlStateNormal];
            break;
            
        case 3:
            
            [_payUIObject.starOne setBackgroundImage:[UIImage imageNamed:@"star_yellow"] forState:UIControlStateNormal];
            [_payUIObject.starTwo setBackgroundImage:[UIImage imageNamed:@"star_yellow"] forState:UIControlStateNormal];
            [_payUIObject.starThree setBackgroundImage:[UIImage imageNamed:@"star_yellow"] forState:UIControlStateNormal];
            break;
            
        case 4:
            
            [_payUIObject.starOne setBackgroundImage:[UIImage imageNamed:@"star_yellow"] forState:UIControlStateNormal];
            [_payUIObject.starTwo setBackgroundImage:[UIImage imageNamed:@"star_yellow"] forState:UIControlStateNormal];
            [_payUIObject.starThree setBackgroundImage:[UIImage imageNamed:@"star_yellow"] forState:UIControlStateNormal];
            [_payUIObject.starFour setBackgroundImage:[UIImage imageNamed:@"star_yellow"] forState:UIControlStateNormal];
            break;
            
        case 5:
            
            [_payUIObject.starOne setBackgroundImage:[UIImage imageNamed:@"star_yellow"] forState:UIControlStateNormal];
            [_payUIObject.starTwo setBackgroundImage:[UIImage imageNamed:@"star_yellow"] forState:UIControlStateNormal];
            [_payUIObject.starThree setBackgroundImage:[UIImage imageNamed:@"star_yellow"] forState:UIControlStateNormal];
            [_payUIObject.starFour setBackgroundImage:[UIImage imageNamed:@"star_yellow"] forState:UIControlStateNormal];
            [_payUIObject.starFive setBackgroundImage:[UIImage imageNamed:@"star_yellow"] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

#pragma - mark 行程详情
-(void)loadTravelDetailDataWithOrder:(NSString *)order
{
    QiFacade *facade;
    facade = [QiFacade sharedInstance];
    _detailFlag = [facade getOrderDetailsWithID:order];
    [facade addHttpObserver:self tag:_detailFlag];
    [self showLoadingWithText:@"Loading..."];
}

#pragma - mark 查看明细
-(void)checkTheOrderData
{
    PayController *pay = [[PayController alloc] init];
    pay.pageType = PAYVIEW_PAGETYPE_PAYAFTER;
    pay.orderNum = self.orderNum;
    pay.allCost = [self.paySuccessDic objectForKey:@"fee"];
    pay.driverDic = [self.paySuccessDic objectForKey:@"driver"];
    [self.navigationController pushViewController:pay animated:YES];
}

#pragma - mark 索要发票
-(void)invoiceButtonActionWithAmount:(NSString *)amount
{
    QiFacade *facade;
    facade = [QiFacade sharedInstance];
    _invoiceFlag = [facade postOrderInvoiceWithID:self.orderNum];
    [facade addHttpObserver:self tag:_invoiceFlag];
    [self showLoadingWithText:@"Loading..."];
}

#pragma - mark 提交评价(PaySuccessDelegate)
-(void)submitTheOrderDateWithStarCount:(NSString *)count AndInputData:(NSString *)input
{
    NSLog(@"StarCount:%@\nInputData:%@",count,input);
    
    if ([input isEqualToString:@" 在这里输入对司机的评论"]) {
        input = @"无评价";
    }
    
    if (count == nil || count.length == 0) {
        
        count = starCount;
    }
    QiFacade *facade;
    facade = [QiFacade sharedInstance];
    _submitFlag = [facade postOrderRating:count Comment:input WithID:self.orderNum];
    [facade addHttpObserver:self tag:_submitFlag];
    [self showLoadingWithText:@"评价提交中..."];
}

#pragma - mark 网络请求回调
-(void)requestFinished:(NSDictionary *)response tag:(NSInteger)iRequestTag
{
    [self dismissLoading];
    
    NSLog(@"成功\n%@",response);
    
    if (_submitFlag != 0 && response != nil && iRequestTag == _submitFlag) {
        
        _submitFlag = 0;
        
        if ([[response objectForKey:@"message"] isEqualToString:@"success"]) {
            
            [self showTextOnlyWith:@"评价提交成功！！！"];
            
            [self performSelector:@selector(backToLastView) withObject:nil afterDelay:1.5f];
            
        }else{
            
            [self showTextOnlyWith:[response objectForKey:@"message"]];
        }
    }else if (_invoiceFlag != 0 && response != nil && iRequestTag == _invoiceFlag) {
        
        _invoiceFlag = 0;
        
        if ([[response objectForKey:@"message"] isEqualToString:@"success"]) {
            
            [self showTextOnlyWith:@"索取发票申请成功！！！"];
            
            self.payUIObject = nil;
            [self loadTravelDetailDataWithOrder:self.orderNum];
            
        }else{
            
            [self showTextOnlyWith:[response objectForKey:@"message"]];
        }
    }else if (_detailFlag != 0 && response != nil && iRequestTag == _detailFlag){
        
        _detailFlag = 0;
        
        [self createTheCustomViewWith:response];
    }
    
}

-(void)requestFailed:(NSDictionary *)response tag:(NSInteger)iRequestTag
{
    [self dismissLoading];
    
    NSLog(@"失败\n%@",response);
    
    if (_submitFlag != 0 && iRequestTag == _submitFlag) {
        
        _submitFlag = 0;
        
        if (response != nil) {
            
            [self showTextOnlyWith:[response objectForKey:@"message"]];
        }else{
            
            [self showTextOnlyWith:@"评价提交失败！！！"];
        }
    }else if (_invoiceFlag != 0 && iRequestTag == _invoiceFlag) {
        
        _invoiceFlag = 0;
        
        if (response != nil) {
            
            [self showTextOnlyWith:[response objectForKey:@"message"]];
        }else{
            
            [self showTextOnlyWith:@"发票索取申请失败！！！"];
        }
    }else if (_detailFlag != 0 && iRequestTag == _detailFlag) {
        
        _detailFlag = 0;
        
        if (response != nil) {
            
            [self showTextOnlyWith:[response objectForKey:@"message"]];
        }else{
            
            [self showTextOnlyWith:@"行程详情获取失败！！！"];
            
            [self performSelector:@selector(backToLastView) withObject:nil afterDelay:1.5f];
        }
    }
}

#pragma - mark UITextView Delegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.textColor = [UIColor blackColor];
    textView.text = @"";
    
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        
        textView.text = @" 在这里输入对司机的评论";
        textView.textColor = [UIColor lightGrayColor];
    }

}

-(void)backToLastView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)backToRootView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(void)goToComplaintView
{
    CancelViewController *cancel = [[CancelViewController alloc]init];
    //投诉
    NSArray *buttonArray = [NSArray arrayWithObjects:@"服务态度恶劣",@"司机迟到",@"绕路行驶",@"骚扰客人", nil];
    cancel.dateDic = [NSDictionary dictionaryWithObjectsAndKeys:@"投诉",Title_key,@"用车过程中遇到什么问题？",Question_key,buttonArray,ButtonArray_key,@"其他投诉理由",TextInput_key,@"提交",SubmitButton_key,self.orderNum,@"orderID", nil];
    [self.navigationController pushViewController:cancel animated:YES];
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
