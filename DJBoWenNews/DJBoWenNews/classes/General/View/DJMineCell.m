//
//  DJMineCell.m
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/18.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import "DJMineCell.h"

@implementation DJMineCell

- (UIImageView *)iconImage
{
    if (!_iconImage)
    {
        self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 30, 30)];
    }
    return _iconImage;
}

- (UILabel *)lblTitle
{
    if (!_lblTitle)
    {
        self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(65, 15, 80, 20)];
        self.lblTitle.textColor = [UIColor colorWithRed:200 / 255.0 green:102 / 255.0 blue:12 / 255.0 alpha:1.0];
    }
    return _lblTitle;
}

- (UILabel *)lblCacheSize
{
    if (!_lblCacheSize)
    {
        self.lblCacheSize = [[UILabel alloc] initWithFrame:CGRectMake(170, 15, 80, 20)];
        self.lblCacheSize.textColor = [UIColor colorWithRed:200 / 255.0 green:102 / 255.0 blue:12 / 255.0 alpha:1.0];
    }
    return _lblCacheSize;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.iconImage];
        [self.contentView addSubview:self.lblTitle];
    }
    return self;
}

- (void)configureWithMineModel:(MineModel *)mineModel {
    self.iconImage.image = [UIImage imageNamed:mineModel.imageName];
    self.lblTitle.text = mineModel.title;
    
    
}

@end
