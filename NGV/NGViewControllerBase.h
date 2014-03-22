//
//  NGViwControllerBase.h
//  NGV
//
//  Created by Yasuhiro Sato on 2014/03/22.
//  Copyright (c) 2014年 Yasuhiro Sato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NGHTMLGetter.h"
#import "NGImageDownloader.h"

@interface NGViewControllerBase : NSObject<NGHTMLGetterDelegate, UICollectionViewDataSource, UICollectionViewDelegate,NGImageDownloaderDelegate,UIAsyncImageViewDelegate>{
    NSMutableArray *imageUrlArray;
    NSMutableArray *imageArray;
    NSString *sourceHtmlUrl;
}

- (void)variableInit;
- (IBAction)downloadImages:(id)sender;
- (void)setSourceHtmlUrl:(NSString *)url;
- (void)getImage;

@property IBOutlet UICollectionView *image_collection_view;
@end
