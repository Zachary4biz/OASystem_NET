//
//  boardDetail.h
//  OASystem_NET
//
//  Created by 周桐 on 16/9/8.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import <UIKit/UIKit.h>
@class boardMod;
@interface boardDetail : UIView
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *providerLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UILabel *ddlLbl;
@property (weak, nonatomic) IBOutlet UIView *tapView;//一个透明的view，用来接收点击触摸事件

@property(nonatomic,strong)boardMod *mod;

@property(nonatomic,strong)void (^boardDetail_touchBlock)();
@end
