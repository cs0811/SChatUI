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
#import "ChatRecordModel.h"
#import "ChatRecordCell.h"


#import "UIResponder+Router.h"
#import<AssetsLibrary/AssetsLibrary.h>
#import<AVFoundation/AVCaptureDevice.h>
#import<AVFoundation/AVMediaFormat.h>

#define NavigationBarH      CGRectGetMaxY(self.navigationController.navigationBar.frame)

@interface SChatVC ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSMutableArray * _dataArr;
    NSTimeInterval _systemAnimationTime;        // 系统动画时间
}
@property (nonatomic, strong) UITableView * chatTable;
@property (nonatomic, strong) SChatToolBar * chatToolBar;

@property (nonatomic, strong) ChatTextCell * textCell;
@property (nonatomic, strong) ChatImageCell * imageCell;
@property (nonatomic, strong) ChatRecordCell * recordCell;
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
    
    self.textCell = [self.chatTable dequeueReusableCellWithIdentifier:@"ChatTextCell"];
    self.imageCell = [self.chatTable dequeueReusableCellWithIdentifier:@"ChatImageCell"];
    self.recordCell = [self.chatTable dequeueReusableCellWithIdentifier:@"ChatRecordCell"];
 
    // 模拟下载
    [self performSelector:@selector(fetch) withObject:nil afterDelay:0.5];
}

- (void)fetch {
    ChatImageModel * imgModel = [ChatImageModel new];
    imgModel.receiveImg = @"http://img.ivsky.com/img/tupian/pre/201606/28/titian-002.jpg";
    imgModel.imgW = 200;
    imgModel.imgH = 150;
    imgModel.isSender = 0;
    
    ChatTextModel * textModel = [ChatTextModel new];
    textModel.isSender = 1;
    textModel.sendText = @"测试-测试-测试-测试-测试=测试测试=测试=测试\nsdfqrsdff\n测试测试测试测试测试-测试测试测试测试\n测试1111111";
    
    ChatRecordModel * recordModel = [ChatRecordModel new];
    recordModel.isSender = 1;
    recordModel.sendUrl = @"";
    recordModel.timeLength = 18.1;
    
    NSArray * data = @[imgModel,textModel,textModel,imgModel,imgModel,textModel,recordModel];
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

    }else if ([model isKindOfClass:[ChatRecordModel class]]){
        ChatRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ChatRecordCell"];
        [cell reloadUIWithData:_dataArr[indexPath.row]];
        return cell;
    }
    return nil;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = _dataArr[indexPath.row];
    
    if ([model isKindOfClass:[ChatTextModel class]]) {
        [self.textCell reloadUIWithData:_dataArr[indexPath.row]];
        return [self.textCell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    }else if ([model isKindOfClass:[ChatImageModel class]]){
        [self.imageCell reloadUIWithData:_dataArr[indexPath.row]];
        return [self.imageCell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    }
    else if ([model isKindOfClass:[ChatRecordModel class]]){
        [self.recordCell reloadUIWithData:_dataArr[indexPath.row]];
        return [self.recordCell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
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
    [self.chatTable insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:_dataArr.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
    [self scrrollToEnd];
//    [self layoutAfterInsertRow];
    
    // 模拟
    [self performSelector:@selector(sendNetworkMessage:) withObject:@{@"start":@1,@"success":@0,@"failed":@0,@"data":imgModel,@"dataClass":imgModel.class} afterDelay:0];
    [self performSelector:@selector(sendNetworkMessage:) withObject:@{@"start":@0,@"success":@1,@"failed":@0,@"data":imgModel,@"dataClass":imgModel.class} afterDelay:2];
}

/**
 *  滚动到底部
 */
- (void)scrrollToEnd {
    Wself
    // 等待insertRow操作完成之后再滚动到底部
    [UIView animateWithDuration:_systemAnimationTime animations:^{
        
    } completion:^(BOOL finished) {
        Sself
        [wself.chatTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:sself->_dataArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }];
}

- (void)layoutAfterInsertRow {
    Wself
    CGFloat h = [self tableView:self.chatTable heightForRowAtIndexPath:[NSIndexPath indexPathForRow:_dataArr.count-1 inSection:0]];
    [UIView animateWithDuration:_systemAnimationTime animations:^{
        wself.chatTable.contentInset = UIEdgeInsetsMake(wself.chatTable.contentInset.top-h, 0, 0, 0);
    } completion:^(BOOL finished) {
        
    }];
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
    _systemAnimationTime = [dic[UIKeyboardAnimationDurationUserInfoKey] floatValue]?:0.25;
    CGRect keyboardRect = [dic[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat keyboardH = keyboardRect.size.height;
    
    CGRect chatBarNewFrame = CGRectMake(0, ScreenHeight-NavigationBarH-ToolBarHeight-keyboardH, CGRectGetWidth(self.chatToolBar.frame), CGRectGetHeight(self.chatToolBar.frame));

    [UIView animateWithDuration:[dic[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        wself.chatToolBar.frame = chatBarNewFrame;
        wself.chatTable.contentInset = UIEdgeInsetsMake(-wself.chatTable.contentSize.height+chatBarNewFrame.origin.y, 0, 0, 0);
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
    if ([eventName isEqualToString:@"SChatToolBarInputViewItemEvent"]) {
        // 点击‘+’之后，弹出选择视图的触发事件
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
            
            return;
        }
    }else if ([eventName isEqualToString:@"SChatToolBarSendTextEvent"]) {
        // 发送文字
        NSString * text = userInfo[@"text"];
        ChatTextModel * textModel = [ChatTextModel new];
        textModel.sendText = text;
        textModel.isSender = 1;
        [_dataArr addObject:textModel];
        [self.chatTable insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:_dataArr.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
        [self scrrollToEnd];
        [self layoutAfterInsertRow];
        
        // 模拟
        [self performSelector:@selector(sendNetworkMessage:) withObject:@{@"start":@1,@"success":@0,@"failed":@0,@"data":textModel,@"dataClass":textModel.class} afterDelay:0];
        [self performSelector:@selector(sendNetworkMessage:) withObject:@{@"start":@0,@"success":@0,@"failed":@1,@"data":textModel,@"dataClass":textModel.class} afterDelay:2];
    }else if ([eventName isEqualToString:@"SChatToolBarRecordDidFinishEvent"]) {
        // 发送语音
        NSString * url = userInfo[@"recordUrl"];
        NSNumber * time = userInfo[@"recordTime"];
        
        ChatRecordModel * recordModel = [ChatRecordModel new];
        recordModel.sendUrl = url;
        recordModel.timeLength = time.floatValue;
        recordModel.isSender = 1;
        [_dataArr addObject:recordModel];
        [self.chatTable insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:_dataArr.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
        [self scrrollToEnd];
        [self layoutAfterInsertRow];
        
        // 模拟
        [self performSelector:@selector(sendNetworkMessage:) withObject:@{@"start":@1,@"success":@0,@"failed":@0,@"data":recordModel,@"dataClass":recordModel.class} afterDelay:0];
        [self performSelector:@selector(sendNetworkMessage:) withObject:@{@"start":@0,@"success":@1,@"failed":@0,@"data":recordModel,@"dataClass":recordModel.class} afterDelay:2];
        
    }else if ([eventName isEqualToString:@"SChatCellResendMessageEvent"]) {
        // 重新发送
        
        // 模拟
        [self performSelector:@selector(sendNetworkMessage:) withObject:@{@"start":@1,@"success":@0,@"failed":@0,@"data":userInfo[@"data"],@"dataClass":userInfo[@"dataClass"]} afterDelay:0];
        [self performSelector:@selector(sendNetworkMessage:) withObject:@{@"start":@0,@"success":@1,@"failed":@0,@"data":userInfo[@"data"],@"dataClass":userInfo[@"dataClass"]} afterDelay:2];
        
    }else if ([eventName isEqualToString:@"SChatStopReplayRecordEvent"]) {
        // 关闭所有语音播放
        for (int i=0; i<_dataArr.count; i++) {
            id cell = [self.chatTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if ([cell isKindOfClass:[ChatRecordCell class]]) {
                [(ChatRecordCell *)cell stopReplayRecord];
            }
        }
    }
}

// 模拟联网发送消息
- (void)sendNetworkMessage:(NSDictionary *)dic {
//    ChatBaseCell * cell = nil;
    if ([dic[@"start"] boolValue]) {
        // 开始发送
        if ([dic[@"data"] isKindOfClass:[ChatBaseModel class]]) {
            [(ChatBaseModel *)dic[@"data"] setStart:YES];
            [(ChatBaseModel *)dic[@"data"] setSuccess:NO];
            [(ChatBaseModel *)dic[@"data"] setFailed:NO];
        }
    }else if ([dic[@"success"] boolValue]) {
        // 成功
        if ([dic[@"data"] isKindOfClass:[ChatBaseModel class]]) {
            [(ChatBaseModel *)dic[@"data"] setStart:NO];
            [(ChatBaseModel *)dic[@"data"] setSuccess:YES];
            [(ChatBaseModel *)dic[@"data"] setFailed:NO];
        }
    }else if ([dic[@"failed"] boolValue]) {
        // 失败
        if ([dic[@"data"] isKindOfClass:[ChatBaseModel class]]) {
            [(ChatBaseModel *)dic[@"data"] setStart:NO];
            [(ChatBaseModel *)dic[@"data"] setSuccess:NO];
            [(ChatBaseModel *)dic[@"data"] setFailed:YES];
            [(ChatBaseModel *)dic[@"data"] setResendData:dic];
        }
    }
    
    NSInteger row = [_dataArr indexOfObject:dic[@"data"]];
    ChatBaseCell * cell = [self.chatTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    [cell layoutWarningViewWithDict:dic];
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
        [_chatTable registerClass:[ChatRecordCell class] forCellReuseIdentifier:@"ChatRecordCell"];
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
