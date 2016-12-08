//
//  DJPictureView.h
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/12.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJPictureModel.h"
#import "PrefixHeader.pch"

@interface DJPictureView : UICollectionViewCell

@property (nonatomic,retain) UIImageView *imageName;
@property (nonatomic,retain) UILabel *labelName;


//给cell子控件赋值
- (void)configureSubviews:(DJPictureModel *)model;

//计算cell高度
+ (CGFloat)heightForRowWithDic:(DJPictureModel *)model;

@end
