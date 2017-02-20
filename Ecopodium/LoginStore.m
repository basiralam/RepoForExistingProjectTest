//
//  LoginStore.m
//  ecoPodium
//
//  Created by Micronixtraining on 8/31/15.
//  Copyright (c) 2015 Micronixsystem. All rights reserved.
//

#import "LoginStore.h"

@implementation LoginStore

+(LoginStore *)LoginClassObj
{
    static LoginStore *LoginObj = nil;
    
    if (!LoginObj) {
        LoginObj = [[LoginStore alloc]init];
    }
    
    return  LoginObj;
}

@end
