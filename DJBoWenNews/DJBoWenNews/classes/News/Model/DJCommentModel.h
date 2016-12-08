//
//  DJCommentModel.h
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/14.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DJCommentModel : NSObject

@property (nonatomic, retain) NSString *timg, *f, *v, *t, *b, *n; //图片，地方，赞，时间，内容，昵称
@property (nonatomic, retain) NSString *ut; //昵称
@property (nonatomic, assign) NSInteger votecount; //评论数

@end
