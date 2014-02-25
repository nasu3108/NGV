//
//  NGOdaimokuTableViewController.m
//  NGV
//
//  Created by Yasuhiro Sato on 2014/01/28.
//  Copyright (c) 2014年 Yasuhiro Sato. All rights reserved.
//

#import "NGOdaimokuTableViewController.h"
#import "NGViewController.h"


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
    
    // 引っ張って更新のあれ
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl = refreshControl;
    
    [refreshControl addTarget:self action:@selector(refreshOccured:) forControlEvents:UIControlEventValueChanged];
    
    // topic 取得
    [self getTopic];
}

- (void)getTopic
{
    NGTopicListGetter *topicGetter = [NGTopicListGetter alloc];
    // NGTopicListGetter の Delegate で指定されていた処理は
    // 私（NGOdaimokuTableViewController）がやりますよーという宣言
    topicGetter.delegate = self;
    [topicGetter getTopic];
}

- (void)refreshOccured:(id)sender {
    // 引っ張って更新のあれ が引っ張られたら呼び出される。
    [self getTopic];
}



-(void)didFinishedLoad:(NSArray *)links
{
    odaimokuUrlArray = [links mutableCopy];
    [odaimoku_table_view reloadData];
    // 更新が完了したら 引っ張って更新のあれ 止めてあげる
    [self.refreshControl endRefreshing];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [odaimokuUrlArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if(indexPath.section==0){//セクション0のセル
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        UILabel *label = (UILabel *)[cell viewWithTag:1];
        
        label.text = [[odaimokuUrlArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 次画面を指定して遷移
    NGViewController  *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"NGViewController1"];
    
    if(controller) {
        NSLog(@"%@",[[odaimokuUrlArray objectAtIndex:indexPath.row] objectForKey:@"link"]);
        [controller setSourceHtmlUrl:[[odaimokuUrlArray objectAtIndex:indexPath.row] objectForKey:@"link"]];
        [controller getImage];
        [self.navigationController pushViewController:controller animated:YES];
    }
}


@end
