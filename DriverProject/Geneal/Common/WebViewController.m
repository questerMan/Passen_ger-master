//
//  WebViewController.m
//  DriverProject
//
//  Created by 林镇杰 on 15/10/15.
//  Copyright © 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "WebViewController.h"
NSString *kCompleteRPCURL = @"webviewprogress:///complete";
@interface WebViewController ()<UIWebViewDelegate>
{
    UIWebView *msgDetailWebView;
}
@end

@implementation WebViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initUI];
    
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
-(void)backViewVC{
    [msgDetailWebView stopLoading];
    msgDetailWebView.delegate=nil;
    //    [msgDetailWebView loadHTMLString:@"" baseURL:nil];
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [msgDetailWebView removeFromSuperview];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initUI
{
    
    msgDetailWebView=[[UIWebView alloc] init];
    msgDetailWebView.delegate=self;
    [(UIScrollView *)[[msgDetailWebView subviews] objectAtIndex:0] setBounces:NO];
    //    [(UIScrollView *)[[msgDetailWebView subviews] objectAtIndex:0]setZoomScale:2];
    
    [msgDetailWebView setFrame:CGRectMake(0.0, 0.0, self.view.width,self.view.height )];
    //    msgDetailWebView.opaque=YES;
    [self.view addSubview:msgDetailWebView];
    
    [self loadWebPageWithString:_webURL];
    
}

#pragma  mark 浏览器
-(void)goBack:(id)sender
{
    if ([msgDetailWebView canGoBack]) {
        [msgDetailWebView goBack];
    }
    //    [self checkButtonImage];//检查是否可前进后退
}
-(void)goPrev:(id)sender
{
    if ([msgDetailWebView canGoForward]) {
        [msgDetailWebView goForward];
    }
    
    //    [self checkButtonImage];//检查是否可前进后退
}


-(void)doCancel:(id)sender

{
    [msgDetailWebView stopLoading];
    /*
     if (_m_isLoadFinished) {
     
     if ([msgDetailWebView canGoBack]) {
     [msgDetailWebView reload];
     }else{
     [self loadWebPageWithString:self.urlStr];
     }
     
     errorLabel.hidden=YES;
     
     }
     else
     {
     [msgDetailWebView stopLoading];
     
     }
     [self checkButtonImage];//检查是否可前进后退
     */
}


- (void)loadWebPageWithString:(NSString*)urlString
{
    NSURL *url =[NSURL URLWithString:urlString];
    if (url.scheme.length == 0) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", [url absoluteString]]];
    }
    
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [msgDetailWebView loadRequest:request];
    });
    
}
-(BOOL)isLoadingCompleted{
    NSString *readyState = [msgDetailWebView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
    NSLog(@"loadingState:%@",readyState);
    BOOL interactive = [readyState isEqualToString:@"interactive"];
    if (interactive)
    {
        NSString *waitForCompleteJS = [NSString stringWithFormat:   @"window.addEventListener('load',function() { "
                                       @"var iframe = document.createElement('iframe');"
                                       @"iframe.style.display = 'none';"
                                       @"iframe.src = '%@';"
                                       @"document.body.appendChild(iframe);"
                                       @"}, false);", kCompleteRPCURL];
        
        [msgDetailWebView stringByEvaluatingJavaScriptFromString:waitForCompleteJS];
    }
    
    BOOL complete = [readyState isEqualToString:@"complete"];
    return complete;
}




#pragma webView
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType

//开始加载的时候执行该方法。
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    
    
}

//加载完成的时候执行该方法。
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    
    
}

//加载出错的时候执行该方法。
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"error==%@",error);
}


- (void)setLoadingProgress:(CGFloat)loadingProgress
{
    
    
    
}

/*
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGB(249, 250, 251);
    
    if ([self.webURL isEqualToString:USER_MANUAL_API]) {
        self.title = @"使用帮助";
    }else if ([self.webURL isEqualToString:CONTACT_APT]){
        self.title = @"联系我们";
    }
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 50, 40);
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToLastView) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftitem;
    
    [self initUI];
}

-(void)initUI
{
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    webView.delegate = self;
    [self.view addSubview:webView];
    [self loadWebPageWithString:self.webURL];
    [self showLoadingWithText:@"加载中..."];
}

- (void)loadWebPageWithString:(NSString*)urlString
{
    NSURL *url =[NSURL URLWithString:urlString];
    if (url.scheme.length == 0) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", [url absoluteString]]];
    }
    
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [webView loadRequest:request];
    });
    
}

-(void)backToLastView
{
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [webView stopLoading];
    [webView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma - mark UIWebView Delegate
-(void)webViewDidStartLoad:(UIWebView *)webView
{

}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self dismissLoading];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self dismissLoading];
    [self showTextOnlyWith:@"加载失败，敬请谅解"];
    [self performSelector:@selector(backToLastView) withObject:nil afterDelay:1.5f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
