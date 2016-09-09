//
//  selfInfoMod.m
//  OASystem_NET
//
//  Created by 周桐 on 16/9/8.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "selfInfoMod.h"

@implementation selfInfoMod

+(instancetype)selfInfoWithDict:(NSDictionary *)jsonObject_dic
{
    selfInfoMod *Mod = [[self alloc]init];
    //    [Mod setValuesForKeysWithDictionary:dict];//json的[0]到底是不是一个字典//好像不行
    Mod.name = jsonObject_dic[@"name"];
    Mod.phone = jsonObject_dic[@"phone"];
    Mod.job = jsonObject_dic[@"job"];
    Mod.city = jsonObject_dic[@"city"];
    Mod.birth = jsonObject_dic[@"birth"];
    Mod.account = jsonObject_dic[@"account"];
    Mod.pwd = jsonObject_dic[@"pwd"];
    Mod.priority = jsonObject_dic[@"priority"];
    Mod.eid = jsonObject_dic[@"eid"];
    return Mod;
}

@end
