//
//  DJReadModel.h
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/14.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DJReadModel : NSObject

@property (nonatomic, copy) NSString *title; //标题
@property (nonatomic, copy) NSString *digest;  //简介
@property (nonatomic, copy) NSString *imgsrc;  //图片链接,无则为No
@property (nonatomic, retain) NSArray *imgnewextra;  //数组内的图片,不一定有
@property (nonatomic, copy) NSString *source;  //左下角来源
@property (nonatomic, copy) NSString *docid;   //唯一标识
@property (nonatomic, copy) NSString *boardid; //标识，转到评论的唯一标识

@property (nonatomic, assign) NSInteger replyCount; //跟帖数
@property (nonatomic, assign) NSInteger flag; //数据需要那套cell展示, 用flag标识

@end
