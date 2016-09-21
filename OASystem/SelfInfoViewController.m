//
//  SelfInfoViewController.m
//  OASystem
//
//  Created by 周桐 on 16/8/22.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "SelfInfoViewController.h"
#import "selfInfoMod.h"
#import "someAssist.h"
//#import "MBProgressHUD.h"
@interface SelfInfoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UITextField *jobTextField;
@property (weak, nonatomic) IBOutlet UITextField *eidTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
- (IBAction)doneBtn:(id)sender;



@end

@implementation SelfInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setTextFields];
#warning 这个默认是给@selector函数传参传自己么
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(edit:)];
    
}

//编辑按钮
-(void)edit:(UIBarButtonItem *)item
{
    if ([item.title isEqualToString:@"编辑"]) {
        item.title = @"取消";
        _doneBtn.hidden = NO;
        [_nameTextField becomeFirstResponder];
        _nameTextField.enabled = YES;
        _jobTextField.enabled = YES;
        _birthTextField.enabled = YES;
        _cityTextField.enabled = YES;
    }
    else{
        item.title = @"编辑";
        _doneBtn.hidden = YES;
        //        [self.view endEditing:YES];
        //使用了.enable=NO之后，键盘就自动退出
        _nameTextField.enabled = NO;
        _jobTextField.enabled = NO;
        _birthTextField.enabled = NO;
        _cityTextField.enabled = NO;
        //点击取消后，编辑的内容变回原来的样子
        _nameTextField.text = self.mod.name;
        _jobTextField.text = self.mod.job;
        _phoneTextField.text = self.mod.phone;
        _eidTextField.text = self.mod.eid;
    }
}
//完成按钮
- (IBAction)doneBtn:(id)sender {
//    [someAssist serverWith:@"editusr"];//notdone
}



//封装起来---赋值UI（最好回到主线程执行）
-(void)setTextFields
{
    self.jobTextField.text = self.mod.job;
    self.eidTextField.text = self.mod.eid;
    self.nameTextField.text = self.mod.name;
    self.birthTextField.text = self.mod.birth;
    self.cityTextField.text = self.mod.city;
    self.phoneTextField.text = self.mod.phone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//点击空白处回收键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
