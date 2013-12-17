//
//  NGImageGetter.h
//  NGV
//
//  Created by Yasuhiro Sato on 2013/12/10.
//  Copyright (c) 2013年 Yasuhiro Sato. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NGImageGetterDelegate<NSObject>
-(void)didFinishedLoad:(NSString *)html;
@end

@interface NGImageGetter : NSObject{
    NSMutableData *receivedData;
    
}
- (BOOL)getImage;
@property (nonatomic, assign) id<NGImageGetterDelegate> delegate;
@end