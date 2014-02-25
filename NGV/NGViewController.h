//
//  NGViewController.h
//  NGV
//
//  Created by Yasuhiro Sato on 2013/12/10.
//  Copyright (c) 2013年 Yasuhiro Sato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGHTMLGetter.h"

@interface NGViewController : UIViewController<NGHTMLGetterDelegate, UICollectionViewDataSource, UICollectionViewDelegate>{
    IBOutlet UICollectionView *image_collection_view;
    NSMutableArray *imageUrlArray;
    NSString *sourceHtmlUrl;
}

- (void)setSourceHtmlUrl:(NSString *)url;
- (void)getImage;
@end
