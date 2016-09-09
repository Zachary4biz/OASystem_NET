//
//  EditContactsViewController.m
//  OASystem
//
//  Created by 周桐 on 16/8/23.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "AddContactsViewController.h"
#import "ContactsMod.h"
#import "ContactsViewController.h"
#import "someAssist.h"
@interface AddContactsViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *eidField;
@property (weak, nonatomic) IBOutlet UITextField *jobField;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;


- (IBAction)addBtn:(id)sender;

//@property (strong, nonatomic)NSMutableDictionary *temp_dict;//用来整齐存储输入的联系人信息
//@property (strong, nonatomic)ContactsMod *temp_mod; //用来存储新编辑的联系人信息

@end

@implementation AddContactsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.nameField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingDidEnd];
    [self.phoneField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingDidEnd];
    [self.eidField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingDidEnd];
    [self.jobField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingDidEnd];
    [self textChange];
    
}

//监听TextField是否填写完毕额
-(void)textChange
{
    self.addBtn.enabled = self.nameField.text.length && self.phoneField.text.length && self.eidField.text.length && self.jobField.text.length;
}

//点击空白隐藏键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)addBtn:(id)sender {
    NSURL *url = [NSURL URLWithString:[someAssist serverWith:@"addcontact"]];
    
    //制作POST请求
    NSMutableURLRequest *request_post = [NSMutableURLRequest requestWithURL:url];
    request_post.HTTPMethod = @"POST";
    NSString *info = [NSString stringWithFormat:@"Name=%@&Phone=%@&Job=%@&EId=%@&",self.nameField.text,self.phoneField.text,self.jobField.text,self.eidField.text];
    request_post.HTTPBody = [info dataUsingEncoding:NSUTF8StringEncoding];
    request_post.timeoutInterval = 5;
    
    //发起异步请求
    [NSURLConnection sendAsynchronousRequest:request_post queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSString *judge = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        if (connectionError) {
            NSLog(@"请求失败--%@",connectionError);
            [someAssist serverWith:@"连接服务器失败"];
        }
        else if([judge isEqualToString:@"done"]){
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if ([judge isEqualToString:@"not done"]){
            [someAssist alertWith:@"添加失败，仅支持英文" viewController:self];
        }
    }];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    ContactsViewController *vc_temp = segue.destinationViewController;
//    [vc_temp.dataArr addObject:_temp_mod];
    NSLog(@"pop掉也会执行prepareForSegue");//不执行
    
    
}
@end
