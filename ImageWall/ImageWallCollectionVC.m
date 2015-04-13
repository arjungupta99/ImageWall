//
//  ImageWallCollectionVC.m
//  ImageWall
//
//  Created by Arjun Gupta on 2/13/15.
//  Copyright (c) 2015 ArjunGupta. All rights reserved.
//

#import "ImageWallCollectionVC.h"
#import "ImageWallCell.h"


@interface ImageWallCollectionVC () {
    
    NSMutableArray *_imageArray;
}


@end

@implementation ImageWallCollectionVC

static NSString * const reuseIdentifier = @"Cell";


- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self loadImages];
        
        return self;
    }
    return nil;
}


- (void)loadImages {
    _imageArray = [NSMutableArray array];
    
    //Loading image names from the included Plist file
    NSString *plistPath = [[NSBundle mainBundle] pathForResource: @"ImageSource" ofType:@"plist"];
    NSArray *URLStringArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
    
    for (NSString *urlString in URLStringArray) {
        [_imageArray addObject:[UIImage imageNamed:urlString]];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    ImageWallLayout* customLayout = (ImageWallLayout*)self.collectionView.collectionViewLayout;
    customLayout.delegate = self;
    
    if (UIDeviceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        customLayout.orientationIsLandscape = YES;
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        customLayout.isIPhone = YES;
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration; {
    
    ImageWallLayout* customLayout = (ImageWallLayout*)self.collectionView.collectionViewLayout;
    [customLayout resetFrames];
    if (UIDeviceOrientationIsLandscape(toInterfaceOrientation)) {
        customLayout.orientationIsLandscape = YES;
    }
    else {
        customLayout.orientationIsLandscape = NO;
    }
}



#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ImageWallCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    cell.imageContainer.image = [_imageArray objectAtIndex:indexPath.row];
    
    cell.backgroundColor = [UIColor whiteColor];

    return cell;
}



#pragma mark - ImageWallLayoutDelegate

//For getting the correct image height while maintaining the ratio
- (CGFloat)collectionView:(UICollectionView*)collectionView Layout:(UICollectionViewLayout*)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath*)indexPath {
    
    ImageWallLayout* imageWallLayout = (ImageWallLayout*)collectionViewLayout;
    UIImage *cellImage = [_imageArray objectAtIndex:indexPath.row];
    CGFloat ratio = imageWallLayout.columnWidth / cellImage.size.width;
    CGFloat imageHeight = cellImage.size.height * ratio;
    
    return imageHeight;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
