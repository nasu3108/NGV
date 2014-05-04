//
//  NGOdaimokuTableViewControllerIphone.m
//  NGV
//
//  Created by Yasuhiro Sato on 2014/03/22.
//  Copyright (c) 2014年 Yasuhiro Sato. All rights reserved.
//

#import "NGOdaimokuTableViewControllerIphone.h"

@implementation NGOdaimokuTableViewControllerIphone

- (void)setNadViews
{
    NSDictionary *nendId = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"a6eca9dd074372c898dd1df549301f277c53f2b9", @"nendID",
                            @"3172", @"spotID",nil];
    [self addNADViewTo:odaimoku_nand_view rect:CGRectMake( 0, 0, 320, 50) nendID:nendId];
}

@end
