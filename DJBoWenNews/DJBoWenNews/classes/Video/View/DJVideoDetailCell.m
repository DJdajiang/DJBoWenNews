//
//  DJVideoDetailCell.m
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/7.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import "DJVideoDetailCell.h"
#import "DJVideoDetailModel.h"

@implementation DJVideoDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.imageName];
        [self.contentView addSubview:self.name];
        [self.contentView addSubview:self.text];
    }
    return self;
}

+ (CGFloat)heightForText:(NSString *)text
{
    return  [text boundingRectWithSize:CGSizeMake(kScreenWidth - 70, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
}
+ (CGFloat)heightCell:(DJVideoDetailModel *)model
{
    return [DJVideoDetailCell heightForText:model.content] + 40;
}
//头像
- (UIImageView *)imageName
{
    if (!_imageName)
    {
        self.imageName = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    }
    return _imageName;
}
- (UILabel *)name
{
    if (!_name)
    {
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, kScreenWidth - 50, 15)];
        self.name.font = [UIFont systemFontOfSize:14];
        self.name.textColor = [UIColor grayColor];
    }
    return _name;
}
- (UILabel *)text
{
    if (!_text)
    {
        self.text = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, kScreenWidth - 70, 60)];
        self.text.numberOfLines = 0;
        self.text.lineBreakMode = NSLineBreakByCharWrapping;
        self.text.font = [UIFont systemFontOfSize:14];
    }
    return _text;
}


-(void)setModel:(DJVideoDetailModel *)model
{
    if (_model != model)
    {
        _model = model;
        [self.imageName sd_setImageWithURL:[NSURL URLWithString:model.user[@"profile_image"]] placeholderImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"defaultAvator" ofType:@"png"]]];
        self.name.text = model.user[@"username"];
        self.text.text = model.content;
        
        CGRect frame = self.text.frame;
        frame.size.height = [DJVideoDetailCell heightForText:model.content];
        self.text.frame = frame;
    }
}


@end
