//
//  InvoiceViewController.m
//  DriverProject
//
//  Created by 林镇杰 on 15/9/13.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "InvoiceViewController.h"
#import "HistoryViewController.h"
#import "QiFacade+postdemol.h"

@interface InvoiceViewController ()<QiFacadeHttpRequestDelegate,UITextFieldDelegate>

@property(nonatomic,strong) InvoiceUIobject *uiObject;

@property(nonatomic, assign)NSInteger flag;

@end

@implementation InvoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发票";
    self.view.backgroundColor = BG_COLOR_VIEW;
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(0, 0, 50, 40);
//    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -25, 0.0, 0.0)];
//    [backBtn addTarget:self action:@selector(backToLastView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, 70, 40);
    [cancelBtn setTitle:@"开票历史" forState:UIControlStateNormal];
    cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [cancelBtn setTitleColor:kUIColorFromRGB(0x212121) forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [cancelBtn addTarget:self action:@selector(goToInvoiceDetailView) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
//    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = item;
    
    self.uiObject = [[InvoiceUIobject alloc]init];
    [_uiObject initUiObjectWith:nil];
    [_uiObject.bgView setScrollEnabled:YES];
    
    _uiObject.bgView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    [self.view addSubview:_uiObject.bgView];
    
    _uiObject.consigneeField.delegate = self;
    _uiObject.phoneField.delegate = self;

    [_uiObject.submitBtn addTarget:self action:@selector(submitInvoiceData) forControlEvents:UIControlEventTouchUpInside];
    _uiObject.thirdView.frame = CGRectMake(0, _uiObject.bgView.height - 126, _uiObject.bgView.width, 60);
    [_uiObject doAutoLayout];
}

-(void)submitInvoiceData
{
    if ([self checkTheInputStatus]) {
        
        QiFacade *facade;
        facade = [QiFacade sharedInstance];
        _flag = [facade postInvoice:_uiObject.titleField.text Amount:_uiObject.amountField.text Address:_uiObject.addressField.text Contactor:_uiObject.consigneeField.text Phone:_uiObject.phoneField.text];
        [facade addHttpObserver:self tag:_flag];
        [self showLoadingWithText:@"提交中..."];
        
    }else{
        
        if (_uiObject.titleField.text.length == 0) {
            
            [self showTextOnlyWith:@"请正确填写发票抬头！！！"];
            
        }else if (_uiObject.amountField.text.length == 0){
            
            [self showTextOnlyWith:@"请正确填写发票金额！！！"];
            
        }else if (_uiObject.amountField.text != 0 && [_uiObject.amountField.text intValue] > [[UIFactory getNSUserDefaultsDataWithKey:@"invoice_money"] intValue]){
            
            [self showTextOnlyWith:@"发票金额过大，请修改！！！"];
            
        }else if (_uiObject.addressField.text.length == 0){
            
            [self showTextOnlyWith:@"请正确填写邮寄地址！！！"];
            
        }else if (_uiObject.consigneeField.text.length == 0){
            
            [self showTextOnlyWith:@"请正确填写收件人！！！"];
            
        }else if (_uiObject.phoneField.text.length == 0){
            
            [self showTextOnlyWith:@"请正确填写联系电话！！！"];
        }
        
    }
}

-(BOOL)checkTheInputStatus
{
    BOOL status;
    
    if (_uiObject.titleField.text.length != 0 && _uiObject.amountField.text.length != 0 && _uiObject.addressField.text.length != 0 && _uiObject.consigneeField.text.length != 0 && _uiObject.phoneField.text.length != 0) {
        
        status = YES;
    }else{
        
        status = NO;
    }
    return status;
}

#pragma - mark 网络请求回调
-(void)requestFinished:(NSDictionary *)response tag:(NSInteger)iRequestTag
{
    [self dismissLoading];
    
    NSLog(@"成功\n%@",response);
    
    if (_flag != 0 && response != nil && iRequestTag == _flag) {
        
        _flag = 0;
        
        NSString *code = [NSString stringWithFormat:@"%@",[response objectForKey:@"code"]];
        
        if ([code isEqualToString:@"1"]) {
            
            [self showTextOnlyWith:@"发票开具申请提交成功！！！"];
            [self performSelector:@selector(goToInvoiceDetailView) withObject:nil afterDelay:1.5f];
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
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [_uiObject.bgView setContentOffset:CGPointMake(0, -64) animated:YES];
    _uiObject.bgView.bouncesZoom = NO;
}

-(void)goToInvoiceDetailView
{
    HistoryViewController *history = [[HistoryViewController alloc]init];
    [self.navigationController pushViewController:history animated:YES];
}

-(void)backToLastView
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)backToRootView//disconnect
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
