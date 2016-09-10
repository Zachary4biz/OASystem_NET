//
//  DetailContactsViewController.m
//  OASystem
//
//  Created by 周桐 on 16/8/23.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "DetailContactsViewController.h"
#import "ContactsMod.h"

#import "ContactsViewController.h"
#import "someAssist.h"
@interface DetailContactsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *jobLbl;
@property (weak, nonatomic) IBOutlet UILabel *phoneLbl;
@property (weak, nonatomic) IBOutlet UILabel *idLbl;
- (IBAction)deleteContactsBtn:(id)sender;
//需要一个变量来记录打开的是哪一个联系人，这样在删除的时候才有东西往外面传
//@property (nonatomic,assign)NSInteger recorder4indexPathRow;//写在.h

//什么用？
//@property (nonatomic, strong)NSMutableArray *modArr;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *jobField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *eidField;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
- (IBAction)saveBtn:(id)sender;

@end

@implementation DetailContactsViewController


- (IBAction)deleteContactsBtn:(id)sender {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确定删除联系人？" message:nil preferredStyle:0];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:
                         ^(UIAlertAction * _Nonnull action)
    {
        
        NSURL *url = [NSURL URLWithString:[someAssist serverWith:@"deletecontact"]];
        NSMutableURLRequest *request_post = [NSMutableURLRequest requestWithURL:url];
        request_post.HTTPMethod = @"POST";
        request_post.timeoutInterval = 5;
        NSString *info = [NSString stringWithFormat:@"Id=%@",self.mod.Id];
        request_post.HTTPBody=[info dataUsingEncoding:NSUTF8StringEncoding];
        
        [NSURLConnection sendAsynchronousRequest:request_post queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            NSString *judge = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            if (connectionError) {
                NSLog(@"deletebtn请求失败--%@",connectionError);
                [someAssist serverWith:@"连接服务器失败"];
            }
            else if([judge isEqualToString:@"done"]){
                [self.navigationController popViewControllerAnimated:YES];
            }
            else if ([judge isEqualToString:@"not done"]){
                [someAssist alertWith:@"删除失败" viewController:self];
            }
        }];
    }];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:ok];
    [alertVC addAction:cancle];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

//-(NSMutableArray *)modArr
//{
//    _modArr = [NSMutableArray array];
//    
//    NSString *path = [[NSBundle mainBundle]pathForResource:@"contacts" ofType:@"plist"];
//    NSArray *dictArr = [NSArray arrayWithContentsOfFile:path];
//    
//    for (NSDictionary *i in dictArr)
//    {
//        ContactsMod *mod = [ContactsMod contactsWithDict:i];
//        [_modArr addObject:mod];
//    }
//    //    NSLog(@"%ld",_dataArr.count);
//    //    NSLog(@"-----------");
//    return _modArr;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    

//    传文字数据
    self.nameField.text = _mod.Name;
    self.jobField.text = self.mod.Job;
    self.phoneField.text = self.mod.Phone;
    self.eidField.text = self.mod.EId;
    //初始加载时，不允许编辑
    _nameField.enabled = NO;
    _jobField.enabled = NO;
    _eidField.enabled = NO;
    _phoneField.enabled = NO;
    self.iconView.image = [UIImage imageNamed:self.mod.Icon];
    
//    [self.view layoutIfNeeded];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(edit:)];
    
    [self.nameField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingDidEnd];
    [self.phoneField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingDidEnd];
    [self.eidField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingDidEnd];
    [self.jobField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingDidEnd];
    
}

-(void)textChange{
    self.saveBtn.enabled = self.nameField.text.length && self.phoneField.text.length && self.eidField.text.length&&self.jobField.text.length;
}


-(void)edit:(UIBarButtonItem *)item
{
    if ([item.title isEqualToString:@"编辑"]) {
        item.title = @"取消";
        _saveBtn.hidden = NO;
        [_phoneField becomeFirstResponder];
        _nameField.enabled = YES;
        _jobField.enabled = YES;
        _eidField.enabled = YES;
        _phoneField.enabled = YES;
    }
    else{
        item.title = @"编辑";
        _saveBtn.hidden = YES;
//        [self.view endEditing:YES];
        //使用了.enable=NO之后，键盘就自动退出
        _nameField.enabled = NO;
        _jobField.enabled = NO;
        _eidField.enabled = NO;
        _phoneField.enabled = NO;
        //点击取消后，编辑的内容变回原来的样子
        self.nameField.text = _mod.Name;
        self.jobField.text = self.mod.Job;
        self.phoneField.text = self.mod.Phone;
        self.eidField.text = self.mod.EId;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)saveBtn:(id)sender {
    //获取URL
    NSURL *url = [NSURL URLWithString:[someAssist serverWith:@"editcontact"]];
    
    //声明一个POST请求
    NSMutableURLRequest *request_post = [NSMutableURLRequest requestWithURL:url];
    request_post.timeoutInterval = 5;
    request_post.HTTPMethod = @"POST";
    
    //post数据为name eid phone job
    NSString *info = [NSString stringWithFormat:@"Id=%@&Name=%@&EId=%@&Phone=%@&Job=%@",self.mod.Id,self.nameField.text,self.eidField.text,self.phoneField.text,self.jobField.text];
    request_post.HTTPBody = [info dataUsingEncoding:NSUTF8StringEncoding];
    
    //发送同步请求
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request_post returningResponse:&response error:&error];
    
    //判断是否成功连接
    if (error) {
        NSLog(@"savebtn请求失败----%@",error);
        [someAssist alertWith:@"连接服务器失败" viewController:self];
    }
    else{
        NSString *judge = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        if ([judge isEqualToString:@"done"]){
            
            //退出编辑模式
            self.navigationItem.rightBarButtonItem.title = @"编辑";
            self.saveBtn.hidden = YES;
            _nameField.enabled = NO;
            _jobField.enabled = NO;
            _eidField.enabled = NO;
            _phoneField.enabled = NO;
        }
        else if ([judge isEqualToString:@"not done"]){
            [someAssist alertWith:@"编辑失败，仅允许英文" viewController:self];
        }
    }
    
}
@end
