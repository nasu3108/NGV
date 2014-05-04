//
//  NGViewController.m
//  NGV
//
//  Created by Yasuhiro Sato on 2013/12/10.
//  Copyright (c) 2013年 Yasuhiro Sato. All rights reserved.
//

#import "NGMainViewController.h"
#import "UIAsyncImageView.h"
#import "NGImageDownloader.h"
#import "SVProgressHUD.h"

@implementation NGMainViewController

- (void)setNadViews
{
    NSDictionary *nendId = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"a6eca9dd074372c898dd1df549301f277c53f2b9", @"nendID",
                            @"3172", @"spotID",nil];
    [self addNADViewTo:nand_view rect:CGRectMake( 0, 0, 320, 50) nendID:nendId];
}

- (void)variableInit
{
    base = [NGMainViewControllerBase alloc];
    [base setUi_view_controller:self];
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

- (void)setSourceHtmlTitle:(NSString *)title
{
    [base setSourceHtmlTitle:title];
}

- (void)getImage
{
    [base getImage];
}

- (IBAction)downloadImages:(id)sender
{
    [base showMenu:sender];
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
