//
//  NGViewController.h
//  NGV
//
//  Created by Yasuhiro Sato on 2014/05/03.
//  Copyright (c) 2014年 Yasuhiro Sato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NADView.h"

@interface NGViewController : UIViewController{
    NSMutableArray *nadViews;
}

// 継承先のクラスでオーバライドして、nadViews にDictionary をinsertする処理を書く
- (void)setNadViews;
- (void)addNADViewTo:(UIView *)view rect:(CGRect)rect nendID:(NSDictionary *)nendID;
@end
