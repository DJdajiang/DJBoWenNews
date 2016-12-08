//
//  DJBigImageCell.m
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/17.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import "DJBigImageCell.h"

@implementation DJBigImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self.contentView addSubview:self.imageTitle];
        [self.contentView addSubview:self.lblTitle];
        [self.contentView addSubview:self.lblReadCount];
    }
    return self;
}

#pragma mark - getter, setter
- (UILabel *)lblTitle
{
    if (!_lblTitle)
    {
        self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, kScreenWidth - 10, 30)];
        self.lblTitle.font = [UIFont systemFontOfSize:15];
    }
    return _lblTitle;
}
- (UILabel *)lblReadCount
{
    if (!_lblReadCount)
    {
        self.lblReadCount = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 75, 0, 75, 30)];
        self.lblReadCount.textColor = [UIColor lightGrayColor];
        self.lblReadCount.font = [UIFont systemFontOfSize:14];
    }
    return _lblReadCount;
}

- (UIImageView *)imageTitle
{
    if (!_imageTitle)
    {
        self.imageTitle = [[UIImageView alloc] initWithFrame:CGRectMake(5, 35, kScreenWidth - 10, 150)];
    }
    return _imageTitle;
}


- (void)setModel:(DJNewsModel *)model
{
    if (_model != model)
    {
        _model = model;
        self.lblTitle.text = model.title;
        [self.imageTitle sd_setImageWithURL:[NSURL URLWithString:model.imgsrc] placeholderImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"博文新闻" ofType:@"png"]]  options:SDWebImageRetryFailed];
        
        if (model.replyCount > 10000)
        {
            NSInteger temp = model.replyCount / 10000;
            model.replyCount = model.replyCount % 10000 / 1000;
            self.lblReadCount.text = [NSString stringWithFormat:@"%ld.%ld万跟帖",(long)temp, (long)model.replyCount];
        }
        else if (model.replyCount == 0)
        {
            
        }
        else
        {
            
            self.lblReadCount.text = [NSString stringWithFormat:@"%li跟帖",(long)model.replyCount];
        }
    }
}


@end
