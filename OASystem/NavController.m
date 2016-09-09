//
//  ViewController.m
//  OASystem
//
//  Created by 周桐 on 16/8/22.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "NavController.h"
#import "anotherViewController.h"
@interface NavController ()
- (IBAction)btn1;

@end

@implementation NavController

//重写了loadView之后，默认的xib中的view都不会加载了，按重写的加载
//通常用于webView
//-(void)loadView
//{
//    self.view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    
//    self.view.backgroundColor = [UIColor redColor];
//    
//}

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
//跳转到另一个ViewController
- (IBAction)btn1 {
//    //创建另一个VC,以另一个VC的类型来初始化
    anotherViewController *anotherVC = [[anotherViewController alloc]init];
    anotherVC.view.backgroundColor = [UIColor blackColor];
    //拿到自己的navigation，并执行跳转
    [self.navigationController pushViewController:anotherVC animated:YES];
    
}
@end



























