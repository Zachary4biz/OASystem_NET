//
//  board.h
//  OASystem_NET
//
//  Created by 周桐 on 16/9/7.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol boardTHNDelegate
@optional
-(void)touchEnd:(CGPoint) curP;

@end

@class boardMod;

@interface boardTHN : UIView
@property (weak,nonatomic)id delegate;

@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong,nonatomic) boardMod *mod;
@property(strong,nonatomic)void(^boardTHN_tapBlock)();
@property(strong,nonatomic)void(^boardTHN_tapWithoutModBlock)();//没有数据时点击
@property(strong,nonatomic)void(^boardTHN_touchBeginBlock)();
@property(strong,nonatomic)void(^boardTHN_touchEndBlock)(CGPoint currentP);
@property(strong,nonatomic)void(^boardTHN_toucheCancelBlock)();
//@property(assign,nonatomic)int index;//这个用来记录每个view在数组中的位置这样才能交换
//不然遍历所有view的frame之后，的确找到了当前触摸点在某个frame中，但这个时候并不知道自己的老frame是哪一个，所以也无从交换了。
@property (weak, nonatomic) IBOutlet UIView *tapView;//透明的view，用来接收点击
//tapView放在头文件声明，因为要在外部判断它有没有被赋模型数据
@end
