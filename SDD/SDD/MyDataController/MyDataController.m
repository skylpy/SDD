//
//  MyDataController.m
//  SDD
//  个人资料
//  Created by Cola on 15/4/17.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "MyDataController.h"
#import "EditPasswordController.h"
#import "BindTelController.h"
#import "EditNameController.h"

#import "UIImageView+WebCache.h"

@interface MyDataController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>{
    
    UIView *_anchorView;
    BOOL _anchorLeft;
    
    // 头像
    UIImageView * userAvatar;
    // 用户昵称
    NSString *nickname;
    // 性别
    NSInteger gender;
}

@end

@implementation MyDataController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataSource = [self getProfileConfigureArray];
    [self setNav:@"我的账号"];
    self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;
    
    nickname = _userInfoDic[@"realName"];
    gender = [_userInfoDic[@"gender"] integerValue];
    
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    // 登录按钮
    UIView * regBtn = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 55)];
    UIButton *_loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.frame = CGRectMake(20, 10, viewWidth - 40, 40);
    _loginBtn.titleLabel.font = largeFont;
    _loginBtn.layer.cornerRadius = 5;
    _loginBtn.backgroundColor = deepOrangeColor;
    [_loginBtn setTitle:NSLocalizedString(@"save", @"") forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [regBtn addSubview:_loginBtn];
    self.tableView.tableFooterView = regBtn;
    
    UITapGestureRecognizer *inputImageClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inputImage:)];
    inputImageClick.numberOfTouchesRequired = 1;
    inputImageClick.numberOfTapsRequired = 1;
    [_loginBtn addGestureRecognizer:inputImageClick];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    UITableViewCellStyle currentStyle;
    
    NSMutableDictionary *sectionDictionary = self.dataSource[section][row];
    NSString *title = [sectionDictionary valueForKey:@"title"];
//    NSString *imageName = [sectionDictionary valueForKey:@"image"];
    
    currentStyle = UITableViewCellStyleValue1;
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:currentStyle reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
        cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
        
        if (indexPath.section == 0 && indexPath.row == 0) {
            userAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth - 110, 10, 80, 80)];
            userAvatar.contentMode = UIViewContentModeScaleAspectFill;
            userAvatar.layer.masksToBounds =YES;
            userAvatar.layer.cornerRadius =40;
            [userAvatar setTag:101];
            [cell addSubview:userAvatar];
        }
    }
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        userAvatar = (UIImageView *)[cell viewWithTag:101];
        [userAvatar sd_setImageWithURL:[NSURL URLWithString:_userInfoDic[@"icon"]]];
    }
    else {
        
        switch (indexPath.row) {
            case 0:
            {
                cell.detailTextLabel.text = nickname;
            }
                break;
            case 1:
            {
                cell.detailTextLabel.text = gender==0?@"女":@"男";
            }
                break;
            case 2:
            {
                cell.detailTextLabel.text = _userInfoDic[@"phone"];
            }
                break;
                
            default:
                break;
        }
    }
    
    if (title) {
        cell.textLabel.text = title;
    }
    
    return cell;
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && indexPath.section == 0) {
        return 100;
    }
    return 45;
}

- (NSMutableArray *)getProfileConfigureArray {
    NSMutableArray *profiles = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSString *titleKey = @"title";
    NSString *imageKey = @"image";
    
    NSMutableArray *rows = [[NSMutableArray alloc] initWithCapacity:1];
    for (int i = 0; i < 1; i ++) {
        NSString *title;
        NSString *imageName;
        switch (i) {
            case 0:
                title = NSLocalizedString(@"face", @"");
                break;
        }
        
        NSMutableDictionary *sectionDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:title, titleKey, imageName, imageKey, nil];
        [rows addObject:sectionDictionary];
    }
    [profiles addObject:rows];
    
    
    NSMutableArray *rows2 = [[NSMutableArray alloc] initWithCapacity:1];
    for (int i = 0; i < 4; i ++) {
        NSString *title;
        NSString *imageName;
        switch (i) {
            case 0:
            {
                title = NSLocalizedString(@"trueName", @"");
            }
                break;
            case 1:
            {
                title = NSLocalizedString(@"sex", @"");
            }
                break;
            case 2:
            {
                title = NSLocalizedString(@"editPhone", @"");
            }
                break;
            case 3:
            {
                title = NSLocalizedString(@"reditPassword", @"");
            }
                break;
            default:
                break;
        }
        
        NSMutableDictionary *sectionDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:title, titleKey, imageName, imageKey, nil];
        [rows2 addObject:sectionDictionary];
    }
    [profiles addObject:rows2];
    
    return profiles;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return 15;
        default: {
            
            return 1;
        }
    }
    return 1;
}

//每个section头部标题高度（实现这个代理方法后前面 sectionFooterHeight 设定的高度无效）
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 14;
}

#pragma mark - 点击cell进入详细页面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *viewController;
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    switch (section) {
        case 0:
        {
            UIActionSheet *shotOrAlbums = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册中选择", nil];
            [shotOrAlbums showInView:self.view];
            break;
        }
        case 1: {
            switch (row) {
                case 0:
                {
                    EditNameController *enc = [[EditNameController alloc] init];
                    
                    enc.theNickname = cell.detailTextLabel.text;
                    [enc valueReturn:^(NSString *theName) {
                        
                        nickname = theName;
                        cell.detailTextLabel.text = theName;
                    }];
                    
                    viewController = enc;
                    break;
                }
                case 1:
                {
//                    SexSelectController *ssc = [[SexSelectController alloc] init];
//                    
//                    ssc.theGender = [cell.detailTextLabel.text isEqualToString:@"女"]?0:1;
//                    [ssc valueReturn:^(NSInteger theGender) {
//                        
//                        gender = theGender;
//                        cell.detailTextLabel.text = theGender ==0?@"女":@"男";
//                    }];
//
//                    viewController = ssc;
                    break;
                }
                case 2:
                {
                    BindTelController *btc = [[BindTelController alloc] init];
                    
                    btc.thePhoneNum = _userInfoDic[@"phone"];
                    [btc valueReturn:^(NSString *thePhoneNum) {
                        
                        cell.detailTextLabel.text = thePhoneNum;
                    }];
                    
                    viewController = btc;
                    break;
                }
                case 3:
                {
                    EditPasswordController *sc = [[EditPasswordController alloc] init];
                    viewController = sc;
                    break;
                }
                default:
                    break;
            }
            break;
        }
    }
    
    if (viewController) {
        [self.navigationController pushViewController:viewController animated:NO];
    }
}

#pragma mark - 保存
- (void)inputImage:(UITapGestureRecognizer *)sender{
    
    NSDictionary *param = @{@"gender":[NSNumber numberWithInteger:gender],@"realName":nickname};
    NSString *urlString = [SDD_MainURL stringByAppendingString:@"/user/modify.do"];              // 拼接主路径和请求内容成完整url
    
    [self sendRequest:param url:urlString];
    [self showLoading:0];
}

- (void)onSuccess:(AFHTTPRequestOperation *)operation context:(id)responseObject{
    
    NSDictionary *dict = responseObject;
    NSLog(@"%@>>>>>>>%@",dict[@"message"],dict);
    [self showSuccessWithText:dict[@"message"]];
    [self.navigationController popViewControllerAnimated:YES];
}
 
- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    //before animation and hiding view    
    switch (buttonIndex) {
        case 0:
        {
            NSLog(@"拍照");
            [self pickImageFromCamera];
        }
            break;
        case 1:
        {
            NSLog(@"相册选择");
            [self pickImageFromAlbum];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 从用户相册获取活动图片
- (void)pickImageFromAlbum{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing = YES;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

#pragma mark - 调用摄像机
- (void)pickImageFromCamera{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.allowsEditing = YES;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - 当用户取消选取时调用；
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 当用户选取完成后调用；
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    //初始化imageNew为从相机中获得的--
    UIImage *imageNew = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        
        UIImageWriteToSavedPhotosAlbum(imageNew, nil, nil, nil);
    }
    
    //设置image的尺寸
    CGSize imagesize = imageNew.size;
    imagesize.height =80;
    imagesize.width =80;
    //对图片大小进行压缩--
//    userAvatar.image = [self imageWithImage:imageNew scaledToSize:imagesize];
    userAvatar.image = imageNew;    
    
    NSData *imageData = UIImageJPEGRepresentation(imageNew,0.01);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString *fullPathToFile = [documentsDirectory stringByAppendingPathComponent:@"newAvatar.png"];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:YES];
    NSLog(@"%@",[NSURL fileURLWithPath:fullPathToFile]);
    [self uploadTask:fullPathToFile];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//对图片尺寸进行压缩--
- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize{
    
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

#pragma mark - 上传图片
- (void)uploadTask:(NSString *)imageUrl{
    NSLog(@"上传图片");
    
    [self showLoading:0];
    
    NSString *str = [SDD_MainURL stringByAppendingString:@"/upload/icon.do"];              // 拼接主路径和请求内容成完整url
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:str parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:imageUrl] name:@"icon" fileName:@"newAvatar.png" mimeType:@"image/png" error:nil];
    } error:nil];
    AFURLSessionManager * manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSProgress *progress = nil;
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            
            [self hideLoading];
            NSLog(@"Error: %@", error);
        } else {
            
//            NSDictionary *dict = responseObject;
//            NSLog(@"+++++++++++++++%@",dict);
            [self hideLoading];
        }
    }];
    
    [uploadTask resume];
}

@end
