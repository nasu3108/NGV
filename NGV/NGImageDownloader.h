//
//  NGImageDownloader.h
//  NGV
//
//  Created by Yasuhiro Sato on 2014/03/18.
//  Copyright (c) 2014年 Yasuhiro Sato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIAsyncImageView.h"

@protocol NGImageDownloaderDelegate<NSObject>
-(void)NGImageDownloaderDelegateDidFinishedLoad;
-(void)NGImageDownloaderDelegateDidConnectionFailed:(NSError*)error;
@end

@interface NGImageDownloader: NSObject{
    NSEnumerator *imageUrlEnumerator;
}
- (id)initWithAsyncImageArray:(NSMutableArray *)imageUrlArray;
- (void)imageDownload;
@property (nonatomic, assign) id<NGImageDownloaderDelegate> delegate;
@end
