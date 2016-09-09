//
//  boardMod.m
//  OASystem_NET
//
//  Created by 周桐 on 16/9/7.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "boardMod.h"

@implementation boardMod

+(instancetype)boardWithDict:(NSDictionary *)jsonObject_dic{
    boardMod *mod =[[boardMod alloc]init];
//    [mod setValuesForKeysWithDictionary:dic];//好像不行
    mod.content = jsonObject_dic[@"content"];
    mod.provider = jsonObject_dic[@"provider"];
    mod.ddl = jsonObject_dic[@"ddl"];
    mod.date = jsonObject_dic[@"date"];
    mod.ID = jsonObject_dic[@"Id"];

    return mod;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_content forKey:@"contentKey"];
    [aCoder encodeObject:_provider forKey:@"providerKey"];
    [aCoder encodeObject:_ddl forKey:@"ddlKey"];
    [aCoder encodeObject:_date forKey:@"dateKey"];
    [aCoder encodeObject:_ID forKey:@"IDKey"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self == [super init]) {
        _content = [aDecoder decodeObjectForKey:@"contentKey"];
        _provider = [aDecoder decodeObjectForKey:@"providerKey"];
        _ddl = [aDecoder decodeObjectForKey:@"ddlKey"];
        _date = [aDecoder decodeObjectForKey:@"dateKey"];
        _ID = [aDecoder decodeObjectForKey:@"IDKey"];
    }
    return self;
}
/**
 *  (lldb) po dic
 {
 Id = 1;
 content = dasfawersdfasfsadfx;
 date = "2016-09-02 09:43:49";
 ddl = "2016-09-14";
 provider = Zac;
 }
 */
@end
