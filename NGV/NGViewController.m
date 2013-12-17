//
//  NGViewController.m
//  NGV
//
//  Created by Yasuhiro Sato on 2013/12/10.
//  Copyright (c) 2013年 Yasuhiro Sato. All rights reserved.
//

#import "NGViewController.h"

@implementation NGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //html 取得
    NSLog(@"test");
    NGImageGetter *imageGetter = [NGImageGetter alloc];
    // NGImageGetter の Delegate で指定されていた処理は
    // 私（NGVieｗController）がやりますよーという宣言
    imageGetter.delegate = self;
    [imageGetter getImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didFinishedLoad:(NSString *)html
{
    // labelのテキストを変更する
    label.text = html;
}

@end
