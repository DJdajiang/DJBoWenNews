//
//  DJMineCell.h
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/18.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineModel.h"

@interface DJMineCell : UITableViewCell

@property (nonatomic, retain) UIImageView *iconImage;
@property (nonatomic, retain) UILabel *lblTitle;
@property (nonatomic, retain) UILabel *lblCacheSize;

- (void)configureWithMineModel:(MineModel *)mineModel;

@end
