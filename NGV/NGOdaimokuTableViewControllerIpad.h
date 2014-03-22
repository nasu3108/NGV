//
//  NGOdaimokuTableViewControllerIpad.h
//  NGV
//
//  Created by Yasuhiro Sato on 2014/03/22.
//  Copyright (c) 2014年 Yasuhiro Sato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGOdaimokuTableViewController.h"
#import "NGViewControllerBase.h"

@interface NGOdaimokuTableViewControllerIpad :NGOdaimokuTableViewController{
    IBOutlet UICollectionView *image_collection_view;
    NGViewControllerBase *ngViewControllerBase;
}

- (IBAction)downloadImages:(id)sender;
@end
