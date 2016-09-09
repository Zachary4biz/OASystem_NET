//
//  DetailContactsViewController.h
//  OASystem
//
//  Created by 周桐 on 16/8/23.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ContactsMod;
@interface DetailContactsViewController : UIViewController
@property (nonatomic,assign)NSInteger recorder4indexPathRow;
@property(nonatomic,strong) ContactsMod *mod;
@property (nonatomic,strong)void(^myBlock)(ContactsMod *mod);
@end
