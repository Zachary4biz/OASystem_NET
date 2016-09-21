//
//  ContactsViewController.m
//  OASystem
//
//  Created by 周桐 on 16/8/19.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactsMod.h"
#import "ContactsTableViewCell.h"
#import "DetailContactsViewController.h"
#import "EntryViewController.h"

#import "someAssist.h"
#import "Masonry.h"
@interface ContactsViewController ()<UITableViewDelegate,UITableViewDataSource>


//@property (nonatomic, strong)NSMutableArray *dataArr;//放在.h声明了

- (IBAction)backBtn:(id)sender;
#pragma UI
@property (weak, nonatomic) IBOutlet UIView *moreBtnView;//显示更多按钮
- (IBAction)editBtn:(id)sender;
- (IBAction)addBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *contactsTableView;//联系人tableview
@property(nonatomic,strong)UIImageView *imgView;//实现能旋转的导航栏按钮，思路是用initWithCustomView给导航栏按钮加载一个UIButton按钮，这个按钮里面有subView:imgView，且这个UIButton的大小是40 40，所以点击的时候旋转这个imgView就可以了，
@property(nonatomic,strong)UIRefreshControl *control;//下拉刷新用的控件

#pragma Functional
@property (nonatomic, strong)UIView *alphaView;//用来实现导航栏滚动透明
@property (nonatomic, assign)NSInteger recorder4indexPathRow;//记录选中的cell
@property (nonatomic,strong)NSMutableDictionary *iconCache;
//内存缓存头像图片，且保证不会重复下载
@property (nonatomic,strong)NSMutableDictionary *operationCache;
//内存缓存操作保证一个图片只开一个线程来下载
//不然使用多线程下载的时候，网速很慢，滚动tableview，cell消失再出现而图片仍然没有下载出来，就会再进入下载的部分，然后再开一个线程取下载图片
//所以，如果下载图片要10S，10S内滚动导致cell消失出现10次，那就会会重复开10个线程
//@property(nonatomic,strong)moreBtnViewView *moreBtnView; //用来全局记录这个生成的Xib View
@property(nonatomic,assign)int judge4rightBtnItem; //用来记录按钮的点击状态，点击一次就取反一次
@end

@implementation ContactsViewController

-(NSMutableDictionary *)iconCache
{
    if (!_iconCache) {
        _iconCache = [NSMutableDictionary dictionary];
    }
    return _iconCache;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    //防止cell不到tableview的顶部，关掉哪个留白
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //通过插入一个view，并把bar本身颜色去掉的，再更改这个插入的view来实现改变透明度
    CGRect frame = self.navigationController.navigationBar.frame;
    self.alphaView = [[UIView alloc] initWithFrame:CGRectMake(0,0, frame.size.width, frame.size.height+20)];
    self.alphaView.backgroundColor = [UIColor orangeColor];
    self.alphaView.alpha = 0;
    [self.view insertSubview:self.alphaView belowSubview:self.navigationController.navigationBar];//below，above都可以
    
    self.moreBtnView.alpha = 0;
    
    //实现自定义的导航栏右侧按钮
    self.imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"3pointH"]];
    UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tempBtn addTarget:self action:@selector(clickRightBtnItem) forControlEvents:UIControlEventTouchUpInside];
    [tempBtn addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(tempBtn);
        make.centerY.equalTo(tempBtn);
    }];
    tempBtn.frame = CGRectMake(0, 0, 40, 40);
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:tempBtn];
    
    //设置下拉刷新的控件
    _control = [[UIRefreshControl alloc]init];
    [_control addTarget:self action:@selector(refreshContactsWithControl:) forControlEvents:UIControlEventValueChanged];
    [self.contactsTableView addSubview:_control];
//    [_control beginRefreshing];
//    [self refreshContactsWithControl:_control];
    
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //无效，tableView中即使没有cell的地方也不是空白的，不会响应这个touche，能响应这个touch的是self.view??
    if (self.judge4rightBtnItem == 1) {
        //为1，当前选项卡为打开，需要关闭
        self.judge4rightBtnItem = 0;
        [UIView animateWithDuration:0.2 animations:^{
            self.imgView.transform = CGAffineTransformRotate(self.imgView.transform, M_PI_2);
            self.moreBtnView.transform = CGAffineTransformIdentity;
            self.moreBtnView.alpha = 0;
        }];
    }
}
//下拉刷新调用
-(void)refreshContactsWithControl:(UIRefreshControl *)control{
    //重新联网获取数据
    self.dataArr = [NSMutableArray array];
    someAssist *hud = [[someAssist alloc]init];
    [hud showWait:self];
    [someAssist getContacts_modArrWithCompletionBlock:^(id object) {
        tellResult(object);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [hud dismissWait:self];
            if (object == nil) {
                self.dataArr = [NSKeyedUnarchiver unarchiveObjectWithFile:contactsModPath];
            }
            else{
                self.dataArr = object;
                [NSKeyedArchiver archiveRootObject:_dataArr toFile:contactsModPath];
            }
            [self.contactsTableView reloadData];
            [control endRefreshing];
        }];
    }];
}
//这里其实是使用持久化数据（plist、数据库文件）来达到传递数据的目的，所以只需要刷新页面就可以

-(void)refreshContacts
{
    someAssist *hud = [[someAssist alloc]init];
    [hud showWait:self];
    //重新从网上下载
    [someAssist getContacts_modArrWithCompletionBlock:^(id object_temp) {
        __block id object = object_temp;
        //需要回到主线程判断
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [hud dismissWait:self];
            tellResult(object);
            if (object != nil) {
                self.dataArr = object;
                [NSKeyedArchiver archiveRootObject:object toFile:contactsModPath];
            }
            else{
                self.dataArr = [NSKeyedUnarchiver unarchiveObjectWithFile:contactsModPath];
            }
            //并且在主线程reloadData
            [self.contactsTableView reloadData];
        }];
    }];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshContacts];
    self.view.alpha = 1;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.imgView.transform = CGAffineTransformIdentity;
    self.moreBtnView.transform = CGAffineTransformIdentity;
    self.moreBtnView.alpha = 0;
    self.judge4rightBtnItem = 0;//点击次数不归零会导致push再pop回来，“..."按钮的横竖显不显示moreBtnView反过来了
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


#pragma mark UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"%ld",self.dataArr.count);
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //把cell的基本信息都搞好
    ContactsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_contacts"];
    cell.mod = self.dataArr[indexPath.row];
    //开始搞图片
    [cell.activityIndicator startAnimating];
    UIImage *icon = self.iconCache[cell.mod.Icon];
    if(icon)
    {
        //内存缓存中有图片
        NSLog(@"缓存中取到图片--%@",cell.mod.Icon);
        cell.iconView.image = icon;
        [cell.activityIndicator stopAnimating];
    }
    else
    {
        //内存缓存中没有图片
        //尝试沙盒中获取--Library/Caches文件夹
        NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        //获取图片名
        NSString *iconName = cell.mod.Icon;
        //获取图片全路径
        NSString *iconPath = [cachesPath stringByAppendingString:iconName];
        //加载沙盒文件数据
        NSData *data = [NSData dataWithContentsOfFile:iconPath];
        
        if(data)
        {
            NSLog(@"沙盒中取到图片数据--%@",cell.mod.Icon);
            //如果沙盒文件中有这个名为cell.mod.Icon的文件
            cell.iconView.image = [UIImage imageWithData:data];
            [cell.activityIndicator stopAnimating];
            //并存入内存缓存
            self.iconCache[cell.mod.Icon] = [UIImage imageWithData:data];
            
        }
        else
        {
            //如果沙盒中也没有，那就连接服务器重新下载
            //依据图片名来保证进程不重复
            NSOperation *operation = self.operationCache[cell.mod.Icon];
            if (operation == nil)
            {
                //在缓存中没有下载该图片的进程,创建新的进程
                operation = [NSBlockOperation blockOperationWithBlock:^()
                {
                    NSLog(@"从服务器下载图片--%@",cell.mod.Icon);
                    NSString *iconStr = [someAssist picWithName:cell.mod.Icon ext:@"jpg"];
                    NSURL *iconURL = [NSURL URLWithString:iconStr];
                    NSData *data = [NSData dataWithContentsOfURL:iconURL];
                    if(data)
                    {
                        //服务器下载到了图片
                        //回到主线程更新UI
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^()
                        {
//                            cell.iconView.image = [UIImage imageWithData:data];//网速慢出现图片错位
                            //上面那个出现图片错位就是因为，新出现的cell复用的上面的cell，而新图片还没下载出来
                            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                            [cell.activityIndicator stopAnimating];
                        }];
                        //图片写入内存缓存中
                        self.iconCache[cell.mod.Icon]= [UIImage imageWithData:data];
                        //写入沙盒文件中，这个YES代表保存过程中出错了文件会被删除不会有残留
                        [data writeToFile:iconPath atomically:YES];
                    }
                    else
                    {
                        //如果服务器没有，说明没有上传过，显示默认头像
                        NSLog(@"服务器获取失败此图片--%@",cell.mod.Icon);
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^()
                        {
                            
                            cell.iconView.image = [UIImage imageNamed:@"iconHolder"];
                            [cell.activityIndicator stopAnimating];
                        }];
                    }
                }];
                //进程创建完毕了，加到字典中，这个操作当然是及时生效，不会等进程跑起来甚至跑完才加入队列
                self.operationCache[cell.mod.Icon] = operation;
                //进程添加到队列中
                NSOperationQueue *queue = [[NSOperationQueue alloc]init];
                [queue addOperation:operation];
            }

        }
    }
    return cell;
}

#pragma mark ScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //想到取每个cell的高度,怎么取？如果cell有不同的格式呢？
    
    //输出当前的滚动位置,注意.contentoffset返回的是cgpoint形式的
    
    NSString *station = [NSString stringWithFormat:@"%f", scrollView.contentOffset.y];
//    NSLog (@"%@",station);
//
    //假设跑500之后变成存在的
    float temp = [station floatValue]/140;
    NSLog(@"%f",temp);
    if (temp<1)
    {
        self.alphaView.alpha = temp;
    }
    else{
        self.alphaView.alpha = 1;
    }
    
}
//实现左划按钮——————————————————————————
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    someAssist *hud = [[someAssist alloc]init];
    [hud showWait:self];
    
    NSURL *url = [NSURL URLWithString:[someAssist serverWith:@"deletecontact"]];
    NSMutableURLRequest *request_post = [NSMutableURLRequest requestWithURL:url];
    request_post.HTTPMethod = @"POST";
    request_post.timeoutInterval = 5;
    ContactsMod *mod = _dataArr[indexPath.row];
    NSString *info = [NSString stringWithFormat:@"Id=%@",mod.Id];
    request_post.HTTPBody=[info dataUsingEncoding:NSUTF8StringEncoding];
    
    [NSURLConnection sendAsynchronousRequest:request_post queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [hud dismissWait:self];
            NSString *judge = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            if (connectionError) {
                NSLog(@"deletebtn请求失败--%@",connectionError);
                [someAssist serverWith:@"连接服务器失败"];
            }
            else if([judge isEqualToString:@"done"]){
                    [self.dataArr removeObjectAtIndex:indexPath.row];
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteContact" object:nil];
            }
            else if ([judge isEqualToString:@"not done"]){
                [someAssist alertWith:@"删除失败" viewController:self];
            }
        }];
    }];

}

//实现左划按钮——————————————————————————

#pragma mark TableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //选中的时候进行跳转
    self.recorder4indexPathRow = indexPath.row;
    NSLog(@"选中了第%ld个cell",(long)indexPath.row);

    [self performSegueWithIdentifier:@"contacts2detail" sender:nil];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"contacts2detail"]) {
        DetailContactsViewController *vc_temp =  segue.destinationViewController;
        //把选中联系人的数据给它
        vc_temp.mod = self.dataArr[_recorder4indexPathRow];
        //把选中的是第几个也给它，方便从plist中删除该联系人
        vc_temp.recorder4indexPathRow = self.recorder4indexPathRow;
        //不刷新数据会显示为上次点击的那个联系人的
//        [vc_temp.view layoutIfNeeded];
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

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickRightBtnItem{
    //judge初始为0
    if (self.judge4rightBtnItem == 0) {
        //judge为0，当前为关闭，需要打开选项卡
        [UIView animateWithDuration:0.2 animations:^{
            self.imgView.transform = CGAffineTransformRotate(self.imgView.transform, M_PI_2);
            self.moreBtnView.transform = CGAffineTransformMakeTranslation(0, 120);
            self.moreBtnView.alpha = 1;
        }];
    }
    else{
        //judge为1,当前为打开，需要关闭选项卡
        [UIView animateWithDuration:0.2 animations:^{
            self.imgView.transform = CGAffineTransformRotate(self.imgView.transform, M_PI_2);
            self.moreBtnView.transform = CGAffineTransformIdentity;
            self.moreBtnView.alpha = 0;
        }];
        
    }
    //操作一次后judge取反
    self.judge4rightBtnItem = !self.judge4rightBtnItem;

}
- (IBAction)editBtn:(id)sender {
    NSLog(@"点击了编辑");
}

- (IBAction)addBtn:(id)sender {
    [self performSegueWithIdentifier:@"contacts2add" sender:nil];
}
@end
