//
//  DJCycleScrollView.m
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/17.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import "DJCycleScrollView.h"
#import "NSTimer+DJControl.h"
#import "DJCycleModel.h"

@interface DJCycleScrollView () <UIScrollViewDelegate>

@property (nonatomic , assign) NSInteger currentPageIndex;
@property (nonatomic , assign) NSInteger totalPageCount;
@property (nonatomic , retain) NSMutableArray *contentViews;
@property (nonatomic , retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIPageControl *pageControl;

@property (nonatomic , retain) NSTimer *animationTimer;
@property (nonatomic , assign) NSTimeInterval animationDuration;

@property (nonatomic, retain) NSArray *dataScource;

@end

@implementation DJCycleScrollView

#pragma mark init

- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration
{
    if (self = [self initWithFrame:frame])
    {
        if (animationDuration > 0.0)
        {
            self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:(self.animationDuration = animationDuration) target:self selector:@selector(animationTimerDidFired:) userInfo:nil repeats:YES];
            [self.animationTimer pauseTimer];
        }
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureCycleView];
        [self configurePageView];
    }
    return self;
}


#pragma mark -
#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.animationTimer pauseTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int contentOffsetX = scrollView.contentOffset.x;
    if(contentOffsetX >= (2 * CGRectGetWidth(scrollView.frame))) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
        [self configContentViews];
    }
    if(contentOffsetX <= 0) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
        [self configContentViews];
    }
    self.pageControl.currentPage = self.currentPageIndex;
    self.title.text = ((DJCycleModel *)self.dataScource[_currentPageIndex]).title;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:YES];
}


#pragma mark -
#pragma mark - 私有函数


//配置轮播图视图
- (void)configureCycleView
{
    self.autoresizesSubviews = YES;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    self.scrollView.contentMode = UIViewContentModeCenter;
    self.scrollView.contentSize = CGSizeMake(4 * CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
    self.scrollView.delegate = self;
    self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0);
    self.scrollView.pagingEnabled = YES;
    [self.contentView addSubview:self.scrollView];
    self.currentPageIndex = 0;
}
//配置分页控件
- (void)configurePageView
{
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(kScreenWidth - 120, self.bounds.origin.y + 170, 100, 30)];
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:35 / 255.0 green:141 / 255.0 blue:255 / 255.0 alpha:1.0];
    [self addSubview:self.pageControl];
}

- (void)configContentViews
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setScrollViewContentDataSource];
    
    NSInteger counter = 0;
    for (UIView *contentView in self.contentViews)
    {
        contentView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
        [contentView addGestureRecognizer:tapGesture];
        CGRect rightRect = contentView.frame;
        rightRect.origin = CGPointMake(CGRectGetWidth(self.scrollView.frame) * (counter ++), 30);
        
        contentView.frame = rightRect;
        [self.scrollView addSubview:contentView];
    }
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
}

/**
 *  设置scrollView的content数据源，即contentViews
 */
- (void)setScrollViewContentDataSource
{
    NSInteger previousPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
    NSInteger rearPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
    if (self.contentViews == nil) {
        self.contentViews = [NSMutableArray array];
    }
    [self.contentViews removeAllObjects];
    
    if (self.fetchContentViewAtIndex) {
        [self.contentViews addObject:self.fetchContentViewAtIndex(previousPageIndex)];
        [self.contentViews addObject:self.fetchContentViewAtIndex(_currentPageIndex)];
        [self.contentViews addObject:self.fetchContentViewAtIndex(rearPageIndex)];
    }
}

- (NSInteger)getValidNextPageIndexWithPageIndex:(NSInteger)currentPageIndex;
{
    if(currentPageIndex == -1)
    {
        return self.totalPageCount - 1;
    }
    else if (currentPageIndex == self.totalPageCount)
    {
        return 0;
    }
    else
    {
        return currentPageIndex;
    }
}

#pragma mark - 响应事件

- (void)animationTimerDidFired:(NSTimer *)timer
{
    CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.frame), self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:newOffset animated:YES];
}

- (void)contentViewTapAction:(UITapGestureRecognizer *)tap
{
    if (self.TapActionBlock) {
        self.TapActionBlock(self.currentPageIndex);
    }
}

#pragma mark - getter, setter

- (UILabel *)title
{
    if (!_title) {
        self.title = [[UILabel alloc] init];
        self.title.textColor = [UIColor blackColor];
        self.title.font = [UIFont fontWithName:@"Avenir" size:14];
        self.title.frame = CGRectMake(5, 0, kScreenWidth - 10, 30);
        [self addSubview:self.title];
    }
    return _title;
}


- (void)setTotalPagesCount:(NSInteger (^)(void))totalPagesCount
{
    _totalPageCount = totalPagesCount();
    self.pageControl.numberOfPages = _totalPageCount;
    if (_totalPageCount > 0) {
        [self configContentViews];
        [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
    }
}
- (void)setValueWithDataArr:(NSArray *)dataArr{
    self.dataScource = dataArr;
    self.title.text = ((DJCycleModel *)self.dataScource[0]).title;
    NSMutableArray *viewsArray = [NSMutableArray array];
    for (DJCycleModel *model in dataArr)
    {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.frame = CGRectMake(0, 0, kScreenWidth, 200);
        [imgView sd_setImageWithURL:[NSURL URLWithString:model.imgsrc] placeholderImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"博文新闻" ofType:@"png"]] options:SDWebImageRetryFailed];
        [viewsArray addObject:imgView];
    }
    self.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return viewsArray[pageIndex];
    };
    self.totalPagesCount = ^NSInteger(void){
        return viewsArray.count;
    };
}

@end
