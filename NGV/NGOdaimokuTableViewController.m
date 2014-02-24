//
//  NGOdaimokuTableViewController.m
//  NGV
//
//  Created by Yasuhiro Sato on 2014/01/28.
//  Copyright (c) 2014年 Yasuhiro Sato. All rights reserved.
//

#import "NGOdaimokuTableViewController.h"


@implementation NGOdaimokuTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        odaimokuUrlArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //html 取得
    NSLog(@"test");
    NGTopicListGetter *topicGetter = [NGTopicListGetter alloc];
    // NGTopicListGetter の Delegate で指定されていた処理は
    // 私（NGOdaimokuTableViewController）がやりますよーという宣言
    topicGetter.delegate = self;
    [topicGetter getTopic];
    
    //[image_collection_view setDataSource:self];
    //[image_collection_view setDelegate:self];
}

-(void)didFinishedLoad:(NSArray *)images
{
    odaimokuUrlArray = [images mutableCopy];
    [odaimoku_table_view reloadData];
}


@end
