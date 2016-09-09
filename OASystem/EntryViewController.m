//
//  InfoViewController.m
//  OASystem
//
//  Created by 周桐 on 16/8/19.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "EntryViewController.h"
#import "ContactsViewController.h"
#import "SelfInfoViewController.h"
#import "ContactsMod.h"
#import "boardMod.h"
#import "selfInfoMod.h"
#import "someAssist.h"
#import "BoardViewController.h"


@interface EntryViewController ()
//- (IBAction)get2contacts:(id)sender;
////- (IBAction)get2selfInfo:(id)sender;
//
//- (IBAction)get2selfInfo:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UIButton *contactsBtn;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UIButton *nameBtn;
@property (weak, nonatomic) IBOutlet UIButton *accountBtn;
@property (weak, nonatomic) IBOutlet UIButton *boardBtn;

@property (strong,nonatomic)NSTimer *timer;//用来在viewDidDisappear中实现repeat刷新时间btn
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

- (IBAction)nameBtn:(id)sender;
@property(strong,nonatomic)id result4selfInfo;//用来判断联网是否成功
@property(strong,nonatomic)selfInfoMod *selfInfoMod;//如果联网成功，用来保存模型并保存到Cache
- (IBAction)contactsBtn:(id)sender;
- (IBAction)accountBtn:(id)sender;
- (IBAction)boardBtn:(id)sender;
- (IBAction)messageBtn:(id)sender;


@end

@implementation EntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //设置nameBtn的字，这里的self.name定义在头文件
    [self.nameBtn setTitle:self.name forState:UIControlStateNormal];
    NSString *contactsBtn_title = [NSString stringWithFormat:@"%@个联系人",self.contacts_count];
    [self.contactsBtn setTitle:contactsBtn_title forState:UIControlStateNormal];
    //隐藏回退按钮、左按钮
    self.navigationItem.hidesBackButton = YES;
    
    //设置时间按钮的文字为实时刷新，刷新会一直闪，改成Btn透明，后面加Lable和View
    self.dateLabel.text = [someAssist getDate];
    self.timeLabel.text = [someAssist getTime];
    
    UIApplication *app = [UIApplication sharedApplication];
    
    //设置联网状态
    app.networkActivityIndicatorVisible = YES;
    
    
    //调用somAssist的方法，获取联系人的模型数组
    id result = [someAssist getContacts];
    if ([result isKindOfClass:[NSString class]]) {
        [someAssist alertWith:result viewController:self];
    }
    else if ([result isKindOfClass:[NSMutableArray class]]){
        _modArr = result;
}
   
    
//    //创建用户通知
//    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
//    
//    //注册用户通知
//    [app registerUserNotificationSettings:settings];
//    
//    //设置提醒数
//    app.applicationIconBadgeNumber = 5;
//    NSLog(@"消息提醒数5");

}



-(void)viewDidAppear:(BOOL)animated{
    //设置时间按钮的文字为1s刷新一次,改成用Btn透明，后面放Lable和蓝色的View
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(run) userInfo:nil repeats:YES];
    
//    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(run)];
//    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];

}

-(void)run
{
    self.dateLabel.text = [someAssist getDate];
    self.timeLabel.text = [someAssist getTime];
    NSLog(@"updatetimeBtntitleLabel..");
}

-(void)viewWillAppear:(BOOL)animated{
    self.view.alpha = 1;
//    self.navigationController.navigationItem.leftBarButtonItem = nil;
//    隐藏左按钮不是这样隐藏的，应该是self.navigationItem.hidesBackButton = YES;，已写在viewDidLoad里
}

-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"disappear-----------------------------------------");
    self.view.alpha = 0;
    //此VC要消失的时候，停止刷新时间的self.timer，并释放掉
    [self.timer invalidate];
    self.timer = nil;
;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([segue.identifier isEqualToString:@"entry2selfInfo"]) {
        SelfInfoViewController *vc = segue.destinationViewController;
        vc.mod = self.selfInfoMod;
    }
    
    if ([segue.identifier isEqualToString:@"entry2board"]) {
        BoardViewController *temp_VC = segue.destinationViewController;
    }
    
}


//- (IBAction)get2contacts:(id)sender {
////    ContactsViewController *anotherVC = [[ContactsViewController alloc]init];
//    ContactsViewController *anotherVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"contacts"];
//    [self.navigationController pushViewController:anotherVC animated:YES];
//}
//
//- (IBAction)get2selfInfo:(id)sender {
//    SelfInfoViewController *anotherVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"selfInfo"];
//    [self.navigationController pushViewController:anotherVC animated:YES];
//}


- (IBAction)nameBtn:(id)sender {
    self.nameBtn.enabled = NO;
    someAssist *hud = [[someAssist alloc]init];
    [hud showWait:self];
    [someAssist getSelfInfo_json:@"zac" Complemention:^(id object) {
        tellResult(object);
        //结果需要回到主线程判断，因为跳转时在主线程，不在主线程判断可能跳转了但是数据没接到
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (object == nil) {
                self.result4selfInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:selfInfoModPath];
            }
            else{
                self.result4selfInfo = object;
                self.selfInfoMod = [selfInfoMod selfInfoWithDict:object[0]];
                [NSKeyedArchiver archiveRootObject:self.selfInfoMod toFile:selfInfoModPath];
            }
            
                [hud dismissWait:self];
                self.nameBtn.enabled=YES;
                [self performSegueWithIdentifier:@"entry2selfInfo" sender:nil];
        }];
    }];
}

- (IBAction)contactsBtn:(id)sender {
    self.contactsBtn.enabled = NO;
    someAssist *hud = [[someAssist alloc]init];
    [hud showWait:self];
    [someAssist getSelfInfo_json:@"zac" Complemention:^(id object) {
        tellResult(object);
        //结果需要回到主线程判断，因为跳转时在主线程，不在主线程判断可能跳转了但是数据没接到
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (object == nil) {
                self.result4selfInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:selfInfoModPath];
            }
            else{
                self.result4selfInfo = object;
                self.selfInfoMod = [selfInfoMod selfInfoWithDict:object[0]];
                [NSKeyedArchiver archiveRootObject:self.selfInfoMod toFile:selfInfoModPath];
            }
            
            [hud dismissWait:self];
            self.nameBtn.enabled=YES;
            [self performSegueWithIdentifier:@"entry2selfInfo" sender:nil];
        }];
    }];
    
}

- (IBAction)accountBtn:(id)sender {
}

- (IBAction)boardBtn:(id)sender {
}

- (IBAction)messageBtn:(id)sender {
}
@end
