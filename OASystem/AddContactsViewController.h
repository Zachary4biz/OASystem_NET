//
//  EditContactsViewController.h
//  OASystem
//
//  Created by 周桐 on 16/8/23.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddContactsViewController,ContactsTableViewCell;
@protocol EditContactsDelegate<NSObject>

@optional
-(void)editContactsViewController:(AddContactsViewController *)editVC didClickEditBtnWithContact:(ContactsTableViewCell *)contact;

@end

//@class ContactsViewController;
@interface AddContactsViewController : UIViewController

@property (nonatomic, weak)id<EditContactsDelegate> delegate;

//@property (nonatomic,strong) ContactsViewController *contactVC;

@end
