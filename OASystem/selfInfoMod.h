//
//  selfInfoMod.h
//  OASystem_NET
//
//  Created by 周桐 on 16/9/8.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface selfInfoMod : NSObject<NSCoding>
@property (nonatomic, strong)NSString *name;//
@property (nonatomic, strong)NSString *city;//
@property (nonatomic, strong)NSString *phone;//
@property (nonatomic, strong)NSString *job;//
@property (nonatomic, strong)NSString *eid;//
@property (nonatomic, strong)NSString *birth;//
@property (nonatomic,strong)NSString *account;//
@property (nonatomic,strong)NSString *pwd;//
@property(nonatomic,strong)NSString *priority;//

+(instancetype)selfInfoWithDict:(NSDictionary *)dict;
@end
