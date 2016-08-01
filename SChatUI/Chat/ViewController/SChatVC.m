//
//  SChatVC.m
//  SChatUI
//
//  Created by tongxuan on 16/7/27.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import "SChatVC.h"
#import "SChatToolBar.h"
#import "ChatBaseCell.h"
#import "ChatBaseModel.h"
#import "ChatTextCell.h"
#import "ChatTextModel.h"
#import "ChatImageCell.h"
#import "ChatImageModel.h"
#import "UIResponder+Router.h"
#import<AssetsLibrary/AssetsLibrary.h>
#import<AVFoundation/AVCaptureDevice.h>
#import<AVFoundation/AVMediaFormat.h>

#define NavigationBarH      CGRectGetMaxY(self.navigationController.navigationBar.frame)

@interface SChatVC ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSMutableArray * _dataArr;
}
@property (nonatomic, strong) UITableView * chatTable;
@property (nonatomic, strong) SChatToolBar * chatToolBar;
@end


@implementation SChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.navigationController.navigationBar.translucent = NO;
    
    [self loadUI];
    [self loadData];
}

#pragma mark loadUI
- (void)loadUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.chatTable];
    [self.view addSubview:self.chatToolBar];

}

#pragma mark loadData
- (void)loadData {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboradWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboradWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // 模拟下载
    [self performSelector:@selector(fetch) withObject:nil afterDelay:0.5];
}

- (void)fetch {
    ChatImageModel * imgModel = [ChatImageModel new];
    imgModel.receiveImg = @"cat.jpg";
    imgModel.isSender = 0;
    
    ChatTextModel * textModel = [ChatTextModel new];
    textModel.isSender = 1;
    textModel.sendText = @"测试-测试-测试-测试-测试=测试测试=测试=测试\nsdfqrsdff\n测试测试测试测试测试-测试测试测试测试\n测试1111111";
    
    NSArray * data = @[imgModel,textModel,textModel,imgModel,imgModel,textModel];
    _dataArr = [NSMutableArray arrayWithArray:data];
    [self.chatTable reloadData];
    [self scrrollToEnd];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = _dataArr[indexPath.row];
    
    if ([model isKindOfClass:[ChatTextModel class]]) {
        ChatTextCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ChatTextCell"];
        [cell reloadUIWithData:_dataArr[indexPath.row]];
        return cell;


    }else if ([model isKindOfClass:[ChatImageModel class]]){
        ChatImageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ChatImageCell"];
        [cell reloadUIWithData:_dataArr[indexPath.row]];
        return cell;

    }
    return nil;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = _dataArr[indexPath.row];
    
    if ([model isKindOfClass:[ChatTextModel class]]) {
        ChatTextCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ChatTextCell"];
        [cell reloadUIWithData:_dataArr[indexPath.row]];
        return [cell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        
        
    }else if ([model isKindOfClass:[ChatImageModel class]]){
        ChatImageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ChatImageCell"];
        [cell reloadUIWithData:_dataArr[indexPath.row]];
        return [cell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        if (buttonIndex == 0) {
            // 拍照
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
                //无权限
                [[[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"您还未允许%@获取您的相机，需要去设置开启%@的相机权限",app_Name,app_Name] delegate:nil cancelButtonTitle:@"" otherButtonTitles:@"确定", nil] show];
            }else {
                sourceType = UIImagePickerControllerSourceTypeCamera;
            }
            
        }else if (buttonIndex == 1) {
            // 相册
            ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
            if(author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied){
                //无权限
                [[[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"您还未允许%@获取您的相册，需要去设置开启%@的相册权限",app_Name,app_Name] delegate:nil cancelButtonTitle:@"" otherButtonTitles:@"确定", nil] show];
                return;
            }else {
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
        }
    }
    else {
        if (buttonIndex == 2) {
            return;
        } else {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    }
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    
    [self presentViewController:imagePickerController animated:YES completion:^{
        
    }];
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    /**
     UIImagePickerControllerCropRect = "NSRect: {{0, 0}, {2668, 1772}}";
     UIImagePickerControllerEditedImage = "<UIImage: 0x7fb855926d90> size {748, 496} orientation 0 scale 1.000000";
     UIImagePickerControllerMediaType = "public.image";
     UIImagePickerControllerOriginalImage = "<UIImage: 0x7fb85352ee70> size {2668, 1772} orientation 0 scale 1.000000";
     UIImagePickerControllerReferenceURL = "assets-library://asset/asset.JPG?id=106E99A1-4F6A-45A2-B320-B0AD4A8E8473&ext=JPG";
     */
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
        
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    ChatImageModel * imgModel = [ChatImageModel new];
    imgModel.sendLocalImg = image;
    imgModel.isSender = 1;
    [_dataArr addObject:imgModel];
    [self.chatTable insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:_dataArr.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self scrrollToEnd];
}

/**
 *  滚动到底部
 */
- (void)scrrollToEnd {
    [self.chatTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_dataArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

#pragma mark action
- (void)keyboradWillShow:(NSNotification *)sender {
    Wself
    NSDictionary * dic = sender.userInfo;
    /**
     UIKeyboardAnimationCurveUserInfoKey = 7;
     UIKeyboardAnimationDurationUserInfoKey = "0.25";
     UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {375, 216}}";
     UIKeyboardCenterBeginUserInfoKey = "NSPoint: {187.5, 775}";
     UIKeyboardCenterEndUserInfoKey = "NSPoint: {187.5, 775}";
     UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 667}, {375, 216}}";
     UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 667}, {375, 216}}";
     UIKeyboardIsLocalUserInfoKey = 1;
     */
    CGRect keyboardRect = [dic[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat keyboardH = keyboardRect.size.height;
    
    CGRect chatBarNewFrame = CGRectMake(0, ScreenHeight-NavigationBarH-ToolBarHeight-keyboardH, CGRectGetWidth(self.chatToolBar.frame), CGRectGetHeight(self.chatToolBar.frame));

    [UIView animateWithDuration:[dic[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        wself.chatToolBar.frame = chatBarNewFrame;
        wself.chatTable.contentInset = UIEdgeInsetsMake(-self.chatTable.contentSize.height+chatBarNewFrame.origin.y, 0, 0, 0);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)keyboradWillHide:(NSNotification *)sender {
    Wself
    NSDictionary * dic = sender.userInfo;
    CGRect chatBarNewFrame = CGRectMake(0, ScreenHeight-NavigationBarH-ToolBarHeight, CGRectGetWidth(self.chatToolBar.frame), CGRectGetHeight(self.chatToolBar.frame));
    
    [UIView animateWithDuration:[dic[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        wself.chatToolBar.frame = chatBarNewFrame;
        wself.chatTable.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    } completion:^(BOOL finished) {
        
    }];
}

// 传递事件
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    // 点击‘+’之后，弹出选择视图的触发事件
    if ([eventName isEqualToString:@"SChatToolBarInputViewItemEvent"]) {
        NSInteger index = [userInfo[@"itemIndex"] floatValue];
        if (index == 0) {
            // 发送图片
            UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                          initWithTitle:nil
                                          delegate:self
                                          cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                          otherButtonTitles:@"拍照", @"相册",nil];
            actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            [actionSheet showInView:self.view];
        }
    }
}


#pragma mark getter
- (UITableView *)chatTable {
    if (!_chatTable) {
        _chatTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavigationBarH-ToolBarHeight) style:UITableViewStylePlain];
        _chatTable.delegate = self;
        _chatTable.dataSource = self;
        _chatTable.tableFooterView = [UIView new];
        _chatTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _chatTable.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
        [_chatTable registerClass:[ChatBaseCell class] forCellReuseIdentifier:@"ChatBaseCell"];
        [_chatTable registerClass:[ChatTextCell class] forCellReuseIdentifier:@"ChatTextCell"];
        [_chatTable registerClass:[ChatImageCell class] forCellReuseIdentifier:@"ChatImageCell"];
    }
    return _chatTable;
}
- (SChatToolBar *)chatToolBar {
    if (!_chatToolBar) {
        _chatToolBar = [SChatToolBar new];
        _chatToolBar.frame = CGRectMake(0, ScreenHeight-NavigationBarH-ToolBarHeight, ScreenWidth, ToolBarHeight);
    }
    return _chatToolBar;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@ 销毁了",self.class);
}

@end
