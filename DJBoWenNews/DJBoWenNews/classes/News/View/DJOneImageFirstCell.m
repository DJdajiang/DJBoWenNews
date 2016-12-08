//
//  DJOneImageFirstCell.m
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/17.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import "DJOneImageFirstCell.h"

@implementation DJOneImageFirstCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithRed:234 / 255.0 green:234 / 255.0 blue:234 / 255.0 alpha:1.0];
        [self.contentView addSubview:self.imageTitle];
        [self.contentView addSubview:self.lblTitle];
    }
    return self;
}

#pragma mark - getter, setter
- (UILabel *)lblTitle
{
    if (!_lblTitle)
    {
        self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 150, kScreenWidth - 20, 30)];
        self.lblTitle.font = [UIFont systemFontOfSize:16];
    }
    return _lblTitle;
}

- (UIImageView *)imageTitle
{
    if (!_imageTitle)
    {
        self.imageTitle = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    }
    return _imageTitle;
}



- (void)setModel:(DJNewsModel *)model
{
    if (_model != model)
    {
        _model = model;
        self.lblTitle.text = model.title;
        [self.imageTitle sd_setImageWithURL:[NSURL URLWithString:model.imgsrc] placeholderImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"博文新闻" ofType:@"png"]] options:SDWebImageRetryFailed];
    }
}


@end
