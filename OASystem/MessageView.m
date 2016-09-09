//
//  MessageView.m
//  OASystem
//
//  Created by 周桐 on 16/8/26.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "MessageView.h"

@implementation MessageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s",__func__);//可以看看touches里面都有什么可以用的
    //获取UITouch对象
    UITouch *touch = [touches anyObject]; //这个是NSSet对象，无序，直接取anyObject
    
    //获取当前点
    CGPoint curP = [touch locationInView:self];
    
    //获取上一个点
    CGPoint preP = [touch precisePreviousLocationInView:self];
    
    //获取x偏移量
    CGFloat offsetX = curP.x - preP.x;
    
    //获取y偏移量
    CGFloat offsetY = curP.y - preP.y;
    
    //修改view的位置(frame,center,transform)
    self.transform = CGAffineTransformTranslate(self.transform, offsetX, offsetY);
    
}

@end
