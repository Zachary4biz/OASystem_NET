//
//  MoreBoardViewController.m
//  OASystem_NET
//
//  Created by 周桐 on 16/9/9.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "MoreBoardViewController.h"
#import "boardMod.h"
#import "someAssist.h"
#import "BoardTableViewCell.h"
#import "boardDetail.h"
@interface MoreBoardViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *boardTableView;//用来给点击出现的详情页定位
@property (nonatomic,strong)NSMutableArray *boardModArr;
@end

@implementation MoreBoardViewController

-(NSMutableArray *)boardModArr
{
    _boardModArr = [someAssist getBoard_modArr];
    return _boardModArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.boardModArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BoardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_board"];
    cell.mod = _boardModArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    boardDetail *DetailView = [[NSBundle mainBundle]loadNibNamed:@"boardDetail" owner:nil options:nil][0];
    DetailView.mod = _boardModArr[indexPath.row];
    DetailView.frame = self.boardTableView.frame;
    [self.view addSubview:DetailView];
    DetailView.boardDetail_touchBlock=^{
        [[self.view.subviews lastObject] removeFromSuperview];
    };
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
