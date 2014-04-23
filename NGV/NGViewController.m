//
//  NGViewController.m
//  NGV
//
//  Created by Yasuhiro Sato on 2013/12/10.
//  Copyright (c) 2013年 Yasuhiro Sato. All rights reserved.
//

#import "NGViewController.h"
#import "UIAsyncImageView.h"
#import "NGImageDownloader.h"
#import "SVProgressHUD.h"

@implementation NGViewController

- (void)variableInit
{
    base = [NGViewControllerBase alloc];
    [base variableInit];    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 引っ張って更新のあれ
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    
    [base setImage_collection_view:image_collection_view];
    
    [refreshControl addTarget:base action:@selector(refreshOccured:) forControlEvents:UIControlEventValueChanged];
    [image_collection_view addSubview:refreshControl];
    
    [image_collection_view setDataSource:base];
    [image_collection_view setDelegate:base];
    
}

- (void)setSourceHtmlUrl:(NSString *)url
{
    [base setSourceHtmlUrl:url];
}

- (void)getImage
{
    [base getImage];
}

- (IBAction)downloadImages:(id)sender
{
    [base downloadImages:sender];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [base viewWillDisappear];
}

@end
