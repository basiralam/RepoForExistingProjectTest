//
//  SignUpStore.m
//  ecoPodium
//
//  Created by Micronixtraining on 8/31/15.
//  Copyright (c) 2015 Micronixsystem. All rights reserved.
//

#import "SignUpStore.h"

@implementation SignUpStore


+(SignUpStore *)SignUpClassObj
{
    static SignUpStore *SignUpClassObj = nil;
    
    if (!SignUpClassObj) {
        SignUpClassObj = [[SignUpStore alloc]init];
    }
    
    return  SignUpClassObj;
}

@end
