//
//  boardMod.h
//  OASystem_NET
//
//  Created by 周桐 on 16/9/7.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface boardMod : NSObject<NSCoding>
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *date;
@property(nonatomic,strong)NSString *provider;
@property(nonatomic,strong)NSString *ddl;
@property(nonatomic,strong)NSString *ID;
//确定是否显示选中的勾
@property(nonatomic,assign)NSInteger check;

+(instancetype)boardWithDict:(NSDictionary *)dic;
@end
