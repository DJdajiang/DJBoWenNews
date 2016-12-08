//
//  DJSuggestController.m
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/18.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import "DJSuggestController.h"
#import "DJSuggestView.h"
#import "AppDelegate.h"
#import "DDMenuController.h"

@interface DJSuggestController ()<UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, retain) DJSuggestView *rootView;
@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain)     UILabel *label;

@end

@implementation DJSuggestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.rootView = [[DJSuggestView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = _rootView;
    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(3, 4, 300, 20)];
    self.label.enabled = NO;
    self.label.text = @"请反馈问题或建议，帮助我们不断改进！";
    self.label.font =  [UIFont systemFontOfSize:15];
    self.label.textColor = [UIColor colorWithRed:225 / 255.0 green:220 / 255.0 blue:225 / 255.0 alpha:1.0];
    [_rootView.content addSubview:self.label];

    self.view.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1.0];
    self.navigationItem.title = @"意见反馈";
    [self configureLeftButton];
    [self configureRightButton];
    _rootView.content.delegate = self;
    _rootView.email.delegate = self;
}

#pragma mark UITextFileDelegate

//点击空白区域，会触发的方法
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //回收键盘
    [self.textField resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.textField = textField;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextViewDelegate设置默认文字

- (void)textViewDidChange:(UITextView *)textView {
    
    if (textView.text.length == 0) {
        [self.label setHidden:NO];
    } else {
        [self.label setHidden:YES];
    }
}
#pragma mark - 界面配置类
- (void)configureLeftButton {
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"qr_toolbar_more_hl"] style:UIBarButtonItemStylePlain target:self action:@selector(handleBack:)];
    self.navigationItem.leftBarButtonItem = left;

    
}
- (void)configureRightButton {
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(handleSend:)];
    self.navigationItem.rightBarButtonItem = right;

    
}
- (void)handleBack:(UIBarButtonItem *)item {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    DDMenuController *menuC  = delegate.menuController;
    [menuC showLeftController:YES];
}

- (void)handleSend:(UIBarButtonItem *)item
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"反馈提醒" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    if (_rootView.content.text.length  < 5) {
        alert.message = @"别吝啬，多留点字吧~";
    } else {
        alert.message = @"反馈成功";
        _rootView.content.text = @"";
        _rootView.email.text = @"";
    }
    [alert show];

}


@end
