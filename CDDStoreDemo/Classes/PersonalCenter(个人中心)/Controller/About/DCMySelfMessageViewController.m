//
//  DCMySelfMessageViewController.m
//  CDDMall
//
//  Created by apple on 2017/6/9.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCMySelfMessageViewController.h"

// Controllers
#import "DCChangeNickNameViewController.h"
#import "DCReceiverAdressViewController.h"
// Models
#import "DCKeepNewUserData.h"
// Views
#import "DCSettingCell.h"
#import "DCSelPhotos.h"
// Vendors
#import "JKDBModel.h"
// Categories

// Others

@interface DCMySelfMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

/* tableView */
@property (strong , nonatomic)UITableView *tableView;
/* imageView */
@property (strong , nonatomic)UIButton *headImageView;


@end

static NSString *const DCSettingCellID = @"DCSettingCell";

@implementation DCMySelfMessageViewController

#pragma mark - LazyLoad
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.frame = CGRectMake(0, DCTopNavH + 180, ScreenW, ScreenH - DCTopNavH);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [self.view addSubview:_tableView];
        
        [_tableView registerClass:[DCSettingCell class] forCellReuseIdentifier:DCSettingCellID];
    }
    return _tableView;
}

#pragma mark - LifeCyle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTab];
}


#pragma mark - initizlize
- (void)setUpTab
{
    self.title = @"账户管理";
    self.view.backgroundColor = DCBGColor;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.scrollEnabled = NO;
}



#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DCSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:DCSettingCellID forIndexPath:indexPath];
    
    NSArray *titles = @[@"会员俱乐部",@"收货地址",@"实名认证",@"账户安全"];
    cell.titleLabel.text = titles[indexPath.row];
    NSArray *contents = @[@"",@"",@"未认证",@"安全等级：中"];
    cell.contentLabel.text = contents[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    DCUserInfo *userInfo = UserInfoData;
//    if (indexPath.section == 0) {
//        if (indexPath.row == 0) {
//            [self changeProfileImage:userInfo];
//        }else if (indexPath.row == 2){
//            [self changeNickNameWith:userInfo];
//        }else if (indexPath.row == 3){
//            [self changeSex:userInfo];
//        }
//    }else if (indexPath.section == 1){
//        DCReceiverAdressViewController *reVc = [[DCReceiverAdressViewController alloc] init];
//        [self.navigationController pushViewController:reVc animated:YES];
//    }
    
}

#pragma mark - 更改昵称
- (void)changeNickNameWith:(DCUserInfo *)userInfo
{
    DCChangeNickNameViewController *chageNickVc = [[DCChangeNickNameViewController alloc] init];
    chageNickVc.oldNickName = userInfo.nickname;
    [self.navigationController pushViewController:chageNickVc animated:YES];
}

#pragma mark - 点击了更换头像
- (void)changeProfileImage:(DCUserInfo *)userInfo {
    WEAKSELF;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        DCSelPhotos *imageManager = [DCSelPhotos selPhotos];
        [imageManager pushImagePickerControllerWithImagesCount:1 WithColumnNumber:3 didFinish:^(TZImagePickerController *imagePickerVc) {
            __strong typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf presentViewController:imagePickerVc animated:YES completion:nil];
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                if (![userInfo.userimage isEqualToString:[DCSpeedy UIImageToBase64Str:photos.lastObject]]) { //判断
                    [strongSelf.headImageView setImage:photos.lastObject forState:UIControlStateNormal];
                    userInfo.userimage = [DCSpeedy UIImageToBase64Str:photos.lastObject];
                    
                    [userInfo save];
                }
            }];
        }];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消更换头像");
    }]];
    
    [weakSelf presentViewController:alert animated:YES completion:nil];

}

#pragma mark - 改变用户性别
- (void)changeSex:(DCUserInfo *)userInfo
{
    WEAKSELF;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        if (![userInfo.sex isEqualToString:@"女"]) {
            userInfo.sex = @"女";
            [userInfo save];
            [weakSelf.tableView reloadData];
        }

    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        if (![userInfo.sex isEqualToString:@"男"]) {
            userInfo.sex = @"男";
            [userInfo save];
            [weakSelf.tableView reloadData];
        }
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消更换性别");
    }]];
    
    [weakSelf presentViewController:alert animated:YES completion:nil];
}


@end
