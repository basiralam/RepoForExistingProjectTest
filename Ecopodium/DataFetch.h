//
//  DataFetch.h
//  JsonDemo
//
//  Created by MacMini3 on 2015-12-09.
//  Copyright © 2015 MacMini3. All rights reserved.
//

#import <Foundation/Foundation.h>
/***********************/
@protocol ProcessDataDelegate <NSObject>

@required
- (void) processSuccessful :(NSDictionary *)data :(NSString *)JsonFor;

@end
/**************************/
@interface DataFetch : NSObject<NSURLConnectionDelegate>
{
    id <ProcessDataDelegate> _delegate; //  " _ " for auto synthesized
}

@property (retain) id delegate;


-(void)request:(NSString *)URL :(NSString *)Method :(NSDictionary *)Method_Parameter :(NSString *)From :(NSString *)Type;
//@property(nonatomic,retain)NSDictionary *Getdata;

@end
