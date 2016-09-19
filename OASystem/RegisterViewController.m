//
//  RegisterViewController.m
//  OASystem
//
//  Created by 周桐 on 16/8/19.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "RegisterViewController.h"
#import "ProvincesMod.h"
#import "EntryViewController.h"//导入这个头文件是因为，后面要利用prepareForeSegue来给entry界面传值，把它的姓名改成注册的姓名
#import "someAssist.h"

@interface RegisterViewController ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

{
    NSInteger _currentPage;
}

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *job;
@property (weak, nonatomic) IBOutlet UITextField *birth;
@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UITextField *pwd1;
@property (weak, nonatomic) IBOutlet UITextField *pwd2;

@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIPickerView *cityPicker;
@property (strong, nonatomic) NSArray *provinces;
@property (assign, nonatomic) NSInteger provinceIndex;
@property (assign, nonatomic) NSInteger cityIndex;
@property (assign, nonatomic) NSInteger currentPageNum;

- (IBAction)registerDoneBtn:(id)sender;//要判断两次密码是否一致、用户名是否可用
@property (weak, nonatomic) IBOutlet UIButton *registerDoneBtn;//用户名、两个密码框没有填内容时不能点完成按钮
@property (strong, nonatomic) NSMutableArray *accounts;//用于读取accounts.plist的数据，以及增加、修改账户字典

@end

@implementation RegisterViewController

@synthesize currentPageNum = _currentPage;

//懒加载省市数据,数组里存的是每一个省的模型数据，这个模型数据里面有city数组
-(NSArray *)provinces
{
    if (_provinces == nil)
    {
        
        NSString *path = [[NSBundle mainBundle]pathForResource:@"provinces" ofType:@"plist"];
        NSArray *dictArr = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *temp = [NSMutableArray array];
        for (NSDictionary *i in dictArr)
        {
            ProvincesMod *Mod = [ProvincesMod provinceWithDict:i];
            [temp addObject:Mod];
        }
        _provinces = temp;
    }
    return _provinces;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //默认是光标在账号上，一进来就填账号
    [self.account becomeFirstResponder];
//pragma mark Picker键盘一、设置输入框的代理
    _job.delegate = self;
    _birth.delegate = self;
    _city.delegate = self;
    
//pragma mark Picker键盘五、 调用设置目标Picker键盘的方法
    [self setUpBirthdayKeyboard];
    [self setUpCityKeyboard];
    
//    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject];
//    path = [path stringByAppendingPathComponent:@"accounts.plist"];
//    //如果文件不存在就创建文件，并写入初始数据
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    if (![fileManager fileExistsAtPath:path]) {
//        [fileManager createFileAtPath:path contents:nil attributes:nil];
//        //写入默认账户
//        NSMutableArray *tempArr = [NSMutableArray array];
//        NSDictionary *tempDict = [NSDictionary dictionaryWithObjectsAndKeys:@{@"account":@"zac4biz",@"password":@"123"},@{@"account":@"1",@"password":@"1"}, nil];
//        [tempArr addObject:tempDict];
//        [tempArr writeToFile:path atomically:YES];
//    }
//    self.accounts = [NSMutableArray arrayWithContentsOfFile:path];
    


//监听账户、密码是否都输入了，不然不能点完成按钮
    [self.account addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.pwd1 addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.pwd2 addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.name addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
}

-(void)textChange
{
    self.registerDoneBtn.enabled = self.account.text.length && self.pwd1.text.length && self.pwd2.text.length;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
//点击空白隐藏键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

//pragma mark Picker键盘三、定义一个点击输入框弹出PickerView的方法
//定义生日键盘
-(void)setUpBirthdayKeyboard
{
    //创建UIDatePicker，注意此控件自带有尺寸，所以不用frame
    //CHANGE_1，在外面声明的时候不用写weak，strong就可以了
    self.datePicker = [[UIDatePicker alloc]init];
    
    //设置地区：中国 zh，目的是为了显示中文的PickerView
    self.datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    
    //设置日期模式
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    
    
    //监听UIDatePicker的滚动，这个滚动的动作名字可以通过在xib中拖入控件再拖线时观察得到
    //这里用addTarget是因为datePicker居然没有delegate可以监听滚动
    //滚动时调用方法birth_dateChange:，给生日框赋值
    [self.datePicker addTarget:self action:@selector(birth_dateChange:) forControlEvents:UIControlEventValueChanged];
    
    
    //利用TextFiel的一个属性inputView实现点击时用某个UIView来进行输入
    self.birth.inputView = self.datePicker;
    
}

//定义城市键盘
-(void)setUpCityKeyboard
{
    //城市的值不像时间，有官方的DatePicker，只能自己用PickerView造了
    self.cityPicker = [[UIPickerView alloc]init];
    
    //这个PickerView的代理设置为self
    self.cityPicker.dataSource = self;
    self.cityPicker.delegate = self;
    
    self.city.inputView = self.cityPicker;
}

//pragma mark Picker键盘四、设置一下日期的格式以及赋值
//即使选择了DateMode日期还是2014-03-19 08:13:09 +0000这种格式
-(void)birth_dateChange:(UIDatePicker *)datePicker
{
    NSLog(@"%@",datePicker.date);
    //设置日期转字符串的格式fmt
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy-MM-dd";
    //stringFromDate：从XX按fmt转换成日期
    NSString *dateStr =[fmt stringFromDate:datePicker.date];
    //输入到生日框
    self.birth.text = dateStr;
}

//pragma mark Picker键盘四、设置城市PickerView的具体细节
#pragma mark UIPickerViewDataSource
//两个部分——省份、地区
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

//设置两部分（省、市）有多少个数据rows
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //'0'列显示省
    if (component == 0) {
        return self.provinces.count;
    }
    else{
        //'1'列根据省显示城市
        
        //provinceIndex：来自滚动的监听，表示获取的component0的第几个row
        //根据这个index获取第index个模型数据
        ProvincesMod *modData = self.provinces[_provinceIndex];
        return modData.cities.count;

    }
}

//设置PickerView显示的数据
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSLog(@"进入显示数据");
    if (component == 0)
    {
        //获取第row个省会的模型数据并显示省会名字
        ProvincesMod *modData = self.provinces[row];
        NSLog(@"component=0 %ld",row);
        return modData.name;
    }
    else
    {
        //出现市的数组下标溢出的问题的老方法是在这里通过selectedRowInComponent:0来定位省份，这没有考虑省份改变后要刷新城市再从城市component里面的row来确定是第几个城市
        //NSInteger index = [pickerView selectedRowInComponent:0];
        
        ProvincesMod *modData = self.provinces[self.provinceIndex];
        //component 为0 和为1的row是不同的
        NSLog(@"component=1 %ld",row);
        return modData.cities[row];
    }
}
#pragma mark UIPickerViewDelegate
//监听滚动？？？addTarget?? 将数据放到输入框中，这里不涉及PickerView的数据显示，数据显示在上一步已经做好了
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"进入监听");
    //如果选好了省份，就刷新右边的城市
    if (component == 0) {
#pragma mark 解决同时滚动省和市的时候，出现市的数组下标溢出的问题。选好省后再选择市
//这个问题的关键在于，在刷新城市部分显示出来的数据即component:2之前，就通过component:2的“selectedRowInComponent:0"获取了城市component的row，而，这时候省份如果改变了，获取到的row就只是前一个省份的城市的row，可能超过当前省份的城市数组下标
        self.provinceIndex = [pickerView selectedRowInComponent:0];
#pragma mark 所为联动——根据左边的省份刷新右边的城市
        //刷新右边的城市
        [pickerView reloadComponent:1];
        NSLog(@"执行完reloadcomponent:1了");
    }
//    这样写的话，如果没有滚动过右边的城市就获取不到self.cityIndex了
//    else{
//        self.cityIndex = [pickerView selectedRowInComponent:1];
//    }
    //输入到文本框中
    //根据选中的省份选定要取第几个模型数据
    ProvincesMod *modData = self.provinces[self.provinceIndex];
    //根据选中的城市选定从模型数据的cities中取第几个到文本框
    NSInteger index_city = [pickerView selectedRowInComponent:1];
    
    self.city.text = [NSString stringWithFormat:@"%@ %@",modData.name,modData.cities[index_city]];
}

#pragma mark delegate -<UITextFieldDelegate>
//pragma mark Picker键盘二、 代理方法中禁止所有已设置代理的输入框"进入编辑模式"
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(nonnull NSString *)string
{
    return NO;
    //此方法中的string是用户输入的值，所以还可以根据用户输入的东西来决定能不能编辑并做一些操作
}

//点击按钮时，判断账号是否已存在、两次密码是否一致，且姓名、账号、密码是必填项
- (IBAction)registerDoneBtn:(id)sender {
    //判断用户名是否可用
    
    if (![self.pwd1.text isEqualToString:self.pwd2.text])
    {
        NSLog(@"两次密码不一致");
        UIAlertController *wrongAccount = [UIAlertController alertControllerWithTitle:@"两次密码不一致" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [wrongAccount addAction:ok];
        [self presentViewController:wrongAccount animated:YES completion:nil];

    }
    else
    {
        NSLog(@"密码通过");
        NSURL *url = [NSURL URLWithString:[someAssist serverWith:@"register"]];
        NSMutableURLRequest *request_post = [NSMutableURLRequest requestWithURL:url];
        request_post.HTTPMethod =@"POST";
        request_post.timeoutInterval = 5;
        NSString *info = [NSString stringWithFormat:@"account=%@&pwd=%@",self.account.text,self.pwd1.text];
        request_post.HTTPBody = [info dataUsingEncoding:NSUTF8StringEncoding];
        
        [NSURLConnection sendAsynchronousRequest:request_post queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            if(connectionError){
                NSLog(@"registerBtn请求失败---%@",connectionError);
                [someAssist alertWith:@"请求失败" viewController:self];
            }
            else{
                NSString *judge = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                if ([judge isEqualToString:@"done"]) {
                    [someAssist alertWith:@"注册成功" viewController:self];
                    [self performSegueWithIdentifier:@"register2entry" sender:nil];
                }
                else if([judge isEqualToString:@"not done"]){
                    [someAssist alertWith:@"注册失败" viewController:self];
                }
                else if([judge isEqualToString:@"existed"]){
                    [someAssist alertWith:@"账户已存在" viewController:self];
                }
            }
        }];
        
    }
    
}

//把注册时写的姓名传给entryView
//此方法会在跳转前调用，调用完这个方法才会进入跳转
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //获取跳转目标ViewController
    EntryViewController *vc_temp = segue.destinationViewController;
    //这个是当前ViewController的self
//    [vc_temp.nameBtn setTitle:self.name.text forState:UIControlStateNormal];
    vc_temp.title = self.name.text;
    
}

@end
