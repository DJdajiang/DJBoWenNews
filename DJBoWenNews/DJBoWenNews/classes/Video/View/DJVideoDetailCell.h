//
//  DJVideoDetailCell.h
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/7.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJVideoDetailModel.h"
#import "PrefixHeader.pch"

@interface DJVideoDetailCell : UITableViewCell

@property (nonatomic, retain) UIImageView *imageName;
@property (nonatomic, retain) UILabel *name;
@property (nonatomic, retain) UILabel *text;

@property (nonatomic, retain) DJVideoDetailModel *model;

+ (CGFloat)heightCell:(DJVideoDetailModel *)model;

@end
