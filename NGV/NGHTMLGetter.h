//
//  NGImageGetter.h
//  NGV
//
//  Created by Yasuhiro Sato on 2013/12/10.
//  Copyright (c) 2013年 Yasuhiro Sato. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NGHTMLGetterDelegate<NSObject>
-(void)NGHTMLGetterDelegateDidFinishedLoad:(NSArray*)images;
-(void)NGHTMLGetterDelegateDidConnectionFailed;
@end

@interface NGHTMLGetter : NSObject{
    NSMutableData *receivedData;
    
}
- (BOOL)getImage:(NSString *)sourceHtmlUrl;
@property (nonatomic, assign) id<NGHTMLGetterDelegate> delegate;
@end