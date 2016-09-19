//
//  CloudDiskViewController.m
//  OASystem_NET
//
//  Created by 周桐 on 16/9/13.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "CloudDiskViewController.h"
#import "CloudDiskMod.h"
#import "CloudDiskTableViewCell.h"
#import "someAssist.h"
@interface CloudDiskViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *cloudTableView;
@property (strong,nonatomic) NSMutableArray *modArr;
@property(strong,nonatomic) UIRefreshControl *control;
@property (strong,nonatomic) NSMutableDictionary *cloudDiskFileDict;//这个字典存放保存文件的路径，每次开始时，检索路径文件，如果存在说明有文件


@end

@implementation CloudDiskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置不自动偏移
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //设置下拉刷新
    _control = [[UIRefreshControl alloc]init];
    [_control addTarget:self action:@selector(refreshCloudDiskWithControl:) forControlEvents:UIControlEventValueChanged];
    [self.cloudTableView addSubview:_control];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_control beginRefreshing];
    [self refreshCloudDiskWithControl:_control];
    
}

#pragma self-made
-(void)refreshCloudDiskWithControl:(UIRefreshControl *)control
{
    //刷新获取云文件的模型数据，内有文件名(包含文件类型)和文件下载地址
    someAssist *hud = [[someAssist alloc]init];
    [hud showWait:self];
    [someAssist getCloudDisk_modArrWithCompletionBlock:^(id object) {
        tellResult(object)
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [hud dismissWait:self];
            if (object != nil)
            {
                self.modArr = object;
                [NSKeyedArchiver archiveRootObject:self.modArr toFile:cloudDiskModPath];
            }
            else{
                self.modArr = [NSKeyedUnarchiver unarchiveObjectWithFile:cloudDiskModPath];
            }
            [self.cloudTableView reloadData];
            [_control endRefreshing];
        }];
    }];
}

//这个在载入页面搞一次？？
-(BOOL)checkLocal:(CloudDiskMod *)mod
{
    //如果模型里面有savePath（保存路径）说明已经保存过了
    if (mod.savePath){
        return YES;
    }
    else{
        return NO;
    }
    
}

#pragma UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CloudDiskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_cloud"];
    cell.mod = self.modArr[indexPath.row];
    
//    cell.downloadBtn.enabled = cell.mod.judge4downloadBtn; //一开始初始的judge是0，导致不能点击按钮
    cell.progressView.alpha = 1;
    cell.progressView.hidden = !cell.mod.judge4progressView;
    cell.checkView.hidden = !cell.mod.judge4checkView;
    //根据本地的字典，判断这个cell的文件名是否存在，从而判断是否下载过
    NSMutableDictionary *cloudDiskFileDic = [NSKeyedUnarchiver unarchiveObjectWithFile:cloudDiskFilePath];
    id temp_judge = [cloudDiskFileDic objectForKey:[NSString stringWithFormat:@"%@",cell.mod.fileName]];
    if (temp_judge) {
        cell.checkView.hidden = NO;
    }
    else{
        cell.checkView.hidden = YES;
    }
    
    typeof(cell) __weak weakCell = cell;
    //设置点击下载按钮的block——实现按钮失效、进度条显示、隐藏checkView
    cell.clickDownloadBtnBlock = ^(){
        //更改模型
        CloudDiskMod *mod = self.modArr[indexPath.row];
        mod.judge4downloadBtn = 0; //按钮不能用
        mod.judge4progressView = 1; //显示进度条
        mod.judge4checkView = 0;//隐藏checkView
        self.modArr[indexPath.row] = mod; //返回给modArr
        
        //更改UI
        weakCell.downloadBtn.enabled = 0;
        weakCell.checkView.hidden = 1;
        weakCell.progressView.hidden= 0;
        weakCell.progressView.alpha=1;
        weakCell.progressView.progress = 0;
        //修改模型是为了复用时不出错，修改UI是为了即时效果
    };
    //设置下载完成后的block——目的是修改self.modArr，因为直接修改cell.mod没用，会在复用的时候被cell.mod = self.modArr[indexPath.row];覆盖掉
    cell.downloadCompleteBlock = ^(NSString *cachesPath){
        //下载完成后，修改模型，注意要修改的是modArr里面的模型，而不是cell.mod
        CloudDiskMod *mod = self.modArr[indexPath.row];
        mod.judge4checkView = 1; //显示checView
        mod.judge4progressView = 0; //不显示progresssView
        mod.judge4downloadBtn = 1; //可用下载按钮
        self.modArr[indexPath.row] = mod; //修改后的mod返回到modArr中
        
        //修改UI
        weakCell.downloadBtn.enabled = 1;
        weakCell.checkView.hidden = 0;
        [UIView animateWithDuration:0.3 animations:^{
            weakCell.progressView.alpha = 0;
            
        }];
        
        //修改模型是为了复用时不出错，修改UI是为了即时效果
        
        //获取一下保存的路径，从someAssist-->Cell-->这里，block嵌套block
        weakCell.mod.savePath = cachesPath;
        //以文件名为key，保存路径在字典中
        _cloudDiskFileDict = [NSMutableDictionary dictionary];
//        _cloudDiskFileDict = [NSKeyedUnarchiver unarchiveObjectWithFile:cloudDiskFilePath];
        [_cloudDiskFileDict setDictionary:[NSKeyedUnarchiver unarchiveObjectWithFile:cloudDiskFilePath]];
        
        [_cloudDiskFileDict setObject:weakCell.mod.savePath forKey:[NSString stringWithFormat:@"%@",weakCell.mod.fileName]];
        //这个字典保存在本地
        [NSKeyedArchiver archiveRootObject:_cloudDiskFileDict toFile:cloudDiskFilePath];
    };
    cell.downloadResultBlock = ^(NSError *er)
    {
        if (er) {
            [someAssist alertAndDisappearWith:@"服务器错误" viewController:self];
        }
    };
    cell.downloadProgressBlock = ^(float progress){
        //        self.mod.progress = progress; //这里有问题，这个self.mod会被复用的
        //        self.progressView.progress = self.mod.progress;
        //持续修改模型的数据
        
        CloudDiskMod *mod = [[CloudDiskMod alloc]init];
        mod = self.modArr[indexPath.row];
        mod.progress = progress;
        weakCell.progressView.progress = mod.progress;
        self.modArr[indexPath.row] = mod;
        
    };
    
    return cell;
}



@end
