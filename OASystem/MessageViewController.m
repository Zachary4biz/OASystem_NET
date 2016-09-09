//
//  MessageViewController.m
//  OASystem
//
//  Created by 周桐 on 16/8/23.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageView.h"

@interface MessageViewController ()
//@property (weak, nonatomic) IBOutlet UIView *messageView;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSBundle *rootBundle = [NSBundle mainBundle];
    MessageView *messageView = [rootBundle loadNibNamed:@"MessageView" owner:nil options:nil][0];
    messageView.frame = CGRectMake(0, 64, 80, 80);
    [self.view addSubview:messageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{

    //3.设置背景颜色为空的颜色
    [[UINavigationBar appearance] setBackgroundColor:[UIColor darkGrayColor]];

}

//触摸移动
//要写在messageView的类里面才是监听它上面的触摸，不然监听的是全局的
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
