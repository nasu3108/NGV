//
//  NGViewController.m
//  NGV
//
//  Created by Yasuhiro Sato on 2014/05/03.
//  Copyright (c) 2014年 Yasuhiro Sato. All rights reserved.
//

#import "NGViewController.h"

@implementation NGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    nadViews = [NSMutableArray array];
    [self setNadViews];
}

- (void)setNadViews
{
    return;
}

- (void)addNADViewTo:(UIView *)view rect:(CGRect)rect nendID:(NSDictionary *)nendID
{
    // (3) ログ出力の指定
    NADView *nadView = [[NADView alloc] initWithFrame:rect];
    
    [nadView setIsOutputLog:NO];
    // (4) set apiKey, spotId.
    // 検証用
    //[nadView setNendID:@"a6eca9dd074372c898dd1df549301f277c53f2b9" spotID:@"3172"];
    // 本番用
    [nadView setNendID:[nendID objectForKey:@"nendID"] spotID:[nendID objectForKey:@"spotID"]];
    [nadView load]; //(6)
    [view addSubview:nadView];
    [nadViews addObject:nadView];
}

- (void)viewDidAppear:(BOOL)animated
{
    for (NADView *nadView in nadViews) {
        [nadView setFrame:[self getNADViewFrameTo:[nadView superview] nadView:nadView]];
    }
}

- (CGRect)getNADViewFrameTo:(UIView *)parent nadView:(NADView *)nadView
{
    CGRect nadViewRect = nadView.bounds;
    return CGRectMake( (CGRectGetWidth(parent.bounds) - CGRectGetWidth(nadView.bounds))/2.0f, 0,
                      CGRectGetWidth(nadViewRect), CGRectGetHeight(nadViewRect));
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    for (NADView *nadView in nadViews) {
        [nadView setFrame:[self getNADViewFrameTo:[nadView superview] nadView:nadView]];
    }
}

- (void) dealloc {
    for (NADView *nadView in nadViews) {
        [nadView setDelegate:nil];
    }
    [nadViews removeAllObjects];
}

@end
