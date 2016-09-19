//
//  MoreBoardViewController.h
//  OASystem_NET
//
//  Created by 周桐 on 16/9/9.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreBoardViewController : UIViewController
@property(nonatomic,assign)NSInteger judgeFromTap;//判断是从tap一个view过来的还是从更多按钮过来的
//如果是从tap过来的就是1，不是从tap过来就没有被赋值，是nil
@end
