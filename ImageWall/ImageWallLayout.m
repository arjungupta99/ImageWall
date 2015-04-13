//
//  ImageWallLayout.m
//  ImageWall
//
//  Created by Arjun Gupta on 2/14/15.
//  Copyright (c) 2015 ArjunGupta. All rights reserved.
//

#import "ImageWallLayout.h"
#import "ImageWallCell.h"
#import "ImageWallCollectionVC.h"


@interface ImageWallLayout()


@property (nonatomic, strong) NSMutableArray *frameArray;
@property (nonatomic, assign) NSInteger numOfColumns;

@end

@implementation ImageWallLayout {
    
    CGFloat _maxColumnHeight;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
        return self;
    }
    return nil;
}


- (CGFloat)margin {
    return 10.0;
}

- (CGFloat)columnWidth {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    if (self.orientationIsLandscape) {
        screenWidth = MAX(screenWidth, screenHeight);
    }
    else {
        screenWidth = MIN(screenWidth, screenHeight);
    }
    
    CGFloat colWidth = (screenWidth - (self.numOfColumns + 1)*self.margin) / self.numOfColumns;

    return colWidth;
}

- (NSInteger)numOfColumns {
    //iPhone
    if (self.isIPhone) {
        if (self.orientationIsLandscape) {
            return 3;
        }
        return 2;
    }
    //iPad
    if (self.orientationIsLandscape) {
        return 4;
    }
    return 3;
}



- (void)resetFrames {
    self.frameArray = nil;
}


- (CGSize)collectionViewContentSize {
    
    return CGSizeMake(self.collectionView.bounds.size.width, _maxColumnHeight);
}


-(void)prepareLayout {
    
    [super prepareLayout];
    
    self.minimumInteritemSpacing = self.margin;
    self.minimumLineSpacing = self.margin;
    
    if (!_frameArray) {
        _frameArray = [[NSMutableArray alloc]init];
        
        _maxColumnHeight = 0;
        
        NSMutableArray *columnHeightList = [NSMutableArray array];
        for (int i = 0 ; i < self.numOfColumns ; i++) {
            [columnHeightList addObject:[NSNumber numberWithFloat:self.margin]];
        }
        
        for(NSInteger i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++)
        {
            NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            
            CGFloat cellHeight = 0;
            if (self.delegate) {
                cellHeight = [self.delegate collectionView:self.collectionView Layout:self heightForItemAtIndexPath:cellIndexPath];
            }
            
            CGSize imageSize = CGSizeMake(self.columnWidth, cellHeight);
            
            
            //Find the column with the minimum height and place the image there
            
            NSInteger placementColumn = 0;
            CGFloat lowestHeight = [[columnHeightList objectAtIndex:0] floatValue];
            
            for (NSInteger k = 0 ; k < self.numOfColumns ; k++) {
                NSNumber *tempHeight = [columnHeightList objectAtIndex:k];
                if ([tempHeight floatValue] < lowestHeight) {
                    lowestHeight = [tempHeight floatValue];
                    placementColumn = k;
                }
            }
            
            CGFloat currentXPosition = (self.columnWidth * placementColumn) + (self.margin * (placementColumn + 1));
            CGFloat currentYPosition = lowestHeight;
            CGRect currentCellFrame = CGRectMake(currentXPosition, currentYPosition, self.columnWidth, imageSize.height);
            
            [_frameArray addObject:[NSValue valueWithCGRect:currentCellFrame]];
            
            lowestHeight = lowestHeight + self.margin + imageSize.height;
            [columnHeightList replaceObjectAtIndex:placementColumn withObject:[NSNumber numberWithFloat:lowestHeight]];
            
            _maxColumnHeight = MAX(_maxColumnHeight, lowestHeight);
        }
    }
}



-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray* visibleCellAttributes = [NSMutableArray array];
    
    for(NSUInteger j = 0; j < [self.collectionView numberOfItemsInSection:0]; j++)
    {
        NSIndexPath* cellIndexPath = [NSIndexPath indexPathForRow:j inSection:0];
        UICollectionViewLayoutAttributes* attributes = [self layoutAttributesForItemAtIndexPath:cellIndexPath];
        
        if(CGRectIntersectsRect(attributes.frame, rect)) {
            
            [visibleCellAttributes addObject:attributes];
        }
    }
    
    return visibleCellAttributes;
}



- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    NSValue *rectValue = [_frameArray objectAtIndex:indexPath.row];
    
    CGRect cellFrame = [rectValue CGRectValue];
    
    attributes.frame = cellFrame;
    
    return attributes;
}

@end
