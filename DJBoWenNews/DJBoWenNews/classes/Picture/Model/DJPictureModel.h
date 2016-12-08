//
//  DJPictureModel.h
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/12.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import <Foundation/Foundation.h>

//"desc":"2016年10月12日消息，陕西商洛，10月5日凌晨，丹凤县城时代购物中心市值过百万元的金银玉器首饰遭洗劫，警方介入调查。警方经过5天全力侦破，10日下午将两名嫌疑人陈某、谢某抓获。图/视觉中国",
//"pvnum":"",
//"createdate":"2016-10-12 17:23:50",
//"scover":"http://img4.cache.netease.com/photo/0096/2016-10-12/s_C36NIVG954GI0096.jpg",
//"setname":"陕西商场盗窃嫌犯指认现场 ",
//"cover":"http://img4.cache.netease.com/photo/0096/2016-10-12/C36NIVG954GI0096.jpg",
//"pics":Array[3],
//"clientcover1":"http://img4.cache.netease.com/photo/0096/2016-10-12/C36NIVG954GI0096.jpg",
//"replynum":"18007",
//"topicname":"",
//"setid":"111158",
//"seturl":"http://help.3g.163.com/photoview/54GI0096/111158.html",
//"datetime":"2016-10-12 17:24:05",
//"clientcover":"",
//"imgsum":"7",
//"tcover":"http://img4.cache.netease.com/photo/0096/2016-10-12/t_C36NIVG954GI0096.jpg"
@interface DJPictureModel : NSObject

@property (nonatomic,copy) NSString *desc; //简介
@property (nonatomic,copy) NSString *pvnum; //
@property (nonatomic,copy) NSString *creatdate; //创建时间
@property (nonatomic,copy) NSString *scover; //
@property (nonatomic,copy) NSString *setname; //标题
@property (nonatomic,copy) NSString *cover; //主图片
@property (nonatomic,copy) NSString *clientcover1; //辅助图片1
@property (nonatomic,copy) NSString *replynum; //回复数量
@property (nonatomic,copy) NSString *topicname;
@property (nonatomic,copy) NSString *setid; //设置id
@property (nonatomic,copy) NSString *seturl; //设置网址字符串对象
@property (nonatomic,copy) NSString *datetime; //更新日期
@property (nonatomic,copy) NSString *clierntcover; //辅助图片
@property (nonatomic,copy) NSString *imgsum; //图片总数
@property (nonatomic,copy) NSString *tcover;
@property (nonatomic,copy) NSArray *pics;

@end
