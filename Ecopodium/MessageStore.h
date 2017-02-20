//
//  MessageStore.h
//  Ecopodium
//
//  Created by Micronixtraining on 9/5/15.
//  Copyright (c) 2015 Amit Poreli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageStore : NSObject


@property(nonatomic,strong) NSString *location;
@property(nonatomic,strong) NSString *Message;



+(MessageStore *)MessageClassObj;

@end
