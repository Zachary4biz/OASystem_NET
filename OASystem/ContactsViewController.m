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
@interface ContactsViewController ()<UITableViewDelegate,UITableViewDataSource>

//@property (nonatomic, strong)NSMutableArray *dataArr;//放在.h声明了

- (IBAction)backBtn:(id)sender;


@property (weak, nonatomic) IBOutlet UITableView *contactsTableView;

@property (nonatomic, strong)UIView *alphaView;//用来实现导航栏滚动透明
@property (nonatomic, assign)NSInteger recorder4indexPathRow;//记录选中的cell

@property (nonatomic,strong)NSMutableDictionary *iconCache;
//内存缓存头像图片，且保证不会重复下载



@property (nonatomic,strong)NSMutableDictionary *operationCache;
//内存缓存操作保证一个图片只开一个线程来下载
//不然使用多线程下载的时候，网速很慢，滚动tableview，cell消失再出现而图片仍然没有下载出来，就会再进入下载的部分，然后再开一个线程取下载图片
//所以，如果下载图片要10S，10S内滚动导致cell消失出现10次，那就会会重复开10个线程
@end

@implementation ContactsViewController

-(NSMutableDictionary *)iconCache
{
    if (!_iconCache) {
        _iconCache = [NSMutableDictionary dictionary];
    }
    return _iconCache;
}

-(NSMutableArray *)dataArr
{
    _dataArr = [NSMutableArray array];
    _dataArr = [someAssist getContacts];
    if ([_dataArr isKindOfClass:[NSString class]]) {
        [someAssist alertWith:@"连接服务器失败" viewController:self];
        //连接服务器失败，就读取本地文件
        _dataArr = [NSKeyedUnarchiver unarchiveObjectWithFile:contactsModPath];
    }
    [NSKeyedArchiver archiveRootObject:_dataArr toFile:contactsModPath];
    return _dataArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    //防止cell不到tableview的顶部，关掉哪个留白
    self.automaticallyAdjustsScrollViewInsets = NO;
    //通过插入一个view，并把bar本身颜色去掉的，再更改这个插入的view来实现改变透明度
//    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    CGRect frame = self.navigationController.navigationBar.frame;
    self.alphaView = [[UIView alloc] initWithFrame:CGRectMake(0,0, frame.size.width, frame.size.height+20)];
//    self.alphaView.backgroundColor = [UIColor blueColor];
    self.alphaView.backgroundColor = [UIColor orangeColor];
    self.alphaView.alpha = 0;
    [self.view insertSubview:self.alphaView aboveSubview:self.navigationController.navigationBar];
    
    //监听是否要刷新的通知 refresh
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getNoteRefresh) name:@"refresh" object:nil];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

//-(void)getNoteRefresh
//{
    //刷新界面刷新数据
    
//    [self.contactsTableView reloadData];//在viewWillApear里面reloadData了，就不用通知了
//    [self.view reloadInputViews];
//}

//这里其实是使用持久化数据（plist、数据库文件）来达到传递数据的目的，所以只需要刷新页面就可以
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.contactsTableView reloadData];
    self.view.alpha = 1;
}
//
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.view.alpha = 0;
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
                    NSString *iconStr = [someAssist picWith:cell.mod.Icon :@"jpg"];
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
@end
