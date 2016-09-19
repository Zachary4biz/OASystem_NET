//
//  boardDetail.m
//  OASystem_NET
//
//  Created by 周桐 on 16/9/8.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "boardDetail.h"
#import "boardMod.h"

@interface boardDetail()<UIGestureRecognizerDelegate>

@end

@implementation boardDetail

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setMod:(boardMod *)mod
{
#warning 什么用这一句
    _mod = mod;//?????
    self.providerLbl.text = mod.provider;
    self.dateLbl.text = mod.date;
    self.ddlLbl.text = mod.ddl;
    self.contentTextView.text = mod.content;
}


-(void)awakeFromNib{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    tap.delegate = self;
    [self.tapView addGestureRecognizer:tap];
}
-(void)tap{
    if (_boardDetail_tapBlock){
        _boardDetail_tapBlock();
    }
}
@end
