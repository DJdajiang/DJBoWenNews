//
//  DJNavView.m
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/17.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import "DJNavView.h"
#import "AppDelegate.h"
#import "DJNavTypeTitleModel.h"


@interface DJNavView()<UIScrollViewDelegate>

@property (nonatomic, retain) DJNavTypeTitleModel *model;
@property (nonatomic, retain) UIScrollView *scroll;

@end

@implementation DJNavView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        //加载类别model
        self.model = [DJNavTypeTitleModel typeTitleWithModel];
        [self configureNav];
    }
    return self;
}

//自定义导航条
- (void)configureNav {
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor colorWithRed:35 / 255.0 green:141 / 255.0 blue:255 / 255.0 alpha:1.0];
    self.tintColor = [UIColor whiteColor];
    [self configureScrollView];
    [self configureLeftButton];
}

//导航左侧按钮
- (void)configureLeftButton {
    UIButton *navLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [navLeftBtn setFrame:CGRectMake(16, 21, 44, 44)];
    [navLeftBtn setTag:1001];//1
    [navLeftBtn setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"qr_toolbar_more_hl"]]];
    [navLeftBtn addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:navLeftBtn];
    
}

//配置导航类型滚动视图
- (void)configureScrollView {
    self.scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(70, 20, kScreenWidth - 140, 44)];
    self.scroll.contentSize = CGSizeMake(self.model.typeName.count * 60, 44);
    self.scroll.delegate = self;
    self.scroll.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scroll];
    for (int i = 0; i < self.model.typeName.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.tag = 101 + i;
        
        btn.frame = CGRectMake(50 * i, 0, 41, 40);
        btn.tintColor = [UIColor whiteColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:self.model.typeName[i] forState:UIControlStateNormal];
        if (i == 0) {
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
            [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        }
        [btn addTarget:self action:@selector(handleBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.scroll addSubview:btn];
    }
    [self addSubview:self.scroll];
}

#pragma mark - action
//调出侧边栏
- (void)handleAction:(UIButton *)sender {
    [((AppDelegate *)[UIApplication sharedApplication].delegate).menuController showLeftController:YES];
}

- (void)handleActionRight:(UIButton *)sender {
    [((AppDelegate *)[UIApplication sharedApplication].delegate).menuController showLeftController:YES];
}

//点击类型按钮事件
- (void)handleBtn:(UIButton *)sender {
    
    self.scroll.contentOffset=CGPointMake(200, 0);
    for (int i = 0; i < self.scroll.subviews.count;i++)
    {
        ((UIButton *)[self.scroll viewWithTag:100 + i]).titleLabel.font = [UIFont systemFontOfSize:14];
        [((UIButton *)[self.scroll viewWithTag:100 + i]) setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    if(sender.frame.origin.x > self.scroll.frame.size.width/2 && (self.scroll.contentSize.width - sender.frame.origin.x) > self.scroll.frame.size.width/2  )
    {
        CGPoint point = self.scroll.contentOffset;
        point = CGPointMake(sender.frame.origin.x - self.scroll.frame.size.width/2 + sender.frame.size.width/2, 0);
        self.scroll.contentOffset = point;
    }
    else if (sender.frame.origin.x < self.scroll.frame.size.width/2)
    {
        CGPoint point = self.scroll.contentOffset;
        point=CGPointMake(0, 0);
        self.scroll.contentOffset=point;
    }
//    else if ((self.scroll.contentSize.width - sender.frame.origin.x) < self.scroll.frame.size.width/2)
//    {
//        CGPoint point = self.scroll.contentOffset;
//        point = CGPointMake(self.scroll.contentSize.width - self.scroll.frame.size.width +50 , 0);
//        self.scroll.contentOffset = point;
//    }


    if ([_delegate respondsToSelector:@selector(clickBtn:typeModel:navView:)])
    {
        [self.delegate clickBtn:sender typeModel:self.model navView:self];
    }
    
    sender.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [sender setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
}

@end
