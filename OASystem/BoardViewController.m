
//
//  BoardViewController.m
//  OASystem
//
//  Created by 周桐 on 16/8/23.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "BoardViewController.h"
#import "boardTHN.h"
#import "boardDetail.h"
#import "someAssist.h"
#import "MoreBoardViewController.h"

@interface BoardViewController ()<boardTHNDelegate,NSCoding>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;//用来装公告
- (IBAction)addBtn:(id)sender; //发布公告按钮

@property (weak, nonatomic) IBOutlet UIView *boardView; //用来装公告的view，每次willAppear都删除它的所有子view，并重新加载xib
@property (nonatomic,strong)NSMutableArray *boardModArr;
@property(nonatomic,assign)CGPoint curP; //用来获取全局上的触摸点   位置
@property(nonatomic,strong) NSMutableArray *recorder4Frame;//换了思路，数组保存frame就行了，数组的索引就是tag。 老想法：数组保存字典，字典是tag和frame，
@property(nonatomic,strong)NSMutableArray *recorder4DefaultFrame; //加载的初始九宫格的frame，这个是为了避免第一次打开程序，recorder4Frame是空，用这个来记录默认的九宫格布局
@property(nonatomic,assign)NSInteger judge;//判断是不是从tap跳转到moreBoard页面
@end

@implementation BoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //搞一个右边按钮
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(rightItmBtn)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
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
    [super viewWillAppear:animated];
    self.judge = 0; //每次出现都把这个判断归为0，当点击添加的view的时候再赋为1，用来判断是从添加view的tap手势取到下一页，还是从导航栏的按钮取到下一页
    [self.boardView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self refreshBoard];
    [self getMod4THN];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self saveFrame];
}

-(void)refreshBoard{
    _boardModArr = [NSMutableArray array];
    //查看本地有没有排好的前12个
    _boardModArr = [NSKeyedUnarchiver unarchiveObjectWithFile:board2ShowModPath];
    //加载12个xib
    [self loadXibs];
    //尝试加载本地布局文件
    //预防新程序本地文件为空
    self.recorder4Frame = [NSMutableArray array];
    [self.recorder4Frame setArray:[NSKeyedUnarchiver unarchiveObjectWithFile:boardTHNFramePath]];
//    self.recorder4Frame = [NSKeyedUnarchiver unarchiveObjectWithFile:boardTHNFramePath];
    if (self.recorder4Frame.count){
        //如果本地有布局文件
        [self loadXibWithLocalFrame]; //这个移动换位置的效果思路就是view的tag都不变，然后根据tag去保存有frame的数组里面从0到n依次拿frame，所以换了位置后要把frame数组里的对应的两个frame也交换。
    }
    else{
        //本地没有布局文件，就不加载本地Frame就行了，使用加载xib的九宫格默认布局
        //并且把默认的布局赋给这个recorder4Frame数组，这个在block里面有用到
        self.recorder4Frame = self.recorder4DefaultFrame;
    }
    //遍历所有子view，给它们设置block
    [self setBoardTHNViewBlocks];
    
}

-(void)loadXibWithLocalFrame
{
    //这里注意要根据tag来给frame，而不是subviews的顺序，注意是tag-1
    for (int i=0; i<self.boardView.subviews.count; i++) {
        boardTHN *boardTHNView = self.boardView.subviews[i];
        boardTHNView.frame = [self.recorder4Frame[boardTHNView.tag-1] CGRectValue];
    }
}

-(void)loadXibs
{
    //先获取一个xib文件，用来设置一些排列用的参数
    boardTHN *boardView_temp = [[NSBundle mainBundle]loadNibNamed:@"boardTHN" owner:nil options:nil][0];
    //设定各个subview的初步排列
    int column = 3;//3列，即3个一行
    int subW = boardView_temp.frame.size.width;
    int subH = boardView_temp.frame.size.height;
    //距离屏幕边框的距离
    //这里需要控制一下宽度，虽然在stroyboard里面写了width = self.view.width但还是出错，要重新把self.view.frame处理了纵向位置后传给self.boardView.frame，
    CGRect temp = self.view.frame;
    temp.origin.y +=64;
    NSLog(@"%f",temp.size.width);
    temp.size.height -= 124;
    self.boardView.frame = temp;
    int marginX = (self.boardView.frame.size.width - column * subW)/(column +1);
    int marginY = marginX;
    
    //这个页面最多显示3X4 12个，12个之后，点击更多按钮
    NSInteger temp_recorder = self.boardModArr.count;
    if (_boardModArr.count>12) {
        temp_recorder = 12;
    }
    //初始化用来保存frame和tag的字典
    _recorder4DefaultFrame = [NSMutableArray array];
    
    for (int i=0; i<12;i++){
        boardTHN *boardTHNView = [[NSBundle mainBundle]loadNibNamed:@"boardTHN" owner:nil options:nil][0];
        int col = i % column;//计算在第几列
        int row = i / column;//计算在第几行
        
        CGFloat subX = marginX + col*(marginX + subW);
        CGFloat subY = marginY + row*(marginX + subH);
        
        boardTHNView.frame = CGRectMake(subX, subY, subW, subH);
        //给标记，后面换位置可能用到
        boardTHNView.tag = i+1;//tag最好不要从零开始，因为默认superView的tag是0
    
        NSValue *frame = [NSValue valueWithCGRect:boardTHNView.frame];
        
        [_recorder4DefaultFrame addObject:frame];
        
        [self.boardView addSubview:boardTHNView];
        
        //把view变成圆形的
        boardTHNView.layer.cornerRadius = boardTHNView.frame.size.width * 0.5;
        
    }
}

-(void)setBoardTHNViewBlocks{
    for(int i=0;i<self.boardView.subviews.count;i++)
    {
        boardTHN *boardTHNView = self.boardView.subviews[i];
        //防止循环引用
        typeof(boardTHNView) __weak weakSelf = boardTHNView;
        //实现点击触摸的block——————tap
        boardTHNView.boardTHN_tapBlock=^(){
            NSLog(@"来到这个tap");
            //显示Detail
            boardDetail *DetailView = [[NSBundle mainBundle]loadNibNamed:@"boardDetail" owner:nil options:nil][0];
            CGRect temp = DetailView.frame;
            temp = self.boardView.frame;
            temp.origin.y -= 64;
            DetailView.frame = temp;
            DetailView.mod = _boardModArr[i];
            
            [self.boardView addSubview:DetailView];
            
            //实现Detail页面点击缩回的block
            DetailView.boardDetail_tapBlock=^(){
                [[self.boardView.subviews lastObject] removeFromSuperview];
            };
        };
        //实现点击触摸（没有数据的情况下）——tapWithoutMod
        //希望只有第一个没有数据的采用这个block，其他没有数据的就不用实现tap的交互了
        //实现触摸就放到最前面来的block——————toucheBegin
        boardTHNView.boardTHN_touchBeginBlock=^(){
            [self.boardView bringSubviewToFront:weakSelf];
        };
        //实现触摸结束换位置————————toucheEnd
        boardTHNView.boardTHN_touchEndBlock=^(CGPoint currentP){
            NSInteger tag_touched = weakSelf.tag-1;
            for (int i =0; i<self.recorder4Frame.count; i++) {
                CGPoint myPoint = [weakSelf convertPoint:currentP toView:self.boardView];
                CGRect frame_target = [self.recorder4Frame[i] CGRectValue];
                //保存当前触摸的view的frame
                CGRect frame_touched = [self.recorder4Frame[tag_touched] CGRectValue];
                if (CGRectContainsPoint(frame_target, myPoint))
                {
                    //再通过tag找到目标view
                    boardTHN *targetView = [self.boardView viewWithTag:i+1];
                    //动画效果
                    [UIView animateWithDuration:0.3 animations:^{
                        weakSelf.frame = targetView.frame;
                        targetView.frame = frame_touched;
                    }];
                    //换数组
                    self.recorder4Frame[i] = self.recorder4Frame[weakSelf.tag-1];
                    self.recorder4Frame[weakSelf.tag-1] = [NSValue valueWithCGRect:frame_target];
                    //                    [self saveFrame];
                    break;
                }
                //-1因为从0开始计数啊！
                else if(i == self.recorder4Frame.count -1 ){
                    //运行这里的条件其实有两个：1.i达到最后一个 2.没有执行上一个if（因为那里有break）
                    //所以说明遍历到最后一个都没有找到curP在哪个frame，即curP在空白处
                    [UIView animateWithDuration:0.3 animations:^{
                        weakSelf.frame = frame_touched;
                    }];
                }
                
            }
        };
        //当触摸中断时，比如tap了之后会弹出详情，就相当于中断了THN的触摸——————toucheCancel
        boardTHNView.boardTHN_toucheCancelBlock = ^{
            weakSelf.transform = CGAffineTransformIdentity;
        };
    }
}

- (void)dealloc {
    NSLog(@"dealloc");
}

//-(void)touchEnd:(CGPoint)curP
//{
//    NSLog(@"DELEGATE?NOW?");
//
//}

-(void)saveFrame
{
    [NSKeyedArchiver archiveRootObject:self.recorder4Frame toFile:boardTHNFramePath];
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    for (int i=0; i<self.recorder4Frame.count; i++) {
        NSString *key = [NSString stringWithFormat:@"%d",i];
        [aCoder encodeObject:self.recorder4Frame[i] forKey:key];
    }
    
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        for (int i=0; i<self.recorder4Frame.count; i++) {
            NSString *key = [NSString stringWithFormat:@"%d",i];
            self.recorder4Frame[i] = [aDecoder decodeObjectForKey:key];
        }
    }
    return self;
}

-(void)getMod4THN
{
    for (int i=0; i<self.boardModArr.count; i++) {
        boardTHN *tempView = self.boardView.subviews[i];
        tempView.layer.cornerRadius = 0;
        tempView.bgView.hidden =YES;
        tempView.mod = self.boardModArr[i];
    }
    if (self.boardModArr.count>=12) {
        //有12个数据了，那就不管了
    }
    else{
        //找到第一个没有数据的，
        boardTHN *firstView = self.boardView.subviews[self.boardModArr.count];
        //设置背景
        firstView.bgView.image = [UIImage imageNamed:@"plus"];
        //设置tag
        //设置第一个没有数据的view的tap，并且用sender传自己
        typeof(firstView) __weak weakfirstWithoutMod = firstView;
        firstView.boardTHN_tapWithoutModBlock=^{
            //是从tap进行跳转的
            self.judge = 1;
            [self performSegueWithIdentifier:@"board2more" sender:weakfirstWithoutMod];
        };
    }
}

- (IBAction)addBtn:(id)sender {
    [self performSegueWithIdentifier:@"board2add" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"board2more"]) {
        if (self.judge ==1 ){
            //说明是从tap来调用
            MoreBoardViewController *tempVC = segue.destinationViewController;
            tempVC.judgeFromTap = 1;
        }
    }

}
@end
