//
//  LoginViewController.h
//  OASystem
//
//  Created by 周桐 on 16/8/20.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface LoginViewController : UIViewController
//写在头文件，这样在board公告里面也可以直接取到名字了
@property (strong , nonatomic)NSString *name; //获取一下登录时所用账户的名字，用来传给EntryView
@property(strong, nonatomic)NSString *contacts_count; //获取联系人个数，用来传给EntryView
@end
