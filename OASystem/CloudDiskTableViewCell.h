//
//  CloudDiskTableViewCell.h
//  OASystem_NET
//
//  Created by 周桐 on 16/9/13.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CloudDiskMod;
@interface CloudDiskTableViewCell : UITableViewCell
@property(nonatomic,strong)CloudDiskMod *mod;
@property (weak, nonatomic) IBOutlet UIImageView *checkView;//希望在cellForRow里面设置这个checkView，因为在cell.m里面会复用
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;//同理避免复用，在cellForRow里设置
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;//同上
//上面这些原理：mod里面有一个属性是judge=0，点击下载按钮后，judge=1，下载完成后judge=0，在cellForRow中根据mod.judge来判断当前要加载的这个cell的各个view是否需要hidden、enabled
@property (nonatomic,assign)NSInteger indexRow;//测试用，在cell的dealloc中看看是什么时候，哪个celldealloc

@property(nonatomic,strong) void (^downloadCompleteBlock)(NSString *cachesPath);//这个下载完成后执行的block，是因为我们改模型数据，是要在tableView的VC里面改它的modArr里面的mod，而不是改cell.mod，因为cell会复用，cell.mod也会复用，每次其实是通过cell.mod = self.modArr[indexPath.row]这句话来修改了cell.mod，所以要改东西也要在self.modArr里面改，改cell.mod没有用的，会被self.modArr覆盖掉
@property(nonatomic,strong) void (^clickDownloadBtnBlock)();//在VC实现这个block
@property(nonatomic,strong)void(^downloadResultBlock)(NSError *er);//请求完毕后，是否有出错，可以从这个来处理
@property(nonatomic,strong) void(^downloadProgressBlock)(float progress);//下载进度也要在self.modArr里赋值
@property(nonatomic,strong) void(^clickSuspendBtnBlock)(NSData *data); //下载按钮变成暂停时，点击了的block
@end
