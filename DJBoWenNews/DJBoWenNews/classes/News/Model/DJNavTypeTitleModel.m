//
//  DJNavTypeTitleModel.m
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/17.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import "DJNavTypeTitleModel.h"

@implementation DJNavTypeTitleModel



- (id)initWithTypeTitleModel
{
    if (self = [super init])
    {
        self.typeName = [NSMutableArray arrayWithObjects:@"头条", @"娱乐",@"时尚", @"汽车", @"科技", @"影视", @"游戏",nil];
        self.typeLinkID = [NSMutableArray arrayWithObjects:@"T1348647853363", @"T1348648517839", @"T1348650593803", @"T1348654060988",@"T1348649580692", @"T1348648650048",@"T1348654151579", nil];
    }
    return self;
}
+ (id)typeTitleWithModel
{
    return [[self alloc] initWithTypeTitleModel];
}


@end
