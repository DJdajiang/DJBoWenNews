
//
//  DJPictureDetailView.m
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/12.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import "DJPictureDetailView.h"

#define SPACE (kScreenWidth - 200 - 40) / 4


@implementation DJPictureDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.imagesScrollView];
        [self addSubview:self.layerView];
        [self addSubview:self.layerViewNote];
        [self addSubview:self.toolBar];
    }
    return self;
}


#pragma mark - lazy loading
- (UILabel *)lblTitle {
    if (!_lblTitle) {
        self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, kScreenWidth - 20, 30)];
        _lblTitle.textColor = [UIColor whiteColor];
        _lblTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _lblTitle;
}

- (UIScrollView *)imagesScrollView {
    if (!_imagesScrollView) {
        self.imagesScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _imagesScrollView.showsHorizontalScrollIndicator = NO;
        _imagesScrollView.showsVerticalScrollIndicator = NO;
        _imagesScrollView.pagingEnabled = YES;
        _imagesScrollView.bounces = NO;
        _imagesScrollView.directionalLockEnabled = YES;
    }
    return _imagesScrollView;
}

//标题渐变层
- (UIView *)layerView {
    if (!_layerView) {
        self.layerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.bounds = _layerView.bounds;
        gradientLayer.borderWidth = 0;
        gradientLayer.frame = _layerView.bounds;
        gradientLayer.colors =  @[(id)[[UIColor blackColor] CGColor], (id)[[UIColor clearColor] CGColor]];

        [_layerView.layer insertSublayer:gradientLayer atIndex:0];
        [_layerView addSubview:self.lblTitle];
        [self addSubview:_layerView];
    }
    return _layerView;
}

//简介渐变层
- (UIView *)layerViewNote {
    if (!_layerViewNote) {
        self.layerViewNote = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 170, kScreenWidth, 170)];
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.bounds = _layerViewNote.bounds;
        gradientLayer.borderWidth = 0;
        gradientLayer.frame = _layerViewNote.bounds;
        gradientLayer.colors =  @[(id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor]];
        gradientLayer.endPoint = CGPointMake(0.5, 0.5);
        [_layerViewNote.layer insertSublayer:gradientLayer atIndex:0];
        [_layerViewNote addSubview:self.note];
        [self addSubview:_layerViewNote];
    }
    return _layerViewNote;
}
- (UITextView *)note {
    if (!_note) {
        self.note = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, 140)];
        //设置textView是否可以拖动
        _note.scrollEnabled = YES;
        _note.editable = NO;
        //设置textView自适应高度
        _note.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _note.font = [UIFont systemFontOfSize:15];
        _note.textColor = [UIColor whiteColor];
        _note.backgroundColor = [UIColor clearColor];
        _note.textAlignment = NSTextAlignmentLeft;
    }
    return _note;
}

- (UIButton *)btnBack {
    if (!_btnBack) {
        self.btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnBack.frame = CGRectMake(28, 0, 30, 25);
        _btnBack.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 10);
        
        [_btnBack setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"XHNBack" ofType:@"png"]] forState:UIControlStateNormal];
    }
    return _btnBack;
}
- (UIButton *)btnShare {
    if (!_btnShare) {
        self.btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnShare.frame = CGRectMake(SPACE * 2 + 40, 1, 20, 20);
        
        [_btnShare setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"XHNPicShare" ofType:@"png"]]forState:UIControlStateNormal];
    }
    return _btnShare;
}

- (UIButton *)btnSave {
    if (!_btnSave) {
        self.btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnSave.frame = CGRectMake(SPACE * 3 + 80, 0, 23, 23);
        
        [_btnSave setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DazStarOutline" ofType:@"png"]] forState:UIControlStateNormal];
    }
    return _btnSave;
}
- (UIButton *)btnComment {
    if (!_btnComment) {
        self.btnComment = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnComment.frame = CGRectMake(SPACE * 4 + 120, 3, 20, 20);
        [_btnComment setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"XHNPicComment" ofType:@"png"]] forState:UIControlStateNormal];
    }
    return _btnComment;
}
- (UILabel *)lblPage {
    if (!_lblPage) {
        self.lblPage = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 60, 0, 60, 20)];
        _lblPage.text = @"...";
        _lblPage.textColor = [UIColor whiteColor];
    }
    return _lblPage;
}

- (UIView *)toolBar {
    if (!_toolBar) {
        self.toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 40, kScreenWidth, 40)];
        _toolBar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
        [self.toolBar  addSubview:self.btnBack];
        [self.toolBar  addSubview:self.btnSave];
        [self.toolBar  addSubview:self.btnShare];
        [self.toolBar  addSubview:self.btnComment];
        [self.toolBar  addSubview:self.lblPage];
    }
    return _toolBar;
}

#pragma mark - setter
- (void)setModel:(DJPictureDetailModel *)model
{
    if (_model != model)
    {
        _model = model;
        
        self.lblTitle.text = model.setname;
        self.note.text = [NSString stringWithFormat:@"      %@", model.photos[0][@"note"]];
        
        self.lblPage.text = [NSString stringWithFormat:@"1/%@",model.imgsum];
    }
}


@end
