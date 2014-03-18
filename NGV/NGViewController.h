//
//  NGViewController.h
//  NGV
//
//  Created by Yasuhiro Sato on 2013/12/10.
//  Copyright (c) 2013年 Yasuhiro Sato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGHTMLGetter.h"
#import "NGImageDownloader.h"

@interface NGViewController : UIViewController<NGHTMLGetterDelegate, UICollectionViewDataSource, UICollectionViewDelegate,NGImageDownloaderDelegate>{
    IBOutlet UICollectionView *image_collection_view;
    NSMutableArray *imageUrlArray;
    NSString *sourceHtmlUrl;
}

- (IBAction)downloadImages:(id)sender;
- (void)setSourceHtmlUrl:(NSString *)url;
- (void)getImage;
@end
