//
//  ContactsTableViewCell.h
//  OASystem
//
//  Created by 周桐 on 16/8/20.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContactsMod;

@interface ContactsTableViewCell : UITableViewCell
@property (nonatomic,strong)ContactsMod *mod;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
