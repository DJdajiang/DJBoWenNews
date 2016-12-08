//
//  DJPictureView.m
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/12.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import "DJPictureView.h"
@implementation DJPictureView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageName];
        [self addSubview:self.labelName];
    }
    return self;
}

- (UIImageView *)imageName
{
    if (_imageName == nil)
    {
        _imageName = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (kScreenWidth - 15) / 2, 220)];
        
    }
    return _imageName;
}

- (UILabel *)labelName
{
    if (_labelName == nil)
    {
        _labelName = [[UILabel alloc] initWithFrame:CGRectMake(0, 230, (kScreenWidth - 15) / 2, 30)];
        
        _labelName.lineBreakMode = NSLineBreakByCharWrapping;//通过字符截取.
        
        _labelName.numberOfLines = 0; //显示多行显示
        
        _labelName.textAlignment = NSTextAlignmentLeft; //文本对齐方式，左对齐
        
        _labelName.font = [UIFont systemFontOfSize:15]; //字体大小
        
    }
    
    return _labelName;
}

//给cell子控件赋值
- (void)configureSubviews:(DJPictureModel *)model
{
    [self.imageName sd_setImageWithURL:[NSURL URLWithString:model.clientcover1] placeholderImage:[UIImage imageNamed:@"博文新闻"]];
    
    if ([model.desc isEqualToString:@""])
    {
        model.desc = model.setname;
    }
    
    //等比例缩放
    CGRect kFrame = self.imageName.frame;
    
    kFrame.size.height = (kScreenWidth - 15) / 2;
    
    self.imageName.frame = kFrame;
    
    //获取文本简介
    self.labelName.text = model.desc;
    
    //动态修改文本frame
    CGFloat textheight = [DJPictureView heightForText:model.desc];
    CGRect frame = self.labelName.frame;
    frame.size.height = textheight;
    frame.origin.y = (kScreenWidth - 15) / 2 + 10;
    self.labelName.frame = frame;
}

#pragma mark - 私有方法
//计算文本高度
+ (CGFloat)heightForText:(NSString *)text {
    return  [text boundingRectWithSize:CGSizeMake((kScreenWidth - 15) / 2, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
}

//计算cell高度
+ (CGFloat)heightForRowWithDic:(DJPictureModel *)model
{
    return [self heightForText:model.desc] + (kScreenWidth - 15) / 2;
}

@end
