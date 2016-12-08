//
//  MineModel.m
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/7.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import "MineModel.h"

@implementation MineModel

- (id)initWithDic:(NSDictionary *)dic {
    if (self = [super init])
    {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
+ (id)mineModelWithDic:(NSDictionary *)dic
{
    return  [[self alloc] initWithDic:dic];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}


@end
