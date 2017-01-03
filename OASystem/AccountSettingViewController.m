//
//  AccountSettingViewController.m
//  OASystem
//
//  Created by 周桐 on 16/8/23.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "AccountSettingViewController.h"
#import "someAssist.h"

@interface AccountSettingViewController ()<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>
- (IBAction)resign:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AccountSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)resign:(id)sender {
    NSLog(@"注销");
    //弹出actionsheet
//    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"确认注销？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"注销" otherButtonTitles:nil, nil];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认注销?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"注销" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:[someAssist serverWith:@"resign"]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init]  completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            NSLog(@"%@",response);
        }];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:ok];
    [alert addAction:no];
    [self presentViewController:alert animated:YES completion:nil];
    
}
-(void)resign
{
    NSLog(@"注销");
    //弹出actionsheet
    //    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"确认注销？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"注销" otherButtonTitles:nil, nil];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认注销?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"注销" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:[someAssist serverWith:@"resign"]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init]  completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            NSLog(@"%@",response);
        }];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:ok];
    [alert addAction:no];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                NSLog(@"修改密码");
            }
            break;
            
        case 1:
            if (indexPath.row == 0) {
                [self resign];
            }
            break;
        default:
            break;
    }
}

#pragma UITableViewDataSource
//-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//    return 2;
//}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 1;
            break;
        default:
            return 1;
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.focusStyle = UITableViewCellFocusStyleCustom;
//    cell.highlighted = NO;
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        switch (indexPath.section) {
            case 0:
                if (indexPath.row == 0) {
                    cell.textLabel.text = @"修改密码";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                else if (indexPath.row == 1){
                    cell.textLabel.text = @"操作2";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                break;
            case 1:
                if (indexPath.row == 0) {
                    cell.textLabel.textColor = [UIColor redColor];
                    cell.textLabel.text = @"注销";
                }
                break;
            default:
                break;
        }
    }

    return cell;
}


@end
