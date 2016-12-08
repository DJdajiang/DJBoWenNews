//
//  DJCommonCell.h
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/17.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJNewsModel.h"

@interface DJCommonCell : UITableViewCell

@property (nonatomic, retain) UIImageView *imageTitle;
@property (nonatomic, retain) UILabel *lblTitle;
@property (nonatomic, retain) UILabel *lblDigest;
@property (nonatomic, retain) UILabel *lblReadCount;

@property (nonatomic, retain) DJNewsModel *model;

@end
