//
//  DJOneImageFirstCell.h
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/17.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJNewsModel.h"
#import "PrefixHeader.pch"

@interface DJOneImageFirstCell : UITableViewCell

/**
 *  除头条外，第一行是一张图片的cell
 */
@property (nonatomic, retain) UILabel *lblTitle;
@property (nonatomic, retain) UIImageView *imageTitle;
@property (nonatomic, retain) DJNewsModel *model;

@end
