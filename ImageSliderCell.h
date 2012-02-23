//
//  ImageSliderCell.h
//  ImageSliderCell
//
//  Created by Y.S. Lu on 12-2-22.
//  Copyright (c) 2012年 Appublisher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import <QuartzCore/QuartzCore.h>

@protocol ImageSliderCellDelegate;

@interface ImageSliderCell : UITableViewCell
{
    NSArray* _imageURLArray;
    NSMutableArray* _imageViewArray;
    UIScrollView* _scrollView;
    NSIndexPath *_indexPath;
}

@property (nonatomic,retain) NSArray* imageURLArray;
@property (nonatomic,assign) id <ImageSliderCellDelegate> delegate; 
@property(nonatomic, retain) NSIndexPath * indexPath;
@property CGFloat padding;

-(void)setImageURLArray:(NSArray *)newImageURLArray;

@end

@protocol ImageSliderCellDelegate <NSObject>
@optional
-(void)imageSliderCell:(ImageSliderCell*)cell didSelectImageAtIndexpath:(NSIndexPath*)indexpath;

@end