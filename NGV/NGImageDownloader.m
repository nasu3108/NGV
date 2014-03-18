//
//  NGImageDownloader.m
//  NGV
//
//  Created by Yasuhiro Sato on 2014/03/18.
//  Copyright (c) 2014年 Yasuhiro Sato. All rights reserved.
//

#import "NGImageDownloader.h"
#import "UIAsyncImageView.h"

@implementation NGImageDownloader
@synthesize delegate;

- (id)initWithAsyncImageArray:(NSMutableArray *)imageUrlArray
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in imageUrlArray) {
        if ([[dic objectForKey:@"check"] isEqualToNumber:@YES]) {
            [array addObject:[dic objectForKey:@"contents"]];
        }
    }
    imageUrlEnumerator = [array objectEnumerator];
    return self;
}

- (void)imageDownload{
    if (![self imageDownloadWithArray]) {
        UIAlertView *alert
        = [[UIAlertView alloc] initWithTitle:nil
                                     message:@"選択されていません" delegate:nil
                           cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

- (BOOL)imageDownloadWithArray{
    NSString *imageUrl = (NSString *)[imageUrlEnumerator nextObject];
    
    if(imageUrl != nil){
        NSURL *url = [NSURL URLWithString:imageUrl];
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
        NSURLResponse *resp;
        NSError *err;
        NSData *result = [NSURLConnection sendSynchronousRequest:req
                                               returningResponse:&resp
                                                           error:&err];
        
        UIImage *image = [[UIImage alloc] initWithData:result];
        
        if (image == nil) {
            //リンク切れ画像があった場合、次の画像に行ってしまおう
            return [self imageDownloadWithArray];
        }
        
        // フォトアルバムに保存する
        UIImageWriteToSavedPhotosAlbum(
                                       image, self,
                                       @selector(savingImageIsFinished:didFinishSavingWithError:contextInfo:), nil);
        return YES;
    }else{
        return NO;
    }
}

// 保存が完了したら呼ばれるメソッド
-(void)savingImageIsFinished:(UIImage*)image
    didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    
    if (error) {
        
        if ([self.delegate respondsToSelector:@selector(NGImageDownloaderDelegateDidConnectionFailed:)]) {
            [self.delegate NGImageDownloaderDelegateDidConnectionFailed:error];
            return;
        }
        /*
        UIAlertView *alert
        = [[UIAlertView alloc] initWithTitle:nil
                                     message:@"保存に失敗しました" delegate:nil
                           cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];*/
        return;
    }
    if (![self imageDownloadWithArray]) {
        // url が nil になったら、ダウンロードが終わったということになるので、Alertを表示する
        
        if ([self.delegate respondsToSelector:@selector(NGImageDownloaderDelegateDidFinishedLoad)]) {
            [self.delegate NGImageDownloaderDelegateDidFinishedLoad];
            return;
        }
        /*
        UIAlertView *alert
        = [[UIAlertView alloc] initWithTitle:nil
                                     message:@"保存しました" delegate:nil
                           cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];*/
    }
}

@end
