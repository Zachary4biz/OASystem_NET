//
//  ProvincesMod.m
//  OASystem
//
//  Created by 周桐 on 16/8/19.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "ProvincesMod.h"

@implementation ProvincesMod

+(instancetype)provinceWithDict:(NSDictionary *)dict
{
    ProvincesMod *Mod = [[self alloc]init];
    
    [Mod setValuesForKeysWithDictionary:dict];
    return Mod;
}
@end
