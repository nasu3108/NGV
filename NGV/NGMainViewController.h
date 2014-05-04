//
//  NGViewController.h
//  NGV
//
//  Created by Yasuhiro Sato on 2013/12/10.
//  Copyright (c) 2013年 Yasuhiro Sato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGViewController.h"
#import "NGHTMLGetter.h"
#import "NGImageDownloader.h"
#import "NGMainViewControllerBase.h"
#import "NendAd/NADView.h"

@interface NGMainViewController : NGViewController{
    IBOutlet UICollectionView *image_collection_view;
    IBOutlet UIView *nand_view;
    NGMainViewControllerBase *base;
}

- (void)variableInit;
- (IBAction)downloadImages:(id)sender;
- (void)setSourceHtmlUrl:(NSString *)url;
- (void)setSourceHtmlTitle:(NSString *)title;
- (void)getImage;
@end
