//
//  NGOdaimokuTableViewControllerIpad.m
//  NGV
//
//  Created by Yasuhiro Sato on 2014/03/22.
//  Copyright (c) 2014年 Yasuhiro Sato. All rights reserved.
//

#import "NGOdaimokuTableViewControllerIpad.h"

@implementation NGOdaimokuTableViewControllerIpad

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ngViewControllerBase = [NGViewControllerBase alloc];
    [ngViewControllerBase variableInit];
    
    [odaimoku_table_view setDataSource:self];
    [odaimoku_table_view setDelegate:self];
    
    // 引っ張って更新のあれ
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    
    [ngViewControllerBase setImage_collection_view:image_collection_view];
    
    [refreshControl addTarget:ngViewControllerBase action:@selector(refreshOccured:) forControlEvents:UIControlEventValueChanged];
    [image_collection_view addSubview:refreshControl];
    
    [image_collection_view setDataSource:ngViewControllerBase];
    [image_collection_view setDelegate:ngViewControllerBase];
}

- (void)setSourceHtmlUrl:(NSString *)url
{
    [ngViewControllerBase setSourceHtmlUrl:url];
}

- (void)getImage
{
    [ngViewControllerBase getImage];
}

- (IBAction)downloadImages:(id)sender
{
    [ngViewControllerBase downloadImages:sender];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [ngViewControllerBase variableInit];
    [ngViewControllerBase setSourceHtmlUrl:[[odaimokuUrlArray objectAtIndex:indexPath.row] objectForKey:@"link"]];
    [ngViewControllerBase getImage];
}

@end
