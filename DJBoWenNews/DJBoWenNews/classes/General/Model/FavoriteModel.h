//
//  FavoriteModel.h
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/7.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavoriteModel : NSObject

@property (nonatomic, assign) NSInteger fid;
@property (nonatomic, copy) NSString *ftitle;
@property (nonatomic, copy) NSString *furl;
@property (nonatomic, copy) NSString *fdocid;
@property (nonatomic, copy) NSString *fboardid;
@property (nonatomic, copy) NSString *flag;

@end
