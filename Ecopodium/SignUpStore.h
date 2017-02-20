//
//  SignUpStore.h
//  ecoPodium
//
//  Created by Micronixtraining on 8/31/15.
//  Copyright (c) 2015 Micronixsystem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignUpStore : NSObject

@property(nonatomic,strong) NSString *username;
@property(nonatomic,strong) NSString *password;
@property(nonatomic,strong) NSString *confromPass;
@property(nonatomic,strong) NSString *email;
@property(nonatomic,strong) NSString *mobile;


+(SignUpStore *)SignUpClassObj;

@end
