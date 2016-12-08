//
//  DJThreeImagesCell.h
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/17.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJNewsModel.h"
#import "PrefixHeader.pch"

@interface DJThreeImagesCell : UITableViewCell

@property (nonatomic, retain) UILabel *lblTitle;
@property (nonatomic, retain) UILabel *lblReadCount;
@property (nonatomic, retain) UIImageView *imageLeft;
@property (nonatomic, retain) UIImageView *imageCenter;
@property (nonatomic, retain) UIImageView *imageRight;

@property (nonatomic, retain) DJNewsModel *model;

@end
