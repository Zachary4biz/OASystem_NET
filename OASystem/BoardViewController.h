//
//  BoardViewController.h
//  OASystem
//
//  Created by 周桐 on 16/8/23.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoardViewController : UIViewController
@property (nonatomic,strong)id result;//以后从网络获取数据都这样传，获取result，这样即使超时、不能连接都会在妻前一个页面转圈，然后到这个页面判断result是取没取到值
//在这个VC里面没法在viewDidload之前判断能不能联网、有没有获得数据，只能说用懒加载，勉强能实现一下连不上网就显示空数据的效果
//如果在进入这一层VC断网了，而获取数据不是从上一层传过来而是从网络获取，会直接崩溃
//注：执行顺序：alloc-->init-->loadView-->viewDidLoad-->viewWillAppear-->DidAppear-->willDisappear-->DidDisappear-->dealloc
//简单来说，只要联网获取数据这一步写在viewDidLoad里面，就会把这个页面卡主，进不来的，只有加载完了才会进来，所以还是在前一个页面联网获取数据把，那样还能搞个加载中的动画
@end
