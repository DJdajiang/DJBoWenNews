//
//  DJHeaderCell.m
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/18.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import "DJHeaderCell.h"

@implementation DJHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = [UIColor clearColor];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 0, 100, 40)] ;
        imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bowenbaike2" ofType:@"png"]];
        [self.contentView addSubview:imageView];
    }
    
    return self;
}

@end
