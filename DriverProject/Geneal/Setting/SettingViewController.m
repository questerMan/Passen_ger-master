//
//  SettingViewController.m
//  DriverProject
//
//  Created by 林镇杰 on 15/9/15.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "SettingViewController.h"
#import "CancelViewController.h"
#import "WebViewController.h"
#import "SettingCell.h"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *settingTab;
    NSArray *settingFirstArray;
    NSArray *settingSecondArray;
    NSArray *imgFirstArray;
    NSArray *imgSecongArray;
    
    BOOL isFirst;
}
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    self.view.backgroundColor = RGB(249, 250, 251);
    
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(0, 0, 50, 40);
//    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -25, 0.0, 0.0)];
//    [backBtn addTarget:self action:@selector(backToLastView) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *leftitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = leftitem;
    
    settingFirstArray = [NSArray arrayWithObjects:@"给专车好评",@"给我们提点建议", nil];
    settingSecondArray = [NSArray arrayWithObjects:@"使用帮助",@"联系我们",@"当前版本:", nil];
    imgFirstArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"emoticon_draygray"],[UIImage imageNamed:@"chat_darkgray"], nil];
    imgSecongArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"help_outline"],[UIImage imageNamed:@"call_darkgray"],[UIImage imageNamed:@"refresh"], nil];
    
    isFirst = YES;
    
    [self createView];
    
}

-(void)createView
{
    UIImageView *logoImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logoLX"]];
    
//    UILabel *appVersions = [UIFactory createLabel:@"丽新专车 V1.0" Font:[UIFont systemFontOfSize:10]];
    
    settingTab = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    settingTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    settingTab.delegate = self;
    settingTab.dataSource = self;
    settingTab.scrollEnabled = NO;
    [settingTab.layer setBorderWidth:0.5f];
    [settingTab.layer setBorderColor:RGB(181, 182, 183).CGColor];
    
    [self.view addSubview:logoImg];
//    [self.view addSubview:appVersions];
    [self.view addSubview:settingTab];
    
    [logoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(96);
        make.width.offset(MATCHSIZE(226));
        make.height.offset(MATCHSIZE(60));
    }];
    
//    [appVersions mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(logoImg.mas_bottom).offset(3);
//        make.centerX.equalTo(self.view);
//        make.height.mas_equalTo(@10);
//    }];
    
    [settingTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoImg.mas_bottom).offset(45);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(@410);
    }];
}

#pragma - mark UITableView DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 0;
        
    }else{
        return 10;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else{
        return 3;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSLog(@"%ld",(long)indexPath.row);
    if (isFirst) {
        cell.imageView.image = [imgFirstArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [settingFirstArray objectAtIndex:indexPath.row];
        if (indexPath.row == 1) {
            isFirst = NO;
        }
    }else{
        
        cell.imageView.image = [imgSecongArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [settingSecondArray objectAtIndex:indexPath.row];
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.showTopSeperateLine = YES;
    }else{
        cell.showTopSeperateLine = NO;
    }
    
    if (indexPath.section == 0 && indexPath.row == 1 ) {
        cell.isShow = @"show";
    }
    
    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
    return cell;
}

#pragma - mark UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"%ld-=-=%ld",(long)indexPath.row,(long)indexPath.section);
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            //给专车好评
            NSString *urlString = [NSString stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", @"1065404779"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            
        }else{
            //提建议
            CancelViewController *cancel = [[CancelViewController alloc]init];
            cancel.dateDic = [NSDictionary dictionaryWithObjectsAndKeys:@"反馈建议",Title_key,@"请填写您的问题和建议，我们将积极改进。",TextInput_key,@"提交",SubmitButton_key,@"",Question_key,nil,ButtonArray_key, nil];
            [self.navigationController pushViewController:cancel animated:YES];
        }
    }else if (indexPath.section ==1){
        
        if (indexPath.row == 0) {
            //使用帮助
            WebViewController *webView = [[WebViewController alloc]init];
            webView.webURL = USER_MANUAL_API;
            webView.title = @"使用帮助";
            [self.navigationController pushViewController:webView animated:YES];
            
        }else{
            //联系我们
            WebViewController *webView = [[WebViewController alloc]init];
            webView.webURL = CONTACT_APT;
            webView.title = @"联系我们";
            [self.navigationController pushViewController:webView animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
