//
//  UIAsyncImageView.m
//  AsarenSample
//
//  Created by 北村　良明 on 2014/01/14.
//  Copyright (c) 2014年 Yoshiaki Kitamura. All rights reserved.
//

#import "UIAsyncImageView.h"

@implementation UIAsyncImageView
@synthesize delegate;

-(void)loadImage:(NSString *)url forceReload:(BOOL)boolean
{
    if (boolean) {
        self.url = nil;
    }
    [self loadImage:url];
}

-(void)loadImage:(NSString *)url{
    if ([self.url isEqualToString:url]) {
        //すでに url 取り込んでいる場合は再読み込みしない
        return;
    }
    self.url = url;
    [self abort];
    self.image = nil;
    self.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.2];
    data = [[NSMutableData alloc] initWithCapacity:0];
    
    NSURLRequest *req = [NSURLRequest
                         requestWithURL:[NSURL URLWithString:url]
                         cachePolicy:NSURLRequestUseProtocolCachePolicy
                         timeoutInterval:30.0];
    conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)nsdata{
    [data appendData:nsdata];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self abort];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    self.image = [UIImage imageWithData:data];
    if (self.image != nil) {
        if ([self.delegate respondsToSelector:@selector(UIAsyncImageViewDelegateDidFinishedLoad: url:)]) {
            [self.delegate UIAsyncImageViewDelegateDidFinishedLoad:self.image url:self.url];
            return;
        }
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    } else {
        self.url = nil;
    }
    [self abort];
}

-(void)abort{
    if(conn != nil){
        [conn cancel];
        //[conn release];
        conn = nil;
    }
    if(data != nil){
        //[data release];
        data = nil;
    }
}

- (void)dealloc {
    [conn cancel];
    //[conn release];
    //[data release];
    //[super dealloc];
}
@end
