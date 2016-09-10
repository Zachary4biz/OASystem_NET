
//
//  BoardViewController.m
//  OASystem
//
//  Created by 周桐 on 16/8/23.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "BoardViewController.h"
#import "boardTHN.h"
#import "someAssist.h"
#import "boardDetail.h"

@interface BoardViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;//用来装公告
- (IBAction)addBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *boardView;
@property (nonatomic,strong)NSMutableArray *boardModArr;
@end

@implementation BoardViewController

//-(id)boardModArr{
//    _boardModArr = [NSMutableArray array];
//    id result = [someAssist getBoard_modArr]; //这里用result判断而不是直接用_boardModArr是因为后面要用到数组的count属性，而判断方法tellResult要求传入的是id类型
//    tellResult(result) //判断result有没有接到模型数组，tellResult中如果不是模型数组会把result=nil
//    //tellResult中也写好了弹窗
//    if (result == nil){
//        _boardModArr = [NSKeyedUnarchiver unarchiveObjectWithFile:boardModPath];
//    }
//    else{
//        _boardModArr = result;
//        [NSKeyedArchiver archiveRootObject:_boardModArr toFile:boardModPath];
//    }
//    return _boardModArr;
//}

//-(id)boardModArr{
//
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //搞一个右边按钮
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(rightItmBtn)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
//    //先获取一个xib文件，用来设置一些排列用的参数
//    boardTHN *boardView_temp = [[NSBundle mainBundle]loadNibNamed:@"boardTHN" owner:nil options:nil][0];
//    //设定各个subview的初步排列
//    int column = 3;//3列，即3个一行
//    int subW = boardView_temp.frame.size.width;
//    int subH = boardView_temp.frame.size.height;
//    //距离屏幕边框的距离
//    int marginX = (self.view.frame.size.width - column * subW)/(column +1);
//    int marginY = marginX+64; //64是上面的导航栏加状态栏
    
//    //这个页面最多显示3X4 12个，12个之后，点击更多按钮
//    NSInteger temp_recorder = self.boardModArr.count;
//    if (_boardModArr.count>12) {
//        temp_recorder = 12;
//    }
//    for (int i=0; i<temp_recorder;i++){
//        boardTHN *boardView = [[NSBundle mainBundle]loadNibNamed:@"boardTHN" owner:nil options:nil][0];
//        int col = i % column;//计算在第几列
//        int row = i / column;//计算在第几行
//        
//        CGFloat subX = marginX + col*(marginX + subW);
//        CGFloat subY = marginY + row*(marginX + subH);
//        
//        boardView.frame = CGRectMake(subX, subY, subW, subH);
//        //给数据
//        boardView.mod = _boardModArr[i];
//        //给标记，后面换位置可能用到
//        boardView.tag = i;
//        
////        [self.scrollView addSubview:boardView];
//        [self.view addSubview:boardView];
//        
//        //实现点击触摸的block
//        boardView.boardTHN_touchBlock=^(){
//            //显示Detail
//            boardDetail *DetailView = [[NSBundle mainBundle]loadNibNamed:@"boardDetail" owner:nil options:nil][0];
//            CGRect temp = DetailView.frame;
//            temp = self.view.frame;
//            temp.origin.y += 64;
//            temp.size.height -=64;
//            DetailView.frame = temp;
//            DetailView.mod = _boardModArr[i];
//            
//            [self.view addSubview:DetailView];
////            [self.view bringSubviewToFront:DetailView];
//            //实现Detail页面点击缩回的block
//            DetailView.boardDetail_touchBlock=^(){
//                [[self.view.subviews lastObject] removeFromSuperview];
////                [[self.scrollView.subviews lastObject] removeFromSuperview];
//            };
//        };
//        //实现触摸就放到最前面来的block
//        boardView.boardTHN_moveBlock=^(){
//#warning 首次遇见block循环引用，但是看上面的DetailView的bringToFront，没有报警告？
//            [self.view bringSubviewToFront:boardView];
//        };
//    }
    
    
}


-(void)rightItmBtn{
    
    [self performSegueWithIdentifier:@"board2more" sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
//    for (NSInteger i=0;i<self.view.subviews.count;i++){
//      [self.view.subviews[i] removeFromSuperview];
//    }
    [self.boardView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self refreshBoard];
}

-(void)refreshBoard{
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
            //重新加载xib并布局
            [self loadXibs];
        }];
    }];

}

-(void)loadXibs
{//注意交换位置还要交换tag
    //检查有没有之前做的布局
    //先获取一个xib文件，用来设置一些排列用的参数
    boardTHN *boardView_temp = [[NSBundle mainBundle]loadNibNamed:@"boardTHN" owner:nil options:nil][0];
    //设定各个subview的初步排列
    int column = 3;//3列，即3个一行
    int subW = boardView_temp.frame.size.width;
    int subH = boardView_temp.frame.size.height;
    //距离屏幕边框的距离
    int marginX = (self.boardView.frame.size.width - column * subW)/(column +1);
    int marginY = marginX;
    
    //这个页面最多显示3X4 12个，12个之后，点击更多按钮
    NSInteger temp_recorder = self.boardModArr.count;
    if (_boardModArr.count>12) {
        temp_recorder = 12;
    }
    for (int i=0; i<temp_recorder;i++){
        boardTHN *boardView = [[NSBundle mainBundle]loadNibNamed:@"boardTHN" owner:nil options:nil][0];
        int col = i % column;//计算在第几列
        int row = i / column;//计算在第几行
        
        CGFloat subX = marginX + col*(marginX + subW);
        CGFloat subY = marginY + row*(marginX + subH);
        
        boardView.frame = CGRectMake(subX, subY, subW, subH);
        //给数据
        boardView.mod = _boardModArr[i];
        //给标记，后面换位置可能用到
        boardView.tag = i;
        
        //        [self.scrollView addSubview:boardView];
        [self.boardView addSubview:boardView];
        
        //实现点击触摸的block
        boardView.boardTHN_touchBlock=^(){
            //显示Detail
            boardDetail *DetailView = [[NSBundle mainBundle]loadNibNamed:@"boardDetail" owner:nil options:nil][0];
            CGRect temp = DetailView.frame;
            temp = self.boardView.frame;
            DetailView.frame = temp;
            DetailView.mod = _boardModArr[i];
            
            [self.boardView addSubview:DetailView];
            //            [self.view bringSubviewToFront:DetailView];
            //实现Detail页面点击缩回的block
            DetailView.boardDetail_touchBlock=^(){
                [[self.boardView.subviews lastObject] removeFromSuperview];
                //                [[self.scrollView.subviews lastObject] removeFromSuperview];
            };
        };
        //实现触摸就放到最前面来的block
        boardView.boardTHN_moveBlock=^(){
#warning 首次遇见block循环引用，但是看上面的DetailView的bringToFront，没有报警告？
            [self.boardView bringSubviewToFront:boardView];
        };
    }
}


- (IBAction)addBtn:(id)sender {
    
    [self performSegueWithIdentifier:@"board2add" sender:nil];
}
@end
