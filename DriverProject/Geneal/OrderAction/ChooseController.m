//
//  ChooseController.m
//  DriverProject
//
//  Created by 林镇杰 on 15/9/21.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "ChooseController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <ContactsUI/ContactsUI.h>
#import <Contacts/Contacts.h>

#define FIELD_NAME_TAG          10010
#define FIELD_PHONE_TAG         10086
#define LABEL_FONT              [UIFont systemFontOfSize:15]
@interface ChooseController ()<UITextFieldDelegate,ABPeoplePickerNavigationControllerDelegate,CNContactPickerDelegate,CNContactViewControllerDelegate>
{
    UITextField *nameField;
    UITextField *phoneField;
    UIView      *messageView;
    UIImageView *selectImg;
    UILabel     *tips;
    ABPeoplePickerNavigationController *picker;
    CNContactPickerViewController *picker_V9;
    BOOL isSend;
}
@end

@implementation ChooseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"选择联系人";
    self.view.backgroundColor = BG_COLOR_VIEW;
    isSend = YES;
    
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(0, 0, 50, 40);
//    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -25, 0.0, 0.0)];
//    [backBtn addTarget:self action:@selector(backToLastView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, 70, 40);
    [cancelBtn setTitle:@"通讯录" forState:UIControlStateNormal];
    cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [cancelBtn setTitleColor:kUIColorFromRGB(0x727272) forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [cancelBtn addTarget:self action:@selector(goToAddressBooklView) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
//    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = item;
    
    [self createTheInputView];
}

-(void)createTheInputView
{
    NSString *nickname = [UIFactory getNSUserDefaultsDataWithKey:@"nickname"];
    NSString *userPhone = [UIFactory getNSUserDefaultsDataWithKey:@"phone"];
    
    nameField = [UIFactory createTextFieldWithFrame:CGRectMake(0, 74, self.view.width, 50) ByDelegate:self];
    nameField.backgroundColor = [UIColor whiteColor];
    [nameField setFont:LABEL_FONT];
    nameField.placeholder = @"姓名";
    nameField.text = nickname;
    nameField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 50)];
    nameField.leftViewMode = UITextFieldViewModeAlways;
    nameField.tag = FIELD_NAME_TAG;
    [nameField.layer setBorderWidth:0.5f];
    [nameField.layer setBorderColor:RGB(181, 182, 183).CGColor];
    [self.view addSubview:nameField];
    
    phoneField = [UIFactory createTextFieldWithFrame:CGRectZero ByDelegate:self];
    phoneField.backgroundColor = [UIColor whiteColor];
    phoneField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 50)];
    phoneField.leftViewMode = UITextFieldViewModeAlways;
    [phoneField setFont:LABEL_FONT];
    phoneField.placeholder = @"手机号码";
    phoneField.text = userPhone;
    phoneField.tag = FIELD_PHONE_TAG;
    [phoneField.layer setBorderWidth:0.5f];
    [phoneField.layer setBorderColor:RGB(181, 182, 183).CGColor];
    [self.view addSubview:phoneField];
    
    messageView = [[UIView alloc]init];
    messageView.backgroundColor = [UIColor whiteColor];
    messageView.userInteractionEnabled = YES;
    [messageView.layer setBorderWidth:0.5f];
    [messageView.layer setBorderColor:RGB(181, 182, 183).CGColor];
    tips = [UIFactory createLabel:@"短信通知乘车人" Font:LABEL_FONT];
    selectImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"check_circle_yellow"]];
    [self.view addSubview:messageView];
    [messageView addSubview:tips];
    [messageView addSubview:selectImg];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectSendMessageOrNot)];
    [messageView addGestureRecognizer:tap];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height - 60, self.view.width, 60)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderWidth = 0.5f;
    bgView.layer.borderColor = COLOR_LINE.CGColor;
    
    UIButton *submitBtn = [UIFactory createButton:@"确定" BackgroundColor:kUIColorFromRGB(0xf4942d) andTitleColor:[UIColor whiteColor]];
    [submitBtn addTarget:self action:@selector(submitThePeopleData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bgView];
    [bgView addSubview:submitBtn];
    
    [phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameField.mas_bottom).offset(-1);
        make.left.equalTo(nameField);
        make.height.equalTo(nameField);
        make.width.equalTo(nameField);
    }];
    
    [messageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneField.mas_bottom).offset(-1);
        make.left.equalTo(phoneField);
        make.height.equalTo(phoneField);
        make.width.equalTo(phoneField);
    }];
    
    [tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(messageView.mas_left).offset(10);
        make.height.mas_equalTo(@30);
        make.centerY.equalTo(messageView);
        make.width.equalTo(messageView.mas_width).multipliedBy(0.8f);
    }];
    
    [selectImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(messageView.mas_right).offset(-10);
        make.centerY.equalTo(messageView);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bgView).with.insets(UIEdgeInsetsMake(10, 15, 10, 15));
    }];
}

-(void)selectSendMessageOrNot
{
    if (isSend) {
        selectImg.hidden = YES;
        tips.textColor = [UIColor lightGrayColor];
    }else{
        selectImg.hidden = NO;
        tips.textColor = [UIColor blackColor];
    }
    
    isSend = !isSend;
}

-(void)goToAddressBooklView
{
    if (IOS9LATER) {
        picker_V9 = [[CNContactPickerViewController alloc]init];
        picker_V9.delegate = self;
        //[self.navigationController pushViewController:picker_V9 animated:YES];
        [self presentViewController:picker_V9 animated:YES completion:nil];
    }else{
        picker = [[ABPeoplePickerNavigationController alloc] init];
        picker.peoplePickerDelegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

-(void)submitThePeopleData
{
    if (phoneField.text == nil || phoneField.text.length < 11) {
        
        [self showTextOnlyWith:@"请正确输入乘车客人的联系方式！！！"];
        
        return;
    }
    
    [self.chooseDelegate loadChooseResultWith:phoneField.text name:nameField.text AndIsMessage:isSend];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)backToLastView
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma - mark ABPeoplePickerNavigationController Delegate 通讯录代理
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    // assigning control back to the main controller
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//7.0
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
     if (property == kABPersonPhoneProperty) {
    NSString *name = (__bridge NSString*)ABRecordCopyCompositeName(person);
    //获取联系人电话
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSString *aPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phoneMulti, identifier);
    NSLog(@"name:%@，%@",name,aPhone);
    
    [peoplePicker dismissViewControllerAnimated:YES completion:^{
        nameField.text = name;
        NSString *str = [aPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
        phoneField.text = str;
    }];
     }
    return NO;
}
//8.0
-(void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    NSString *name = (__bridge NSString*)ABRecordCopyCompositeName(person);
    //获取联系人电话
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSString *aPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phoneMulti, identifier);
     NSString *str = [aPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    nameField.text = name;
    phoneField.text = str;
    NSLog(@"name:%@，%@",name,aPhone);
}

// 选择联系人完毕：自定义
-(void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelected:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    if (property == kABPersonPhoneProperty) {
        NSString *firstName = CFBridgingRelease(ABRecordCopyValue(person,kABPersonFirstNameProperty));
        firstName = firstName != nil? firstName:@"";
        NSString *lastName =CFBridgingRelease(ABRecordCopyValue(person,kABPersonLastNameProperty));
        lastName = lastName != nil? lastName:@"";
        
        ABMultiValueRef valuesRef =ABRecordCopyValue(person, kABPersonPhoneProperty);
        CFIndex index = ABMultiValueGetIndexForIdentifier(valuesRef,identifier);
        CFStringRef value =ABMultiValueCopyValueAtIndex(valuesRef,index);
        [peoplePicker dismissViewControllerAnimated:YES completion:^{
            NSString* selectNumber = [NSString stringWithFormat:@"%@",(__bridge NSString*)value];
            if ([selectNumber isEqualToString:@"(null)"]) {
                selectNumber = @"";
            } else {
                selectNumber = [selectNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
                NSLog(@"联系人：%@",[NSString stringWithFormat:@"%@%@， 电话：%@",lastName,firstName, selectNumber]);
            }
        }];
    }
}

//9.0以上
//选中一个人
//- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContacts:(NSArray<CNContact*> *)contacts
//{
//    NSLog(@"contact:%@",contacts);
//}
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact
{
    NSLog(@"contact:%@",contact.familyName);
    nameField.text = contact.familyName;
    
    NSArray *phones = contact.phoneNumbers;
    [phones enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *name = NSStringFromClass([obj class]);
        NSLog(@"name:%@",name);
        CNLabeledValue *lableValue = obj;
        CNPhoneNumber *phone = lableValue.value;
        NSLog(@"lableValue.value:%@",phone.stringValue);
        NSLog(@"lableValue.label:%@",lableValue.label);
        NSLog(@"lableValue.identifier:%@",lableValue.identifier);
        phoneField.text = phone.stringValue;
        return;
    }];
}
//- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperties:(NSArray<CNContactProperty*> *)contactProperties
//{
//    NSLog(@"contact:%@",contactProperties);
//}
#pragma - mark UITextField Delegate

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
