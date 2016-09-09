//
//  anotherViewController.m
//  OASystem
//
//  Created by 周桐 on 16/8/22.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "anotherViewController.h"

@interface anotherViewController ()
- (IBAction)Show:(id)sender;

@end

@implementation anotherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)Show:(id)sender {
    NSLog(@"%@", self.navigationController);
}
@end
