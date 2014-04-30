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
    NSInteger maxPage;
    NSInteger loadPages;
}

- (void)refreshOccured:(id)sender;
- (void)variableInit;
- (IBAction)showMenu:(id)sender;
- (void)downloadImages;
- (void)getImage;
- (void)viewWillDisappear;

@property IBOutlet UICollectionView *image_collection_view;
@property UIViewController *ui_view_controller;
@property NSString *sourceHtmlUrl;
@property NSString *sourceHtmlTitle;
@end
