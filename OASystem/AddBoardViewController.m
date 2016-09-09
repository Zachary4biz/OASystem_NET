//
//  AddBoardViewController.m
//  OASystem_NET
//
//  Created by 周桐 on 16/9/8.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "AddBoardViewController.h"
#import "someAssist.h"
@interface AddBoardViewController ()
@property (weak, nonatomic) IBOutlet UITextField *providerTextField;
@property (weak, nonatomic) IBOutlet UITextField *durationTextField;
@property (weak, nonatomic) IBOutlet UITextField *levelTextField;
@property (weak, nonatomic) IBOutlet UITextView *boardTextView;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
- (IBAction)doneBtn:(id)sender;

@end

@implementation AddBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *name = [[NSString alloc]init];

    self.providerTextField.text = name;
    [self.providerTextField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.durationTextField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.levelTextField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self textChange];
    
    // Do any additional setup after loading the view.
}

-(void)textChange
{
    self.doneBtn.enabled = self.providerTextField.text.length && self.durationTextField.text.length && self.levelTextField.text.length;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)doneBtn:(id)sender {
}
@end
