//
//  DJVideoTwoCell.m
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/21.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import "DJVideoTwoCell.h"
@implementation DJVideoTwoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.imageName];
        [self.contentView addSubview:self.text];
        [self.contentView addSubview:self.name];
        [self.contentView addSubview:self.moreButton];
        [self.contentView addSubview:self.createTime];
        [self.contentView addSubview:self.tempImage];
        [self.contentView addSubview:self.playerView];
    }
    return self;
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

- (void)handleMore:(UIButton *)sender {
    if (self.btnMoreBlock)
    {
        self.btnMoreBlock(self);
    }
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

- (UIImageView *)tempImage
{
    if (_tempImage == nil)
    {
        _tempImage = [[UIImageView alloc] init];
        
    }
    return _tempImage;
}

- (DJPlayerView *)playerView
{
    if (_playerView == nil)
    {
        _playerView = [[DJPlayerView alloc] init];
        
        
    }
    return _playerView;
}
-(void)setModel:(DJVideoModel *)model
{
    if (_model != model)
    {
        _model = model;
        
        //配置控件信息
        [self.imageName sd_setImageWithURL:[NSURL URLWithString:model.profile_image] placeholderImage:[UIImage imageNamed:@"博文新闻3"]];
        self.name.text = model.name;
        self.text.text = model.text;
        self.createTime.text = model.created_at;
        self.videoUrl = model.videouri;
        CGRect frame = self.text.frame;
        frame.size.height = [DJVideoTwoCell heightForText:model.text];
        self.text.frame = frame;
        //动态修改控件frame
        
        //当高过宽时，处理结果
        if ([model.height integerValue] > [model.width integerValue])
        {
            NSInteger width =  kScreenWidth - 150;
            self.tempImage.frame = CGRectMake(75, 40 + frame.size.height + 10, width , (width * [model.height integerValue]) / [model.width integerValue]);
            
            self.playerView.frame = CGRectMake(75, 40 + frame.size.height + 10, width , (width * [model.height integerValue]) / [model.width integerValue]);
        }
        else
        {
            NSInteger width = kScreenWidth - 10;
            self.tempImage.frame = CGRectMake(5, 40 + frame.size.height + 10, width , (width * [model.height integerValue]) / [model.width integerValue]);
            
            self.playerView.frame = CGRectMake(5, 40 + frame.size.height + 10, width , (width * [model.height integerValue]) / [model.width integerValue]);
        }
        
        [self.tempImage sd_setImageWithURL:[NSURL URLWithString:model.image_small] placeholderImage:[UIImage imageNamed:@"博文新闻"]];
    }
}

+ (CGFloat)heightForText:(NSString *)text {
    return  [text boundingRectWithSize:CGSizeMake(kScreenWidth - 10, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.height;
}


+ (CGFloat)heightCell:(DJVideoModel *)model
{
    NSInteger width = kScreenWidth - 10;
    if ([model.height integerValue] > [model.width integerValue]) {
        width =  kScreenWidth - 150;
    }
    return  60 + [DJVideoTwoCell heightForText:model.text] + (width * [model.height integerValue]) / [model.width integerValue] + 10;
}
@end
