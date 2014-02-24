//
//  NGTopicListGetter.h
//  NGV
//
//  Created by Yasuhiro Sato on 2014/01/28.
//  Copyright (c) 2014年 Yasuhiro Sato. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NGTopicListGetterDelegate<NSObject>
-(void)didFinishedLoad:(NSArray*)html;
@end

@interface NGTopicListGetter: NSObject<NSXMLParserDelegate> {
    NSMutableData *receivedData;
    
    int elementkey;
    NSMutableArray *odaimokuArray;
    NSString *itemName;
    NSString *imageUrl;
}
- (BOOL)getTopic;
@property (nonatomic, assign) id<NGTopicListGetterDelegate> delegate;
@end