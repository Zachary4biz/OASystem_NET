//
//  ContactsMod.m
//  OASystem
//
//  Created by 周桐 on 16/8/20.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "ContactsMod.h"

@implementation ContactsMod

+(instancetype)contactsWithDict:(NSDictionary *)jsonObject_dic
{
    ContactsMod *Mod = [[self alloc]init];
//    [Mod setValuesForKeysWithDictionary:dict];//json的[0]到底是不是一个字典//好像不行
    Mod.Name = jsonObject_dic[@"Name"];
    Mod.Phone = jsonObject_dic[@"Phone"];
    Mod.Job = jsonObject_dic[@"Job"];
    Mod.City = jsonObject_dic[@"City"];
    Mod.Birth = jsonObject_dic[@"Birth"];
    Mod.EId = jsonObject_dic[@"EId"];
    Mod.Sex = jsonObject_dic[@"Sex"];
    Mod.Icon = jsonObject_dic[@"Icon"];
    Mod.Id = jsonObject_dic[@"Id"];
    return Mod;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_Name forKey:@"name"];
    [aCoder encodeObject:_Phone forKey:@"phone"];
    [aCoder encodeObject:_Job forKey:@"job"];
    [aCoder encodeObject:_City forKey:@"city"];
    [aCoder encodeObject:_Birth forKey:@"birth"];
    [aCoder encodeObject:_EId forKey:@"eid"];
    [aCoder encodeObject:_Sex forKey:@"sex"];
    [aCoder encodeObject:_Icon forKey:@"icon"];
    [aCoder encodeObject:_Id forKey:@"id"];

}

-(id)initWithCoder:(NSCoder *)aDecoder{
    _Name = [aDecoder decodeObjectForKey:@"name"];
    _Job = [aDecoder decodeObjectForKey:@"job"];
    _Phone = [aDecoder decodeObjectForKey:@"phone"];
    _Birth =[aDecoder decodeObjectForKey:@"birth"];
    _City = [aDecoder decodeObjectForKey:@"city"];
    _EId = [aDecoder decodeObjectForKey:@"eid"];
    _Sex =[aDecoder decodeObjectForKey:@"sex"];
    _Icon = [aDecoder decodeObjectForKey:@"icon"];
    _Id = [aDecoder decodeObjectForKey:@"id"];
    return self;
}
//
//+(instancetype)contactsWithJSON:(id *)jsonObject_dict
//{
//    ContactsMod *mod = [[self alloc]init];
//    mod.name = jsonObject[@"Name"];
//    mod.phone = jsonObject[@"Phone"];
//}
@end
