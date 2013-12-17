//
//  NGViewController.h
//  NGV
//
//  Created by Yasuhiro Sato on 2013/12/10.
//  Copyright (c) 2013年 Yasuhiro Sato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGImageGetter.h"

@interface NGViewController : UIViewController<NGImageGetterDelegate>{
    IBOutlet UILabel *label;
}
@end
