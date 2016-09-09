//
//  ContactsTableViewCell.m
//  OASystem
//
//  Created by 周桐 on 16/8/20.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "ContactsTableViewCell.h"
#import "ContactsMod.h"
@interface ContactsTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *ID;
@property (weak, nonatomic) IBOutlet UILabel *job;
@property (weak, nonatomic) IBOutlet UILabel *phone;


@end

@implementation ContactsTableViewCell

-(void)setMod:(ContactsMod *)mod
{
    _mod = mod;
//    self.iconView.image = [UIImage imageNamed:mod.Icon];
    self.ID.text = mod.EId;
    self.job.text = mod.Job;
    self.phone.text = mod.Phone;
    self.name.text = mod.Name;
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
