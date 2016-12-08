//
//  DJData.h
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/7.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FavoriteModel.h"

@interface DJData : NSObject<NSCopying>

//创建单例类
+ (instancetype)shareData;


//打开数据库
- (void)openDataBase;
//创建收藏表
- (void)createTable;
//插入收藏数据
- (BOOL)insertData:(FavoriteModel *)model;
//删除收藏数据
- (void)deleteData:(NSInteger)fid;
//获取列表
- (NSMutableArray *)getListData;

//关闭数据库
- (void)closeDataBase;

@end
