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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        imageUrlArray = [NSMutableArray array];
        sourceHtmlUrl = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 引っ張って更新のあれ
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    
    [refreshControl addTarget:self action:@selector(refreshOccured:) forControlEvents:UIControlEventValueChanged];
    [image_collection_view addSubview:refreshControl];
    
    [image_collection_view setDataSource:self];
    [image_collection_view setDelegate:self];
}

- (void)setSourceHtmlUrl:(NSString *)url
{
    sourceHtmlUrl = url;
}

- (void)getImage
{
    if (sourceHtmlUrl == nil) {
        // sourceHTmlUrl が空だったらなにもしない
        return;
    }
    // html 取得
    NGHTMLGetter *htmlListGetter = [NGHTMLGetter alloc];
    
    // NGImageGetter の Delegate で指定されていた処理は
    // 私（NGVieｗController）がやりますよーという宣言
    htmlListGetter.delegate = self;
    
    [htmlListGetter getImage:sourceHtmlUrl];
}

- (void)refreshOccured:(id)sender {
    // 引っ張って更新のあれ が引っ張られたら呼び出される。
    [self getImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)NGHTMLGetterDelegateDidFinishedLoad:(NSArray *)images
{
    //imageUrlArray = [images mutableCopy];
    [self copyImageUrlArray:images];
    [image_collection_view reloadData];
    
    // 更新が完了したら 引っ張って更新のあれ 止めてあげる
    [self stopRefreshControl];
}

- (void)copyImageUrlArray:(NSArray *)images
{
    imageUrlArray =[NSMutableArray array];
    for (int i = 0; i < [images count]; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:@YES forKey:@"check"];
        [dic setObject:[images objectAtIndex:i] forKey:@"contents"];
        [imageUrlArray addObject:dic];
    }
}

-(void)NGHTMLGetterDelegateDidConnectionFailed
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

- (void)stopRefreshControl
{
    NSArray *subviewArray = [image_collection_view subviews];
    for (int i = [subviewArray count] - 1; i >= 0; i--) {
        if([[subviewArray objectAtIndex:i] isMemberOfClass:[UIRefreshControl class]]){
            [[subviewArray objectAtIndex:i] endRefreshing];
            return;
        }
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(section==0){
        return [imageUrlArray count];
        //return 5;
    } else {
        return 0;
    }
}

//Method to create cell at index path
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell;
    
    if(indexPath.section==0){//セクション0のセル
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell1" forIndexPath:indexPath];
        //cell.backgroundColor = [UIColor greenColor];
        
        UIAsyncImageView *imageView = (UIAsyncImageView *)[cell viewWithTag:1];
        [self setCheck:cell cellForItemAtIndexPath:indexPath];
        [imageView loadImage:[[imageUrlArray objectAtIndex:indexPath.row] objectForKey:@"contents"]];
        //CGRect rect = CGRectMake(0, height, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    return cell;
}

- (void)setCheck:(UICollectionViewCell *)cell cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIImageView *check = (UIImageView *)[cell viewWithTag:2];
    check.hidden = [[[imageUrlArray objectAtIndex:indexPath.row] objectForKey:@"check"] isEqualToNumber:@NO];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    
    if(indexPath.section==0){//セクション0のセル
        //クリックされたらよばれる
        NSLog(@"Clicked %d-%d",indexPath.section,indexPath.row);
        NSMutableDictionary *dic = [imageUrlArray objectAtIndex:indexPath.row];
        NSNumber *check = [NSNumber numberWithBool:[[dic objectForKey:@"check"] isEqualToNumber:@NO]];
        [dic setObject:check forKey:@"check"];
        [imageUrlArray replaceObjectAtIndex:indexPath.row withObject:dic];
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell1" forIndexPath:indexPath];
        
        [self setCheck:cell cellForItemAtIndexPath:indexPath];

        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
}

- (IBAction)downloadImages:(id)sender{
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    NGImageDownloader *loader = [NGImageDownloader alloc ];
    loader.delegate = self;
    [[loader initWithAsyncImageArray:imageUrlArray] imageDownload];
}

-(void)NGImageDownloaderDelegateDidFinishedLoad{
    //[SVProgressHUD dismiss];
    [SVProgressHUD showSuccessWithStatus:@"保存完了！"];
}

-(void)NGImageDownloaderDelegateDidConnectionFailed:(NSError*)error{
    //[SVProgressHUD dismiss];
    [SVProgressHUD showSuccessWithStatus:@"保存失敗..."];
}

@end
