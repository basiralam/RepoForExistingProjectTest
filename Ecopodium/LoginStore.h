//
//  LoginStore.h
//  ecoPodium
//
//  Created by Micronixtraining on 8/31/15.
//  Copyright (c) 2015 Micronixsystem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginStore : NSObject

@property(nonatomic,strong) NSString *username;
@property(nonatomic,strong) NSString *password;

+(LoginStore *)LoginClassObj;


@end
