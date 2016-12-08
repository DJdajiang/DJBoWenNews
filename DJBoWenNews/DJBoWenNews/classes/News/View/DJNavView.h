//
//  DJNavView.h
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/17.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"

@class DJNavTypeTitleModel;
@class DJNavView;

@protocol DJNavViewDelegate <NSObject>

@optional
- (void)clickBtn:(UIButton *)btn typeModel:(DJNavTypeTitleModel *)typemodel  navView:(DJNavView *)navView;

@end

@interface DJNavView : UIView

@property (nonatomic, assign) id<DJNavViewDelegate> delegate;

@end
