//
//  SelfInfoViewController.m
//  OASystem
//
//  Created by 周桐 on 16/8/22.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "SelfInfoViewController.h"
#import "selfInfoMod.h"
#import "someAssist.h"
//#import "MBProgressHUD.h"
@interface SelfInfoViewController ()<UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UITextField *jobTextField;
@property (weak, nonatomic) IBOutlet UITextField *eidTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (assign,nonatomic)int judge4iconViewEdit; //用来判断是不是在编辑模式，决定iconView能不能响应tap手势
- (IBAction)doneBtn:(id)sender;



@end

@implementation SelfInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setTextFields];
#warning 这个默认是给@selector函数传参传自己么
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(edit:)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iconTap)];
    
    [self.iconView addGestureRecognizer:tap];
    
}

//tap头像view
-(void)iconTap
{
    if (_judge4iconViewEdit == 0) {
        return;
    }
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"相机拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self callCamera];
    }];
    UIAlertAction *album = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self callAlbum];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:camera];
    [alertVC addAction:album];
    [alertVC addAction:cancel];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}
//调用相机
-(void)callCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *pickerVC = [[UIImagePickerController alloc]init];//初始化
        pickerVC.delegate = self;//设置代理
        pickerVC.allowsEditing = YES;//允许编辑
        pickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;//设置源为相机
        pickerVC.showsCameraControls = YES;//显示相机控制按钮
        pickerVC.cameraDevice = UIImagePickerControllerCameraDeviceFront;//选择摄像头--前置、后置
        [self presentViewController:pickerVC animated:YES completion:nil];
        
        /**
         一个添加相框的玩法，假设相框图片名字是XXX
         UIView *overlayerView = [[UIView alloc]initWithFrame:CGRectMake(0, 120, 320, 254)];
         UIImage *overlayBGimg = [UIImage imageNamed:@"XXX"];//是一个中间挖空了的图片，中间显示相机拍摄
         UIImageView *BGImgView = [[UIImageView alloc]initWithImage:overlayBGimg];
         [overlayerView addSubview:BGImgView];
         pickerVC.cameraOverlayView = overlayerView;
         */
        

    }
    else{
        [someAssist alertWith:@"相机不可用" viewController:self];
    }
    
}
//调用相册
-(void)callAlbum
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *pickerVC = [[UIImagePickerController alloc]init];
        pickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerVC.delegate = self;
        pickerVC.allowsEditing = YES;
        [self presentViewController:pickerVC animated:YES completion:nil];
    }
    else{
        [someAssist alertWith:@"相册不可用" viewController:self];
    }
}

//编辑按钮
-(void)edit:(UIBarButtonItem *)item
{
    if ([item.title isEqualToString:@"编辑"]) {
        item.title = @"取消";
        _doneBtn.hidden = NO;
        [_nameTextField becomeFirstResponder];
        _nameTextField.enabled = YES;
        _jobTextField.enabled = YES;
        _birthTextField.enabled = YES;
        _cityTextField.enabled = YES;
        _judge4iconViewEdit = 1;
    }
    else{
        item.title = @"编辑";
        _doneBtn.hidden = YES;
        //        [self.view endEditing:YES];
        //使用了.enable=NO之后，键盘就自动退出
        _nameTextField.enabled = NO;
        _jobTextField.enabled = NO;
        _birthTextField.enabled = NO;
        _cityTextField.enabled = NO;
        _judge4iconViewEdit = 0;
        //点击取消后，编辑的内容变回原来的样子
        _nameTextField.text = self.mod.name;
        _jobTextField.text = self.mod.job;
        _phoneTextField.text = self.mod.phone;
        _eidTextField.text = self.mod.eid;
    }
}
//完成按钮
- (IBAction)doneBtn:(id)sender {
//    [someAssist serverWith:@"editusr"];//notdone
    self.navigationItem.rightBarButtonItem.title = @"编辑";
    _doneBtn.hidden = YES;
    //        [self.view endEditing:YES];
    //使用了.enable=NO之后，键盘就自动退出
    _nameTextField.enabled = NO;
    _jobTextField.enabled = NO;
    _birthTextField.enabled = NO;
    _cityTextField.enabled = NO;
    _judge4iconViewEdit = 0;


}



//封装起来---赋值UI（最好回到主线程执行）
-(void)setTextFields
{
    self.jobTextField.text = self.mod.job;
    self.eidTextField.text = self.mod.eid;
    self.nameTextField.text = self.mod.name;
    self.birthTextField.text = self.mod.birth;
    self.cityTextField.text = self.mod.city;
    self.phoneTextField.text = self.mod.phone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//点击空白处回收键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma UIImagePickerViewControllerDelegate
//选完图片了
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //获取源图像
//    UIImage *image0  =[info objectForKey:UIImagePickerControllerOriginalImage];
    //获取裁剪后的图像
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    //照片存储到媒体库
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSaveingWithError:contextInfo:), NULL);
    //显示出来
    self.iconView.image = image;
    //将照片存到沙盒
    [self saveImage:image];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma 选完图片后用到的几个方法
-(void)saveImage:(UIImage *)image
{
    //设置照片品质
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    NSLog(@"NSHomeDirectory is ----\n%@",NSHomeDirectory());
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/currentImage.png"];
    NSString *testPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"testPath is ---\n %@",testPath);
    [imageData writeToFile:filePath atomically:YES];
    
}
#warning 这个(void*)contextInfo是什么？？
-(void)image:(UIImage *)image didFinishSaveingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        NSLog(@"done");
    }else{
        NSLog(@"error is ---%@",error);
    }
}



@end
