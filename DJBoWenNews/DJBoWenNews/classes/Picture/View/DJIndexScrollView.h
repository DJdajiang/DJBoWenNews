//
//  DJIndexScrollView.h
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/13.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"

@interface DJIndexScrollView : UIScrollView


/**
 *  重用UIScrollView机制的小的UIScrollView
 */
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, retain) UIImageView *imageV;

@end
