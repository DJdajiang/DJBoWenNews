//
//  DJVideoModel.h
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/7.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DJVideoModel : NSObject

@property (nonatomic, copy) NSString *text; //标题
@property (nonatomic, copy) NSString *videouri, *image_small; //视频连接
@property (nonatomic, copy) NSString *width, *height;
@property (nonatomic, copy) NSString *name; //用户名
@property (nonatomic, copy) NSString *profile_image;// 头像
@property (nonatomic, copy) NSString *videotime, *created_at;//视频播放时间
@property (nonatomic, strong) NSNumber *playcount;
@property (nonatomic, assign) NSInteger ID;

@end
