//
//  ViewController.m
//  ScrollImageTable
//
//  Created by B.H.Liu appublisher on 12-2-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "SBJson.h"

@implementation ViewController

@synthesize jsonArray=_jsonArray;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    ScrollImageTable *imageTable = [[ScrollImageTable alloc]initWithFrame:self.view.frame];
    imageTable.imageTableDatasource = self;
    imageTable.imageTableDelegate = self;
    
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    self.jsonArray = [parser objectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"test" ofType:@"json"]]];
        
    [self.view addSubview:imageTable];
}

#pragma mark-
#pragma mark- ScrollImageTable Datasource

- (NSInteger)numberofSectionsInScrollImageTableView:(ScrollImageTable*)tableView
{
    return [self.jsonArray count];
}

- (NSArray*)scrollImageTable:(ScrollImageTable*)tableView photoURLAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self.jsonArray objectAtIndex:indexPath.section] objectForKey:@"images"];
}

- (NSString*)scrollImageTable:(ScrollImageTable*)tableView TitleAtSection:(NSInteger)section
{
    return [[self.jsonArray objectAtIndex:section] objectForKey:@"title"];
}

- (NSString*)scrollImageTable:(ScrollImageTable*)tableView SummaryAtSection:(NSInteger)section
{
    return [[self.jsonArray objectAtIndex:section] objectForKey:@"description"];
}

#pragma mark-
#pragma mark- ScrollImageTable Delegate

- (void)scrollImageTable:(ScrollImageTable*)tableView didSelectPhotoAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"tap on %d",indexPath.row);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
