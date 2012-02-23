//
//  ImageSliderCell.m
//  ImageSliderCell
//
//  Created by Y.S. Lu on 12-2-22.
//  Copyright (c) 2012年 Appublisher. All rights reserved.
//

#import "ImageSliderCell.h"


#define IMAGE_WIDTH 70
#define IMAGE_PADDING 10

@implementation ImageSliderCell

@synthesize imageURLArray=_imageURLArray;
@synthesize indexPath=_indexPath;
@synthesize delegate,padding;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        //initial array
        _imageViewArray = [[NSMutableArray alloc] init];
        
        _scrollView = [[UIScrollView alloc] init];//what is the frame set to??
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor clearColor];

        //UI presentation        
        self.padding = 2.f;
        
        //监听
        UITapGestureRecognizer* tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)] autorelease];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

//- (void)layoutSubviews
//{
//    
//}


-(void)setImageURLArray:(NSArray *)newImageURLArray
{
    [_imageURLArray release];
    _imageURLArray = [newImageURLArray retain];
    
    _scrollView.frame = CGRectMake(0, 10, self.frame.size.width, 100 - 20);
    _scrollView.contentSize = CGSizeMake(IMAGE_PADDING+(IMAGE_WIDTH+IMAGE_PADDING)*_imageURLArray.count, IMAGE_WIDTH);
    [self addSubview:_scrollView];

    for (int i=0; i<=_imageURLArray.count-1; i++) 
    {
        AsyncImageView* imageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(IMAGE_PADDING+(IMAGE_WIDTH+IMAGE_PADDING)*i, IMAGE_PADDING/2, IMAGE_WIDTH, IMAGE_WIDTH)];
        imageView.layer.borderColor = [UIColor grayColor].CGColor;
        imageView.layer.borderWidth = 2.;
        imageView.layer.cornerRadius = 3.;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        
        imageView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        imageView.layer.shadowOpacity = 0.8f;
        imageView.layer.shadowOffset = CGSizeMake(5, 0);
        imageView.layer.masksToBounds = NO;
        imageView.layer.shadowRadius = 5.0f;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds cornerRadius:5.0f];
        imageView.layer.shadowPath = path.CGPath;
        
        [_imageViewArray addObject:imageView];
        [_scrollView addSubview:imageView];
        
        [imageView loadImage:[[_imageURLArray objectAtIndex:i]objectForKey:@"url"]];
                
        [imageView release];
    }
    
}

- (void) tapped:(UITapGestureRecognizer*)tapRecognizer 
{
    NSLog(@"tap location %@",NSStringFromCGPoint([tapRecognizer locationInView:_scrollView]));
    if ([self.delegate respondsToSelector:@selector(imageSliderCell:didSelectImageAtIndexpath:)]) 
    {
        CGPoint point = [tapRecognizer locationInView:_scrollView];
        CGFloat w = IMAGE_WIDTH + IMAGE_PADDING;
        int tapindex = (int) (point.x/w);
        if (1)
        {
            [self.delegate imageSliderCell:self didSelectImageAtIndexpath:[NSIndexPath indexPathForRow:tapindex inSection:self.indexPath.section]];
        }

    }
}


//- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    UIView * view = [super hitTest:point withEvent:event];
//    if (view!= nil) return  self;
//    return view;
//}


-(void)dealloc
{
    self.imageURLArray = nil;
    self.indexPath = nil;
    [super dealloc];
}

@end
