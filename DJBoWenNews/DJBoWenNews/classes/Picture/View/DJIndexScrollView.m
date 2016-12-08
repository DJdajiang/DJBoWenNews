//
//  DJIndexScrollView.m
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/13.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import "DJIndexScrollView.h"

@implementation DJIndexScrollView

- (UIImageView *)imageV  {
    if (!_imageV) {
        self.imageV = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _imageV;
}

- (instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.imageV];
    }
    return self;
}

@end
