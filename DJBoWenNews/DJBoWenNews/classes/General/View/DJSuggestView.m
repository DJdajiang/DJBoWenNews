//
//  DJSuggestView.m
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/18.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import "DJSuggestView.h"

@implementation DJSuggestView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self addSubview:self.content];
        [self addSubview:self.email];
    }
    return self;
}
- (UITextView *)content
{
    if (!_content)
    {
        //让textview从第一行显示
        UITextView * v = [[UITextView alloc] init];
        [self addSubview:v];
        
        self.content = [[UITextView alloc] initWithFrame:CGRectMake(5, 70, kScreenWidth - 10, 100)];
        _content.layer.cornerRadius = 6;
        _content.layer.masksToBounds = YES;
        _content.layer.borderColor = [[UIColor colorWithRed:220 / 255.0 green:220 / 255.0  blue:220 / 255.0  alpha:1.0] CGColor];
        _content.layer.borderWidth = 1;
        _content.font = [UIFont systemFontOfSize:14];
        _content.returnKeyType = UIBarButtonSystemItemRewind;
        _content.keyboardAppearance = UIKeyboardAppearanceLight;
        
    }
    return _content;
}
- (UITextField *)email
{
    if (!_email)
    {
        self.email = [[UITextField alloc] initWithFrame:CGRectMake(5, 180, kScreenWidth - 10, 40)];
        _email.borderStyle = UITextBorderStyleRoundedRect;
        _email.placeholder = @"联系方式(邮箱或QQ号)";
        _email.font = [UIFont systemFontOfSize:14];
        _email.returnKeyType = UIReturnKeySend;
        _email.clearsOnBeginEditing = YES;
        _email.keyboardAppearance = UIKeyboardAppearanceLight;
    }
    return _email;
}

@end
