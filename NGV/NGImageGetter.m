//
//  NGImageGetter.m
//  NGV
//
//  Created by Yasuhiro Sato on 2013/12/10.
//  Copyright (c) 2013年 Yasuhiro Sato. All rights reserved.
//

#import "NGImageGetter.h"

@implementation NGImageGetter
@synthesize delegate;

- (BOOL)getImage{
    //http://www.yoheim.net/blog.php?q=20120606
    // 送信したいURLを作成する
    NSURL *url = [NSURL URLWithString:@"http://matome.naver.jp/odai/2135478736309706801"];
    // Mutableなインスタンスを作成し、インスタンスの内容を変更できるようにする
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    // MethodにPOSTを指定する。
    request.HTTPMethod = @"POST";
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (!connection) {
        return FALSE;
    }
    return TRUE;
}

- (void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response {
    receivedData = [[NSMutableData alloc] init];
}

// データ受信したら何度も呼び出されるメソッド。
// 受信したデータをreceivedDataに追加する
- (void) connection:(NSURLConnection *) connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSString *html
    = [[NSString alloc] initWithBytes:receivedData.bytes
                               length:receivedData.length
                             encoding:NSUTF8StringEncoding];
    NSLog(@"%@",html);
    // デリゲート先がちゃんと「didFinishedLoad」というメソッドを持っているか?
    if ([self.delegate respondsToSelector:@selector(didFinishedLoad:)]) {
        // sampleMethod1を呼び出す
        [self.delegate didFinishedLoad:html];
        return;
    }
    return;
}

@end
