//
//  AddBoardViewController.m
//  OASystem_NET
//
//  Created by 周桐 on 16/9/8.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "AddBoardViewController.h"
#import "someAssist.h"
@interface AddBoardViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *providerTextField;
@property (weak, nonatomic) IBOutlet UITextField *durationTextField;
@property (weak, nonatomic) IBOutlet UITextField *levelTextField;
@property (weak, nonatomic) IBOutlet UITextView *boardTextView;//textView，用来填入公告
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;//发布按钮
@property (weak, nonatomic) IBOutlet UIPickerView *levelPickerView; //拖控件获得公告level的PickerView
@property (strong,nonatomic)UIPickerView *durationPickerView; //代码动态创建公告duration的PickerView
- (IBAction)doneBtn:(id)sender;


@end

@implementation AddBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *name = [[NSString alloc]init];
    self.providerTextField.text = name;
    
    //设置监听是否有输入
    [self.providerTextField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.durationTextField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.levelTextField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self textChange];
    
    //定义弹出PickerView的方法
    [self setLevelPickerView];
    [self setDurationPickerView];
    
    // Do any additional setup after loading the view.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
-(void)textChange
{
    self.doneBtn.enabled = self.providerTextField.text.length && self.durationTextField.text.length && self.levelTextField.text.length;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma 定义弹出PickerView的方法
//公告level的pickerView使用storyboard拖控件方式生成
-(void)setLevelPickerView
{
    self.levelPickerView.delegate = self;
    self.levelPickerView.dataSource = self;
    [self.levelPickerView removeFromSuperview]; //ios8之后的inputView的对象都不能是其他view的subview，在storyboard里面拖控件的时候，把这个levelPickerView拖在了那个view里面了
    self.levelTextField.inputView = self.levelPickerView;
}
//duration的PickerView使用代码创建
-(void)setDurationPickerView
{
    
    self.durationPickerView = [[UIPickerView alloc]init];
    self.durationPickerView.backgroundColor = [UIColor whiteColor];
//    self.durationPickerView.alpha = 0.7; //透明无效
    self.durationPickerView.delegate = self;
    self.durationPickerView.dataSource = self;
    
    self.durationTextField.inputView = self.durationPickerView;
}

#pragma UIPickerViewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self.levelPickerView) {
        return 10;
    }
    else if(pickerView == self.durationPickerView)
    {
        return 30;
    }
    else{
        NSLog(@"？？？？？，不存在的PickerView");
        return 0;
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%ld",row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == self.levelPickerView) {
        self.levelTextField.text = [NSString stringWithFormat:@"%ld",row];
    }
    else{
        self.durationTextField.text = [NSString stringWithFormat:@"%ld",row];
    }
    
}
#pragma UITExtFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //textField不可编辑，只能从pickerView选数据进去
    return NO;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)doneBtn:(id)sender {
    
}
@end
