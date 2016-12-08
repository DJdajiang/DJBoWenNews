//
//  MineModel.h
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/7.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineModel : NSObject

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *title;

- (id)initWithDic:(NSDictionary *)dic;
+ (id)mineModelWithDic:(NSDictionary *)dic;

@end
