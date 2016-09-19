//
//  CloudDiskMod.h
//  OASystem_NET
//
//  Created by 周桐 on 16/9/13.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CloudDiskMod : NSObject<NSCoding>
@property(nonatomic,strong)NSString *provider;
@property(nonatomic,strong)NSString *downloadPath;
@property(nonatomic,strong)NSString *fileName;
@property(nonatomic,strong)NSString *savePath;
@property(nonatomic,assign) float progress;
@property(nonatomic,assign) int judge; //1表示点了下载，要有下载条，0表示没有
@property(nonatomic,assign) int judge4checkView; //显示不显示checkView
@property (nonatomic,assign)int judge4downloadBtn; //按钮可不可点击
@property (nonatomic,assign)int judge4progressView; //显不显示进度条
+(instancetype)cloudDiskWithDict:(NSDictionary *)dict;
@end
