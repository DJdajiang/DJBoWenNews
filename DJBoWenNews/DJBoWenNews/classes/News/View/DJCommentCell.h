//
//  DJCommentCell.h
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/14.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJCommentModel.h"
#import "PrefixHeader.pch"

@interface DJCommentCell : UITableViewCell

@property (nonatomic, retain) UIImageView *avator;
@property (nonatomic, retain) UILabel *name;
@property (nonatomic, retain) UILabel *address;
@property (nonatomic, retain) UILabel *content;
@property (nonatomic, retain) UILabel *time;
@property (nonatomic, retain) DJCommentModel *model;

+ (CGFloat)heightForRowWithDic:(DJCommentModel *)model;

@end
