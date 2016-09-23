//
//  CloudDiskMod.m
//  OASystem_NET
//
//  Created by 周桐 on 16/9/13.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "CloudDiskMod.h"

@implementation CloudDiskMod

+(instancetype)cloudDiskWithDict:(NSDictionary *)dict
{
    CloudDiskMod *mod = [[self alloc]init];
    mod.provider=dict[@"provider"];
    mod.fileName = dict[@"fileName"];
    mod.downloadPath=dict[@"filePath"];
    //提前设置好保存的路径
    mod.savePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:mod.fileName];
    return mod;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.provider forKey:@"provider"];
    [aCoder encodeObject:self.fileName forKey:@"fileName"];
    [aCoder encodeObject:self.downloadPath forKey:@"downloadPath"];
    [aCoder encodeObject:_savePath forKey:@"savePath"];
    [aCoder encodeFloat:_progress forKey:@"progress"];
    [aCoder encodeInt:_judge forKey:@"judge"];
    
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self.provider = [aDecoder decodeObjectForKey:@"provider"];
    self.fileName = [aDecoder decodeObjectForKey:@"fileName"];
    self.downloadPath = [aDecoder decodeObjectForKey:@"downloadPath"];
    _savePath = [aDecoder decodeObjectForKey:@"savePath"];
    _progress = [aDecoder decodeFloatForKey:@"progress"];
    _judge = [aDecoder decodeIntForKey:@"judge"];
    return self;
}
@end
