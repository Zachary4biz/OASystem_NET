//
//  someAssist.h
//  OASystem_NET
//
//  Created by 周桐 on 16/9/1.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompletionBlock)(id object);


#define tellResult(result) \
if ([result isKindOfClass:[NSString class]]) {\
    if ([result isEqualToString:@"connect fail"]){\
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{\
            [someAssist alertWith:@"连接服务器失败" viewController:self];\
        }];\
        result = nil;\
    }\
    else if ([result isEqualToString:@"json faile"]){\
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{\
            [someAssist alertWith:@"读取数据失败" viewController:self];\
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

+(void)alertWith:(NSString *)str viewController:(UIViewController *)vc;
+(NSString *)getDate;
+(NSString *)getTime;
@property (nonatomic,strong)NSString *server;

+(NSString *)serverWith:(NSString *)str;//http://192.168.1.103:8080/str

+(NSString *)picWith:(NSString*)name :(NSString *)ext;
//http://192.168.1.103:8080/static/pics/name.ext
+(id) getContacts;
+(id) getBoard_modArr;
+(void)getSelfInfo_json:(NSString *)usr Complemention:(CompletionBlock)complete;
-(void)showWait:(UIViewController *)VC;
-(void)dismissWait:(UIViewController *)VC;
+(void)getJson:(NSURL *)url Completion:(CompletionBlock)completion;
@end










