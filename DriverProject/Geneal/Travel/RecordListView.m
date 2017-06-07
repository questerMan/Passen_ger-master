//
//  RecordListView.m
//  DriverProject
//
//  Created by 林镇杰 on 15/9/6.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "RecordListView.h"
#import "RecordViewCell.h"
#import "CancelViewController.h"
#import "RecordModel.h"
#import "TravelDetailsController.h"
#import "MJRefresh.h"
#import "BlankPage.h"
#import "PaySuccessController.h"
#import "OrderModel.h"
#import "OrderViewController.h"

#define PER_PAGE            @"10"
@interface RecordListView ()<BlankPageDelegate,UIAlertViewDelegate>
{
    UITableView *recordTable;
    NSMutableArray *sendArray;
    NSMutableDictionary *orderDic;
    int page;
    BOOL isMore;
}

@property(nonatomic, assign)NSInteger flag;

@property(nonatomic, strong)BlankPage *blankPage;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation RecordListView

-(void)viewWillAppear:(BOOL)animated
{
   
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"行程记录";
    self.view.backgroundColor = RGB(249, 250, 251);
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(0, 0, 50, 40);
//    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -25, 0.0, 0.0)];
//    [backBtn addTarget:self action:@selector(backToLastView) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = item;
   
    [self createRecordTableView];
    
    self.recordArray = [NSMutableArray array];
    self.recordListArray = [NSMutableArray array];
    orderDic = [NSMutableDictionary dictionary];
    page = 1;
    [self loadRecordDataWithPage:page];
}

-(void)createRecordTableView
{
    recordTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStylePlain];
    recordTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    recordTable.tableFooterView = [[UIView alloc]init];
    recordTable.separatorInset = UIEdgeInsetsZero;
    recordTable.dataSource = self;
    recordTable.delegate = self;
    [self.view addSubview:recordTable];
    
    __weak UITableView *tableView = recordTable;
    
    // 下拉刷新
    tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        page = 1;
        isMore = NO;
        
        [self loadRecordDataWithPage:page];
        // 结束刷新
        [tableView.header endRefreshing];
        [tableView reloadData];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.header.automaticallyChangeAlpha = YES;
    
    // 上拉加载
    tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        page = page + 1;
        isMore = YES;
        
        [self loadRecordDataWithPage:page];
        // 结束刷新
        [tableView.footer endRefreshing];
        [tableView reloadData];
    }];
}

#pragma - mark BlankPageDelegate
-(void)loadDataAgain
{
    [self loadRecordDataWithPage:page];
}

-(void)loadRecordDataWithPage:(int)page_number
{
    QiFacade *facade;
    facade = [QiFacade sharedInstance];
    _flag = [facade getOrder:[NSString stringWithFormat:@"%d",page_number] Per_page:PER_PAGE];
    [facade addHttpObserver:self tag:_flag];
//    [self showLoadingWithText:@"Loading..."];
}

-(void)loadRecordDataFinish:(NSDictionary *)dataDic
{
    
    NSArray *content = [dataDic objectForKey:@"content"];
    
    if (isMore) {
        if (content.count == 0) {
            
            [self showTextOnlyWith:@"已没有更多记录"];
            
            return;
        }
    }else{
        
        if (content.count == 0) {
            
            [recordTable removeFromSuperview];
            
            self.blankPage = [[BlankPage alloc]initBlankPageFrame:CGRectMake(0, 100, self.view.width, 200) WithImg:[UIImage imageNamed:@"recordIcon"] AndTips:@"暂无行程记录"];
            _blankPage.blankPageDelegate = self;
            [self.view addSubview:_blankPage];
            
            return;
        
        }
    }
    
    NSMutableArray *untreatedArray = [NSMutableArray arrayWithCapacity:content.count];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:content.count];
    
    for (int i = 0; i < content.count; i ++) {
        
        NSDictionary *info = [content objectAtIndex:i];
        [untreatedArray addObject:info];
        RecordModel *recordModel = [[RecordModel alloc]initWithDataDic:info];
        [array addObject:recordModel];
    }
    
    if (isMore) {
        
        [self.recordArray addObjectsFromArray:untreatedArray];
        [self.recordListArray addObjectsFromArray:array];
        
    }else{
        
        self.recordArray = untreatedArray;
        self.recordListArray = array;
    }
        
    [recordTable reloadData];
}

#pragma - mark 网络请求回调
-(void)requestFinished:(NSDictionary *)response tag:(NSInteger)iRequestTag
{
    [self dismissLoading];
    
    NSLog(@"成功\n%@",response);
    
    if (_flag != 0 && response != nil && iRequestTag == _flag) {
        
        _flag = 0;
        
        [self loadRecordDataFinish:response];
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

#pragma - mark UITableView Delegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorInset = UIEdgeInsetsZero;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    CancelViewController *cancel = [[CancelViewController alloc]init];
//    NSArray *buttonArray = [NSArray arrayWithObjects:@"我改变行程，暂时不需要用车",@"司机告诉我需要等很久",@"司机无法来接我",@"我选择了别的出行方式", nil];
//    cancel.dateDic = [NSDictionary dictionaryWithObjectsAndKeys:@"取消原因",Title_key,@"请告诉我们您取消的原因，我们会不断改进！",Question_key,buttonArray,ButtonArray_key,@"填写其他原因",TextInput_key,@"确定取消",SubmitButton_key, nil];
    
//    NSArray *buttonArray = [NSArray arrayWithObjects:@"服务态度恶劣",@"司机迟到",@"绕路行驶",@"骚扰客人", nil];
//    cancel.dateDic = [NSDictionary dictionaryWithObjectsAndKeys:@"投诉",Title_key,@"用车过程中遇到什么问题？",Question_key,buttonArray,ButtonArray_key,@"在这里输入对司机评价",TextInput_key,@"提交",SubmitButton_key, nil];

//    cancel.dateDic = [NSDictionary dictionaryWithObjectsAndKeys:@"反馈建议",Title_key,@"请填写您的问题和建议，我们将积极改进。",TextInput_key,@"提交",SubmitButton_key,@"",Question_key,nil,ButtonArray_key, nil];
//    [self.navigationController pushViewController:cancel animated:YES];
    if ([[[self.recordArray objectAtIndex:indexPath.row]objectForKey:@"is_canceld"]intValue] == 1) {
        
        TravelDetailsController *travel = [[TravelDetailsController alloc]init];
        travel.detailDic = [self.recordArray objectAtIndex:indexPath.row];
        travel.isBook = NO;
        [self.navigationController pushViewController:travel animated:YES];
        
    }else{
        
        if ([[[self.recordArray objectAtIndex:indexPath.row]objectForKey:@"status"] intValue] == ORDER_STATUS_H) {
            PaySuccessController *paySuccess = [[PaySuccessController alloc]init];
            paySuccess.orderNum = [[self.recordArray objectAtIndex:indexPath.row]objectForKey:@"id"];
            [self.navigationController pushViewController:paySuccess animated:YES];
            
        }else if ([[[self.recordArray objectAtIndex:indexPath.row]objectForKey:@"status"] intValue] == ORDER_STATUS_C || [[[self.recordArray objectAtIndex:indexPath.row]objectForKey:@"status"] intValue] == ORDER_STATUS_D || [[[self.recordArray objectAtIndex:indexPath.row]objectForKey:@"status"] intValue] == ORDER_STATUS_E || [[[self.recordArray objectAtIndex:indexPath.row]objectForKey:@"status"] intValue] == ORDER_STATUS_G){
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否前往进行中的订单" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"前往", nil];
            [alertView show];
            
            [orderDic setValuesForKeysWithDictionary:[self.recordArray objectAtIndex:indexPath.row]];
            
        }else{
            
            TravelDetailsController *travel = [[TravelDetailsController alloc]init];
            travel.detailDic = [self.recordArray objectAtIndex:indexPath.row];
            travel.isBook = NO;
            travel.delegate = self;
            [self.navigationController pushViewController:travel animated:YES];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)refreshRecoedListView{
    [self loadRecordDataWithPage:1];
    [recordTable reloadData];
}

#pragma - mark UITableView DataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recordArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    RecordViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[RecordViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.recordModel = [self.recordListArray objectAtIndex:indexPath.row];
    
//    [cell setNeedsLayout];
    return cell;
}

#pragma - mark UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        OrderViewController *order = [[OrderViewController alloc]init];
        OrderModel *orderModel = [[OrderModel alloc]init];
        orderModel.orderState = [[orderDic objectForKey:@"status"] integerValue];//状态
        orderModel.orderID = [orderDic objectForKey:@"id"];//id
        orderModel.newOrder = NO;
        order.ordermodel = orderModel;
        [self.navigationController pushViewController:order animated:YES];
        
    }
    
    [orderDic removeAllObjects];
}

-(void)backToLastView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
