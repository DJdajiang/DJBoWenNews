//
//  DJVideoCell.m
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/7.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import "DJVideoCell.h"
#import "NSTimer+DJControl.h"
#import "DJVideoModel.h"
#import "DJVideoController.h"

@interface DJVideoCell ()
{
    UIView *tempView;
    DJVideoController *vvvv;
}
@end

@implementation DJVideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.imageName];
        [self.contentView addSubview:self.text];
        [self.contentView addSubview:self.name];
        [self.contentView addSubview:self.moreButton];
        [self.contentView addSubview:self.createTime];
        [self.contentView addSubview:self.player.view];
        
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                               target:self
                                                             selector:@selector(animationTimerDidFired:)
                                                             userInfo:nil
                                                              repeats:YES];
        [self.animationTimer pauseTimer];
        NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
        [noti addObserver:self selector:@selector(moviePlayerState:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:_player];
    }
    return self;
}

//监听播放状态
- (void)moviePlayerState:(NSNotification *)noti
{
    if (_player.playbackState == MPMoviePlaybackStatePlaying)
    {
        _startButton.hidden = YES;
        self.tempImage.hidden = YES;
        [self.animationTimer resumeTimerAfterTimeInterval:1];
    }
    else if(_player.playbackState == MPMoviePlaybackStateSeekingBackward )
    {
        _startButton.hidden = NO;
        self.tempImage.hidden = NO;
        [self.animationTimer pauseTimer];
    }
    else if (_player.playbackState == MPMoviePlaybackStatePaused)
    {
        _startButton.hidden = NO;
    }
}

- (void)animationTimerDidFired:(NSTimer *)timer
{
    [self setTimeStype:[NSString stringWithFormat:@"%.2f",_player.duration - _player.currentPlaybackTime]];
}

+ (CGFloat)heightForText:(NSString *)text {
    return  [text boundingRectWithSize:CGSizeMake(kScreenWidth - 10, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.height;
}

+ (CGFloat)widthForText:(NSString *)text {
    return  [text boundingRectWithSize:CGSizeMake(kScreenWidth - 10, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.width + 30;
}

+ (CGFloat)heightCell:(DJVideoModel *)model
{
    NSInteger width = kScreenWidth - 10;
    if ([model.height integerValue] > [model.width integerValue]) {
        width =  kScreenWidth - 150;
    }
    return  60 + [DJVideoCell heightForText:model.text] + (width * [model.height integerValue]) / [model.width integerValue] + 10;
}

//设置时间格式
- (void)setTimeStype:(NSString *)time
{
    NSInteger timeInterval = [time integerValue];
    if (timeInterval < 60)
    {
        self.time.text = timeInterval > 9 ? [NSString stringWithFormat:@"00:%ld", (long)timeInterval] : [NSString stringWithFormat:@"00:0%ld", (long)timeInterval];
    }
    else if (timeInterval < 3600)
    {
        [[NSDate date] timeIntervalSinceDate:[NSDate date]];
        self.time.text = (timeInterval / 60) > 9 ? [NSString stringWithFormat:@"%ld:%@", (long)timeInterval / 60,  timeInterval % 60 > 9 ? [NSString stringWithFormat:@"%ld", (long)timeInterval % 60] : [NSString stringWithFormat:@"0%ld", (long)timeInterval % 60]] : [NSString stringWithFormat:@"0%ld:%@", (long)timeInterval / 60, timeInterval % 60 > 9 ? [NSString stringWithFormat:@"%ld", (long)timeInterval % 60] : [NSString stringWithFormat:@"0%ld", (long)timeInterval % 60]];
        
    }
    
}

- (void)handleMore:(UIButton *)sender {
    if (self.btnMoreBlock)
    {
        self.btnMoreBlock(self);
    }
}

#pragma mark - lazy loading
//头像
- (UIImageView *)imageName
{
    if (!_imageName) {
        _imageName = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
    }
    return _imageName ;
}
- (UILabel *)name
{
    if (!_name)
    {
        _name = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, kScreenWidth - 100, 15)];
        _name.font = [UIFont systemFontOfSize:14];
    }
    return _name;
}

- (UIButton *)moreButton
{
    if (!_moreButton)
    {
        _moreButton = [ UIButton buttonWithType:UIButtonTypeCustom];
        _moreButton.frame = CGRectMake(kScreenWidth - 40, 10, 40, 20);
        _moreButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [_moreButton setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
        [_moreButton setImage:[UIImage imageNamed:@"morehigh"] forState:UIControlStateHighlighted];
        [_moreButton addTarget:self action:@selector(handleMore:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

- (UILabel *)createTime
{
    if (!_createTime)
    {
        self.createTime = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, kScreenWidth - 50, 15)];
        self.createTime.font = [UIFont systemFontOfSize:12];
        self.createTime.textColor = [UIColor grayColor];
    }
    return _createTime;
}
- (UILabel *)text
{
    if (!_text)
    {
        self.text = [[UILabel alloc] initWithFrame:CGRectMake(5, 40, kScreenWidth - 20, 60)];
        self.text.numberOfLines = 0;
        self.text.lineBreakMode = NSLineBreakByCharWrapping;
        self.text.font = [UIFont systemFontOfSize:16];
    }
    return _text;
}

- (MPMoviePlayerController *)player
{
    if (!_player) {
        self.player = [[MPMoviePlayerController alloc] init];
        _player.repeatMode = MPMovieRepeatModeOne;
        _player.controlStyle = MPMovieControlStyleNone;
        _player.scalingMode = MPMovieScalingModeAspectFit;
        _player.backgroundView.backgroundColor = [UIColor lightGrayColor];
    }
    return _player;
}


- (UIButton *)btnState
{
    if (!_startButton)
    {
        self.startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _startButton;
}
- (UILabel *)time
{
    if (!_time)
    {
        self.time = [[UILabel alloc] initWithFrame:CGRectZero];
        _time.backgroundColor = [UIColor blackColor];
        _time.textAlignment = NSTextAlignmentRight;
        _time.font = [UIFont boldSystemFontOfSize:15];
        _time.alpha = 0.6;
        _time.textColor = [UIColor whiteColor];
    }
    return _time;
}

- (UILabel *)count
{
    if (!_count)
    {
        self.count = [[UILabel alloc] initWithFrame:CGRectZero];
        _count.backgroundColor = [UIColor blackColor];
        _count.textAlignment = NSTextAlignmentRight;
        _count.font = [UIFont boldSystemFontOfSize:15];
        _count.alpha = 0.6;
        _count.textColor = [UIColor whiteColor];
    }
    return _count;
}

- (void)setModel:(DJVideoModel *)model
{
    if (_model != model)
    {
        _model = model;
        //配置控件信息
        [self.imageName sd_setImageWithURL:[NSURL URLWithString:model.profile_image] placeholderImage:[UIImage imageNamed:@"defaultAvator"]];
        self.name.text = model.name;
        self.text.text = model.text;
        self.createTime.text = model.created_at;
        NSString *playCount = [NSString stringWithFormat:@"%@", model.playcount];
        self.count.text = [playCount stringByAppendingString:@"播放"];
        [self setTimeStype:model.videotime];
        
        CGRect frame = self.text.frame;
        frame.size.height = [DJVideoCell heightForText:model.text];
        self.text.frame = frame;
        
        [_player setContentURL:[NSURL URLWithString:model.videouri]];
        //动态修改控件frame
        NSInteger width = kScreenWidth - 10;
        _player.view.frame = CGRectMake(5, 40 + frame.size.height + 10, width , (width * [model.height integerValue]) / [model.width integerValue]);
        //当高过宽时，处理结果
        if ([model.height integerValue] > [model.width integerValue]) {
            width =  kScreenWidth - 150;
            _player.view.frame = CGRectMake(75, 40 + frame.size.height + 10, width , (width * [model.height integerValue]) / [model.width integerValue]);
            
        }
        //没有播放时的背景图
        self.tempImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width , (width * [model.height integerValue]) / [model.width integerValue])];
        [self.tempImage sd_setImageWithURL:[NSURL URLWithString:model.image_small] placeholderImage:[UIImage imageNamed:@"博文新闻"]];
        
        
        [_player.view addSubview:self.tempImage];
        //开始按钮
        [_player.view addSubview:self.btnState];
        //时间
        _time.frame = CGRectMake(width - 41,(width * [model.height integerValue]) / [model.width integerValue] - 20, 40, 20);
        [_player.view addSubview:_time];
        
        //播放次数
        _count.frame = CGRectMake(width - [DJVideoCell widthForText:playCount], 2, [DJVideoCell widthForText:playCount], 20);
        [_player.view addSubview:_count];
        //播放窗口的点击层
        tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width , (width * [model.height integerValue]) / [model.width integerValue])];
        [_player.view addSubview:tempView];
        
        
        //手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [tempView addGestureRecognizer:tap];
        self.btnState.frame = CGRectMake(0, 0, 50 , 50);
        self.btnState.center = self.tempImage.center;
        [self.btnState setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"start" ofType:@"png"]] forState:UIControlStateNormal];
        
    }

}

#pragma mark - action
- (void)handleTap:(UITapGestureRecognizer *)tap
{
    _startButton.hidden = _startButton.hidden ? NO : YES;
    
    if (_startButton.hidden)
    {
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
         {
             if (status != AFNetworkReachabilityStatusReachableViaWiFi)
             {
                 
                 UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"当前网络2G或3G网络，是否继续观看?" preferredStyle:UIAlertControllerStyleAlert];
                 
                 UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                     
                     
                 }];
                 [alert addAction:action1];
                 
                 [vvvv presentViewController:alert animated:YES completion:^{
                     
                     
                 }];
             }
             else
             {
                [_player play];
             }
         }];
    } else
    {
        [self.animationTimer pauseTimer];
        
        [_player pause];
        
    }
    
    if (self.TapBlock)
    {
        self.TapBlock(self);
    }
}

@end
