//
//  DJCommonCell.m
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/17.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import "DJCommonCell.h"

#define kMarginLeft_PhotoView       5
#define kMarginTop_PhotoView        5
#define kWidth_PhotoView            100
#define kHeight_PhotoView           80

#define kMarginLeft_TitleLable      (kMarginLeft_PhotoView + kWidth_PhotoView + 5)
#define kMarginTop_TitleLable       10
#define kWidth_TitleLable           (kScreenWidth - kMarginLeft_TitleLable - 5)
#define kHeight_TitleLable          30

#define kMarginLeft_DigestLable     kMarginLeft_TitleLable
#define kMarginTop_DigestLable      (kMarginTop_TitleLable + kHeight_TitleLable)
#define kWidth_DigestLable          kWidth_TitleLable
#define kHeight_DigestLable         35

#define kWidth_ReadLable            75
#define kMarginLeft_ReadLable       kScreenWidth - 80
#define kMarginTop_ReadLable        kMarginTop_DigestLable + kHeight_DigestLable / 2 + 15

@implementation DJCommonCell

#pragma mark - init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self.contentView addSubview:self.imageTitle];
        [self.contentView addSubview:self.lblTitle];
        [self.contentView addSubview:self.lblDigest];
        [self.contentView addSubview:self.lblReadCount];
    }
    return self;
}

#pragma mark - lazy loading, getter,setter
- (UIImageView *)imageTitle
{
    if (!_imageTitle)
    {
        self.imageTitle = [[UIImageView alloc] initWithFrame:CGRectMake(kMarginLeft_PhotoView, kMarginTop_PhotoView, kWidth_PhotoView, kHeight_PhotoView)];
    }
    return _imageTitle;
}

- (UILabel *)lblDigest
{
    if (!_lblDigest)
    {
        self.lblDigest = [[UILabel alloc] initWithFrame:CGRectMake(kMarginLeft_DigestLable, kMarginTop_DigestLable, kWidth_DigestLable, kHeight_DigestLable)];
        self.lblDigest.numberOfLines = 0;
        self.lblDigest.lineBreakMode = NSLineBreakByCharWrapping;
        self.lblDigest.textColor = [UIColor lightGrayColor];
        self.lblDigest.font = [UIFont systemFontOfSize:12];
        
    }
    return _lblDigest;
}
- (UILabel *)lblTitle
{
    if (!_lblTitle)
    {
        self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(kMarginLeft_TitleLable, kMarginTop_TitleLable, kWidth_TitleLable, kHeight_TitleLable)];
        self.lblTitle.font = [UIFont systemFontOfSize:15];
    }
    return _lblTitle;
}
- (UILabel *)lblReadCount
{
    if (!_lblReadCount)
    {
        self.lblReadCount = [[UILabel alloc] initWithFrame:CGRectMake(kMarginLeft_ReadLable, kMarginTop_ReadLable , kWidth_ReadLable, kHeight_DigestLable / 2)];
        self.lblReadCount.textColor = [UIColor lightGrayColor];
        self.lblReadCount.font = [UIFont systemFontOfSize:12];
        self.lblReadCount.textAlignment = NSTextAlignmentRight;
    }
    return _lblReadCount;
}

- (void)setModel:(DJNewsModel *)model
{
    if (_model != model)
    {
        _model = model;
        [self.imageTitle sd_setImageWithURL:[NSURL URLWithString:model.imgsrc] placeholderImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"博文新闻" ofType:@"png"]]  options:SDWebImageRetryFailed];
        self.lblDigest.text = [model.digest isEqualToString:@""] ? model.title : model.digest;
        self.lblTitle.text = model.title;
        
        if (model.replyCount > 10000)
        {
            NSInteger temp = model.replyCount / 10000;
            model.replyCount = model.replyCount % 10000 / 1000;
            self.lblReadCount.text = [NSString stringWithFormat:@"%li.%li万跟帖",(long)temp, (long)model.replyCount];
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
