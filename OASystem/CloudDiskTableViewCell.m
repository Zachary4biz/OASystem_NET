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
    self.downloadBtn.enabled=YES;
    self.progressView.hidden=YES;
    self.checkView.hidden = YES;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)downloadBtn:(id)sender {
    
    //点击下载按钮后，显示progressView，按钮失效，
    if (_clickDownloadBtnBlock) {
        _clickDownloadBtnBlock();
    }
    
    NSString *fileStr = [someAssist serverWith:self.downloadPath];
    NSURL *fileURL = [NSURL URLWithString:fileStr];
    NSMutableURLRequest *request_get = [NSMutableURLRequest requestWithURL:fileURL];
    request_get.timeoutInterval = 18000;
    
    //这个进度条是唯一一个在cell里面做的UI变化，还不知道好不好使______其实UI变化可以在cell里面做，UI变化后的标识如各种judge必须在VC的self.modArr里面更改才有效果，不然复用的时候cell.mod= self.modArr[indexPath.row];会把cell.mod里面保存的更改覆盖掉的。
    someAssist *download = [[someAssist alloc]init];
    download.progressblock=^(float progress){
        if (_downloadProgressBlock) {
            _downloadProgressBlock(progress);
        }
//        self.mod.progress = progress; //这里有问题，这个self.mod会被复用的
//        self.progressView.progress = self.mod.progress;
    };
    
    [download downloadFileWithrequest:request_get];
    
    download.completeDownloadBlock = ^(NSString *cachesPath){
        //回到主线程，判断并更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            //下载完成后，执行saveBlock，将用一个字典，以文件名为key，文件保存路径为value
            if (_downloadCompleteBlock) {
                _downloadCompleteBlock(cachesPath);
            }
        });
    };
    
    download.resultBlock = ^(NSError *error){
        if (_downloadResultBlock) {
            _downloadResultBlock(error);
        }
        
    };
}



@end
