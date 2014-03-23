//
//  NGTopicListGetter.m
//  NGV
//
//  Created by Yasuhiro Sato on 2014/01/28.
//  Copyright (c) 2014年 Yasuhiro Sato. All rights reserved.
//

#import "NGTopicListGetter.h"
#import "HTMLParser.h"

@implementation NGTopicListGetter
@synthesize delegate;

- (BOOL)getTopic{
    //http://www.yoheim.net/blog.php?q=20120606
    // 送信したいURLを作成する
    NSURL *url = [NSURL URLWithString:@"http://matome.naver.jp/feed/topic/1HinO"];
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
    odaimokuArray = [NSMutableArray array];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:receivedData];
    [xmlParser setDelegate: self];
    [xmlParser setShouldResolveExternalEntities:YES];
    [xmlParser parse];
    
    [self deleteReturnInOdaimokuArray];
    
    // デリゲート先がちゃんと「didFinishedLoad」というメソッドを持っているか?
    if ([self.delegate respondsToSelector:@selector(NGTopicListGetterDelegateDidFinishedLoad:)]) {
        [self.delegate NGTopicListGetterDelegateDidFinishedLoad:odaimokuArray];
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
    if ([self.delegate respondsToSelector:@selector(NGTopicListGetterDelegateDidConnectionFailed)]) {
        [self.delegate NGTopicListGetterDelegateDidConnectionFailed];
        return;
    }
    return;
}

-(void)deleteReturnInOdaimokuArray
{
    NSMutableArray *newOdaimokuArray = [NSMutableArray array];
    for (int i = 0; i < [odaimokuArray count] ; i++) {
        NSMutableDictionary *dic = [odaimokuArray objectAtIndex:i];
        NSString *link = [[dic objectForKey:@"link"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *title = [[dic objectForKey:@"title"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [dic setObject:link forKey:@"link"];
        [dic setObject:title forKey:@"title"];
        [newOdaimokuArray addObject:dic];
    }
    odaimokuArray = newOdaimokuArray;
}


-(void) parser:(NSXMLParser *) parser
didStartElement:(NSString *) elementName
namespaceURI:(NSString *) namespaceURI
qualifiedName:(NSString *) qName
attributes:(NSDictionary *) attributeDict
{
    //パーサーが開始タグ「title」「link」を見つけたらフラグをたてる
    if([elementName isEqualToString:@"title"]){
        if(elementkey!=1){
            elementkey = 1;
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:[NSMutableString stringWithString:@""] forKey:@"title"];
            [dic setObject:[NSMutableString stringWithString:@""] forKey:@"link"];
            [odaimokuArray addObject:dic];
        }
    }else if([elementName isEqualToString:@"link"]){
        elementkey = 2;
    }else{
        elementkey = 0;
    }
}

-(void)parser:(NSXMLParser *) parser foundCharacters:(NSString *)string
{
    if (elementkey == 1) {
        NSMutableDictionary *dic = [odaimokuArray lastObject];
        NSMutableString *str = [dic objectForKey:@"title"];
        [str appendString:string];
        [dic setObject:str forKey:@"title"];
    }
    if (elementkey == 2) {
        NSMutableDictionary *dic = [odaimokuArray lastObject];
        NSMutableString *str = [dic objectForKey:@"link"];
        [str appendString:string];
        [dic setObject:str forKey:@"link"];
    }
}

@end


