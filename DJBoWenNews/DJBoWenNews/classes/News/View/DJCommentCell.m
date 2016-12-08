//
//  DJCommentCell.m
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/14.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import "DJCommentCell.h"



#define kMarginLeft_Avator    10
#define kMarginTop_Avator     20
#define kWidth_Avator         30
#define kHeight_Avator        30

#define kMarginLeft_Name        (kMarginLeft_Avator + kWidth_Avator + 10)
#define kMarginTop_Name         kMarginTop_Avator + 5
#define kWidth_Name             200
#define kHeight_Name            20

#define kMarginLeft_Address     kMarginLeft_Name
#define kMarginTop_Address      (kMarginTop_Name + kHeight_Name)
#define kWidth_Address          140
#define kHeight_Address         20

#define kMarginLeft_Time        (kMarginLeft_Name + kWidth_Address)
#define kMarginTop_Time         kMarginTop_Address
#define kWidth_Time             50
#define kHeight_Time            20

#define kMarginLeft_btn         (kScreenWidth - 40)
#define kMarginTop_btn          (kMarginTop_Name - 5)
#define kWidth_btn              30
#define kHeight_btn             30

#define kMarginLeft_Content     kMarginLeft_Name
#define kMarginTop_Content      kMarginTop_Address +  kHeight_Address + 5
#define kWidth_Content          kScreenWidth - kMarginLeft_Content - 30

@implementation DJCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self.contentView addSubview:self.avator];
        [self.contentView addSubview:self.name];
        [self.contentView addSubview:self.address];
        [self.contentView addSubview:self.content];
        [self.contentView addSubview:self.time];
    }
    return self;
}

#pragma mark -  计算高度

//计算文本宽度
+ (CGFloat)widthForText:(NSString *)text
{
    return  [text boundingRectWithSize:CGSizeMake(kScreenWidth - 80, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.width;
}
//计算文本高度
+ (CGFloat)heightForText:(NSString *)text
{
    return  [text boundingRectWithSize:CGSizeMake(kScreenWidth - 80, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.height;
}
//计算cell高度
+ (CGFloat)heightForRowWithDic:(DJCommentModel *)model
{
    return [self heightForText:model.b] + kMarginTop_Address + kHeight_Address + 20;
}

#pragma mark - getter
- (UIImageView *)avator
{
    if (!_avator) {
        self.avator = [[UIImageView alloc] initWithFrame:CGRectMake(kMarginLeft_Avator, kMarginTop_Avator, kWidth_Avator, kHeight_Avator)];
        self.avator.layer.cornerRadius = kWidth_Avator / 2;
        self.avator.layer.masksToBounds = YES;
    }
    return _avator;
}
- (UILabel *)name
{
    if (!_name)
    {
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(kMarginLeft_Name, kMarginTop_Name, kWidth_Name, kHeight_Name)];
    }
    return _name;
}
- (UILabel *)address
{
    if (!_address)
    {
        self.address = [[UILabel alloc] initWithFrame:CGRectMake(kMarginLeft_Address, kMarginTop_Address, kWidth_Address, kHeight_Address)];
        self.address.font = [UIFont systemFontOfSize:12];
        self.address.textColor = [UIColor lightGrayColor];
    }
    return _address;
}
- (UILabel *)time
{
    if (!_time)
    {
        self.time = [[UILabel alloc] initWithFrame:CGRectMake(kMarginLeft_Time, kMarginTop_Time, kWidth_Time, kHeight_Time)];
        self.time.font = [UIFont systemFontOfSize:12];
        self.time.textColor = [UIColor lightGrayColor];
    }
    return _time;
}

- (UILabel *)content
{
    if (!_content)
    {
        self.content = [[UILabel alloc] initWithFrame:CGRectMake(kMarginLeft_Content, kMarginTop_Content, kWidth_Content, 0)];
        self.content.textAlignment = NSTextAlignmentLeft;
        self.content.font = [UIFont systemFontOfSize:16];
        self.content.lineBreakMode = NSLineBreakByCharWrapping;
        self.content.numberOfLines = 0;
        
    }
    return _content;
}

#pragma mark setter
- (void)setModel:(DJCommentModel *)model
{
    if (_model != model)
    {
        _model = model;
        [self.avator sd_setImageWithURL:[NSURL URLWithString:model.timg] placeholderImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"博文新闻" ofType:@"png"]]];
        self.name.text = [model.n isEqualToString:@""]|| model.n == nil ? @"火星人" : model.n;
        self.address.text = model.f;
        self.content.text = model.b;
        
        self.time.text = model.t;
        //从地址字符串中，找出昵称
        if ([model.f containsString:@"&nbsp;"])
        {
            self.name.text = [self.name.text isEqualToString:@"火星人"] ? [model.f componentsSeparatedByString:@"&nbsp"][1] : self.name.text;
        }
        self.name.text = [[self.name.text stringByReplacingOccurrencesOfString:@";" withString:@""] stringByReplacingOccurrencesOfString:@"：" withString:@""];
        self.address.text = [[model.f componentsSeparatedByString:@"网友"][0] stringByAppendingFormat:@"网友"];
        [self setupTimeStyle];
        [self configureFrame];
    }
}

- (void)setupTimeStyle {
    
    if (self.time.text == nil)
    {
        self.time.text = @"时间都去哪了";
        return;
    }
    NSDateFormatter *format = [[NSDateFormatter alloc] init];//转换器
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设置格式
    NSDate *date = [format dateFromString:self.time.text];//转换
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:date];
    
    if (timeInterval <= 60)
    {
        self.time.text = @"刚刚";
    } else if (timeInterval <= 3600) {[[NSDate date] timeIntervalSinceDate:[NSDate date]];
        self.time.text = [NSString stringWithFormat:@"%i分钟前", (int)timeInterval / 60];
    } else if (timeInterval <= 3600 * 24){
        self.time.text = [NSString stringWithFormat:@"%i小时前", (int)timeInterval / 3600];
    } else {
        self.time.text = [NSString stringWithFormat:@"%i天前", (int)timeInterval / 3600 * 24];
    }
}


#pragma mark - 修改frame

- (void)configureFrame
{
    //动态修改控件的位置
    CGRect aframe = self.address.frame;
    aframe.size.width = [DJCommentCell widthForText:self.address.text];
    self.address.frame = aframe;
    
    //修改
    CGRect bframe = self.time.frame;
    bframe.origin.x = self.address.frame.origin.x + self.address.frame.size.width + 7;
    bframe.size.width = [DJCommentCell widthForText:self.time.text];
    self.time.frame = bframe;
    
    //修改内容frame
    CGRect frame = self.content.frame;
    frame.size.height = [DJCommentCell heightForText:self.content.text];
    self.content.frame = frame;
    
}

@end
