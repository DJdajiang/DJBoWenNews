//
//  DJFavoriteCell.m
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/18.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import "DJFavoriteCell.h"


@implementation DJFavoriteCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self.contentView addSubview:self.lblTitle];
        [self.contentView addSubview:self.lblTag];
    }
    return self;
}
- (UILabel *)lblTag
{
    if (!_lblTag)
    {
        self.lblTag = [[UILabel alloc] initWithFrame:CGRectMake(5, 7, 50, 30)];
        _lblTag.font = [UIFont systemFontOfSize:16];
    }
    return _lblTag;
}
- (UILabel *)lblTitle
{
    if (!_lblTitle)
    {
        self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(55, 7, kScreenWidth - 70, 30)];
        _lblTitle.font = [UIFont systemFontOfSize:16];
    }
    return _lblTitle;
}


@end
