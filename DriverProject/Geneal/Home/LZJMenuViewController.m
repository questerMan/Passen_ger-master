//
//  LZJMenuViewController.m
//  DriverProject
//
//  Created by 林镇杰 on 15/9/6.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "LZJMenuViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "LZJNavigationController.h"
#import "HomeViewController.h"
#import "MenuCell.h"
#import "RecordListView.h"
#import "SettingViewController.h"
#import "UserInfoController.h"
#import "CouponViewController.h"
#import "InvoiceViewController.h"
#import "AccountBalanceController.h"
#import "newLoginViewController.h"

@interface LZJMenuViewController ()<UIAlertViewDelegate>
{
    HomeViewController *home;
    
    BOOL isLogin;
    UILabel *nameLabel;
}

@end

@implementation LZJMenuViewController

-(void)viewWillAppear:(BOOL)animated
{
    
    [home.confirmListView tapViewResignFirstRespinder];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    home = [[HomeViewController alloc] init];
    LZJNavigationController *navigation = [[LZJNavigationController alloc] initWithRootViewController: home];
    self.frostedViewController.contentViewController = navigation;
    
    self.tableView.separatorColor = [UIColor lightGrayColor];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 40, self.view.width, 100)];
//      [view.layer setBorderWidth:0.5f];
//      [view.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        view.backgroundColor = [UIColor whiteColor];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 30, 60, 60)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        imageView.image = [UIImage imageNamed:@"account"];
        
        nameLabel = [[UILabel alloc] initWithFrame: CGRectZero];
        nameLabel.numberOfLines = 0;
        nameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = [UIColor darkGrayColor];
        [nameLabel sizeToFit];
        nameLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        if (![[UIFactory getNSUserDefaultsDataWithKey:@"nickname"] isEqual:NULL_DATA]) {
            
            isLogin = YES;
            
            nameLabel.text = [NSString stringWithFormat:@"%@\n%@",[UIFactory getNSUserDefaultsDataWithKey:@"nickname"],[UIFactory getNSUserDefaultsDataWithKey:@"phone"]];
            
        }else{
            
            isLogin = NO;
            
            nameLabel.text = @"尚未登录\n请点击登录";
            
        }
        
        UIImageView *tips = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightbutton"]];
        
        [view addSubview:imageView];
        [view addSubview:nameLabel];
        [view addSubview:tips];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right);
            make.top.equalTo(imageView.mas_top).offset(5);
            make.bottom.equalTo(imageView.mas_bottom).offset(-5);
            make.right.equalTo(tips.mas_left);
        }];
        
        [tips mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view).offset(-5);
            make.centerY.equalTo(nameLabel);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userDataButtonAction:)];
        [view addGestureRecognizer:tap];
        view;
    });

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationSuccessAction:) name:NOTIFICATION_LOGIN_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationFailureAction:) name:NOTIFICATION_LOGIN_FAILURE object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationSuccessAction:) name:NOTIFICATION_USER_DATA_CHANGE object:nil];
}

#pragma - mark User Data
-(void)userDataButtonAction:(id)object
{
    NSLog(@"nikename:%@",[UIFactory getNSUserDefaultsDataWithKey:@"nickname"]);
    if (![[UIFactory getNSUserDefaultsDataWithKey:@"nickname"] isEqualToString:NULL_DATA]) {
        
        UserInfoController *info = [[UserInfoController alloc] init];
        [home.navigationController pushViewController:info animated:YES];
    }else{
        
        if ([[UIFactory getNSUserDefaultsDataWithKey:@"nickname"] isEqualToString:NULL_DATA]) {
            newLoginViewController *login = [[newLoginViewController alloc]init];
            [home.navigationController pushViewController:login animated:YES];
        }else if (![UIFactory isLoginOrNot]) {
            
            [self.frostedViewController hideMenuViewController];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您尚未登录您的帐号，您是想现在登录吗？" delegate:self cancelButtonTitle:@"暂不登录" otherButtonTitles:@"登录", nil];
            [alert show];
            
        }
    }
    [self.frostedViewController hideMenuViewController];
}

#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (![UIFactory isLoginOrNot] && indexPath.row != 4) {
        
        [self.frostedViewController hideMenuViewController];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您尚未登录您的帐号，您是想现在登录吗？" delegate:self cancelButtonTitle:@"暂不登录" otherButtonTitles:@"登录", nil];
        [alert show];
        
        return;
    }
    if (indexPath.row == 0) {
        
        //行程记录
        RecordListView *record = [[RecordListView alloc] init];
        [home.navigationController pushViewController:record animated:YES];
        
    }else if (indexPath.row == 1){
        
        //账户余额
        AccountBalanceController *account = [[AccountBalanceController alloc]init];
        [home.navigationController pushViewController:account animated:YES];

    }else if (indexPath.row == 2){
        
        //优惠券
        CouponViewController *coupon = [[CouponViewController alloc]init];
        [home.navigationController pushViewController:coupon animated:YES];
        
    }else if (indexPath.row == 3){
        
        //发票
        InvoiceViewController *invoice = [[InvoiceViewController alloc]init];
        [home.navigationController pushViewController:invoice animated:YES];
        
    }else if (indexPath.row == 4){
        
        //设置
        SettingViewController *setting = [[SettingViewController alloc]init];
        [home.navigationController pushViewController:setting animated:YES];
    }
    
    [self.frostedViewController hideMenuViewController];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"-=-=%ld\n=-=-%@",(long)indexPath.row,[UIFactory getNSUserDefaultsDataWithKey:@"company"]);
    if (indexPath.row == 1) {
        if (isLogin) {
            if ([UIFactory isCompany]) {
                return 50;
            }else{
                return 0;
            }
        }else{
            
            return 0;
        }
        
    }
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";

    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[MenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.row == 0) {
        cell.showTopSeperateLine = YES;
    }else{
        cell.showTopSeperateLine = NO;
    }
    
    NSArray *titles = @[@"行程记录", @"账户余额", @"优惠券",@"发票",@"设置"];
    NSArray *titleImage = [NSArray arrayWithObjects:[UIImage imageNamed:@"record"],[UIImage imageNamed:@"amount"],[UIImage imageNamed:@"coupon"],[UIImage imageNamed:@"invoice"],[UIImage imageNamed:@"setting"], nil];
    
    if (indexPath.row == 1) {
        if ([UIFactory isCompany]) {
            
            cell.titleLabel.text = titles[indexPath.row];
//            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
            cell.titleImage.image = [titleImage objectAtIndex:indexPath.row];
        }else{
            
            cell.titleLabel.text = @" ";
//            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
            cell.titleImage.image = nil;
        }
    }else{
        cell.titleLabel.text = titles[indexPath.row];
//        cell.textLabel.font = [UIFont systemFontOfSize:15];//[UIFont fontWithName:@"HelveticaNeue" size:15];
        cell.titleImage.image = [titleImage objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}

-(void)notificationSuccessAction:(NSNotification *)notification
{
    isLogin = YES;
    nameLabel.text = [NSString stringWithFormat:@"%@\n%@",[UIFactory getNSUserDefaultsDataWithKey:@"nickname"],[UIFactory getNSUserDefaultsDataWithKey:@"phone"]];
    [self.tableView reloadData];
}

- (void)notificationFailureAction:(NSNotification *)notification
{
    isLogin = NO;
    
    nameLabel.text = @"尚未登录\n请点击登录";
    
    [self.tableView reloadData];
    NSString *str = [NSString stringWithFormat:@"%@",notification.object];
    if ([str isEqualToString:@"102"]) {
        [home.navigationController popViewControllerAnimated:NO];
        [self.frostedViewController hideMenuViewController];
        
        if (![home.navigationController.topViewController isKindOfClass:[newLoginViewController class]]) {
            newLoginViewController *login = [[newLoginViewController alloc] init];
            [home.navigationController pushViewController:login animated:YES];
        }
    }
}

#pragma - mark UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        newLoginViewController *login = [[newLoginViewController alloc] init];
        [home.navigationController pushViewController:login animated:YES];
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_LOGIN_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_LOGIN_FAILURE object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
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
