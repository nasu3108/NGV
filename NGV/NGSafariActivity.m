//
//  NGSafariActivity.m
//  NGV
//
//  Created by Yasuhiro Sato on 2014/05/01.
//  Copyright (c) 2014年 Yasuhiro Sato. All rights reserved.
//

#import "NGSafariActivity.h"

@implementation NGSafariActivity

@synthesize urlString;

- (NSString *)activityType {
    return @"NGSafari";
}

- (NSString *)activityTitle {
    return @"Safari で開く";
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
    
    NSURL *url = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:url];
    
    [self activityDidFinish:YES];
}

- (void)activityDidFinish:(BOOL)completed{
    NSLog(@"finished!!");
    
    [super activityDidFinish:completed];
}
@end