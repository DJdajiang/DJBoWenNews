//
//  DJCollectionViewFlowLayout.h
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/13.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"

@class DJCollectionViewFlowLayout;
@protocol  DJCollectionViewFlowLayout<UICollectionViewDelegate>

//每个cell高度指定代理
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(DJCollectionViewFlowLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexpath;

@end

@interface DJCollectionViewFlowLayout : UICollectionViewLayout

@property (nonatomic,assign) CGFloat itemWidth; // 宽度
@property (nonatomic,assign) CGFloat minLineSpacing; //每行每列的间隔
@property (nonatomic,assign) CGFloat interitemSpacing;  //每列的间隔
@property (nonatomic,assign) NSInteger itemCount; //item的个数
@property (nonatomic,assign) NSUInteger columnCount; //列数
@property (nonatomic,assign) UIEdgeInsets sectionInset; // 每个section的边框间距
@property (nonatomic,strong) NSMutableArray *columnHeights;  // 每一列的总高度
@property (nonatomic,strong) NSMutableArray *itemAttributes;  // 每个item的attributes
@property (nonatomic,weak) id<DJCollectionViewFlowLayout> delegate;

@end
