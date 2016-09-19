//
//  moreBtnView.h
//  OASystem_NET
//
//  Created by 周桐 on 16/9/11.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface moreBtnView : UIView
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
- (IBAction)btn1:(id)sender;
- (IBAction)btn2:(id)sender;
@property (strong,nonatomic)void(^btn1Block)();
@property (strong,nonatomic)void(^btn2Block)();
@end
