//
//  AccountSettingViewController.m
//  OASystem
//
//  Created by 周桐 on 16/8/23.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "AccountSettingViewController.h"
#import "someAssist.h"

@interface AccountSettingViewController ()<UIActionSheetDelegate>
- (IBAction)resign:(id)sender;

@end

@implementation AccountSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

    // Do any additional setup after loading the view.
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

- (IBAction)resign:(id)sender {
    NSLog(@"注销");
    //弹出actionsheet
//    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"确认注销？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"注销" otherButtonTitles:nil, nil];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认注销?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"注销" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:[someAssist serverWith:@"resign"]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSLog(@"%@",result);
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:ok];
    [alert addAction:no];
    [self presentViewController:alert animated:YES completion:nil];
    
}
//-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    //点击了注销按钮
//    if ( buttonIndex == 0){
//        
//        [self.navigationController popToRootViewControllerAnimated:YES];
//        
//    }
//}

@end
