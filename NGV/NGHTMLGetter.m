//
//  NGImageGetter.m
//  NGV
//
//  Created by Yasuhiro Sato on 2013/12/10.
//  Copyright (c) 2013年 Yasuhiro Sato. All rights reserved.
//

#import "NGHTMLGetter.h"
#import "HTMLParser.h"

@implementation NGHTMLGetter
@synthesize delegate;

- (BOOL)getImage:(NSString *)sourceHtmlUrl{
    //http://www.yoheim.net/blog.php?q=20120606
    // 送信したいURLを作成する
    NSURL *url = [NSURL URLWithString:sourceHtmlUrl];
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
    
    NSError *error;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    
    HTMLNode *bodyNode = [parser body];
    
    
    NSArray *nodeImages = [bodyNode findChildTags:@"img"];//imgタグの物を全部とってくる
    NSMutableArray *imageUrls = [NSMutableArray array];
    
    for(HTMLNode *imageNode in nodeImages) {
        NSString *url = [imageNode getAttributeNamed:@"src"];
        [imageUrls addObject:url];
    }
    
    NSLog(@"%@",imageUrls);
    
    // デリゲート先がちゃんと「didFinishedLoad」というメソッドを持っているか?
    if ([self.delegate respondsToSelector:@selector(didFinishedLoad:)]) {
        [self.delegate didFinishedLoad:imageUrls];
        if (error) {
            NSLog(@"Error: %@", error);
            return;
        }
        return;
    }
    return;
}

// 通信失敗
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError : %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    // デリゲート先がちゃんと「didConnectionFailed」というメソッドを持っているか?
    if ([self.delegate respondsToSelector:@selector(didConnectionFailed)]) {
        [self.delegate didConnectionFailed];
        return;
    }
    return;
}

@end


