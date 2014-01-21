//
//  NGViewController.m
//  NGV
//
//  Created by Yasuhiro Sato on 2013/12/10.
//  Copyright (c) 2013年 Yasuhiro Sato. All rights reserved.
//

#import "NGViewController.h"
#import "UIAsyncImageView.h"

@implementation NGViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        imageUrlArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //html 取得
    NSLog(@"test");
    NGHTMLGetter *htmlListGetter = [NGHTMLGetter alloc];
    // NGImageGetter の Delegate で指定されていた処理は
    // 私（NGVieｗController）がやりますよーという宣言
    htmlListGetter.delegate = self;
    [htmlListGetter getImage];
    
    [image_collection_view setDataSource:self];
    [image_collection_view setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didFinishedLoad:(NSArray *)images
{
    imageUrlArray = [images mutableCopy];
    [image_collection_view reloadData];
    
    /*
    // labelのテキストを変更する
    int height = 0;
    //label.text = [images objectAtIndex:0];
    for(NSString *imageURL in images) {
        UIAsyncImageView *imageView = [[UIAsyncImageView alloc] init];
        [imageView loadImage:imageURL];
        CGRect rect = CGRectMake(0, height, self.view.frame.size.width, self.view.frame.size.height);
        //height += self.view.frame.size.height;
        height += 20;
        imageView.frame = rect;
        //[image_scroll_view addSubview:imageView];
    }*/
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
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell;
    
    if(indexPath.section==0){//セクション0のセル
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell1" forIndexPath:indexPath];
        //cell.backgroundColor = [UIColor greenColor];
        
        UIAsyncImageView *imageView = (UIAsyncImageView *)[cell viewWithTag:1];
        [imageView loadImage:[imageUrlArray objectAtIndex:indexPath.row]];
        //CGRect rect = CGRectMake(0, height, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //クリックされたらよばれる
    NSLog(@"Clicked %d-%d",indexPath.section,indexPath.row);
}

@end
