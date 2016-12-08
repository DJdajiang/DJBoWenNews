//
//  DJVideoCell.h
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/7.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "DJVideoModel.h"
#import <AVKit/AVKit.h>
#import "PrefixHeader.pch"

@interface DJVideoCell : UITableViewCell

@property (nonatomic, retain) UIImageView *imageName;
@property (nonatomic, retain) UILabel *name;
@property (nonatomic, retain) UILabel *text;
@property (nonatomic, retain) MPMoviePlayerController *player;
@property (nonatomic, retain) UIButton *startButton;
@property (nonatomic, retain) UILabel *time;
@property (nonatomic, retain) UILabel *createTime;
@property (nonatomic, retain) UILabel *count;
@property (nonatomic, retain) NSTimer *animationTimer;
@property (nonatomic, retain) UIButton *moreButton;
@property (nonatomic, retain) DJVideoModel *model;
@property (nonatomic, retain) UIImageView *tempImage;
@property (nonatomic, copy) void(^btnMoreBlock)(DJVideoCell *cell);
@property (nonatomic, copy) void(^TapBlock)(DJVideoCell *cell);

+ (CGFloat)heightCell:(DJVideoModel *)model;

@end
