//
//  DJData.m
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/7.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import "DJData.h"
#import "PrefixHeader.pch"

static DJData *data = nil;
@implementation DJData

FMDatabase *dataBase = nil;


//创建单例类
+ (instancetype)shareData
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        data = [[DJData alloc] init];
    });
    
    return data;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        data = [super allocWithZone:zone];
    });
    return data;
}

-(id)copy
{
    return data;
}

-(id)copyWithZone:(NSZone *)zone
{
    return data;
}

//打开数据库
- (void)openDataBase
{
    dataBase = [FMDatabase databaseWithPath:[self getHomePath:@"BoWenDB.sqlite"]];
    if (![dataBase open])
    {
        return;
    }
    {
        [self createTable];
    }
    //为数据库设置缓存，提高性能
    [dataBase setShouldCacheStatements:YES];
}

//创建收藏表
- (void)createTable
{
    //判断表是否创建
    [dataBase executeUpdate:@"create table if not exists t_favorite(fid integer primary key autoincrement, ftitle text, furl text, fdocid text, fboardid text, flag text)"];

}
//插入一条收藏信息
- (BOOL)insertData:(FavoriteModel *)model
{
    
    //处理为空
    if ([model.ftitle isEqualToString:@""] || !model.ftitle)
    {
        return NO;
    }
    FMResultSet *resultSet = [dataBase executeQuery:@"select * from t_favorite where ftitle=?", model.ftitle];
    
    //已经存在
    if ([resultSet next])
    {
        return NO;
    }
    else
    {
        [dataBase executeUpdate:@"insert into t_favorite(ftitle, furl, fdocid, fboardid, flag) values(?, ?, ?, ?, ?)", model.ftitle, model.furl, model.fdocid, model.fboardid, model.flag];
        return YES;
    }
    
}
//删除一条收藏信息
- (void)deleteData:(NSInteger)fid
{

    [dataBase executeUpdate:@"delete from t_favorite where fid=?",[NSString stringWithFormat:@"%ld", (long)fid]];

}
//返回查询数据结果
- (NSMutableArray *)getListData
{
    NSMutableArray *listArr = [NSMutableArray array];
    FMResultSet *resultSet = [dataBase executeQuery:@"select * from t_favorite"];
    while ([resultSet next])
    {
        FavoriteModel *model = [[FavoriteModel alloc] init];
        model.fid = [resultSet intForColumn:@"fid"];
        model.ftitle = [resultSet stringForColumn:@"ftitle"];
        model.furl = [resultSet stringForColumn:@"furl"];
        model.fboardid =  [resultSet stringForColumn:@"fboardid"];
        model.fdocid = [resultSet stringForColumn:@"fdocid"];
        model.flag = [resultSet stringForColumn:@"flag"];
        [listArr addObject:model];
    }
    return listArr;
}

//返回路径
- (NSString *)getHomePath:(NSString *)databaseName
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:databaseName];
}

//关闭数据库
- (void)closeDataBase
{
    [dataBase close];
}
@end
