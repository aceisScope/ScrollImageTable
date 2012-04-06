//
//  ScrollImageTable.h
//  ScrollImageTable
//
//  Created by B.H.Liu appublisher on 12-2-22.
//  Copyright (c) 2012年 Appublisher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageSliderCell.h"

#define ROWHEIGHT 100
#define HEADERHEIGHT 30
#define FONT_SIZE 20

@class ScrollImageTable;

@protocol ScrollImageTableDatasource <NSObject>
@required
- (NSInteger)numberofSectionsInScrollImageTableView:(ScrollImageTable*)tableView;
- (NSArray*)scrollImageTable:(ScrollImageTable*)tableView photoURLAtIndexPath:(NSIndexPath *)indexPath;
- (NSString*)scrollImageTable:(ScrollImageTable*)tableView TitleAtSection:(NSInteger)section;
- (NSString*)scrollImageTable:(ScrollImageTable*)tableView SummaryAtSection:(NSInteger)section;
@end

@protocol ScrollImageTableDelegate <NSObject>
@optional
////require cell view to return the image clicked
- (void)scrollImageTable:(ScrollImageTable*)tableView didSelectPhotoAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface ScrollImageTable : UITableView<UITableViewDelegate, UITableViewDataSource,ImageSliderCellDelegate>


@property (nonatomic,assign) id<ScrollImageTableDatasource>imageTableDatasource;
@property (nonatomic,assign) id<ScrollImageTableDelegate>imageTableDelegate;

//- (UIView*) imageViewForPhotoAtIndex:(NSIndexPath*)indexPath;

@end
