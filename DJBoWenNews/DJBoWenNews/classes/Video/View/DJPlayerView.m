
//
//  DJPlayerView.m
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/24.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import "DJPlayerView.h"

@implementation DJPlayerView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayer *)player {
    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setPlayer:(AVPlayer *)player {
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}

@end
