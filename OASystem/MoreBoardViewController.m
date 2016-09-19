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
@property (weak, nonatomic) IBOutlet UITableView *boardTableView;//定位用，用来给点击出现的详情页定位
@property (weak, nonatomic) IBOutlet UIButton *doneBtn; //选择完成
@property (strong, nonatomic)NSMutableArray *choseArr;//保存选择的那几个数据的模型，每个元素都是mod
@property (strong, nonatomic)UIRefreshControl *control;//用来下拉刷新的
- (IBAction)doneBtn:(id)sender;
@property (nonatomic,strong)NSMutableArray *boardModArr;//所有数据的模型
@end

@implementation MoreBoardViewController

/**
 *  说明：
    为了尝试两种选择方法：系统自带的tableview.allowsMutipleSelectionDuringEditting=YES
                        (自带方法是利用[tableView indexPathsForSelectedRows来记录选中的所有row)
                      自己写的自定义选择，根据didSelect代理方法修改mod里的check数据表示被选中
    所以本文件下基本所有的控件都有两种情况：如果是从tap手势进来就是在编辑下的多选模式，否则是自定义选择模式
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
    
    //设置下拉刷新的控件
    _control = [[UIRefreshControl alloc]init];
    [_control addTarget:self action:@selector(refreshBoard:) forControlEvents:UIControlEventValueChanged];
    [self.boardTableView addSubview:_control];
//    [_control beginRefreshing];
//    [self refreshBoard:_control];
    //设置导航栏右侧按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"选择" style:UIBarButtonItemStylePlain target:self action:@selector(chose)];
    //初始化用来保存选择的公告的模型数组choseArr
    self.choseArr = [NSMutableArray array];
    
    //判断是不是从前面的加号view使用tap手势进来的
    NSLog(@"%ld",self.judgeFromTap);
    if (self.judgeFromTap) {
        //如果是从tap手势进来的就进入下面的方法——进入编辑模式
        [self.boardTableView setEditing:YES animated:YES];
        self.boardTableView.allowsMultipleSelectionDuringEditing = YES;
        self.doneBtn.hidden = NO;
        self.navigationItem.rightBarButtonItem.title = @"取消";
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshBoard:_control];
}

-(void)chose
{
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"选择"]) {
        //按下“选择”的时候，清空上次选择的数组choseArr
        [self.choseArr removeAllObjects];
        self.navigationItem.rightBarButtonItem.title = @"取消";
        self.doneBtn.hidden = NO;
    }
    else{
        //按下“取消”的时候，cancelChose
        [self cancelChose];
        self.navigationItem.rightBarButtonItem.title = @"选择";
        self.doneBtn.hidden = YES;
    }
    if (self.boardTableView.isEditing) {
        //如果是在编辑模式时点了按钮（进入编辑模式时因为从tap手势进来这个VC，进来时已经设置了rightBtnItem额title是“取消”，现在就直接执行退出编辑模式，并隐藏按钮就行了
        [self.boardTableView setEditing:NO animated:YES];
        self.doneBtn.hidden = YES;
    }
}
//取消选择，让模型数组的所有模型都执行这个方法，check为0
-(void)cancelChose
{
    for (int i =0; i<self.boardModArr.count; i++) {
        boardMod *mod_temp = _boardModArr[i];
        mod_temp.check = 0;
    }
    [self.boardTableView reloadData];
}


//下拉刷新调用这个
-(void)refreshBoard:(UIRefreshControl *)control{
    //重新联网获取数据
    _boardModArr = [NSMutableArray array];
    someAssist *hud = [[someAssist alloc]init];
    [hud showWait:self];
    [someAssist getBoard_modArrWithCompletionBlock:^(id object) {
        tellResult(object);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [hud dismissWait:self];
            if (object == nil) {
                _boardModArr = [NSKeyedUnarchiver unarchiveObjectWithFile:boardModPath];
            }
            else{
                _boardModArr = object;
                [NSKeyedArchiver archiveRootObject:_boardModArr toFile:boardModPath];
            }
            [self.boardTableView reloadData];
            [control endRefreshing];
        }];
    }];
}



#pragma Delegates
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
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"选择"]) {
        //如果rightBtnItem的title是选择，说明还没有点击过，不是在选取模式
        boardDetail *DetailView = [[NSBundle mainBundle]loadNibNamed:@"boardDetail" owner:nil options:nil][0];
        DetailView.mod = _boardModArr[indexPath.row];
        DetailView.frame = self.boardTableView.frame;
        [self.view addSubview:DetailView];
        DetailView.boardDetail_tapBlock=^{
            [[self.view.subviews lastObject] removeFromSuperview];
        };
    }
    else{
        //else，rightBtnItem的title是取消，说明正在进行选择模式
        //但是要判断是系统的选择模式还是自定义选择模式
        if (self.boardTableView.isEditing){
            //如果是在编辑模式，选中时就不用做其他操作了
        }
        else{
            //如果是自定义选择
            boardMod *mod_temp = _boardModArr[indexPath.row];
            mod_temp.check = !mod_temp.check; //反选，就是选了再点一次就不选了
            [self.boardTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
        }
    }

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
    if (self.boardTableView.isEditing) {
        //如果是在编辑模式下点击的按钮
        //因为是添加，所以要先读取原来的数据
        self.choseArr =[NSKeyedUnarchiver unarchiveObjectWithFile:board2ShowModPath];
        //取到所选择的行得到的是indexPath的一个数组
        NSArray *indexPathsArr = [self.boardTableView indexPathsForSelectedRows];
        if (indexPathsArr.count+self.choseArr.count >12) {
            //如果超过了12个
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"最多显示12个" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:0.5];
        }
        else{
            //如果没有超过12个
            for (NSIndexPath *p in indexPathsArr){
                [self.choseArr addObject:_boardModArr[p.row]];
            }
            //添加后写回去
            [NSKeyedArchiver archiveRootObject:self.choseArr toFile:board2ShowModPath];
            //并调用cancel取消选择
            //        [self cancelChose];//应该不用，直接回到原界面就行了
            //回到原界面
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else{
        //点击完成按钮时，遍历，检查check，为1，就是要显示的，加入数组
        for (int i =0; i<self.boardModArr.count; i++) {
            boardMod *mod_temp = _boardModArr[i];
            if (mod_temp.check == 1) {
                //如果要显示check，就加入数组
                [self.choseArr addObject:_boardModArr[i]];
            }
        }
        //最多只能显示12个
        if (self.choseArr.count > 12) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"最多显示12个" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:0.5];
        }
        else{
            [NSKeyedArchiver archiveRootObject:self.choseArr toFile:board2ShowModPath];
            //保存好了也要取消选择，
            [self cancelChose];
            //并退出选择状态
            self.navigationItem.rightBarButtonItem.title = @"选择";
            [self.boardTableView reloadData];
            self.doneBtn.hidden = YES;
        }
    }
    
}
//取消那个“最多显示12个”的提示
- (void)dismissAlert:(UIAlertView *)alert {
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}
@end
