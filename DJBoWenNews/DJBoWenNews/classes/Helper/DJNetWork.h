//
//  DJNetWork.h
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/7.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DJNetWork : NSObject

/**
 
 *网络请求类
 
*/

+ (void)JSONDataWithURL:(NSString *)url success:(void (^) (id data))success fail:(void (^) ())fail;

+ (BOOL)okPass:(NSString *)text;


@end
