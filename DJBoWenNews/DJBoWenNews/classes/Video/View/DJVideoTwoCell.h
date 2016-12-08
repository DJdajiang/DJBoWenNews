//
//  DJVideoTwoCell.h
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/21.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJVideoModel.h"
#import "DJPlayerView.h"
#import "PrefixHeader.pch"

@interface DJVideoTwoCell : UITableViewCell

@property (nonatomic,copy) NSString *videoUrl;
@property (nonatomic,retain) DJPlayerView *playerView;
@property (nonatomic, retain) UIImageView *tempImage;
@property (nonatomic, retain) UIImageView *imageName;
@property (nonatomic, retain) UILabel *name;
@property (nonatomic, retain) UILabel *text;
@property (nonatomic, retain) UILabel *createTime;
@property (nonatomic, retain) UIButton *moreButton;
@property (nonatomic, retain) DJVideoModel *model;
@property (nonatomic, copy) void(^btnMoreBlock)(DJVideoTwoCell *cell);
@property (nonatomic, copy) void(^TapBlock)(DJVideoTwoCell *cell);

+ (CGFloat)heightCell:(DJVideoModel *)model;

@end
