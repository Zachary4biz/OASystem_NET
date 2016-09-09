//
//  EditContactsViewController.m
//  OASystem
//
//  Created by 周桐 on 16/8/23.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "EditContactsViewController.h"
#import "ContactsMod.h"
#import "ContactsViewController.h"
@interface EditContactsViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *idField;
@property (weak, nonatomic) IBOutlet UITextField *jobField;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
- (IBAction)addBtn:(id)sender;

//@property (strong, nonatomic)NSMutableDictionary *temp_dict;//用来整齐存储输入的联系人信息
//@property (strong, nonatomic)ContactsMod *temp_mod; //用来存储新编辑的联系人信息

@end

@implementation EditContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.nameField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingDidEnd];
    [self.phoneField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingDidEnd];
    [self.idField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingDidEnd];
    [self.jobField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingDidEnd];
}

//监听TextField是否填写完毕额
-(void)textChange
{
    self.addBtn.enabled = YES;
}

//点击空白隐藏键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

//- (void)addBtn:(id)sender {
//    //更新你的数据
////    NSArray *arr = self.navigationController.viewControllers;
////    self.navigationController.viewControllers[arr.count-2];
//    
//    [self.navigationController popViewControllerAnimated:YES];
//}

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

- (IBAction)addBtn:(id)sender {
    //建立一个临时字典整齐地存储
//        self.temp_dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@{@"ID":_idField.text,@"job":_jobField,@"name":_nameField,@"phone":_phoneField,@"icon":@"1"}, nil];
//    self.temp_dict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@{@"ID":_idField.text,@"job":_jobField,@"name":_nameField,@"phone":_phoneField,@"icon":@"1"}, nil];
//    [self.temp_dict setValue:_idField.text forKey:@"ID"];
//    [self.temp_dict setValue:_jobField.text forKey:@"job"];
//    [self.temp_dict setValue:_nameField.text forKey:@"name"];
//    [self.temp_dict setValue:_phoneField.text forKey:@"phone"];
//    [self.temp_dict setValue:@"1"  forKey:@"icon"];
    //利用模型存储好要输入的联系人信息
//    _temp_mod.name = self.nameField.text;
//    _temp_mod.ID = self.idField.text;
//    _temp_mod.phone = self.phoneField.text;
//    _temp_mod.job = self.jobField.text;
//    _temp_mod.icon = @"1";
    
    //从沙盒中获取（创建）contacts.plist
    NSString *pre_path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject];
    NSString *path = [pre_path stringByAppendingPathComponent:@"contacts.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createFileAtPath:path contents:nil attributes:nil];
        //写入默认空数组
        NSMutableArray *tempArr = [NSMutableArray array];
        [tempArr writeToFile:path atomically:YES];
    }
    NSMutableArray *temp_Arr = [NSMutableArray arrayWithContentsOfFile:path];
    
    NSDictionary *tempDict = @{@"ID":self.idField.text,@"name":self.nameField.text,@"job":self.jobField.text,@"phone":self.phoneField.text,@"icon":@"1"};

//    [temp_Arr addObject:self.temp_dict];
    [temp_Arr addObject:tempDict];
    [temp_Arr writeToFile:path atomically:YES];
//    [self performSegueWithIdentifier:@"editcontacts2contacts" sender:nil];
    //通知ContactsViewController刷新页面
    //1.创建通知
    NSNotification *refresh = [NSNotification notificationWithName:@"refresh" object:nil];
    //2.post发送通知到默认通知中心
    [[NSNotificationCenter defaultCenter]postNotification:refresh];
    
    [self.navigationController popViewControllerAnimated:YES];
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
////    ContactsViewController *vc_temp = segue.destinationViewController;
////    [vc_temp.dataArr addObject:_temp_mod];
//
//    
//}
@end
