//
//  MessageStore.m
//  Ecopodium
//
//  Created by Micronixtraining on 9/5/15.
//  Copyright (c) 2015 Amit Poreli. All rights reserved.
//

#import "MessageStore.h"

@implementation MessageStore

+(MessageStore *)MessageClassObj
{
    static MessageStore *MessageClassObj = nil;
    
    if (!MessageClassObj) {
        MessageClassObj = [[MessageStore alloc]init];
    }
    
    return  MessageClassObj;
}


@end
