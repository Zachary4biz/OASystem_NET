//
//  InfoViewController.h
//  OASystem
//
//  Created by 周桐 on 16/8/19.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ContactsMod;

@interface EntryViewController : UIViewController

@property(strong,nonatomic)NSString *name;//用来接收loginView传的登录账户的姓名，因为在prepareforSegue的时候直接对按钮setTitle失败了，所以走另一条路来试试
@property(strong,nonatomic)NSString *contacts_count;//用来接收loginView传的联系人个数
@property (strong,nonatomic) ContactsMod *mod;
@property (strong,nonatomic)NSMutableArray *modArr;//模型数组
//@property (strong,nonatomic)NSArray *modArr;//模型数组

@end
