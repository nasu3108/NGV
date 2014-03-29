//
//  UIAsyncImageView.h
//  AsarenSample
//
//  Created by 北村　良明 on 2014/01/14.
//  Copyright (c) 2014年 Yoshiaki Kitamura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIAsyncImageView.h"

@protocol UIAsyncImageViewDelegate<NSObject>
-(void)UIAsyncImageViewDelegateDidFinishedLoad:(UIImage *)image url:(NSString *)url;
@end

@interface UIAsyncImageView : UIImageView
{
    @private
    NSURLConnection *conn;
    NSMutableData *data;
}

- (void)loadImage:(NSString *)url forceReload:(BOOL)boolean;
- (void)loadImage:(NSString *)url;
- (void)abort;

@property NSString *url;

// weak にしておけばdelegate元がdeallocされてもBAD_ACCESSにならない。
// 一応ならないのだが、もっといい改善方法があれば検討
@property (nonatomic, weak) id<UIAsyncImageViewDelegate> delegate;
@end
