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

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_phone forKey:@"phone"];
    [aCoder encodeObject:_job forKey:@"job"];
    [aCoder encodeObject:_city forKey:@"city"];
    [aCoder encodeObject:_birth forKey:@"birth"];
    [aCoder encodeObject:_account forKey:@"account"];
    [aCoder encodeObject:_pwd forKey:@"pwd"];
    [aCoder encodeObject:_priority forKey:@"priority"];
    [aCoder encodeObject:_eid forKey:@"eid"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    _name = [aDecoder decodeObjectForKey:@"name"];
    _phone = [aDecoder decodeObjectForKey:@"phone"];
    _job = [aDecoder decodeObjectForKey:@"job"];
    _city = [aDecoder decodeObjectForKey:@"city"];
    _birth = [aDecoder decodeObjectForKey:@"birth"];
    _account = [aDecoder decodeObjectForKey:@"account"];
    _pwd = [aDecoder decodeObjectForKey:@"pwd"];
    _priority = [aDecoder decodeObjectForKey:@"priority"];
    _eid = [aDecoder decodeObjectForKey:@"eid"];
    return self;
}

@end
