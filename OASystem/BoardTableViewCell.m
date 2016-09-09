//
//  BoardTableViewCell.m
//  OASystem_NET
//
//  Created by 周桐 on 16/9/9.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "BoardTableViewCell.h"
#import "boardMod.h"
@interface BoardTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *provider;

@property (weak, nonatomic) IBOutlet UILabel *content;

@end

@implementation BoardTableViewCell



-(void)setMod:(boardMod *)mod
{
    _mod = mod;
    self.provider.text = mod.provider;
    self.content.text = mod.content;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
