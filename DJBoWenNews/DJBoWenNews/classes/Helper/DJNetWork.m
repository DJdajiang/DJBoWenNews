//
//  DJNetWork.m
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/7.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import "DJNetWork.h"
#import <AFNetworking/AFNetworking.h>
@implementation DJNetWork

+ (void)JSONDataWithURL:(NSString *)url success:(void (^) (id data))success fail:(void (^) ())fail
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject)
        {
            
            if (success)
            {
                success(responseObject);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (fail)
        {
            fail();
        }
    }];
}

+ (BOOL)okPass:(NSString *)text
{
    if ([text containsString:@"苹果"] || [text containsString:@"iPhone"] ||[text containsString:@"iPad"] || [text containsString:@"Swift"] ||
        [text containsString:@"swift"]||[text containsString:@"三星"] || [text containsString:@"Apple"] || [text containsString:@"apple"] || [text containsString:@"安卓"] || [text containsString:@"Android"] || [text containsString:@"手机"] || [text containsString:@"电脑"] || [text containsString:@"美"] || [text containsString:@"纽"]|| [text containsString:@"平板"]) {
        return NO;
    } else {
        return YES;
    }

}

@end
