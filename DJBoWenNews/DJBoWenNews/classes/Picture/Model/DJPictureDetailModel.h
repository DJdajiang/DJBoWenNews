//
//  DJPictureDetailModel.h
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/13.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DJPictureDetailModel : NSObject

//"postid":"PHOT22LC009654GI",
//"series":"",
//"clientadurl":"",
//"desc":"6月14日，郑州，少林寺耕种的120多亩小麦熟了，武僧们走进田间，收获黄灿灿的果实。",
//"datatime":"2015-06-15 09:50:22",
//"createdate":"2015-06-15 08:11:07",
//"relatedids":Array[0],
//"scover":"http://img3.cache.netease.com/photo/0096/2015-06-15/s_AS4T2QVC54GI0096.jpg",
//"autoid":"",
//"url":"http://help.3g.163.com/photoview/54GI0096/68268.html",
//"creator":"王雪飞",
//"reporter":"",
//"photos":Array[6],
//"setname":"小麦成熟少林武僧进田间收粮",
//"neteasecode":"",
//"cover":"http://img3.cache.netease.com/photo/0096/2015-06-15/AS4T2QVC54GI0096.jpg",
//"commenturl":"http://comment.help.3g.163.com/photoview_bbs/PHOT22LC009654GI.html",
//"source":"",
//"settag":"武僧",
//"boardid":"photoview_bbs",
//"tcover":"http://img3.cache.netease.com/photo/0096/2015-06-15/t_AS4T2QVC54GI0096.jpg",
//"imgsum":"6"

@property (nonatomic,copy) NSString *postid; //
@property (nonatomic,copy) NSString *series; //系列
@property (nonatomic,copy) NSString *clientadurl; //
@property (nonatomic,copy) NSString *desc; //简介
@property (nonatomic,copy) NSString *datatime; //数据时间
@property (nonatomic,copy) NSString *createdate; //发布时间
@property (nonatomic,copy) NSString *scover;
@property (nonatomic,copy) NSString *autoid;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *creator;
@property (nonatomic,copy) NSString *reporter;
@property (nonatomic,copy) NSString *setname;
@property (nonatomic,copy) NSString *neteasecode;
@property (nonatomic,copy) NSString *cover;
@property (nonatomic,copy) NSString *commenturl;
@property (nonatomic,copy) NSString *source;
@property (nonatomic,copy) NSString *boardid;
@property (nonatomic,copy) NSString *tcover;
@property (nonatomic,copy) NSString *imgsum;
@property (nonatomic,strong) NSArray *photos;
@property (nonatomic,strong) NSArray *relatedids; //

@end
