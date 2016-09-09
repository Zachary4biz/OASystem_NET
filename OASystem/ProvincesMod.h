//
//  ProvincesMod.h
//  OASystem
//
//  Created by 周桐 on 16/8/19.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProvincesMod : NSObject
@property (nonatomic, strong)NSMutableArray *cities;
@property (nonatomic, strong)NSString *name;

+(instancetype)provinceWithDict:(NSDictionary *)dict;
@end
