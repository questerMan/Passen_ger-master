//
//  AddressSelectController.m
//  DriverProject
//
//  Created by 林镇杰 on 15/9/28.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "AddressSelectController.h"
//#import <AMapSearchKit/AMapSearchKit.h>

#define LABEL_FONT              [UIFont systemFontOfSize:15]

@interface AddressSelectController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,AMapSearchDelegate,UITextFieldDelegate>
{
    UIView *headerView;
    UIButton *backBtn;
    UIView *homeBtn;
    UIView *companyBtn;
    UITableView *locationTable;
    UITextField *filed;
    UIButton    *search;
    AMapSearchAPI *_search;
}

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *displayController;

@property (nonatomic, strong) NSMutableArray *tips;

@property (nonatomic, strong) NSMutableArray *busLines;

@property (nonatomic, strong) NSMutableArray *locations;

@end

@implementation AddressSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = RGB(249, 250, 251);
    //[self.navigationController setNavigationBarHidden:YES];
    
    self.tips = [NSMutableArray array];
    self.busLines = [NSMutableArray array];
 
    
    //配置用户Key
    //[AMapSearchServices sharedServices].apiKey = MAPAPIKEY;
    
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] initWithSearchKey:MAPAPIKEY Delegate:self];
    
//    //发起输入提示搜索
//    [_search AMapInputTipsSearch: tipsRequest];
    [self initLocations];
    [self createTheHeaderView];
    [self creatLocationTable];
}

-(void)viewWillAppear:(BOOL)animated
{
    
}

-(void)viewDidAppear:(BOOL)animated
{
 
}


-(void)viewDidDisappear:(BOOL)animated
{
    [filed removeFromSuperview];
    [search removeFromSuperview];
}

#pragma -mark 初始化常用地址列表数据
- (void)initLocations
{
    self.locations = nil;
    self.locations = [[NSMutableArray alloc] init];
    /*
     --test--
     */
    //NSFileManager* fileManager=[NSFileManager defaultManager];
    //[fileManager removeItemAtPath:[UIFactory dataFilePath:@"commonlyAddress"] error:nil];
    
    if (_searchType == SearchEnd) {
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:[UIFactory dataFilePath:@"commonAddress"]];
        __block NSMutableArray *locArr = [NSMutableArray arrayWithCapacity:0];
        [arr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            DDLocation *location = [[DDLocation alloc] init];
            location.name = [obj objectForKey:@"name"];
            location.cityCode = [obj objectForKey:@"cityCode"]?:@"020";
            location.address = [obj objectForKey:@"address"];
            if ([[obj objectForKey:@"coordinateLon"] floatValue] != 0 && [[obj objectForKey:@"coordinateLat"] floatValue] != 0) {
                location.coordinateLon = [[obj objectForKey:@"coordinateLon"] floatValue];
                location.coordinateLat = [[obj objectForKey:@"coordinateLat"] floatValue];
                [locArr addObject:location];
            }
//            location.coordinateLon = [[obj objectForKey:@"coordinateLon"] floatValue];
//            location.coordinateLat = [[obj objectForKey:@"coordinateLat"]  floatValue];
//            [locArr addObject:location];
            
        }];
        if (arr && arr.count) {
            _locations = [NSMutableArray arrayWithArray:locArr];
        }
    }
}

- (void)creatLocationTable
{
//    locationTable = [[UITableView alloc]initWithFrame:CGRectMake(0, homeBtn.frame.size.height+homeBtn.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - homeBtn.frame.size.height-homeBtn.frame.origin.y-2) style:UITableViewStylePlain];
//    locationTable.delegate = self;
//    locationTable.dataSource = self;
//    locationTable.tag = 1002;
//    [self.view addSubview:locationTable];
//    [self setExtraCellLineHidden:locationTable];
    [self showTableView];
    if (_searchType  == SearchStart) {
        //[self searchTipsWithKey:self.text];
        //发起逆地理编码
        [self reverseGeographyCode:self.coordinateLocation];
    }

}

//去掉多余的线
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    
    UIView *view =[ [UIView alloc]init];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
    
    [tableView setTableHeaderView:view];
}


-(void)createTheHeaderView
{
    UIImageView *homeImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_black"]];
    
    UILabel *homeLabel = [UIFactory createLabel:@"家" Font:LABEL_FONT];
    homeBtn = [[UIView alloc] init];
    homeBtn.frame = CGRectMake(0, 64, self.view.frame.size.width/2, 60);
    [homeBtn addSubview:homeImg];
    [homeBtn addSubview:homeLabel];
    
    UITapGestureRecognizer *tap_home = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(homeButtonAction)];
    [homeBtn addGestureRecognizer:tap_home];
    
    UIImageView *companyImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"location_city"]];
    UILabel *companyLabel = [UIFactory createLabel:@"公司" Font:LABEL_FONT];
    UIView *line_middle = [UIFactory createLineView];
    
    companyBtn = [[UIView alloc]init];
    companyBtn.frame = CGRectMake(self.view.frame.size.width/2, homeBtn.frame.origin.y, self.view.frame.size.width/2, homeBtn.frame.size.height);
    [companyBtn addSubview:line_middle];
    [companyBtn addSubview:companyImg];
    [companyBtn addSubview:companyLabel];
    
    UITapGestureRecognizer *tap_company = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(companyButtonAction)];
    [companyBtn addGestureRecognizer:tap_company];
    
    UIView *line = [UIFactory createLineView];
    line.frame = CGRectMake(0, companyBtn.frame.size.height+companyBtn.frame.origin.y, self.view.frame.size.width, 1);
    
    [self.view addSubview:homeBtn];
    [self.view addSubview:companyBtn];
    [self.view addSubview:line];
//    
//    
//    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, self.view.width, 120)];
//    [headerView.layer setBorderWidth:0.5f];
//    [headerView.layer setBorderColor:COLOR_LINE.CGColor];
//    [self.view addSubview:headerView];
//    
//    backBtn = [UIFactory createButton:[UIImage imageNamed:@"back"]];
//    [backBtn addTarget:self action:@selector(backToLastView) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIView *line = [UIFactory createLineView];
//    
//    UIImageView *homeImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_black"]];
//    
//    UILabel *homeLabel = [UIFactory createLabel:@"家" Font:LABEL_FONT];
//    
//    homeBtn = [[UIView alloc]init];
//    [homeBtn addSubview:homeImg];
//    [homeBtn addSubview:homeLabel];
//    
//    UITapGestureRecognizer *tap_home = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(homeButtonAction)];
//    [homeBtn addGestureRecognizer:tap_home];
//    
//    UIImageView *companyImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"location_city"]];
//    
//    UILabel *companyLabel = [UIFactory createLabel:@"公司" Font:LABEL_FONT];
//    
//    UIView *line_middle = [UIFactory createLineView];
//    
//    companyBtn = [[UIView alloc]init];
//    [companyBtn addSubview:line_middle];
//    [companyBtn addSubview:companyImg];
//    [companyBtn addSubview:companyLabel];
//    
//    UITapGestureRecognizer *tap_company = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(companyButtonAction)];
//    [companyBtn addGestureRecognizer:tap_company];
//    
//    [headerView  addSubview:backBtn];
//    [headerView addSubview:line];
//    [headerView addSubview:homeBtn];
//    [headerView addSubview:companyBtn];
//    
//    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(headerView).offset(10);
//        make.top.equalTo(headerView).offset(25);
//        make.size.mas_equalTo(CGSizeMake(30, 30));
//    }];
//    
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(backBtn.mas_bottom).offset(10);
//        make.left.equalTo(headerView);
//        make.width.equalTo(headerView.mas_width);
//        make.height.mas_equalTo(@1);
//    }];
    
    [homeImg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(homeBtn);
        make.right.equalTo(homeLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [homeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(homeBtn);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
//    [homeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_top).offset(44);
//        make.left.equalTo(self.view.mas_top).offset(0);
//        make.width.equalTo(self.view).multipliedBy(0.5f);
//        make.height.mas_equalTo(@44);
//    }];
    
    [companyImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(companyBtn);
        make.right.equalTo(companyLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(companyBtn);
        make.size.mas_equalTo(CGSizeMake(35, 25));
    }];
    
    [line_middle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(companyBtn);
        make.height.equalTo(companyBtn.mas_height).multipliedBy(0.7f);
        make.width.mas_equalTo(@1);
        make.centerY.equalTo(companyBtn);
    }];
    
//    [companyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_top).offset(44);
//        make.right.equalTo(self.view.mas_top).offset(0);
//        make.width.equalTo(self.view).multipliedBy(0.5f);
//        make.height.mas_equalTo(@44);
//    }];
    
//    [self initSearchBar];
//    [self initSearchDisplayController];
    
    [self initSearchBarFiled];
}

-(void)initSearchBarFiled
{
    UIImage* iamge_back = [UIImage imageNamed:@"back"];
//    UIBarButtonItem* backItem = [[UIBarButtonItem alloc]initWithImage:iamge_back style:UIBarButtonItemStyleDone target:self action:@selector(backToLastView)];
//    [backItem setBackButtonBackgroundImage:iamge_back forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];//更改背景图片
//    self.navigationItem.leftBarButtonItem = backItem;
    
    UIButton* right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(0, 0, 30, 30);
    [right setImage:iamge_back forState:UIControlStateNormal];
    [right setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)]; // 向右边拉伸
    
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:right];
    self.navigationItem.leftBarButtonItem = rightItem;
    [right addTarget:self action:@selector(backToLastView) forControlEvents:UIControlEventTouchUpInside];
    
    filed = [[UITextField alloc]initWithFrame:CGRectMake(70, 5, self.view.frame.size.width*.55, 30)];
    //filed.center = CGPointMake(filed.center.x, backBtn.frame.size.height/2);
    filed.layer.borderColor = [[UIColor grayColor]CGColor];
    filed.layer.borderWidth = .6;
    filed.layer.cornerRadius = 4;
    filed.delegate = self;
    filed.font = [UIFont systemFontOfSize:14];
    filed.placeholder = @" 请输入搜索地址";
    [filed addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    CGRect frame = [filed frame];
    frame.size.width = 10.0f;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    filed.leftViewMode = UITextFieldViewModeAlways;
    filed.leftView = leftview;
    [self.navigationController.navigationBar addSubview:filed];
    
    if (iPhone5) {
         search = [[UIButton alloc]initWithFrame:CGRectMake(filed.frame.size.width+filed.frame.origin.x+25, 5, 40, 30)];
    }
    search = [[UIButton alloc]initWithFrame:CGRectMake(ViewWidth - ViewWidth/414*75, 5, 40, 30)];
    NSLog(@"xx%f",ViewWidth);
    [search setTitle:@"搜索" forState:UIControlStateNormal];
    [search setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //search.backgroundColor = [UIColor redColor];
    [search addTarget:self action:@selector(searchTipsWithKey:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:search];

}

- (void) textFieldDidChange:(id) sender {
    UITextField *_field = (UITextField *)sender;
    NSLog(@"%@",[_field text]);
    [self searchTipsWithKey:_field.text];
}

- (void)initSearchBar
{
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.barStyle     = UIBarStyleDefault;
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor]];
    self.searchBar.translucent  = YES;
    self.searchBar.delegate     = self;
    //self.searchBar.text         = self.text;
    self.searchBar.placeholder  = @"请输入您想搜索的位置";
    self.searchBar.keyboardType = UIKeyboardTypeDefault;
    
    //self.navigationItem.titleView = self.searchBar;
    [headerView addSubview:self.searchBar];
    
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView).offset(33);
        make.centerX.equalTo(headerView);
        make.width.equalTo(headerView.mas_width).multipliedBy(0.7f);
        make.height.mas_equalTo(@36);
    }];
}

- (void)initSearchDisplayController
{
    self.displayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.displayController.delegate                = self;
    self.displayController.searchResultsDataSource = self;
    self.displayController.searchResultsDelegate   = self;
    self.displayController.displaysSearchBarInNavigationBar = NO;
    self.displayController.searchContentsController.edgesForExtendedLayout = UIRectEdgeNone;
}

//Home按钮点击
-(void)homeButtonAction
{
    if ([[UIFactory getNSUserDefaultsDataWithKey:@"home_address"] isEqualToString:NULL_DATA] ||
        !(((NSString *)[UIFactory getNSUserDefaultsDataWithKey:@"home_address"]).length)) {
        
        [self showTextOnlyWith:@"您尚未设置您的家庭地址"];
    }else{
        //回调下单页面
        CLLocationCoordinate2D coordinate;
        DDLocation *location = [[DDLocation alloc]init];
        location.coordinateLat = [[UIFactory getNSUserDefaultsDataWithKey:@"home_address_lat"]floatValue];
        location.coordinateLon = [[UIFactory getNSUserDefaultsDataWithKey:@"home_address_lon"]floatValue];
        location.name = [UIFactory getNSUserDefaultsDataWithKey:@"home_address"];
        location.address = [UIFactory getNSUserDefaultsDataWithKey:@"home_address_detail"];
        if (_delegate && [_delegate respondsToSelector:@selector(searchViewController:didSelectLocation: searchType:)])
        {
            [_delegate searchViewController:self didSelectLocation:location searchType:self.searchType];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

//Company按钮点击
-(void)companyButtonAction
{
    if ([[UIFactory getNSUserDefaultsDataWithKey:@"company_address"] isEqualToString:NULL_DATA] ||
        !(((NSString *)[UIFactory getNSUserDefaultsDataWithKey:@"company_address"]).length)) {
        
        [self showTextOnlyWith:@"您尚未设置您的公司地址"];
    }else{
        //回调下单页面
        CLLocationCoordinate2D coordinate;
        DDLocation *location = [[DDLocation alloc]init];
        location.coordinateLat = [[UIFactory getNSUserDefaultsDataWithKey:@"company_address_lat"]floatValue];
        location.coordinateLon = [[UIFactory getNSUserDefaultsDataWithKey:@"company_address_lon"]floatValue];
        location.name = [UIFactory getNSUserDefaultsDataWithKey:@"company_address"];
        location.address = [UIFactory getNSUserDefaultsDataWithKey:@"company_address_detail"];
        if (_delegate && [_delegate respondsToSelector:@selector(searchViewController:didSelectLocation: searchType:)])
        {
            [_delegate searchViewController:self didSelectLocation:location searchType:self.searchType];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

//返回上一级页面
-(void)backToLastView
{
    [self.navigationController popViewControllerAnimated:YES];
}

/* 输入提示 搜索.*/
//- (void)searchTipsWithKey:(NSString *)key
//{
//    if (key.length == 0)
//    {
//        return;
//    }
//    
//    AMapInputTipsSearchRequest *tips = [[AMapInputTipsSearchRequest alloc] init];
//    tips.keywords = key;
//    tips.city     = @"广州";
//    
//    [_search AMapInputTipsSearch:tips];
//}
#pragma -mark生成table
-(void)showTableView
{
    if (locationTable) {
        [locationTable reloadData];
    }else{
        locationTable = [[UITableView alloc]initWithFrame:CGRectMake(0, homeBtn.frame.size.height+homeBtn.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - homeBtn.frame.size.height-homeBtn.frame.origin.y-2) style:UITableViewStylePlain];
        locationTable.delegate = self;
        locationTable.dataSource = self;
        locationTable.tag = 1002;
        [self.view addSubview:locationTable];
        [self setExtraCellLineHidden:locationTable];
    }
}

#pragma -mark逆地理编码 获取地址
//逆地理编码
- (void)reverseGeographyCode:(CLLocationCoordinate2D)coor
{
    AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    regeoRequest.location = [AMapGeoPoint locationWithLatitude:coor.latitude longitude:coor.longitude];
    regeoRequest.radius = 10000;
    regeoRequest.requireExtension = YES;
    
    //发起逆地理编码
    [_search AMapReGoecodeSearch: regeoRequest];
}

#pragma -mark实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil) {
        NSArray  *pois  = response.regeocode.pois;
        for (AMapPOI *obj in pois) {
            NSLog(@"poi:%@",obj.name);
            CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(obj.location.latitude, obj.location.longitude);
            DDLocation *location = [[DDLocation alloc] init];
            location.name = obj.name;
            location.coordinateLat = coor.latitude;
            location.coordinateLon = coor.longitude;
            location.address = obj.address;
            location.cityCode = obj.citycode;
            if (obj.address) {
                [self.locations addObject:location];
            }
        }
        [self showTableView];
    }
}


- (void)searchTipsWithKey:(id)key
{
    NSString *keys;
    if ([key isKindOfClass:[UIButton class]]) {
        keys = filed.text;
    }else if ([key isKindOfClass:[NSString class]]){
        keys = key;
    }
    if (!keys|| keys.length == 0)
    {
        return;
    }
    
    __weak __typeof(&*self) weakSelf = self;
    AMapPlaceSearchRequest *request = [[AMapPlaceSearchRequest alloc] init];
    request.requireExtension = YES;
    request.keywords = keys;
    request.searchType = AMapSearchType_PlaceKeyword;
    
    if (self.city.length > 0)
    {
        request.city = @[self.city];
    }
    
    [[DDSearchManager sharedInstance] searchForRequest:request completionBlock:^(id request, id response, NSError *error) {
        if (error)
        {
            NSLog(@"error :%@", error);
        }
        else
        {
            [weakSelf.locations removeAllObjects];
            
            AMapPlaceSearchResponse *aResponse = (AMapPlaceSearchResponse *)response;
            [aResponse.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop)
             {
                 CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(obj.location.latitude, obj.location.longitude);
                 DDLocation *location = [[DDLocation alloc] init];
                 location.name = obj.name;
                 location.coordinateLat = coor.latitude;
                 location.coordinateLon = coor.longitude;
                 location.address = obj.address;
                 location.cityCode = obj.citycode;
                 if (obj.address) {
                     [self.locations addObject:location];
                 }
             }];
            [locationTable reloadData];
            //[self.displayController.searchResultsTableView reloadData];
        }
    }];
}

-(void)searchWithDriving:(CLLocationCoordinate2D)startPoint end:(CLLocationCoordinate2D)endPoint
{
    AMapNavigationSearchRequest *request = [[AMapNavigationSearchRequest alloc] init];
    request.strategy = 5;
    [[DDSearchManager sharedInstance] searchForRequest:request completionBlock:^(id request, id response, NSError *error) {
         AMapNavigationSearchResponse *aResponse = (AMapNavigationSearchResponse *)response;
        AMapRoute *route = aResponse.route;
        for (AMapPath *path in route.paths) {
            NSInteger dis = path.distance;
            NSInteger time = path.duration;
            NSLog(@"距离：%f米，耗时：%f分钟",(float)(dis/1000),(float)(time/60));
        }
    }];
}

#pragma mark - AMapSearchDelegate

/* 输入提示回调. */
//- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
//{
//    [self.tips setArray:response.tips];
//    
//    [self.displayController.searchResultsTableView reloadData];
//}
//
//#pragma mark - UISearchBarDelegate
//
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
//{
//    NSString *key = searchBar.text;
//    
//    [self.displayController setActive:NO animated:NO];
//    
//    self.searchBar.placeholder = key;
//}
//
//#pragma mark - UISearchDisplayDelegate
//
//- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
//{
//    [self searchTipsWithKey:searchString];
//    
//    return YES;
//}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchTipsWithKey:searchBar.text];
}

#pragma mark - UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self searchTipsWithKey:searchString];
    
    return YES;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.locations.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
    }
    
    DDLocation *location;
    if (self.locations.count) {
        location = self.locations[indexPath.row];
   
        cell.textLabel.text = location.name;
    
        cell.detailTextLabel.text = location.address;
    }
    
    return cell;

}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [_searchBar resignFirstResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    DDLocation *location = self.locations[indexPath.row];
    if (_delegate && [_delegate respondsToSelector:@selector(searchViewController:didSelectLocation: searchType:)])
    {
        if (location != nil) {
            
            [_delegate searchViewController:tableView didSelectLocation:location searchType:self.searchType];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }

}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
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
