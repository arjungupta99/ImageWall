//
//  ImageWallLayout.h
//  ImageWall
//
//  Created by Arjun Gupta on 2/14/15.
//  Copyright (c) 2015 ArjunGupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageWallLayoutDelegate <NSObject>

- (CGFloat)collectionView:(UICollectionView*)collectionView Layout:(UICollectionViewLayout*)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath*)indexPath;

@end

@interface ImageWallLayout : UICollectionViewFlowLayout


@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, assign) CGFloat columnWidth;
@property (nonatomic, assign) BOOL orientationIsLandscape;
@property (nonatomic, assign) BOOL isIPhone;

@property (weak, nonatomic) id <ImageWallLayoutDelegate> delegate;


- (void)resetFrames;

@end
