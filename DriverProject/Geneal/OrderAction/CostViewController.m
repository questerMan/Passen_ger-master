//
//  CostViewController.m
//  DriverProject
//
//  Created by 林镇杰 on 15/9/21.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "CostViewController.h"


#define LABEL_FONT              [UIFont systemFontOfSize:12]
#define LABEL_RESULT_FONT       [UIFont systemFontOfSize:16]

@interface CostViewController ()<AMapSearchDelegate>
{
    UIView *typeBg;
    //UIButton *cheapBtn;
    UIButton *comfortBtn;
    UIButton *businessBtn;
    
    //UILabel *cheapLabel;
    UILabel *comfortLabel;
    UILabel *businessLabel;
    
    UILabel *priceLabel;
    UILabel *typeLabel;
    UILabel *journeyLabel;
    UILabel *couponCost;
    
    NSMutableString *typeString;
    NSString *journeyString;
    
    NSArray  *_cartypes;
    NSInteger _flagCost;
    NSInteger _selectType;
    //临时保存三种价格

}
@end

@implementation CostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"费用预估";
    self.view.backgroundColor = RGB(249, 250, 251);
    
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(0, 0, 50, 40);
//    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -25, 0.0, 0.0)];
//    [backBtn addTarget:self action:@selector(backToLastView) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *leftitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = leftitem;
    
    if (self.rideModel.distance  && self.rideModel.time) {
       journeyString = [NSString stringWithFormat:@"约%@公里/%@分钟",self.rideModel.distance,self.rideModel.time];
    }else{
        journeyString = [NSString stringWithFormat:@"约0公里/0分钟"];
    }
    
    _cartypes = [UIFactory getNSUserDefaultsDataWithKey:@"carTypes"];
    
    _selectType = [self.rideModel.carType integerValue];
    
    typeString = [NSMutableString stringWithFormat:@"元（%@）",[_cartypes objectAtIndex:_selectType - 1][@"name"]];
    
    
    
    
//    switch (_selectType) {
//            
//        case 1:
//            typeString = [NSMutableString stringWithFormat:@"元（经济型）"];
//            break;
//            
//        case 2:
//            
//            typeString = [NSMutableString stringWithFormat:@"元（舒适型）"];
//            break;
//            
//        case 3:
//            
//            typeString = [NSMutableString stringWithFormat:@"元（商务型）"];
//            break;
//        case 4:
//            
//            typeString = [NSMutableString stringWithFormat:@"元（豪华型）"];
//            break;
//            
//        default:
//            typeString = [NSMutableString stringWithFormat:@"元"];
//
//            break;
//    }
    
    [self createCarTypeSelectView];
    
    //配置用户Key
    //[AMapSearchServices sharedServices].apiKey = MAPAPIKEY;
    
    //如果没有费用
    if (self.rideModel.cost || ([self.rideModel.cost floatValue] == 0)) {
        
        [self computationalCostWithType];
    }
}


-(void)createCarTypeSelectView
{
    typeBg = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, 100)];
    typeBg.backgroundColor = [UIColor whiteColor];
    typeBg.layer.borderWidth = 0.5f;
    typeBg.layer.borderColor = COLOR_LINE.CGColor;
    [self.view addSubview:typeBg];
    
    _cartypes = [UIFactory getNSUserDefaultsDataWithKey:@"carTypes"];
    NSLog(@"_cartypes:%@",_cartypes);
    for (int i = 0 ; i < _cartypes.count; i++) {
        int tag = [[[_cartypes objectAtIndex:i]objectForKey:@"type"] intValue];
        NSString *name = [[_cartypes objectAtIndex:i] objectForKey:@"name"];
        float spacing = self.view.frame.size.width/(_cartypes.count*2+1);
        float width = spacing+13;
        UIButton *cheapBtn = [UIFactory createTheCircleViewWithBorderColor:kUIColorFromRGB(0xf4942d) AndBorderWidth:0.5 WithTarget:self AndAction:@selector(selectCarTypeByView:) ByTag:tag];
        cheapBtn.frame = CGRectMake(spacing*(2*i+1), 10, width, width);
        cheapBtn.center = CGPointMake(cheapBtn.center.x, typeBg.frame.size.height/2);
        UILabel *cheapLabel = [UIFactory createLabel:name Font:LABEL_FONT];
        cheapBtn.layer.cornerRadius = width/2;
        cheapLabel.textColor = COLOR_ORANGE;
        cheapLabel.textAlignment = NSTextAlignmentCenter;
        cheapLabel.font = [UIFont systemFontOfSize:10];
        cheapLabel.adjustsFontSizeToFitWidth = YES;
        cheapLabel.tag = 100;
        UIImageView *cheapImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"directions_car"]];
        cheapImg.tag = 200;
        [typeBg addSubview:cheapBtn];
        [cheapBtn addSubview:cheapLabel];
        [cheapBtn addSubview:cheapImg];
        if (tag == _selectType) {
            [cheapImg setImage:[UIImage imageNamed:@"directions_car_yellow"]];
        }else{
            cheapBtn.layer.borderColor = [[UIColor grayColor]CGColor];
            cheapLabel.textColor = [UIColor grayColor];
        }
        [cheapImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(cheapBtn);
            make.top.equalTo(cheapBtn.mas_top).offset(0);
            make.size.mas_equalTo(CGSizeMake(cheapBtn.size.width -20, cheapBtn.size.height-20));
        }];
        
        [cheapLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cheapImg.mas_bottom).offset(-3);
            make.centerX.equalTo(cheapBtn);
            make.size.mas_equalTo(CGSizeMake(40, 15));
        }];
        
        
    }
//    cheapBtn = [UIFactory createTheCircleViewWithBorderColor:COLOR_ORANGE AndBorderWidth:0.5 WithTarget:self AndAction:@selector(selectCarTypeByView:) ByTag:1];
//    cheapLabel = [UIFactory createLabel:@"经济型" Font:LABEL_FONT];
//    cheapLabel.textColor = COLOR_ORANGE;
//    cheapLabel.textAlignment = NSTextAlignmentCenter;
//    UIImageView *cheapImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"directions_car_yellow"]];
//    [typeBg addSubview:cheapBtn];
//    [cheapBtn addSubview:cheapLabel];
//    [cheapBtn addSubview:cheapImg];
//    
//    comfortBtn = [UIFactory createTheCircleViewWithBorderColor:COLOR_LINE AndBorderWidth:0.5 WithTarget:self AndAction:@selector(selectCarTypeByView:) ByTag:2];
//    comfortLabel = [UIFactory createLabel:@"舒适型" Font:LABEL_FONT];
//    comfortLabel.textColor = [UIColor lightGrayColor];
//    comfortLabel.textAlignment = NSTextAlignmentCenter;
//    UIImageView *comfortImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"directions_car_yellow"]];
//    [typeBg addSubview:comfortBtn];
//    [comfortBtn addSubview:comfortLabel];
//    [comfortBtn addSubview:comfortImg];
//    
//    businessBtn = [UIFactory createTheCircleViewWithBorderColor:COLOR_LINE AndBorderWidth:0.5 WithTarget:self AndAction:@selector(selectCarTypeByView:) ByTag:3];
//    businessLabel = [UIFactory createLabel:@"商务型" Font:LABEL_FONT];
//    businessLabel.textColor = [UIColor lightGrayColor];
//    businessLabel.textAlignment = NSTextAlignmentCenter;
//    UIImageView *businessImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"directions_car_yellow"]];
//    [typeBg addSubview:businessBtn];
//    [businessBtn addSubview:businessLabel];
//    [businessBtn addSubview:businessImg];
//    
//    [comfortBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(typeBg);
//        make.height.equalTo(typeBg.mas_height).multipliedBy(0.6f);
//        make.width.equalTo(typeBg.mas_height).multipliedBy(0.6f);
//    }];
//    
//    [cheapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(comfortBtn.mas_left).offset(-50);
//        make.height.equalTo(comfortBtn);
//        make.width.equalTo(comfortBtn);
//        make.centerY.equalTo(typeBg);
//    }];
//    
//    [businessBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(comfortBtn.mas_right).offset(50);
//        make.height.equalTo(comfortBtn);
//        make.width.equalTo(comfortBtn);
//        make.centerY.equalTo(typeBg);
//    }];
//    
//    [cheapImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(cheapBtn);
//        make.top.equalTo(cheapBtn.mas_top).offset(5);
//        make.size.mas_equalTo(CGSizeMake(30, 30));
//    }];
//    
//    [comfortImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(comfortBtn);
//        make.top.equalTo(comfortBtn.mas_top).offset(5);
//        make.size.mas_equalTo(CGSizeMake(30, 30));
//    }];
//    
//    [businessImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(businessBtn);
//        make.top.equalTo(businessBtn.mas_top).offset(5);
//        make.size.mas_equalTo(CGSizeMake(30, 30));
//    }];
//    
//    [cheapLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(cheapImg.mas_bottom);
//        make.centerX.equalTo(cheapBtn);
//        make.size.mas_equalTo(CGSizeMake(40, 15));
//    }];
//    
//    [comfortLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(comfortImg.mas_bottom);
//        make.centerX.equalTo(comfortBtn);
//        make.size.mas_equalTo(CGSizeMake(40, 15));
//    }];
//    
//    [businessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(businessImg.mas_bottom);
//        make.centerX.equalTo(businessBtn);
//        make.size.mas_equalTo(CGSizeMake(40, 15));
//    }];
    
    [self createResultView];
}

-(void)createResultView
{
    UIView *resultView = [[UIView alloc]initWithFrame:CGRectMake(0, 174, self.view.width, 120)];
    resultView.backgroundColor = [UIColor whiteColor];
    resultView.layer.borderWidth = 0.5f;
    resultView.layer.borderColor = COLOR_LINE.CGColor;
    [self.view addSubview:resultView];
    
    UILabel *yugu = [UIFactory createLabel:@"预估" Font:LABEL_RESULT_FONT];
    yugu.textAlignment = NSTextAlignmentRight;
    
    priceLabel = [UIFactory createLabel:(self.rideModel.cost?:(@"0")) Font:[UIFont systemFontOfSize:27]];
    priceLabel.textColor = kUIColorFromRGB(0xf4942d);
    priceLabel.textAlignment = NSTextAlignmentCenter;
    
    typeLabel = [UIFactory createLabel:typeString Font:LABEL_RESULT_FONT];
    
    journeyLabel = [UIFactory createLabel:journeyString Font:LABEL_FONT];
    journeyLabel.textColor = [UIColor lightGrayColor];
    journeyLabel.textAlignment = NSTextAlignmentCenter;
    
    UIView *line = [UIFactory createLineView];
    
    UILabel *couponLabel = [UIFactory createLabel:@"优惠券已抵扣" Font:[UIFont systemFontOfSize:14]];
    
    couponCost = [UIFactory createLabel:[NSString stringWithFormat:@"%@元",(self.rideModel.preferential?:@"0")] Font:[UIFont systemFontOfSize:14]];
    couponCost.textAlignment = NSTextAlignmentRight;

    [resultView addSubview:yugu];
    [resultView addSubview:priceLabel];
    [resultView addSubview:typeLabel];
    [resultView addSubview:journeyLabel];
    [resultView addSubview:line];
    [resultView addSubview:couponLabel];
    [resultView addSubview:couponCost];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height - 60, self.view.width, 60)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderWidth = 0.5f;
    bgView.layer.borderColor = COLOR_LINE.CGColor;
    
    UIButton *submitBtn = [UIFactory createButton:@"确定" BackgroundColor:kUIColorFromRGB(0xf4942d) andTitleColor:[UIColor whiteColor]];
    [submitBtn addTarget:self action:@selector(submitTheSelectData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bgView];
    [bgView addSubview:submitBtn];
    
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(resultView);
        make.top.equalTo(resultView.mas_top).offset(17);
        make.size.mas_equalTo(CGSizeMake(70, 25));
    }];
    
    [yugu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(resultView.mas_top).offset(25);
        make.right.equalTo(priceLabel.mas_left);
        make.width.mas_equalTo(@50);
        make.bottom.equalTo(priceLabel.mas_bottom);
    }];
    
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(priceLabel.mas_right);
        make.height.equalTo(yugu);
        make.top.equalTo(yugu);
        make.width.mas_equalTo(@100);
    }];
    
    [journeyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(resultView);
        make.top.equalTo(priceLabel.mas_bottom).offset(3);
        make.size.mas_equalTo(CGSizeMake(150, 17));
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(journeyLabel.mas_bottom).offset(17);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(@1);
//        make.size.mas_equalTo(CGSizeMake(self.view.width, 1));
    }];
    
    [couponLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(resultView.mas_left).offset(10);
        make.top.equalTo(line.mas_bottom).offset(10);
        make.bottom.equalTo(resultView.mas_bottom).offset(-10);
        make.width.mas_equalTo(@100);
    }];
    
    [couponCost mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(resultView.mas_right).offset(-10);
        make.top.equalTo(line.mas_bottom).offset(10);
        make.bottom.equalTo(resultView.mas_bottom).offset(-10);
        make.width.mas_equalTo(@100);
    }];
    
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bgView).with.insets(UIEdgeInsetsMake(10, 15, 10, 15));
    }];
}

-(void)selectCarTypeByView:(UIButton *)view
{
    NSLog(@"ViewTag:%ld",(long)view.tag);
   
    UIButton *bnt = view;
    bnt.layer.borderColor = [[UIColor orangeColor]CGColor];
    
    UILabel *lable = (UILabel *)[bnt viewWithTag:(100)];
    lable.textColor = [UIColor orangeColor];
    
    UIImageView *imgeView  = (UIImageView *)[bnt viewWithTag:(200)];
    imgeView.image = [UIImage imageNamed:@"directions_car_yellow"];
    
    NSArray *subviews = [typeBg subviews];
    for (UIView *view in subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            if (!(button.tag == bnt.tag)) {
                button.layer.borderColor = [[UIColor grayColor]CGColor];
                UILabel *lable = (UILabel *)[button viewWithTag:(100)];
                UIImageView *imgeView  = (UIImageView *)[button viewWithTag:(200)];
                lable.textColor = [UIColor grayColor];
                imgeView.image = [UIImage imageNamed:@"directions_car"];
            }
        }
        
    }
    
    NSInteger type = [bnt tag];
    _selectType = type;
    priceLabel.text = @"0";
    for (NSDictionary *dic in _cartypes) {
        NSInteger caretype = [[dic objectForKey:@"type"]integerValue];
        if (caretype == type ) {
            typeLabel.text = [NSString stringWithFormat:@"元(%@)",[dic objectForKey:@"name"]];
        }
    }
    //请求费用
    journeyLabel.text = [NSString stringWithFormat:@"计算中"];
    [self computationalCostWithType];

}

-(void)submitTheSelectData
{
    self.rideModel.carType = [NSString stringWithFormat:@"%ld",(long)_selectType];
    if([self.costDelegate respondsToSelector:@selector(loadCostDataWith:carType:)]){
    [self.costDelegate loadCostDataWith:[NSString stringWithFormat:@"费用预估：%@%@",priceLabel.text,typeLabel.text] carType:self.rideModel.carType];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)backToLastView
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma - mark 计算费用

-(void)computationalCostWithType
{
    CLLocationCoordinate2D start = self.rideModel.startLocation;
    CLLocationCoordinate2D end   = self.rideModel.endLocation;
    [self.rideModel computationalDistanceAndTime:start
                                     endLocation:end
                                    successBlock:^(float distance, float duration) {
                                        QiFacade *facade;
                                        facade = [QiFacade sharedInstance];
                                        _flagCost = [facade postFee:[NSString stringWithFormat:@"%f",distance]
                                                               Time:[NSString stringWithFormat:@"%f",duration]
                                                               Type:[NSString stringWithFormat:@"%lu",(unsigned long)self.rideModel.orderType]
                                                            CarType: [NSString stringWithFormat:@"%ld",(long)_selectType]
                                                                Tip:@"0"];
                                        [facade addHttpObserver:self tag:_flagCost];
                                        self.rideModel.distance = [NSString stringWithFormat:@"%.1f",distance];
                                        self.rideModel.time     = [NSString stringWithFormat:@"%.1f",duration];
                                    } failure:^{
                                        self.rideModel.cost    = [NSString stringWithFormat:@"0"];
                                        journeyLabel.text = @"预估失败";
                                    }];
    
}

#pragma - mark 网络请求回调
-(void)requestFinished:(NSDictionary *)response tag:(NSInteger)iRequestTag
{
    if (_flagCost != 0 && response != nil && iRequestTag == _flagCost) {
        
        _flagCost = 0;
        NSLog(@"费用预估：%@",response);
        NSString *cost = [[response objectForKey:@"data"]objectForKey:@"fee"];
        NSString *preferential = [[response objectForKey:@"data"]objectForKey:@"reduce_fee"];
        self.rideModel.cost = [NSString stringWithFormat:@"%@",cost];
        self.rideModel.preferential = [NSString stringWithFormat:@"%@",preferential];
        //设置界面
        priceLabel.text = self.rideModel.cost;
        couponCost.text = self.rideModel.preferential;
        journeyLabel.text = [NSString stringWithFormat:@"约%@公里/%@分钟",self.rideModel.distance,self.rideModel.time];
    }
}

-(void)requestFailed:(NSDictionary *)response tag:(NSInteger)iRequestTag
{
    NSString *msg = [response objectForKey:@"message"];
    NSLog(@"失败33\n%@",msg );
    //费用预估
    if (_flagCost != 0 && response != nil && iRequestTag == _flagCost) {
        
        NSLog(@"费用预估失败：%@",[response objectForKey:@"message"]);
        self.rideModel.cost = @"0";
        self.rideModel.preferential = @"0";
        //设置界面
        priceLabel.text = @"0";
        couponCost.text = @"0";
        journeyLabel.text = @"预估失败";
    }
    
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
