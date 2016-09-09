//
//  ContactsMod.h
//  OASystem
//
//  Created by 周桐 on 16/8/20.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ContactsMod : NSObject<NSCoding>

@property (nonatomic, strong)NSString *Name;
@property (nonatomic, strong)NSString *Icon;
@property (nonatomic, strong)NSString *Phone;
@property (nonatomic, strong)NSString *Job;
@property (nonatomic, strong)NSString *EId;
@property (nonatomic, strong)NSString *Birth;
@property (nonatomic, strong)NSString *Sex;
@property (nonatomic, strong)NSString *City;
@property (nonatomic, strong)NSString *Id;

+(instancetype)contactsWithDict:(NSDictionary *)dict;
//+(instancetype)contactsWithJSON:(id *)jsonObject;

@end
