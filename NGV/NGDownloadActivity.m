//
//  NGDownloadActivity.m
//  NGV
//
//  Created by Yasuhiro Sato on 2014/04/30.
//  Copyright (c) 2014年 Yasuhiro Sato. All rights reserved.
//

#import "NGDownloadActivity.h"

@implementation NGDownloadActivity

@synthesize base;

- (NSString *)activityType {
    return @"NGDownload";
}

- (NSString *)activityTitle {
    return @"チェックした画像をダウンロード";
}

- (UIImage *)activityImage {
    return [UIImage imageNamed:@"OK.png"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems{
    return YES;
    
}

- (void)prepareWithActivityItems:(NSArray *)activityItems;{
    NSLog(@"prepare!!");
    
    [super prepareWithActivityItems:activityItems];
    
}

- (UIViewController *)activityViewController{
    return nil;
}

- (void)performActivity{
    
    NSLog(@"perform!!");
    
    [base downloadImages];
    
    [self activityDidFinish:YES];
}

- (void)activityDidFinish:(BOOL)completed{
    NSLog(@"finished!!");
    
    [super activityDidFinish:completed];
}
@end
