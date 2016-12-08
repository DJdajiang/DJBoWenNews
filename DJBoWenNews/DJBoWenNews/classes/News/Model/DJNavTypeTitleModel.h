//
//  DJNavTypeTitleModel.h
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/17.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DJNavTypeTitleModel : NSObject

/**
 *  新闻类别类
 */

@property (nonatomic, retain) NSMutableArray *typeName;   //类别名称，
@property (nonatomic, retain) NSMutableArray *typeLinkID;  //类别ID

- (id)initWithTypeTitleModel;
+ (id)typeTitleWithModel;

@end
