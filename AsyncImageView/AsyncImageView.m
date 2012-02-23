//
//  AsyncImageView.m
//  AirMedia
//
//  Created by Xingzhi Cheng on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AsyncImageView.h"
#import "FullyLoaded.h"

@interface AsyncImageView ()
- (void) downloadImage:(NSString*)imageURL;
@end

@implementation AsyncImageView
@synthesize request = _request;

- (void) dealloc {
	self.request.delegate = nil;
    [self cancelDownload];
    [super dealloc];
}

- (void) loadImage:(NSString*)imageURL {
    UIImage * image = [[FullyLoaded sharedFullyLoaded] imageForURL:imageURL];
    if (image) 
        self.image = image;
    else
        [self downloadImage:imageURL];
}

- (void) loadImage:(NSString*)imageURL withPlaceholdImage:(UIImage *)image {
    self.image = image;
    [self loadImage:imageURL];
}

- (void) cancelDownload {
    [self.request cancel];
    self.request = nil;
}

#pragma mark - 
#pragma mark private downloads

- (void) downloadImage:(NSString *)imageURL {
    [self cancelDownload];
	NSString * newImageURL = [imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:newImageURL]];
    [self.request setDownloadDestinationPath:[[FullyLoaded sharedFullyLoaded] pathForImageURL:imageURL]];
    [self.request setDelegate:self];
    [self.request startAsynchronous];
//	NSLog(@"download Image %@", imageURL);
}

- (void) requestFinished:(ASIHTTPRequest *)request {
	self.request.delegate = nil;
    self.request = nil;
	
	NSLog(@"async image download done");
    
    NSString * imageURL = [[request.originalURL absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.image = [[FullyLoaded sharedFullyLoaded] imageForURL:imageURL];
}

- (void) requestFailed:(ASIHTTPRequest *)request {
	self.request.delegate = nil;
    self.request = nil;
	
	NSLog(@"async image download failed");
}

@end
