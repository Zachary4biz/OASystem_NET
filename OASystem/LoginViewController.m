//
//  LoginViewController.m
//  OASystem
//
//  Created by 周桐 on 16/8/20.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "LoginViewController.h"
#import "someAssist.h"
#import "EntryViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UITextField *pwd;

@property (weak, nonatomic) IBOutlet UIButton *UIloginBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomSpacing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upViewBottomSpacing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewTopSpacing;
@property (weak, nonatomic) IBOutlet UISwitch *rememberPwdSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *autoLoginSwitch;
- (IBAction)rememberPwdSwitch:(id)sender;
- (IBAction)autoLoginSwitch:(id)sender;
- (IBAction)loginBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;//为了获取它的Y，方便键盘弹出隐藏时改动它的约束



//@property (strong , nonatomic)NSString *name; //获取一下登录时所用账户的名字，用来传给EntryView
//@property(strong, nonatomic)NSString *contacts_count; //获取联系人个数，用来传给EntryView

@end

@implementation LoginViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // Do any additional setup after loading the view.
//    self.account.delegate = self;
//    self.pwd.delegate = self;
    
    
    //文本框添加监听器
    [self.account addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.pwd addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    
    //添加监听键盘
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //账号框默认记录
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *saveArr = [userDefaults objectForKey:@"UserKey"];
    NSLog(@"%@",saveArr);
    
    self.account.text = saveArr.lastObject[@"account"];
    //记住密码
    if (self.rememberPwdSwitch.on==YES){
        self.pwd.text = saveArr[0][@"pwd"];
        //自动登录
        if (self.autoLoginSwitch.on==YES){
            [self loginBtn];
        }
    }
    
    [self textChange];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
//当pwd和account都有内容时才能点击login按钮
-(void)textChange
{

    self.UIloginBtn.enabled = self.account.text.length && self.pwd.text.length;
    NSLog(@"%@----%@",self.account.text,self.pwd.text);
}

//应对键盘弹出时，需要将窗口上移
-(void)keyboardWillShow:(NSNotification *)note{
//    NSLog(@"keyboardWillShow -%@",note.userInfo);
    //从通知中获取键盘的frame
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey ]CGRectValue];
    //这句是从通知中获取键盘弹出用的时间
    double keyboardDuration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    //修改约束
    self.bottomViewBottomSpacing.constant = rect.size.height;
//    self.upViewBottomSpacing.constant = rect.size.height;
    double y =self.bottomView.frame.origin.y ;
    NSLog(@"%f",y);
    self.bottomViewTopSpacing.constant = y - rect.size.height;
    [UIView animateWithDuration:keyboardDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

//应对键盘收回的时候，窗口下移回去
-(void)keyboardWillHide:(NSNotification *)note{
    //    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    //    不需要再获取，直接是0就可以了
    double keyboardDuration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
//    self.upViewBottomSpacing.constant = 0;
    self.bottomViewBottomSpacing.constant = 0;
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey ]CGRectValue];
    double y =self.bottomView.frame.origin.y ;
    NSLog(@"%f",y);
    self.bottomViewTopSpacing.constant =y + rect.size.height;
    [UIView animateWithDuration:keyboardDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

//点击空白处回收键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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



- (IBAction)loginBtn{
    //点击登录时，键盘也要退出
    [self.view  endEditing:YES];
    //显示蒙版
    __block someAssist *hud = [[someAssist alloc]init];
    [hud showWait:self];
    
    //设置连接url和request相关
    NSURL *url = [NSURL URLWithString:[someAssist serverWith:@"login"]];
    NSMutableURLRequest *request_post = [NSMutableURLRequest requestWithURL:url];
    request_post.HTTPMethod = @"POST";
    NSString *info = [NSString stringWithFormat:@"account=%@&pwd=%@",self.account.text,self.pwd.text];
    request_post.HTTPBody=[info dataUsingEncoding:NSUTF8StringEncoding];
    request_post.timeoutInterval=5;
    
    //异步request
    [NSURLConnection sendAsynchronousRequest:request_post queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse * response, NSData * data, NSError * _Nullable connectionError) {
        //回到主线程关闭蒙版
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud dismissWait:self];
            
            //把这一坨判断写在主线程里面是因为用的是GCD async，所以可能已经跳转页面了，但是hud还没有dismiss
            if (connectionError) {
                NSLog(@"请求失败--%@",connectionError);
                [someAssist alertWith:@"连接失败" viewController:self];
            }
            else{
                NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                //这里是登录后服务器会返回done Zhou 15，即done(空格)用户的名字(空格)联系人个数
                NSArray *resultArr = [result componentsSeparatedByString:@" "];
                //这里仍然可以先用字符串截取的方式截取前4个，前四个仍然可以判断能不能登录(done)
                if ([[result substringWithRange:NSMakeRange(0,4)] isEqualToString:@"done"]) {
                    //登录成功之后，就把返回结果按空格分隔，取第二个和第三个分别是名字和联系人个数
                    [self saveAccountPwd];
                    self.name = resultArr[1];
                    self.contacts_count = resultArr[2];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self performSegueWithIdentifier:@"login2entry" sender:nil];
                    });
                }
                else if ([result isEqualToString:@"account wrong"]){
                    [someAssist alertWith:@"账号不存在" viewController:self];
                }
                else if ([result isEqualToString:@"pwd wrong"]){
                    //                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"密码错误" message:nil preferredStyle:UIAlertControllerStyleAlert];
                    //                UIAlertAction *action  = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
                    //                [alert addAction:action];
                    //                [self presentViewController:alert animated:YES completion:nil];
                    [someAssist alertWith:@"密码错误" viewController:self];
                }
                else{
                    [someAssist alertWith:@"未知错误" viewController:self];
                }
            }

        });
        
    }];
    
}
//封装---login中使用--保存账号密码
-(void)saveAccountPwd{
//保存输入的账号密码
if (self.rememberPwdSwitch.on==YES) {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *userArr_temp = [userDefaults objectForKey:@"UserKey"];
    NSMutableArray *userArr = [NSMutableArray array];
    if (userArr_temp) {
        userArr = [userArr_temp mutableCopy];
    }
    
    //        NSMutableArray *userArr = [NSMutableArray array];
    //        for (id i in [userDefaults objectForKey:@"UserKey"]){
    //            [userArr addObject:i];
    //        }
    
    [userArr addObject:@{@"account":self.account.text,@"pwd":self.pwd.text}];
    
    [userDefaults setObject:userArr forKey:@"UserKey"];
}
else if(self.rememberPwdSwitch.on==NO){
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *userArr_temp = [userDefaults objectForKey:@"UserKey"];
    NSMutableArray *userArr = [NSMutableArray array];
    if (userArr_temp) {
        userArr = [userArr_temp mutableCopy];
    }
    NSString *nu=NULL;
    [userArr addObject:@{@"account":self.account.text,@"pwd":nu}];
    [userDefaults setObject:userArr forKey:@"UserKey"];
}
}



//-(void)alertWith:(NSString *)str{
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:str message:nil preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *action  = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
//    [alert addAction:action];
//    [self presentViewController:alert animated:YES completion:nil];
//}

- (IBAction)rememberPwdSwitch:(id)sender {
    if (self.rememberPwdSwitch.on == NO)
    {
        //取消了记住密码，那么也默认取消自动登录
//        self.autoLoginSwitch.on = NO;
        [self.autoLoginSwitch setOn:NO animated:YES];
        
    }

}

- (IBAction)autoLoginSwitch:(id)sender {
    if (self.autoLoginSwitch.on == YES)
    {
        //如果勾选了自动登录，那么也默认勾选记住密码
//        self.rememberPwdSwitch.on = YES;
        [self.rememberPwdSwitch setOn:YES animated:YES];

    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier  isEqual: @"login2entry"]) {
        EntryViewController *tempVC = segue.destinationViewController;
        tempVC.name = self.name;
        tempVC.contacts_count = self.contacts_count;
#warning 这为什么不能直接给nameBtn 做 setTitle？得到的.titleLabel.text为什么是null
//        [tempVC.nameBtn setTitle:self.name forState:UIControlStateNormal];
//        NSLog(@"%@",tempVC.nameBtn.titleLabel.text);
    }

}
#pragma  mark UITextFieldDelegate
//这个方法不够及时，要换方法来监听是否输入内容，并启用登录按钮
//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    NSLog(@"%@",_account.text);
//    return YES;
//}
//







@end
