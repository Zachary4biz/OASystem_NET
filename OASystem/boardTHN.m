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
@property (weak, nonatomic) IBOutlet UIView *tapView;//透明的view，用来接收点击
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
    self.contentLabel.text = mod.content;
    
}

//允许响应多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

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

//开始触摸它，就把它放到所有view的最前面来
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_boardTHN_moveBlock) {
        _boardTHN_moveBlock();
    }
}

-(void)awakeFromNib{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    tap.delegate = self;
    [self.tapView addGestureRecognizer:tap];
    
}
-(void)tap{
    if (_boardTHN_touchBlock){
        _boardTHN_touchBlock();
    }
}



@end
