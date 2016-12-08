
//
//  DJReadDetailView.m
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/14.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import "DJReadDetailView.h"


@implementation DJReadDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.title];
        [self addSubview:self.webView];
        [self addSubview:self.source];
        [self addSubview:self.date];
        [self addSubview:self.toolBar];
        [self configureLine];
    }
    return self;
}

#pragma mark - 重写get方法
- (UILabel *)title {
    if (!_title) {
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(10, 66, kScreenWidth, 30)];
        self.title.numberOfLines = 0;
        self.title.font = [UIFont systemFontOfSize:16 weight:3];
        self.title.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _title;
}

- (UILabel *)source {
    if (!_source) {
        self.source = [[UILabel alloc] initWithFrame:CGRectMake(15, 96, 80, 15)];
        self.source.font = [UIFont systemFontOfSize:14];
        self.source.textColor = [UIColor grayColor];
    }
    return _source;
}

- (UILabel *)date {
    if (!_date) {
        self.date = [[UILabel alloc] initWithFrame:CGRectMake(15 + 80, 96, kScreenWidth - 150 - 25, 15)];
        self.date.font = [UIFont systemFontOfSize:14];
        self.date.textColor = [UIColor grayColor];
    }
    return _date;
}
- (UIWebView *)webView {
    if (!_webView) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 115, kScreenWidth, [UIScreen mainScreen].bounds.size.height - 160)];
        _webView.backgroundColor = [UIColor clearColor];
        //        _webView.scrollView.scrollEnabled = NO;
        _webView.allowsInlineMediaPlayback = YES;
        _webView.mediaPlaybackRequiresUserAction = NO;
        
    }
    return _webView;
}


- (UIButton *)btnShare
{
    if (!_btnShare) {
        self.btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnShare.frame = CGRectMake(kScreenWidth - 40 - 20, 3, 20, 20);
        [_btnShare setImage:[UIImage imageNamed:@"btn.content.share"] forState:UIControlStateNormal];
    }
    return _btnShare;
}
- (UIButton *)btnSave
{
    if (!_btnSave) {
        self.btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnSave.frame = CGRectMake(kScreenWidth - 23 - 100, 0, 23, 23);
        [_btnSave setImage:[UIImage imageNamed:@"icon.more.enjoy"] forState:UIControlStateNormal];
    }
    return _btnSave;
}

- (UIButton *)btnComment
{
    if (!_btnComment) {
        self.btnComment = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnComment.frame = CGRectMake(kScreenWidth - 20 - 160, 3, 20, 20);
        [_btnComment setImage:[UIImage imageNamed:@"btn.common.comment"] forState:UIControlStateNormal];
    }
    return _btnComment;
}
- (UIView *)toolBar
{
    if (!_toolBar) {
        self.toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 44, kScreenWidth, 44)];
        self.toolBar.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0  blue:245 / 255.0 alpha:0.3];
        [self.toolBar  addSubview:self.btnSave];
        UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 23 - 100, 23, 20, 20)];
        lbl1.text = @"收藏";
        lbl1.font = [UIFont systemFontOfSize:10];
        [self.toolBar addSubview:lbl1];
        
        [self.toolBar  addSubview:self.btnShare];
        UILabel *lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 40 - 20, 23, 20, 20)];
        lbl2.text = @"分享";
        lbl2.font = [UIFont systemFontOfSize:10];
        [self.toolBar addSubview:lbl2];
        
        [self.toolBar addSubview:self.btnComment];
        UILabel *lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 20 - 160, 23, 20, 20)];
        lbl3.font = [UIFont systemFontOfSize:10];
        [self.toolBar addSubview:lbl3];
    }
    return _toolBar;
}

#pragma mark - setter 方法
- (void)configureLine
{
    //标题分割线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(5, 96 + 18, kScreenWidth - 10, 1)];
    line.backgroundColor = [UIColor grayColor];
    [self addSubview:line];
}

- (void)setModel:(DJReadDetailModel *)model
{
    if (_model != model)
    {
        _model = model;
        self.title.text = model.title;
        self.date.text = model.ptime;
        self.source.text = model.source;
        //获取图片集信息
        for (int i = 0; i < model.img.count; i++)
        {
            NSArray *pixArr = [model.img[i][@"pixel"]  componentsSeparatedByString:@"*"];
            if (!pixArr)
            {
                pixArr = @[[NSString stringWithFormat:@"%f", kScreenWidth - 20], [NSString stringWithFormat:@"%f", (kScreenWidth - 20) * 2.0 / 3]];
            }
            if ([pixArr[0] floatValue] > kScreenWidth)
            {
                pixArr = @[[NSString stringWithFormat:@"%f", kScreenWidth - 20],[NSString stringWithFormat:@"%f",[pixArr[1] floatValue]  * kScreenWidth / [pixArr[0] floatValue]]];
                
            }
            NSString *imgTag = [NSString stringWithFormat:@"<div style=\"border:1px font-size:14; text-align:center; solid #ccc;\"> <img style=\" width:%@; height:%@;\" src=\"%@\"><span>%@</span></div>",pixArr[0], pixArr[1], model.img[i][@"src"], model.img[i][@"alt"]];
            model.body = [model.body stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<!--IMG#%d-->", i] withString:imgTag];
        }
        for (int i = 0; i < model.video.count; i++) {
            NSString *videoTag = [NSString stringWithFormat:@"<div style=\"border:1px font-size:14; text-align:center; solid #ccc;\"><video id=\"player\" width=\"300\" height=\"250\" controls webkit-playsinline controls='controls' autoplay='autoplay'> <source src=\"%@\" type=\"video/mp4\" /> </video></div>", model.video[i][@"url_mp4"]];
            model.body = [model.body stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<!--VIDEO#%d-->", i] withString:videoTag];
        }
        [self.webView loadHTMLString:model.body baseURL:nil];
        
        CGRect frame = self.source.frame;
        frame.size.width = [DJReadDetailView getTextWidth:self.source.text];
        self.source.frame = frame;
        
        CGRect frame2 = self.date.frame;
        frame2.origin.x = 15 + frame.size.width + 5;
        self.date.frame = frame2;
    }
}

+ (CGFloat)getTextWidth:(NSString *)text
{
    return  [text boundingRectWithSize:CGSizeMake(kScreenWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin |
             NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} context:nil].size.width;
}

@end
