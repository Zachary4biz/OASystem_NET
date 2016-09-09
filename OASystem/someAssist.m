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




@interface someAssist()
#warning  如何删除UIAlertController？？？？
@property(nonatomic,strong) UIAlertController *alertController;//想实现类似MBProgress的蒙版效果
@property(nonatomic, strong)UIAlertView *alertView;
@end

@implementation someAssist

+(void)alertWith:(NSString *)str viewController:(UIViewController *)vc{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:str message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action  = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
    [alert addAction:action];
    [vc presentViewController:alert animated:YES completion:nil];
    
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


+(NSString *)serverWith:(NSString *)str{
    
    NSString *root = @"http://192.168.1.103:8080";
//    NSString *root = @"http://192.168.10.111:8080";
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",root,str];
    return urlStr;
//    return @"http://127.0.0.1:8080";
}



+(NSString *)picWith:(NSString*)name :(NSString *)ext{
    NSString *iconStr = [[someAssist serverWith:@"static/pics"] stringByAppendingPathComponent:name];
    iconStr = [iconStr stringByAppendingPathExtension:ext];
    return iconStr;
}

+(void)getJson:(NSURL *)url Completion:(CompletionBlock)completion{
#warning 还能有别的传消息方式吗，block里面不能return
    
    __block NSArray *jsonObject = nil;
    //建立task，默认就新开一条线程
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
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

+(id)getContacts{
    //得到url
    NSURL *url = [NSURL URLWithString:[someAssist serverWith:@"contacts_json"]];
    
    //get方式请求，同步请求
    NSMutableURLRequest *request_get = [NSMutableURLRequest requestWithURL:url];
    request_get.timeoutInterval = 5;
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request_get returningResponse:&response error:&error];
//    [NSURLConnection sendAsynchronousRequest:request_get queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//        if (connectionError) {
//            NSLog(@"getContacts请求失败---%@",error);
//            return @"connect fail";
//        }
//        else{
//            //处理得到的json数据
//            NSError *error4json = nil;
//            NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error4json];
//            
//            //json数据以字典形式存入模型，再把模型存入数组,json数据可以当做字典来用
//            NSMutableArray *tempArr = [NSMutableArray array];
//            for(int i=0;i<jsonObject.count;i++){
//                ContactsMod *mod_temp = [ContactsMod contactsWithDict:jsonObject[i]];
//                [tempArr addObject:mod_temp];
//            }
//            return tempArr;
//    }];
    
    if (error){
        NSLog(@"getContacts请求失败---%@",error);
        NSString *er =@"连接服务器失败";
        return er;
    }
    else{
        //处理得到的json数据
        NSError *error4json = nil;
        NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error4json];
        
        //json数据以字典形式存入模型，再把模型存入数组,json数据可以当做字典来用
        NSMutableArray *tempArr = [NSMutableArray array];
        for(int i=0;i<jsonObject.count;i++){
            ContactsMod *mod_temp = [ContactsMod contactsWithDict:jsonObject[i]];
            [tempArr addObject:mod_temp];
        }
        return tempArr;
    }
}

+(id)getBoard_modArr{
    //得到url
    
    NSURL *url = [NSURL URLWithString:[someAssist serverWith:@"board_json"]];
    //get方式请求，同步请求
    NSMutableURLRequest *request_get = [NSMutableURLRequest requestWithURL:url];
    request_get.timeoutInterval = 5;
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request_get returningResponse:&response error:&error];
    
    if (error){
        NSLog(@"getBoard请求失败---%@",error);
        NSString *er =@"connect fail";
        return er;
    }
    else{
        //处理得到的json数据
        NSError *error4json = nil;
        NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error4json];
        if (error4json) {
            return @"json fail";
        }
        else{
            //json数据以字典形式存入模型，再把模型存入数组,json数据可以当做字典来用
            NSMutableArray *tempArr = [NSMutableArray array];
            for(int i=0;i<jsonObject.count;i++){
#warning 比如这里，跟getContacts差别其实只在于模型的类不同，一个是boardMod一个是ContactsMod，如何根据传入参数来修改这个类名？？这里参考setvalueforkeywithdictionary那个方法，它不就实现了么
                boardMod *mod_temp = [boardMod boardWithDict:jsonObject[i]];
                [tempArr addObject:mod_temp];
            }
            return tempArr;
        }
    }
}

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

-(void)showWait:(UIViewController *)VC{
//    self.alertController = [UIAlertController alertControllerWithTitle:@"请稍后" message:nil preferredStyle:UIAlertControllerStyleAlert];
//    [VC presentViewController:self.alertController animated:YES completion:nil];
    self.alertView = [[UIAlertView alloc]initWithTitle:@"请稍后" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [_alertView show];
}
-(void)dismissWait:(UIViewController *)VC{
//    [self.alertController removeFromParentViewController];
    [_alertView dismissWithClickedButtonIndex:0 animated:YES];
}

@end
