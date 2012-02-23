//
//  ViewController.h
//  ScrollImageTable
//
//  Created by B.H.Liu appublisher on 12-2-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollImageTable.h"

@interface ViewController : UIViewController<ScrollImageTableDatasource,ScrollImageTableDelegate>

@property (nonatomic,retain) NSArray *jsonArray;

@end
