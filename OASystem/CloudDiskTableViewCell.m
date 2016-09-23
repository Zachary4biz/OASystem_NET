//
//  CloudDiskTableViewCell.m
//  OASystem_NET
//
//  Created by 周桐 on 16/9/13.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "CloudDiskTableViewCell.h"
#import "CloudDiskMod.h"
#import "someAssist.h"

@interface CloudDiskTableViewCell()
#pragma UI
@property (weak, nonatomic) IBOutlet UILabel *fileName;
@property (weak, nonatomic) IBOutlet UILabel *provider;
@property (strong, nonatomic) someAssist *download;
- (IBAction)downloadBtn:(id)sender;




#pragma functional
@property (strong,nonatomic)NSString *downloadPath; //下载用的地址

@end

@implementation CloudDiskTableViewCell

-(void)setMod:(CloudDiskMod *)mod
{
#warning 这句干嘛用的来着？
    _mod = mod;
    self.fileName.text = mod.fileName;
    self.provider.text = mod.provider;
    self.downloadPath = mod.downloadPath;
#warning 注意*****************************不能修改模型数据，这样模型赋值_mod=mod的意义就没有了，直接修改UI就好了
//    //初始化时，下载按钮可用，进度条、check都不显示
//    self.mod.judge4downloadBtn = 1;
//    self.mod.judge4progressView = 0;
//    self.mod.judge4checkView = 0;
//    self.downloadBtn.enabled=YES;
    
    self.progressView.hidden=YES;
    self.checkView.hidden = YES;
    _download.cachesPath = self.mod.savePath;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //每个cell都有一个自己的download对象
    _download = [[someAssist alloc]init];
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)downloadBtn:(id)sender {
    
    if ([_downloadBtn.titleLabel.text isEqualToString:@"下载"]) {
        //点击下载按钮后，显示progressView，按钮失效，
        if (_clickDownloadBtnBlock) {
            _clickDownloadBtnBlock();
        }
        
        //准备下载
        NSString *fileStr = [someAssist serverWith:self.downloadPath];
        NSURL *fileURL = [NSURL URLWithString:fileStr];
        NSMutableURLRequest *request_get = [NSMutableURLRequest requestWithURL:fileURL];
        request_get.timeoutInterval = 18000;
        
        //下载前先传一下resumeData
        //把resumeData返回给download对象，在它的类里面会检查这个resumeData
//        NSString *fileName = [NSString stringWithFormat:@"resume_%@",self.mod.fileName];
//        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileName];
//        NSData *resumeData = [NSData dataWithContentsOfFile:path];
//        _download.getLocalResumeDataBlock = ^(){
//            return resumeData;
//        };
        //开始下载
        [_download downloadFileWithrequest:request_get];
        
        //三个传值block——进度、完成后的下载路径、请求完毕的结果（是否有error）
        //这个进度条是唯一一个在cell里面做的UI变化，还不知道好不好使______其实UI变化可以在cell里面做，UI变化后的标识如各种judge必须在VC的self.modArr里面更改才有效果，不然复用的时候cell.mod= self.modArr[indexPath.row];会把cell.mod里面保存的更改覆盖掉的。
        typeof(self) __weak weakSelf = self;
        _download.progressblock=^(float progress){
            //回到主线程，更新UI——progressView
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.downloadProgressBlock) {
                    weakSelf.downloadProgressBlock(progress);
                }
            });
    //        self.mod.progress = progress; //这里有问题，这个self.mod会被复用的
    //        self.progressView.progress = self.mod.progress;
        };

        _download.completeDownloadBlock = ^(NSString *cachesPath){
            //回到主线程，判断并更新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                //下载完成后，执行saveBlock，将用一个字典，以文件名为key，文件保存路径为value
                if (weakSelf.downloadCompleteBlock) {
                    weakSelf.downloadCompleteBlock(cachesPath);
                }
            });
        };
        
        _download.resultBlock = ^(NSError *error){
            if (weakSelf.downloadResultBlock) {
                weakSelf.downloadResultBlock(error);
            }
        };
    }
    else{
        //暂停情况下点击
        [_download suspendDownload];
        if (_clickSuspendBtnBlock) {
            _clickSuspendBtnBlock();
        }

    }
}



@end
