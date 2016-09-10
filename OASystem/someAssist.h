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
//弹窗
+(void)alertWith:(NSString *)str viewController:(UIViewController *)vc;
+(void)alertAndExitWith:(NSString *)str viewController:(UIViewController *)vc;

//获取时间
+(NSString *)getDate;
+(NSString *)getTime;

//获取服务器地址
@property (nonatomic,strong)NSString *server;
+(NSString *)serverWith:(NSString *)str;//http://192.168.1.103:8080/str

//获取图片
+(NSString *)picWith:(NSString*)name :(NSString *)ext;
//http://192.168.1.103:8080/static/pics/name.ext

//获取数据
+(void)getContacts_modArrWithCompletionBlock:(CompletionBlock)completion;
+(void)getBoard_modArrWithCompletionBlock:(CompletionBlock)completion;
+(void)getSelfInfo_json:(NSString *)usr Complemention:(CompletionBlock)complete;

//蒙版
-(void)showWait:(UIViewController *)VC;
-(void)dismissWait:(UIViewController *)VC;

//通用获取json
+(void)getJson:(NSMutableURLRequest *)request Completion:(CompletionBlock)completion;
@end










