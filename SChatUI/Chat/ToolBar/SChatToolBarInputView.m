//
//  SChatToolBarInputView.m
//  SChatUI
//
//  Created by tongxuan on 16/7/29.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import "SChatToolBarInputView.h"
#import "Masonry.h"
#import "UIResponder+Router.h"


#define Wself                           __weak typeof(self) wself = self;
#define Sself                           __strong typeof(wself) sself = wself;
#define ScreenWidth                     [UIScreen mainScreen].bounds.size.width
#define ScreenHeight                    [UIScreen mainScreen].bounds.size.height

@interface SChatToolBarInputViewItem : UICollectionViewCell
@property (nonatomic, strong) UIImageView * iconImg;
@property (nonatomic, strong) UILabel * titleLabel;
@end

@implementation SChatToolBarInputViewItem
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUI];
    }
    return  self;
}

- (void)loadUI {
    Wself
    [self addSubview:self.iconImg];
    [self addSubview:self.titleLabel];
    
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(wself);
        make.height.equalTo(wself).multipliedBy(0.6);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself);
        make.top.equalTo(wself.iconImg.mas_bottom);
    }];
}

#pragma mark getter
- (UIImageView *)iconImg {
    if (!_iconImg) {
        _iconImg = [UIImageView new];
        _iconImg.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImg;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:17.];
        _titleLabel.textColor = [UIColor lightGrayColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
@end

@implementation SChatToolBarInputSingleItem
@end

@interface SChatToolBarInputView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView * inputColleciton;
@end

@implementation SChatToolBarInputView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUI];
    }
    return  self;
}

#pragma mark loadUI
- (void)loadUI {
}

#pragma mark setter
- (void)setAllItems:(NSArray<SChatToolBarInputSingleItem *> *)allItems {
    _allItems = allItems;
    if (_allItems.count >0) {
        [self.inputColleciton removeFromSuperview];
        [self addSubview:self.inputColleciton];
        self.frame = self.inputColleciton.frame;
    }
}

#pragma mark getter
- (UICollectionView *)inputColleciton {
    if (!_inputColleciton) {
        
        // 行数
        CGFloat lines = floor(self.allItems.count/ToolBarInputViewMaxLineNum);
        if (self.allItems.count%ToolBarInputViewMaxLineNum != 0 ) {
            lines = lines+1;
        }
        
        CGFloat itemW = 0;
        itemW = (ScreenWidth-2*ToolBarInputViewLeftSpace-(ToolBarInputViewMaxLineNum-1)*ToolBarInputViewItemSpaceH)/ToolBarInputViewMaxLineNum;
        CGFloat ratio = ToolBarInputViewItemRatio;
        CGFloat itemH = itemW/ratio;
        CGFloat h = itemH*lines+2*ToolBarInputViewTopSpace+(lines-1)*ToolBarInputViewItemSpaceV;
        
        UIEdgeInsets insets = UIEdgeInsetsMake(ToolBarInputViewTopSpace, ToolBarInputViewLeftSpace, ToolBarInputViewTopSpace, ToolBarInputViewLeftSpace);
        
        UICollectionViewFlowLayout * layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(itemW, itemH);
        layout.sectionInset = insets;
        _inputColleciton = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, h) collectionViewLayout:layout];
        _inputColleciton.backgroundColor = [UIColor whiteColor];
        _inputColleciton.delegate = self;
        _inputColleciton.dataSource = self;
        
        [_inputColleciton registerClass:[SChatToolBarInputViewItem class] forCellWithReuseIdentifier:@"SChatToolBarInputViewItem"];
    }
    return _inputColleciton;
}

#pragma mark UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.allItems.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SChatToolBarInputViewItem * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"SChatToolBarInputViewItem" forIndexPath:indexPath];
    
    SChatToolBarInputSingleItem * item = self.allItems[indexPath.row];
    cell.titleLabel.text = item.title;
    // 一般使用本地图片
    cell.iconImg.image = [UIImage imageNamed:item.icon];
    return cell;
}
#pragma mark UICollectionViewDelegateFlowLayout
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"kInputViewItemDidChoose" object:nil];
    [self routerEventWithName:@"SChatToolBarInputViewItemEvent" userInfo:@{@"itemIndex":@(indexPath.row)}];
}

@end
