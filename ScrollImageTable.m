//
//  ScrollImageTable.m
//  ScrollImageTable
//
//  Created by B.H.Liu appublisher on 12-2-22.
//  Copyright (c) 2012年 Appublisher. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ScrollImageTable.h"
#import "NSAttributedString+Attributes.h"
#import "OHAttributedLabel.h"


@implementation ScrollImageTable

@synthesize imageTableDelegate = _imageTableDelegate;
@synthesize imageTableDatasource = _imageTableDatasource;

- (id) initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self != nil) {
        [super setDataSource:self];
        [super setDelegate:self];
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.delaysContentTouches = NO;
    }
    return self;
}

- (void)dealloc
{
    self.imageTableDelegate = nil;
    self.imageTableDatasource = nil;
    [super dealloc];
}

#pragma mark-
#pragma mark- UITableView DataSource/Users/Appublisher/Desktop/imagetable.png
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return [self.imageTableDatasource numberofSectionsInScrollImageTableView:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    ImageSliderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[ImageSliderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.delegate = self;
    }
    cell.indexPath = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *photoUrls = [self.imageTableDatasource scrollImageTable:self photoURLAtIndexPath:indexPath];
    [cell setImageURLArray:photoUrls];
    
    return cell;
}

#pragma mark-
#pragma mark- UITableView Delegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROWHEIGHT;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    OHAttributedLabel *label = [[[OHAttributedLabel alloc] initWithFrame:CGRectMake(0, 2.5, self.frame.size.width,HEADERHEIGHT - 5)]autorelease];
    label.userInteractionEnabled = NO;
    label.backgroundColor = [UIColor colorWithRed:220.0/256 green:220.0/256 blue:220.0/256 alpha:.9];
    label.layer.borderColor = [UIColor colorWithRed:248.0/256 green:248.0/256 blue:255.0/256 alpha:.9].CGColor;
    label.layer.borderWidth = 2;
    
    label.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    label.layer.shadowOpacity = .6f;
    label.layer.masksToBounds = NO;
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.frame.size.width, HEADERHEIGHT+5)];
    label.layer.shadowPath = path.CGPath;
    
    NSMutableAttributedString *title = [NSMutableAttributedString attributedStringWithString:@"标题标题标题标题  "];
    NSMutableAttributedString *description = [NSMutableAttributedString attributedStringWithString:@"描述描述描述描述"];
    
    [title setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    [description setFont:[UIFont systemFontOfSize:FONT_SIZE - 5]];
    
    NSMutableAttributedString *content = [NSMutableAttributedString attributedStringWithAttributedString:title];
    [content appendAttributedString:description];
    label.attributedText = content;

    label.centerVertically = YES;
    
    return label;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section 
{
    return HEADERHEIGHT;
}

#pragma mark-
#pragma mark- ImageSliderCell Delegate
- (void)imageSliderCell:(ImageSliderCell *)cell didSelectImageAtIndexpath:(NSIndexPath *)indexpath
{
    NSLog(@"tap at index (%d,%d)",indexpath.section,indexpath.row);
}


@end
