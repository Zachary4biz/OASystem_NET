//
//  someAssist.h
//  OASystem_NET
//
//  Created by 周桐 on 16/9/1.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompletionBlock)(id object);
typedef id(^CompletionBlock_WithReturn)(id object);


#define tellResult(result) \
if ([result isKindOfClass:[NSString class]]) {\
    if ([result isEqualToString:@"connect fail"]){\
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{\
            [someAssist alertWith:@"连接服务器失败" viewController:self];\
        }];\
        result = nil;\
    }\
    else if ([result isEqualToString:@"json fail"]){\
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{\
            [someAssist alertWith:@"读取数据失败" viewController:self];\
        }];\
        result = nil;\
    }\
    else if ([result isEqualToString:@"not login"]){\
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{\
    [someAssist alertAndExitWith:@"登录失效" viewController:self];\
    }];\
    result = nil;\
    }\
    else{\
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{\
            [someAssist alertWith:@"未知错误" viewController:self];\
        }];\
        result = nil;\
    }\
}\


typedef NS_ENUM(NSInteger,wait_action){
    start = 0,
    stop
};



@interface someAssist : NSObject

+ (instancetype)shareAssist;



//弹窗
+(void)alertWith:(NSString *)str viewController:(UIViewController *)vc;
+(void)alertAndExitWith:(NSString *)str viewController:(UIViewController *)vc;
+(void)alertAndDisappearWith:(NSString *)str viewController:(UIViewController *)vc;

//蒙版
-(void)showWait:(UIViewController *)VC;
-(void)dismissWait:(UIViewController *)VC;


//获取时间
+(NSString *)getDate;
+(NSString *)getTime;

//获取服务器地址
@property (nonatomic,strong)NSString *server;
+(NSString *)serverWith:(NSString *)str;//http://192.168.1.103:8080/str

//获取图片
+(NSString *)picWithName:(NSString*)name ext:(NSString *)ext;
//http://192.168.1.103:8080/static/pics/name.ext

//获取数据
+(void)getContacts_modArrWithCompletionBlock:(CompletionBlock)completion;
+(void)getBoard_modArrWithCompletionBlock:(CompletionBlock)completion;
+(void)getSelfInfo_json:(NSString *)usr Complemention:(CompletionBlock)complete;
+(void)getCloudDisk_modArrWithCompletionBlock:(CompletionBlock)completion;
-(void)downloadFileWithrequest:(NSMutableURLRequest *)request; //要在代理里面判断是哪个session进去的，所以要用成员变量，必须是实例方法,同时将下载完成的block写到了代理didFInished里面
-(void)suspendDownload;//暂停
@property(nonatomic,strong)NSString *cachesPath;//保存的路径，使用dataTask后，这个要从外面传进来，mod里面在读json时就根据文件名设置好了保存的路径
@property(nonatomic,assign)float progress;//全局接收进度的，writeData接收，在download函数里面的block传出去
@property(nonatomic,strong)void (^progressblock)(float progress);//传进度的block
@property(nonatomic,strong)void (^completeDownloadBlock)(NSString *cachesPath);//因为使用了代理，所以下载完成也要在代理里面了，要单独搞个blcok出来
@property(nonatomic,strong)void (^resultBlock)(NSError *error);//请求完毕的结果，放在代理里面，看有没有报错
@property(nonatomic,strong)NSData* (^getLocalResumeDataBlock)(); //获得本地的resumeData

//通用获取json
+(void)getJson:(NSMutableURLRequest *)request Completion:(CompletionBlock)completion;
@end










