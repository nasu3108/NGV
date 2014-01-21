//
//  UIAsyncImageView.m
//  AsarenSample
//
//  Created by 北村　良明 on 2014/01/14.
//  Copyright (c) 2014年 Yoshiaki Kitamura. All rights reserved.
//

#import "UIAsyncImageView.h"

@implementation UIAsyncImageView

-(void)loadImage:(NSString *)url{
    [self abort];
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
    self.contentMode = UIViewContentModeScaleAspectFit;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
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
