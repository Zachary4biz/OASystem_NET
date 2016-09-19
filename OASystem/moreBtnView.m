//
//  moreBtnView.m
//  OASystem_NET
//
//  Created by 周桐 on 16/9/11.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "moreBtnView.h"

@interface moreBtnView ()


@end


@implementation moreBtnView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)btn1:(id)sender {
    if (_btn1Block) {
        _btn1Block();
    }
}

- (IBAction)btn2:(id)sender {
    if (_btn2Block) {
        _btn2Block();
    }
}
@end
