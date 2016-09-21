//
//  someAssist.m
//  OASystem_NET
//
//  Created by 周桐 on 16/9/1.
//  Copyright © 2016年 周桐. All rights reserved.
//


#import "someAssist.h"
#import "ContactsMod.h"
#import "boardMod.h"
#import "CloudDiskMod.h"




@interface someAssist() <NSURLSessionDataDelegate> //dataDelegate同时自身也遵守了NSURLDelegate
#pragma UI
#warning  如何删除UIAlertController？？？？
//@property(nonatomic,strong) UIAlertController *alertController;//想实现类似MBProgress的蒙版效果
@property(nonatomic, strong)UIAlertView *alertView;

#pragma functional
//用在代理里面识别是哪一个session
@property(nonatomic,strong)NSURLSession *sessionDownload;//下载云盘文件用的下载session
@property(nonatomic,strong)NSString *cachesPath;//保存的路径，要传给云盘的VC
@property(nonatomic,strong)NSData *resumeData;//跟downloadTask配套使用，用来在cancel后，当恢复标识用

@end

@implementation someAssist
//------------------------------------------以下一些小功能------------------------------------
#pragma 小功能

+ (instancetype)shareAssist {
    static someAssist *shareAssist = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareAssist = [[self alloc] init];
    });
    return shareAssist;
}

+(NSString *)serverWith:(NSString *)str{
    
    //    NSString *root = @"http://192.168.1.104:8080";
    //    NSString *root = @"http://127.0.0.1:8080";
        NSString *root = @"http://192.168.10.113:8080";
//    NSString *root = @"http://192.168.191.1:8080";
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",root,str];
    return urlStr;
    
}

+(void)alertWith:(NSString *)str viewController:(UIViewController *)vc{
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:str message:nil preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *action  = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
//    [alert addAction:action];
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//        [vc presentViewController:alert animated:YES completion:nil];
//    }];
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:str message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    
}

+(void)alertAndExitWith:(NSString *)str viewController:(UIViewController *)vc{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:str message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action  = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了确定?");
        [vc.navigationController popToRootViewControllerAnimated:YES];
    }];
    [alert addAction:action];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [vc presentViewController:alert animated:YES completion:nil];
    }];
    
}

+(void)alertAndDisappearWith:(NSString *)str viewController:(UIViewController *)vc{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:str message:nil preferredStyle:UIAlertControllerStyleAlert];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertController removeFromParentViewController];
    });
}

+(NSString *)getDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
//    NSString *t = [formatter stringFromDate:[NSDate date]];
    return [formatter stringFromDate:[NSDate date]];
    

}

+(NSString *)getTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm:ss"];
    //    NSString *t = [formatter stringFromDate:[NSDate date]];
    return [formatter stringFromDate:[NSDate date]];
}

-(void)showWait:(UIViewController *)VC{
    //    self.alertController = [UIAlertController alertControllerWithTitle:@"请稍后" message:nil preferredStyle:UIAlertControllerStyleAlert];
    self.alertView = [[UIAlertView alloc]initWithTitle:@"请稍后" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        //        [VC presentViewController:self.alertController animated:YES completion:nil];
        [_alertView show];
    }];
}
-(void)dismissWait:(UIViewController *)VC{
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        //        [self.alertController removeFromParentViewController];
        [_alertView dismissWithClickedButtonIndex:0 animated:NO];
    }];
}


+(NSString *)picWithName:(NSString*)name ext:(NSString *)ext{
    NSString *iconStr = [[someAssist serverWith:@"static/pics"] stringByAppendingPathComponent:name];
    iconStr = [iconStr stringByAppendingPathExtension:ext];
    return iconStr;
}

//--------------------------------------------以上一些小功能-------------------------------------------



//----------------------------------------——————————-发送网络请求获取数据--------------------————————————————-
#pragma 发送请求获取数据
+(void)getJson:(NSMutableURLRequest *)request Completion:(CompletionBlock)completion
{
    __block NSArray *jsonObject = nil;
    //建立task，默认就新开一条线程
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                NSLog(@"getJson连接失败--%@",error);
                completion(@"connect fail");
            }
            else{
                NSError *er4json = nil;
                jsonObject = [NSJSONSerialization JSONObjectWithData:data  options:NSJSONReadingAllowFragments error:&er4json];
                if (er4json) {
                    NSLog(@"json错误--%@",er4json);
                    completion(@"json fail");
                }
                else{
                    completion(jsonObject);
                }
            }
        }];
    //task启动
    [task resume];

}
//获取联系人的模型数组
+(void)getContacts_modArrWithCompletionBlock:(CompletionBlock)completion{
    //得到url
    NSURL *url = [NSURL URLWithString:[someAssist serverWith:@"contacts_json"]];
    
    NSMutableURLRequest *request_get = [NSMutableURLRequest requestWithURL:url];
    request_get.timeoutInterval = 3;
    
    //使用NSURLSession
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request_get completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"getContacts连接失败--%@",error);
            completion(@"connect fail");
        }
        else{
            //由于服务器重启，返回值可能是not_login字符串
            NSString *dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            
            if ([dataStr isEqualToString:@"not login"]) {
                completion(@"not login");
            }
            else{
                NSError *er4json = nil;
                NSArray *jsonObject = nil;
                jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&er4json];
                if (er4json) {
                    NSLog(@"getContacts读取Json失败--%@",er4json);
                    completion(@"json fail");
                }
                else{
                    NSMutableArray *tempArr = [NSMutableArray array];
                    for (id i in jsonObject){
                        ContactsMod *mod =[ContactsMod contactsWithDict:i];
                        [tempArr addObject:mod];
                    }
                    completion(tempArr);
                }
            }
        }
    }];
    
    [task resume];
}
//获取公告的模型数组
+(void)getBoard_modArrWithCompletionBlock:(CompletionBlock)completion{
    //得到url
    NSURL *url = [NSURL URLWithString:[someAssist serverWith:@"board_json"]];
    //get方式请求
    NSMutableURLRequest *request_get = [NSMutableURLRequest requestWithURL:url];
    request_get.timeoutInterval = 5;

    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request_get completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"getBoard连接失败--%@",error);
            completion(@"connect fail");
        }
        else{
            //由于服务器重启，返回值可能是not_login字符串
            NSString *dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            if ([dataStr isEqualToString:@"not login"]) {
                completion(@"not login");
            }
            else{
                NSError *er4json = nil;
                NSArray *jsonObject = nil;
                jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&er4json];
                if (er4json) {
                    NSLog(@"getBoard读取Json失败--%@",er4json);
                    completion(@"json fail");
                }
                else{
                    NSMutableArray *tempArr = [NSMutableArray array];
                    for (id i in jsonObject){
                        boardMod *mod =[boardMod boardWithDict:i];
                        [tempArr addObject:mod];
                    }
                    completion(tempArr);
                }
            }
        }
    }];
    [task resume];
    
}
//获取个人信息的json字符 NSArray类型
+(void)getSelfInfo_json:(NSString *)usr Complemention:(CompletionBlock)complete
{
    
    NSURL *url = [NSURL URLWithString:[someAssist serverWith:@"usr"]];
    NSMutableURLRequest *request_post = [NSMutableURLRequest requestWithURL:url];
    
    request_post.HTTPMethod =@"POST";
    request_post.timeoutInterval = 5;
    NSString *info = [NSString stringWithFormat:@"account=%@",usr];
    request_post.HTTPBody = [info dataUsingEncoding:NSUTF8StringEncoding];
    
    __block NSArray *jsonObject = nil;
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request_post completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"getJson连接失败--%@",error);
            complete(@"connect fail");
        }
        else{
            NSError *er4json = nil;
            jsonObject = [NSJSONSerialization JSONObjectWithData:data  options:NSJSONReadingAllowFragments error:&er4json];
            if (er4json) {
                NSLog(@"json错误--%@",er4json);
                complete(@"json fail");
            }
            else{
                complete(jsonObject);
            }
        }
    }];
    
    [task resume];

}
//获取云盘的模型数组
+(void)getCloudDisk_modArrWithCompletionBlock:(CompletionBlock)completion
{
    
    NSURL *url = [NSURL URLWithString:[someAssist serverWith:@"cloudDisk_json"]];
    NSMutableURLRequest *request_get = [NSMutableURLRequest requestWithURL:url];
    request_get.timeoutInterval = 5;
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request_get completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"getCloudDisk连接失败--%@",error);
            completion(@"connect fail");
        }
        else{
            //由于服务器重启，返回值可能是not_login字符串
            NSString *dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            if ([dataStr isEqualToString:@"not login"]) {
                completion(@"not login");
            }
            else{
                NSError *er4json = nil;
                NSArray *jsonObject = nil;
                jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&er4json];
                if (er4json) {
                    NSLog(@"getCloudDisk读取Json失败--%@",er4json);
                    completion(@"json fail");
                }
                else{
                    NSMutableArray *tempArr = [NSMutableArray array];
                    for (id i in jsonObject){
                        CloudDiskMod *mod = [CloudDiskMod cloudDiskWithDict:i];
                        [tempArr addObject:mod];
                    }
                    completion(tempArr);
                }
            }
        }
    }];
    [task resume];
    
    
}
//下载文件（用于云盘下载按钮），不能再搞类方法了，必须用实例方法，不然：类方法-->不能用成员变量-->不能全局找出这个session-->不能在代理中区分这个session
-(void)downloadFileWithrequest:(NSMutableURLRequest *)request
{
//    [_downloadTask addObserver:self forKeyPath:@"downloadTask" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    //使用了代理，所以下载完成后的操作block要写在代理里面了,completeDownloadBlock
    //建立下载任务 DownloadTask
    self.sessionDownload = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc]init]];
    //获得resumeData
    if (_getLocalResumeDataBlock()) {
        _resumeData = _getLocalResumeDataBlock();
    }
    //检查resumeData
    if (_resumeData) {
        _downloadTask = [_sessionDownload downloadTaskWithResumeData:_resumeData];
    }
    else{
        _downloadTask = [_sessionDownload downloadTaskWithRequest:request];
    }
    
    
    //启动下载任务
    [_downloadTask resume];
}

//-(void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
//{
//    if ([keyPath isEqualToString:@"downloadTaks"]) {
//        NSLog(@"值发生改变---");
//    }
//}
//停止下载，类似点击暂停按钮
-(void)suspendDownloadWithCompleteBlock:(CompletionBlock)completion
{
    [_downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        completion(resumeData);
    }];
#warning 未完成，如果要实现退出程序再打开还能继续下载，这里需要把暂停前写好的文件提出来，继续下载，见08-nsurlsession断点下载
}
//————————————————————————————————————发送网络请求获取数据————————————————————————————


//------------------------------------NSURLSession的代理------------------------------------------
#pragma NSURLSessionDataDelegate
//dataTask的代理方法

//1.收到服务器响应
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    if (session == _sessionDownload) {
        NSLog(@"didReceiveResponse");
        NSLog(@"%s",__func__);
    }
    //允许处理服务器响应，这样才会继续接收服务器数据
    completionHandler(NSURLSessionResponseAllow);
}
//2.收到数据的时候（可能被调用多次）
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    if (session == _sessionDownload) {
        NSLog(@"%s",__func__);
    }
}
//3.请求完毕（成功失败都来这里），有错就有error，没有就error为空，不同task的这个代理是一样的，写在下面了
//-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
//{
//    if (session == _sessionDownload) {
//        NSLog(@"%s",__func__);
//    }
//}

//downloadTask的代理方法
-(void)URLSession:(NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    NSLog(@"有没有来到这里？到底为什么在suspend函数里面的_downloadTask是nil");
}

// 开始写入数据，会多次调用
-(void)URLSession:(NSURLSession*)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    //totalBytesExpectedToWrite：文件总大小
    //totalBytesWritten：已写入的大小
    //bytesWritten：当前这次调用要写多少
//    NSLog(@"writeData");
    if (session == _sessionDownload) {
        self.progress = 1.0 * totalBytesWritten/totalBytesExpectedToWrite;
//        NSLog(@"%lld-%lld",totalBytesWritten,totalBytesExpectedToWrite);
//        NSLog(@"progress is ---%f", self.progress);
        if (_progressblock) {
            //这里用来更新progressUI的，需要在主线程调用
//            NSLog(@"progress is ---%f", self.progress);
            dispatch_async(dispatch_get_main_queue(), ^{
                _progressblock(_progress);
            });
        }
    }
//    NSLog(@"---%f",totalBytesWritten/totalBytesExpectedToWrite *1.0);
}
//下载完成，来到这里，需要剪切一下下载的文件
-(void)URLSession:(NSURLSession*)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(nonnull NSURL *)location
{
    if (session == _sessionDownload) {
        NSLog(@"开始剪切");
        //默认下载location的位置在temp
        //剪切到我们想要的路径——NSCaches，保存的文件名也是服务器上的文件名,来自downloadTask.response.suggestedFileName
        _cachesPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
        
        NSFileManager *mgr=[NSFileManager defaultManager];
        //注意到locatino是用URL形式给出来的所以要用moveItemAtURL而不是path
        [mgr moveItemAtURL:location toURL:[NSURL fileURLWithPath:_cachesPath] error:nil];
        if(_completeDownloadBlock)
        {
            _completeDownloadBlock(_cachesPath);
        }
    }
}


-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"error is %@",error);
    if (_resultBlock) {
        _resultBlock(error);
    }
}
//------------------------------------NSURLSession的代理------------------------------------------

@end
