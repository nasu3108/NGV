//
//  NGOdaimokuTableViewController.m
//  NGV
//
//  Created by Yasuhiro Sato on 2014/01/28.
//  Copyright (c) 2014年 Yasuhiro Sato. All rights reserved.
//

#import "NGOdaimokuTableViewController.h"
#import "NGMainViewController.h"

@implementation NGOdaimokuTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 引っ張って更新のあれ
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [odaimoku_table_view addSubview:refreshControl];
    
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

-(void)NGTopicListGetterDelegateDidFinishedLoad:(NSArray *)links
{
    odaimokuUrlArray = [links mutableCopy];
    [odaimoku_table_view reloadData];
    // 更新が完了したら 引っ張って更新のあれ 止めてあげる
    [self stopRefreshControl];
}

- (void)stopRefreshControl
{
    NSArray *subviewArray = [odaimoku_table_view subviews];
    for (long i = [subviewArray count] - 1; i >= 0; i--) {
        if([[subviewArray objectAtIndex:i] isMemberOfClass:[UIRefreshControl class]]){
            [[subviewArray objectAtIndex:i] endRefreshing];
            return;
        }
    }
}

-(void)NGTopicListGetterDelegateDidConnectionFailed
{
    // アラートダイアログ表示
    [[[UIAlertView alloc]
      initWithTitle:@"接続失敗"
      message:@"接続に失敗しました"
      delegate:nil
      cancelButtonTitle:nil
      otherButtonTitles:@"OK", nil
      ] show];
    // 接続に失敗した場合も 引っ張って更新のあれ 止めてあげる
    [self stopRefreshControl];
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
    NGMainViewController  *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"NGMainViewController1"];
    
    if(controller) {
        [controller variableInit];
        [controller setSourceHtmlUrl:[[odaimokuUrlArray objectAtIndex:indexPath.row] objectForKey:@"link"]];
        NSString *str = [[odaimokuUrlArray objectAtIndex:indexPath.row] objectForKey:@"title"];
        [controller setSourceHtmlTitle:str];
        [controller getImage];
        [self.navigationController pushViewController:controller animated:YES];
    }
}


@end
