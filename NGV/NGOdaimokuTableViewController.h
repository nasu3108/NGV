//
//  NGOdaimokuTableViewController.h
//  NGV
//
//  Created by Yasuhiro Sato on 2014/01/28.
//  Copyright (c) 2014年 Yasuhiro Sato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGTopicListGetter.h"

@interface NGOdaimokuTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,NGTopicListGetterDelegate>{
    IBOutlet UITableView *odaimoku_table_view;
    NSMutableArray *odaimokuUrlArray;
}
@end
