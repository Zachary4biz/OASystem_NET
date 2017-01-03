//
//  AppDelegate.m
//  OASystem
//
//  Created by 周桐 on 16/8/19.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "AppDelegate.h"
#import "NavController.h"
#import "EntryViewController.h"
#import "LoginViewController.h"


@interface AppDelegate ()




@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window.backgroundColor = [UIColor whiteColor];
    // Override point for customization after application launch.
    
//    创建窗口
//    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    //创建导航控制器的根控制器，也是导航控制器中显示在最外面的view,也是导航控制器的子控制器
    //XIB方法
    //这里init默认等同于initWithNibName:@"NavController"，默认寻找同名的xib进行加载
//    UIViewController *vc4nav = [[NavController alloc]init];
//    vc4nav.view.backgroundColor = [UIColor blueColor];
    
    //STORYBOARD方法
    //加载“Main”storyboard
//     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//     //通过storyboard创建控制器，使用的是storyboard中箭头所指向的initial View Controller
//     UIViewController *vc4nav= [storyboard instantiateInitialViewController];
    
    //创建导航控制器,根控制器是上面创建好的UIViewController类型的对象vc4nav
//    UINavigationController *navVc = [[UINavigationController alloc]initWithRootViewController:vc4nav];
    
//    navVc.view.backgroundColor = [UIColor purpleColor];
    
//    navVc.navigationBarHidden = YES;

    //设置窗口的跟控制器为创建好的导航控制器
//    self.window.rootViewController = navVc;
//
//    self.window.backgroundColor = [UIColor yellowColor];
    //显示窗口
//    [self.window makeKeyAndVisible];
    
    //1.设置分割线为空的图片
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    //2.设置背景图片为空的图片
    [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //3.设置背景颜色为空的颜色
    [[UINavigationBar appearance] setBackgroundColor:[UIColor clearColor]];
    //4.设置字体颜色（这只控制两个按钮的字体颜色，而不是title
    [[UINavigationBar appearance] setTintColor:[UIColor blueColor]];
    //5.设置title的字体颜色
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
