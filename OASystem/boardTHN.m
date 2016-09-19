//
//  board.m
//  OASystem_NET
//
//  Created by 周桐 on 16/9/7.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "boardTHN.h"
#import "boardMod.h"
@interface boardTHN()<UIGestureRecognizerDelegate>

@end

@implementation boardTHN

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setMod:(boardMod *)mod{
    _mod = mod;
    //缩略图只显示部分公告内容
    self.contentLabel.text = mod.content;
    
}

//允许响应多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

//开始触摸它，就把它放到所有view的最前面来
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.alpha = 0.3;
    if (_boardTHN_touchBeginBlock) {
        _boardTHN_touchBeginBlock();
    }
}

//触摸点移动就跟随移动
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //一开始移动就变透明
    self.alpha = 0.3;

    //    NSLog(@"%s",__func__);//可以看看touches里面都有什么可以用的
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

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.alpha =1;
    CGPoint curP = [[touches anyObject]locationInView:self];
    if ([_delegate respondsToSelector:@selector(touchEnd:)]) {
        [_delegate touchEnd:curP];
    }
    if(_boardTHN_touchEndBlock){
        _boardTHN_touchEndBlock(curP);
    }
    
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.alpha = 1;
    if (_boardTHN_toucheCancelBlock) {
        _boardTHN_toucheCancelBlock();
    }
}

-(void)awakeFromNib{

    //给缩略图设置tap手势识别
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    tap.delegate = self;
//    [self.tapView addGestureRecognizer:tap];
    //这里tapView其实用不上
    [self addGestureRecognizer:tap];
    
}
//实现tap手势的响应————点击缩略图时，弹出详情
-(void)tap{
    if (self.mod) {
        if (_boardTHN_tapBlock){
            _boardTHN_tapBlock();
            
        }
    }
    else{
        if (_boardTHN_tapWithoutModBlock){
            _boardTHN_tapWithoutModBlock();
        }
    }

}



@end
