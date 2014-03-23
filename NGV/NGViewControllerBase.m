//
//  NGViwControllerBase.m
//  NGV
//
//  Created by Yasuhiro Sato on 2014/03/22.
//  Copyright (c) 2014年 Yasuhiro Sato. All rights reserved.
//

#import "NGViewControllerBase.h"
#import "UIAsyncImageView.h"
#import "NGImageDownloader.h"
#import "SVProgressHUD.h"

@implementation NGViewControllerBase
@synthesize image_collection_view;

- (void)variableInit
{
    imageUrlArray = [NSMutableArray array];
    sourceHtmlUrl = nil;
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
    imageArray = [NSMutableArray array];
    for (int i = 0; i < [images count]; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:@YES forKey:@"check"];
        [dic setObject:[images objectAtIndex:i] forKey:@"contents"];
        [imageUrlArray addObject:dic];
        [imageArray addObject:[NSNull null]];
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
    for (long i = [subviewArray count] - 1; i >= 0; i--) {
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
        if ([[imageArray objectAtIndex:indexPath.row] isKindOfClass:[UIImage class]]) {
            imageView.image = [imageArray objectAtIndex:indexPath.row];
        } else {
            [imageView setDelegate:self];
            [imageView loadImage:[[imageUrlArray objectAtIndex:indexPath.row] objectForKey:@"contents"] forceReload:TRUE];
        }
    }
    
    return cell;
}

-(void)UIAsyncImageViewDelegateDidFinishedLoad:(UIImage *)image url:(NSString *)url
{
    NSInteger index = -1;
    NSInteger i = 0;
    for (NSDictionary *dic in imageUrlArray) {
        if(![[dic objectForKey:@"contents"] isEqual:url]){
            i++;
        }else{
            index = i;
            break;
        }
    }
    if (index >= 0) {
        [imageArray replaceObjectAtIndex:index withObject:image];
    }
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

-(void)NGImageDownloaderDelegateNotSelectImage{
    [SVProgressHUD dismiss];
    UIAlertView *alert
    = [[UIAlertView alloc] initWithTitle:nil
                                 message:@"選択されていません" delegate:nil
                       cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}

@end
