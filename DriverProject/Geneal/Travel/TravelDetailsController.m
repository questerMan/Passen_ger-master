//
//  TravelDetailsController.m
//  DriverProject
//
//  Created by 林镇杰 on 15/9/10.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "TravelDetailsController.h"
#import "CancelViewController.h"
#import "QiFacade+getmodel.h"
#import "PayController.h"

@interface TravelDetailsController ()<QiFacadeHttpRequestDelegate,UIAlertViewDelegate>
{
    NSString *canceld;
    NSString *comment;
    NSString *fee;
    NSString *invoice;
    int status;
    NSString *time;
    NSString *type;
    
    NSDictionary *driverDic;
    NSString *cancel_msg;
    NSString *cancel_fee;
    int free_cancel;
}

@property(nonatomic,strong) TravelUiObject *uiObject;

@property(nonatomic, assign)NSInteger flag;
@property(nonatomic, assign)NSInteger cancelFlag;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation TravelDetailsController

//-(void)action{
//    
//    [self loadTheTravelDetailDataWithOrder:[self.detailDic objectForKey:@"id"]];
//    
//}
-(void)viewDidDisappear:(BOOL)animated{
    [self.timer invalidate];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(action) userInfo:nil repeats:YES];
//    
    self.title = @"预约成功";//修改了头部标签
    self.view.backgroundColor = BG_COLOR_VIEW;
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(0, 0, 50, 40);
//    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -25, 0.0, 0.0)];
//    [backBtn addTarget:self action:@selector(backToLastView) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = item;
    
    if (![[self.detailDic objectForKey:@"is_canceld"]isEqual:@"1"]) {
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(0, 0, 70, 40);
        [cancelBtn setTitle:@"取消用车" forState:UIControlStateNormal];
        cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [cancelBtn setTitleColor:kUIColorFromRGB(0x212121) forState:UIControlStateNormal];
        [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [cancelBtn addTarget:self action:@selector(cancelUseTheCar:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
   
}


-(void)viewWillAppear:(BOOL)animated
{
    [self loadTheTravelDetailDataWithOrder:[self.detailDic objectForKey:@"id"]];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backOnclick)];
}

-(void)backOnclick{
    if ([_delegate respondsToSelector:@selector(refreshHomeView)]) {
        [_delegate refreshHomeView];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)cancelUseTheCar:(id)sender
{
    if (free_cancel == 1) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您确定取消本次用车吗？" delegate:self cancelButtonTitle:@"暂不取消" otherButtonTitles:@"确定取消", nil];
        alert.tag = 10010;
        [alert show];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:cancel_msg delegate:self cancelButtonTitle:@"暂不取消" otherButtonTitles:@"确定取消", nil];
        alert.tag = 10086;
        [alert show];
        
    }
    
    //投诉
//    NSArray *buttonArray = [NSArray arrayWithObjects:@"服务态度恶劣",@"司机迟到",@"绕路行驶",@"骚扰客人", nil];
//    cancel.dateDic = [NSDictionary dictionaryWithObjectsAndKeys:@"投诉",Title_key,@"用车过程中遇到什么问题？",Question_key,buttonArray,ButtonArray_key,@"在这里输入对司机评价",TextInput_key,@"提交",SubmitButton_key,[self.detailDic objectForKey:@"id"],@"orderID", nil];
    
    //反馈
//    cancel.dateDic = [NSDictionary dictionaryWithObjectsAndKeys:@"反馈建议",Title_key,@"请填写您的问题和建议，我们将积极改进。",TextInput_key,@"提交",SubmitButton_key,@"",Question_key,nil,ButtonArray_key,[self.detailDic objectForKey:@"id"],@"orderID", nil];
    
}

-(void)loadTheTravelDetailDataWithOrder:(NSString *)orderNo
{
    QiFacade *facade;
    facade = [QiFacade sharedInstance];
    _flag = [facade getOrderDetailsWithID:orderNo];
    [facade addHttpObserver:self tag:_flag];
    [self showLoadingWithText:@"Loading..."];
}

-(void)loadTheTravelDetailDataFinish:(NSDictionary *)dataDic
{
    canceld = [dataDic objectForKey:@"canceld"];
    comment = [dataDic objectForKey:@"comment"];
    fee = [dataDic objectForKey:@"fee"];
    invoice = [dataDic objectForKey:@"invoice"];
    status = [[dataDic objectForKey:@"status"] intValue];
    time = [dataDic objectForKey:@"time"];
    type = [dataDic objectForKey:@"type"];
    BOOL isCancel =  ([canceld intValue] == 1)?YES:NO;
    
    if ([dataDic objectForKey:@"free_cancel"] != nil) {
        
        cancel_msg = [NSString stringWithFormat:@"%@\n需要扣取的费用为：%@",[[dataDic objectForKey:@"free_cancel"] objectForKey:@"cancel_msg"],[[dataDic objectForKey:@"free_cancel"] objectForKey:@"cancel_fee"]];
        free_cancel = [[[dataDic objectForKey:@"free_cancel"] objectForKey:@"free_cancel"] intValue];
        cancel_fee = [[dataDic objectForKey:@"free_cancel"] objectForKey:@"cancel_fee"];
        driverDic = [dataDic objectForKey:@"driver"];
    }
    for (UIView *view in self.view.subviews) {
        
        [view removeFromSuperview];
    }
    
    self.uiObject = [[TravelUiObject alloc]init];
    _uiObject.isBook = self.isBook;
    [self.uiObject initUiObjectWith:dataDic];
    
    for (UIView *view in self.uiObject.viewArrays) {
        [self.view addSubview:view];
    }
    [_uiObject doAutoLayout:status AndStatus:isCancel AndType:[type intValue]];
}

//取消订单
-(void)cancelOrderAction
{
    QiFacade *facade;
    facade = [QiFacade sharedInstance];
    _cancelFlag = [facade putOrder:nil WithID:[self.detailDic objectForKey:@"id"]];
    [facade addHttpObserver:self tag:_cancelFlag];
    [self showLoadingWithText:@"订单取消中..."];
    
}

#pragma - mark 网络请求回调
-(void)requestFinished:(NSDictionary *)response tag:(NSInteger)iRequestTag
{
    [self dismissLoading];
    
    NSLog(@"成功22\n%@",response);
    
    if (_flag != 0 && response != nil && iRequestTag == _flag) {
        
        _flag = 0;
        
        [self loadTheTravelDetailDataFinish:response];
        
    }else if (_cancelFlag != 0 && response != nil && iRequestTag == _cancelFlag) {
        
        _cancelFlag = 0;
        
        if ([[response objectForKey:@"message"] isEqualToString:@"success"]) {
            
            [self showTextOnlyWith:@"订单取消成功！！！"];
            //取消订单成功，返回去实现刷新界面
            if ([_delegate respondsToSelector:@selector(refreshRecoedListView)]) {
                [_delegate refreshRecoedListView];
            }
            
            [self performSelector:@selector(backToLastView) withObject:nil afterDelay:1.5f];
            
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
        
    }else if (_cancelFlag != 0 && response != nil && iRequestTag == _cancelFlag) {
        
        _cancelFlag = 0;
        
        [self showTextOnlyWith:@"订单取消失败"];
        
    }
}

#pragma - mark UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 10086) {
        
        if (buttonIndex == 1) {
            
            PayController *pay = [[PayController alloc]init];
            pay.pageType = PAYVIEW_PAGETYPE_PAYBEFORE;
            pay.orderNum = [self.detailDic objectForKey:@"id"];
            pay.allCost = cancel_fee;
            pay.driverDic = driverDic;
            
            [self.navigationController pushViewController:pay animated:YES];
        }
    }else if (alertView.tag == 10010){
        
        if (buttonIndex == 1) {
            /*
            CancelViewController *cancel = [[CancelViewController alloc]init];
            
            //取消订单
            NSArray *buttonArray = [NSArray arrayWithObjects:@"我改变行程，暂时不需要用车",@"司机告诉我需要等很久",@"司机无法来接我",@"我选择了别的出行方式", nil];
            cancel.dateDic = [NSDictionary dictionaryWithObjectsAndKeys:@"取消原因",Title_key,@"请告诉我们您取消的原因，我们会不断改进！",Question_key,buttonArray,ButtonArray_key,@"填写其他原因",TextInput_key,@"确定取消",SubmitButton_key,[self.detailDic objectForKey:@"id"],@"orderID", nil];
            [self.navigationController pushViewController:cancel animated:YES];
             */
            
            [self cancelOrderAction];
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
