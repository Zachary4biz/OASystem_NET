//
//  board.h
//  OASystem_NET
//
//  Created by 周桐 on 16/9/7.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import <UIKit/UIKit.h>
@class boardMod;

@interface boardTHN : UIView
@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong,nonatomic) boardMod *mod;
@property(strong,nonatomic)void(^boardTHN_touchBlock)();
@property(strong,nonatomic)void(^boardTHN_moveBlock)();

@end
