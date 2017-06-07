//
//  ConfirmListView.m
//  ConfirmList
//
//  Created by 开涛 on 15/9/19.
//  Copyright (c) 2015年 com.LHW.Location. All rights reserved.
//

#import "ConfirmListView.h"
#define TITLE_LABEL_FONT        [UIFont systemFontOfSize:20]
#define ITEMS_LABEL_FONT        [UIFont systemFontOfSize:14]

@implementation ConfirmListView
{
    NSArray *_imagesNameCall;
    NSMutableArray *_titlesCall;
    NSArray *_imagesNameAppointment;
    NSMutableArray *_titlesAppointment;
    
    CGFloat   _cellHeight;
    CGFloat   _cellHearderHeight;
    NSInteger _cellTextFont;
    NSInteger _buttonTextFont;
    
    UIView *_tapView;
    UIView *_backView;
    ConfirmListViewType _confirType;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

-(void)tapViewResignFirstRespinder
{
    NSLog(@"点击背景弹回");
    CGRect bouns = [[UIScreen mainScreen] bounds];
    CGRect frameLater = CGRectMake(_backView.frame.origin.x, bouns.size.height, _backView.frame.size.width, _backView.frame.size.height);
    //_backView.frame = frameLater;
    [UIView animateWithDuration:0.3 animations:^{
        _backView.frame = frameLater;
        [_confirmDelegate tapViewResignFirstRespinderDelegate];
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
}

-(void)setBookTime:(NSString *)bookTime
{
    [_titlesAppointment replaceObjectAtIndex:0 withObject:bookTime];
    [_confirmTable reloadData];
}

-(void)setBookCar:(NSString *)bookCar
{
    [_titlesAppointment replaceObjectAtIndex:1 withObject:bookCar];
    [_confirmTable reloadData];
}

- (void)setPhoneNum:(NSString *)phoneNum
{
    [_titlesCall replaceObjectAtIndex:0 withObject:phoneNum];
    [_confirmTable reloadData];
}

- (void)setStartPoint:(NSString *)startPoint
{
    [_titlesCall replaceObjectAtIndex:1 withObject:startPoint];
    [_confirmTable reloadData];

}

-(void)setEndPoint:(NSString *)endPoint
{
    [_titlesCall replaceObjectAtIndex:2 withObject:endPoint];
    [_confirmTable reloadData];
}

- (void)setCost:(NSString *)cost
{
    [_titlesCall replaceObjectAtIndex:3 withObject:cost];
    [_confirmTable reloadData];
}


- (void)showConfirmView:(UIView *)view
{
    CGRect bouns = [[UIScreen mainScreen] bounds];
    CGRect frameBegin = _backView.frame;
    CGRect frameLater = CGRectMake(_backView.frame.origin.x, bouns.size.height, _backView.frame.size.width, _backView.frame.size.height);
    //    if ([UIApplication sharedApplication].keyWindow.rootViewController.navigationController) {
    //        [[UIApplication sharedApplication].keyWindow.rootViewController.navigationController.view addSubview:self];
    //    }else{
    //        [[UIApplication sharedApplication].keyWindow addSubview:self];
    //    }
    [view addSubview:self];
    _backView.frame = frameLater;
    [UIView animateWithDuration:0.5 animations:^{
        _backView.frame = frameBegin;
    }];
}

-(instancetype)initConfirmListViewWithType:(ConfirmListViewType)type showView:(UIView *)view
{
    CGRect bouns = [[UIScreen mainScreen] bounds];
    CGRect frame = CGRectMake(0, 0, bouns.size.width, bouns.size.height);
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:.6 alpha:.6];
        self.frame = frame;
        _tapView = [[UIView alloc]initWithFrame:frame];
        [self addSubview:_tapView];
        
        _titlesCall = [NSMutableArray arrayWithObjects:
                       @"本机号码",
                       @"起始位置",
                       @"终点位置",
                       @"预估费用",nil];
        _imagesNameCall = [NSArray arrayWithObjects:
                           [UIImage imageNamed:@"call_darkgray"],
                           [UIImage imageNamed:@"start"],
                           [UIImage imageNamed:@"pin_drop"],
                           [UIImage imageNamed:@"money_darkgray"],nil];
       
        _confirType = type;
        
        switch (type) {
            case ConfirmListViewType_call:
            {
                
            }
                break;
            case ConfirmListViewType_appointment:
            {
                _imagesNameAppointment = [NSArray arrayWithObjects:
                                          [UIImage imageNamed:@"access_time"],
                                          [UIImage imageNamed:@"directions_car"],nil];
                
                _titlesAppointment = [NSMutableArray arrayWithObjects:
                                      @"预约时间",
                                      @"预约用车",nil];
            }
                break;
                
            default:
                break;
        }
        
        [self drawView:frame];
        [self showConfirmView:view];
        
        //添加点击界面
        UITapGestureRecognizer *tapViewRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapViewResignFirstRespinder)];
        [_tapView addGestureRecognizer:tapViewRecognizer];
    }
    return self;
}

-(void)drawView:(CGRect)frame
{
    NSLog(@"%@",[UIFactory deviceString]);
    
    CGFloat labelH      = 60; //确认信息高度
    CGFloat sureViewH   = 70; //按钮界面高度
    CGFloat originY     = 0;
    CGFloat height      = 0;
    CGFloat tableH      = 0;
    
    _cellHeight = 40; //cell高度
    _cellHearderHeight = 10; //cell头高度
    
    NSString *title;
    
    UIColor *bgColor = [UIColor whiteColor];
    
    switch (_confirType) {
        case ConfirmListViewType_call:
        {
            tableH  = _titlesCall.count *_cellHeight;
            height = labelH + sureViewH  + tableH + 3*_cellHearderHeight;
            title = @"呼叫专车";
        }
            break;
        case ConfirmListViewType_appointment:
        {
            tableH  = (_titlesCall.count+_titlesAppointment.count)*_cellHeight + _cellHearderHeight*2;
             height = labelH + sureViewH + tableH + _cellHeight;
             title = @"预约专车";
        }
            break;
            
        default:
            break;
    }
    originY = frame.size.height - height;
    
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, originY, frame.size.width, height)];
    _backView.backgroundColor = BG_COLOR_VIEW;
    [self addSubview:_backView];
    
    //确认字样
    UILabel *sureLable = [UIFactory createLabel:@"确认信息" Font:TITLE_LABEL_FONT];
    sureLable.textAlignment = NSTextAlignmentCenter;
    sureLable.backgroundColor = bgColor;
    [sureLable.layer setBorderWidth:0.5f];
    [sureLable.layer setBorderColor:COLOR_LINE.CGColor];
    [_backView addSubview:sureLable];
    
    [sureLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backView);
        make.top.equalTo(_backView);
        make.right.equalTo(_backView);
        make.height.mas_equalTo(labelH);
    }];
    
    //table
    _confirmTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _confirmTable.dataSource = self;
    _confirmTable.delegate   = self;
    _confirmTable.scrollEnabled = NO;
    [_confirmTable.layer setBorderWidth:0.5f];
    [_confirmTable.layer setBorderColor:COLOR_LINE.CGColor];
    _confirmTable.backgroundColor = bgColor;
    [_backView addSubview:_confirmTable];
    
    [_confirmTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sureLable.mas_bottom).offset(10);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(tableH);
    }];
    
    //buttonView
    UIView *sureView = [[UIView alloc]initWithFrame:CGRectMake(0, _backView.height - sureViewH, _backView.width, sureViewH)];
    [sureView.layer setBorderWidth:0.5f];
    [sureView.layer setBorderColor:COLOR_LINE.CGColor];
    sureView.backgroundColor = bgColor;
    [_backView addSubview:sureView];
    
    UIButton *sureButton  = [UIFactory createButton:title BackgroundColor:kUIColorFromRGB(0x3ab48f) andTitleColor:bgColor];
    if (_confirType == ConfirmListViewType_appointment) {
        [sureButton setBackgroundColor:kUIColorFromRGB(0xf4942d)];
    }
    
    [sureButton addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
    [sureView addSubview:sureButton];
    
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(sureView).with.insets(UIEdgeInsetsMake(10, 15, 10, 15));
    }];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

//高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = _cellHearderHeight;
    switch (_confirType) {
        case ConfirmListViewType_call:
                height = 0;
                break;
            
        case ConfirmListViewType_appointment:
            switch (section) {
                case 0:
                    height = 0;
                    break;
                    
                default:
                    break;
            }
            break;
        default:
            break;
    }

    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat height = 10;
    
    switch (_confirType) {
        case ConfirmListViewType_call:
            height = 0;
            break;
            
        case ConfirmListViewType_appointment:
            switch (section) {
                case 1:
                    height = 0;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    return height;
}

//组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

//每组个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count;
    switch (_confirType) {
        case ConfirmListViewType_call:
            switch (section) {
                case 0:
                    count = 0;
                    break;
                case 1:
                    count = _titlesCall.count;
                    break;
                default:
                    break;
            }
            
            break;
            
        case ConfirmListViewType_appointment:
            switch (section) {
                case 0:
                    count = _titlesAppointment.count;
                    break;
                case 1:
                    count = _titlesCall.count;
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    return count;
}

//cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"adlistTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    UIImage *icon;
    NSString *title;
    switch (_confirType) {
        case ConfirmListViewType_call:
        {
            switch ([indexPath section]) {
                case 0:
                {
                    icon  = nil;
                    title = @"";
                }
                    break;
                case 1:
                {
                    icon  = [_imagesNameCall objectAtIndex:[indexPath row]];
                    title = [_titlesCall objectAtIndex:[indexPath row]];
                }
                    break;
                default:
                    break;
            }
        }
            break;
            
        case ConfirmListViewType_appointment:
        {
            switch ([indexPath section]) {
                case 0:
                {
                    icon  = [_imagesNameAppointment objectAtIndex:[indexPath row]];
                    title = [_titlesAppointment objectAtIndex:[indexPath row]];
                    
                    if ([indexPath row] == 1) {
                        [self addLine:cell above:NO];
                    }
                }
                    break;
                case 1:
                {
                    icon  = [_imagesNameCall objectAtIndex:[indexPath row]];
                    title = [_titlesCall objectAtIndex:[indexPath row]];
                    if ([indexPath row] == 0) {
                        [self addLine:cell above:YES];
                    }
                    
                }
                    break;
                default:
                    break;
            }
            
        }
            break;
            
        default:
            break;
    }
    cell.imageView.image = icon;
    cell.textLabel.text  = title;
    cell.textLabel.font  = ITEMS_LABEL_FONT;
    cell.accessoryType   = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}
//选中
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //传出自己想要的数据
    [self.confirmDelegate didSelectRowAtSection:[indexPath section] andRow:[indexPath row] data:nil];
}

//加一根线
-(void)addLine:(UIView *)view above:(BOOL)above
{
    CGFloat y;
    if (above) {
        y = 0;
    }else{
        y = view.bounds.size.height-4.5;
    }
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, y, self.frame.size.width, 0.8)];
    line.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [view addSubview:line];
}

- (void)clickButton
{
    //传出自己想要的数据
    [self.confirmDelegate buttonClickDelegate:nil viewType:_confirType];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
