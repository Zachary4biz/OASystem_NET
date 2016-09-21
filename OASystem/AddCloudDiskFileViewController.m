//
//  AddCloudDiskFileViewController.m
//  OASystem_NET
//
//  Created by 周桐 on 16/9/19.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "AddCloudDiskFileViewController.h"

@interface AddCloudDiskFileViewController ()
- (IBAction)doneBtn:(id)sender;
- (IBAction)uploadBtn:(id)sender;

@end

@implementation AddCloudDiskFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (IBAction)doneBtn:(id)sender {
}

- (IBAction)uploadBtn:(id)sender {
    NSURLSession *sessionUpload = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:@""];
    NSMutableURLRequest *request_post = [NSMutableURLRequest requestWithURL:url];
    request_post.HTTPMethod = @"POST";
//    request_post.HTTPBody = //不能用.HTTPBody，会被uploadTask忽略，要自己建一个data数据
    //要上传的数据
    NSMutableData *data2upload = [NSMutableData data];
    
    //文件参数
    //分割线
    //文件参数名
    //文件类型
    //文件数据
    //结束标记
    
    
    NSURLSessionUploadTask *uploadTask = [sessionUpload uploadTaskWithRequest:request_post fromData:data2upload completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"done,error is %@",error);
        [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    }];
    
    [uploadTask resume];
    
    
}
@end
