//
//  TimeViewController.m
//  OASystem
//
//  Created by 周桐 on 16/8/23.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "TimeViewController.h"
#import "someAssist.h"
@interface TimeViewController ()
- (IBAction)doneBtn:(id)sender;

@end

@implementation TimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"---");
    
    NSLog(@"---");
    [someAssist alertAndExitWith:@"测试alertVC的消失" viewController:self];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];


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

- (IBAction)doneBtn:(id)sender {
    someAssist *s = [[someAssist alloc]init];
    [s showWait:self];
    sleep(5);
    [s dismissWait:self];
}
@end
