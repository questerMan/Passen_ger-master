//
//  BookTypeController.m
//  DriverProject
//
//  Created by 林镇杰 on 15/9/20.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "BookTypeController.h"
#import "TypeCell.h"
#import "TypeModel.h"

#define COLOR_TITLE_NO        RGB(117,117,117)
#define COLOR_TITLE_YES       RGB(245,146,46)
#define TITLE_LABEL_FONT      [UIFont systemFontOfSize:14]

@interface BookTypeController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSMutableArray *imgArray;
    
    UITableView *typeTable;
    
    NSString *cellCelect;
    
    UILabel *timeLabel;
    
    UITextField *numberField;
    
    UIView *baView;
    
    UIView *pickerBgView;
    
    int selectRow;
    
    BOOL isClickTimeBtn;
}
@end

@implementation BookTypeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"预约类型";
    self.view.backgroundColor = RGB(249, 250, 251);
    
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(0, 0, 50, 40);
//    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -25, 0.0, 0.0)];
//    [backBtn addTarget:self action:@selector(backToLastView) forControlEvents:UIControlEventTouchUpInside];
//
//    UIBarButtonItem *leftitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = leftitem;
    
    cellCelect = @"NO";
    selectRow = 0;
    isClickTimeBtn = NO;
    _typeArray = [NSMutableArray array];
    _selectArray = [NSMutableArray array];
    [self createTheSelectView];
    [self createTheInputView];
    [self loadTheViewData];
    
}

-(void)createTheSelectView
{
    typeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, self.view.width, 184) style:UITableViewStylePlain];
    typeTable.delegate = self;
    typeTable.dataSource = self;
    typeTable.scrollEnabled = NO;
    [typeTable.layer setBorderWidth:0.5f];
    [typeTable.layer setBorderColor:COLOR_LINE.CGColor];
    [self.view addSubview:typeTable];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height - 60, self.view.width, 60)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderWidth = 0.5f;
    bgView.layer.borderColor = COLOR_LINE.CGColor;
    [self.view addSubview:bgView];
    
    UIButton *submitBtn = [UIFactory createButton:@"提交" BackgroundColor:kUIColorFromRGB(0xf4942d) andTitleColor:[UIColor whiteColor]];
    [submitBtn addTarget:self action:@selector(sumbitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:submitBtn];
    
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bgView).with.insets(UIEdgeInsetsMake(10, 15, 10, 15));
    }];
}

-(void)createTheInputView
{
    baView = [[UIView alloc]init];
    baView.backgroundColor = [UIColor whiteColor];
    [baView.layer setBorderWidth:0.5f];
    [baView.layer setBorderColor:COLOR_LINE.CGColor];
    
    [self.view addSubview:baView];
    
    [baView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(typeTable.mas_bottom).offset(10);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(@81);
    }];
    
    UIImageView *timeImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"access_time"]];
    timeLabel = [UIFactory createLabel:@"航班日期" Font:TITLE_LABEL_FONT];
    timeLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showTimePickerView)];
    [timeLabel addGestureRecognizer:tap];
    timeLabel.text = [NSString stringWithFormat:@"航班日期：%@",self.flightDate?:@""];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = COLOR_LINE;
    UIImageView *numberImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"flight_darkgray"]];
    UILabel *numberLabel = [UIFactory createLabel:@"航班号:" Font:TITLE_LABEL_FONT];
    numberField = [UIFactory createTextFieldWithFrame:CGRectZero ByDelegate:self];
    numberField.font = TITLE_LABEL_FONT;
    numberField.text = self.flightNum;
    
    [baView addSubview:timeImg];
    [baView addSubview:timeLabel];
    [baView addSubview:numberImg];
    [baView addSubview:numberLabel];
    [baView addSubview:line];
    [baView addSubview:numberField];
    
    
    //默认选择type行
    NSInteger row = (self.type - 2);
    NSInteger cell;
    switch (row) {
        case 0:
        {
            cell = 0;
             [baView setHidden:YES];
        }
            break;
        case 1:
        {
            cell = 2;
            [baView setHidden:NO];
        }
            break;
        case 2:
        {
            cell = 1;
             [baView setHidden:YES];
        }
            break;
            
        default:
            break;
    }
    NSIndexPath *indexPath = [NSIndexPath
                              indexPathForRow:cell inSection:0];
    [self tableView:typeTable didSelectRowAtIndexPath:indexPath];
    
    [timeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(baView).offset(10);
        make.top.equalTo(baView).offset(10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeImg.mas_right).offset(10);
        make.height.equalTo(timeImg);
        make.top.equalTo(timeImg);
        make.width.equalTo(baView.mas_width).multipliedBy(0.8f);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeLabel.mas_bottom).offset(10);
        make.centerX.equalTo(baView);
        make.width.mas_equalTo(baView.mas_width);
        make.height.mas_equalTo(@1);
    }];
    
    [numberImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(baView).offset(10);
        make.top.equalTo(line.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(numberImg.mas_right).offset(10);
        make.height.equalTo(numberImg);
        make.top.equalTo(numberImg);
        make.width.equalTo(baView.mas_width).multipliedBy(0.15f);
    }];
    
    [numberField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(numberLabel.mas_right);
        make.top.equalTo(numberLabel);
        make.height.equalTo(numberLabel);
        make.width.equalTo(baView.mas_width).multipliedBy(0.7f);
    }];
}

-(void)loadTheViewData
{
    NSDictionary *car = [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"directions_car"],@"logo",@"预约专车",@"title",@"NO",@"status", nil];
    NSDictionary *planeOut = [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"flight_takeoff_darkgray"],@"logo",@"送机",@"title",@"NO",@"status", nil];
    NSDictionary *planeCome = [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"flight_land_darkgray"],@"logo",@"接机",@"title",@"NO",@"status", nil];
    NSMutableArray *array = [NSMutableArray arrayWithObjects:car,planeOut,planeCome, nil];
    
    for (int i = 0; i < array.count; i ++) {
        
        TypeModel *typeModel = [[TypeModel alloc]initWithDataDic:[array objectAtIndex:i]];
        [_typeArray addObject:typeModel];
    }
    
    NSDictionary *carSelect = [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"directions_car_yellow"],@"logo",@"预约专车",@"title",@"YES",@"status", nil];
    NSDictionary *planeOutSelect = [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"flight_takeoff_yellow"],@"logo",@"送机",@"title",@"YES",@"status", nil];
    NSDictionary *planeComeSelect = [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"flight_land_yellow"],@"logo",@"接机",@"title",@"YES",@"status", nil];
    NSMutableArray *arraySelect = [NSMutableArray arrayWithObjects:carSelect,planeOutSelect,planeComeSelect, nil];
    
    for (int i = 0; i < arraySelect.count; i ++) {
        
        TypeModel *typeModel = [[TypeModel alloc]initWithDataDic:[arraySelect objectAtIndex:i]];
        [_selectArray addObject:typeModel];
    }
    
    [typeTable reloadData];
}

#pragma - mark UITableView DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _typeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    TypeCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[TypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.row == selectRow) {
        
        cell.typeModel = [_selectArray objectAtIndex:indexPath.row];
    }else{
        
        cell.typeModel = [_typeArray objectAtIndex:indexPath.row];
    }
    
    [cell setNeedsLayout];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectRow = (int)indexPath.row;
    [tableView reloadData];
    
    if (indexPath.row == 0) {
        baView.hidden = YES;
        self.type = OrderTypeBook;
    }else if(indexPath.row == 1){
        baView.hidden = YES;
        self.type = OrderTypeGive;
    }else if(indexPath.row == 2){
        self.type = OrderTypePick;
        baView.hidden = NO;
    }
 
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma - mark 航班时间选择
-(void)showTimePickerView
{
    [self.view endEditing:YES];
    if (isClickTimeBtn) {
        isClickTimeBtn = NO;
        [pickerBgView removeFromSuperview];
        return;
    }
    isClickTimeBtn = YES;
    pickerBgView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height - 250, self.view.width, 250)];
    pickerBgView.backgroundColor = [UIColor whiteColor];
    [pickerBgView.layer setBorderWidth:0.5f];
    [pickerBgView.layer setBorderColor:COLOR_LINE.CGColor];
    [self.view addSubview:pickerBgView];
    
    
    NSDate *date = [NSDate date];
    UIDatePicker *datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 50, pickerBgView.width, 216)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.minuteInterval = 5;
    datePicker.minimumDate = date;
    
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    [pickerBgView addSubview:datePicker];
    
    UIButton *sureBtn = [UIFactory createButton:@"确定" BackgroundColor:[UIColor clearColor] andTitleColor:kUIColorFromRGB(0xf4942d)];
    sureBtn.tag = 1122;
    [sureBtn addTarget:self action:@selector(pickerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [pickerBgView addSubview:sureBtn];
    
    UIButton *cancelBtn = [UIFactory createButton:@"取消" BackgroundColor:[UIColor clearColor] andTitleColor:kUIColorFromRGB(0xf4942d)];
    cancelBtn.tag = 3344;
    [cancelBtn addTarget:self action:@selector(pickerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [pickerBgView addSubview:cancelBtn];
    
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(pickerBgView.mas_right).offset(-10);
        make.top.equalTo(pickerBgView.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pickerBgView.mas_left).offset(10);
        make.top.equalTo(pickerBgView.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
}

-(void)pickerButtonAction:(UIButton *)sender
{
    if (sender.tag == 1122) {
        
        if (![self.flightDate isEqualToString:@""]) {
            if (self.flightDate == nil) {
                NSDateFormatter *matter = [[NSDateFormatter alloc]init];
                [matter setDateFormat:@"yyyy-MM-dd"];
                self.flightDate = [matter stringFromDate:[NSDate date]];
            }
            
            timeLabel.text = [NSString stringWithFormat:@"航班日期：%@",self.flightDate];
        }
        
    }
    [pickerBgView removeFromSuperview];
}

-(void)dateChanged:(id)sender
{
    UIDatePicker* control = (UIDatePicker*)sender;
    NSDate* _date = control.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    self.flightDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:_date]];
    self.flightDate = [self.flightDate substringToIndex:10];
    NSLog(@"self.flightDate:%@",self.flightDate);
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [pickerBgView removeFromSuperview];
}

-(void)sumbitButtonAction:(UIButton *)sender
{
    NSString *type;
    NSString *msg;
    
    switch (selectRow) {
        case 0:
            
            type = @"预约专车";
            self.flightDate = @"";
            numberField.text = @"";
            break;
            
        case 1:
            
            type = @"送机";
            self.flightDate = @"";
            numberField.text = @"";
            break;
        
        case 2:
            
            type = [NSString stringWithFormat:@"%@ %@ %@",@"接机",self.flightDate,numberField.text];
            
            if (self.flightDate == nil || self.flightDate.length == 0) {
                msg = @"请选择接机时间";
            }else if(numberField.text.length == 0){
                msg = @"请填写航班号";
            }
            
            if (msg.length) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:msg message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }

            break;
            
        default:
            break;
    }
  
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSString stringWithFormat:
                          @"%lu",(unsigned long)self.type],@"type",
                         self.flightDate,@"flightDate",
                         numberField.text,@"flightNum",nil];
    [self.bookTypeDelegate loadBookTypeDataWithType:type AndOther:dic];
    [self.navigationController popViewControllerAnimated:YES];
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
