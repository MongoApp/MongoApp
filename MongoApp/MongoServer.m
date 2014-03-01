//
//  MongoServer.m
//  Mongo
//
//  Created by Pavel Kozlov on 01.03.14.
//  Copyright (c) 2014 Pavel Kozlov. All rights reserved.
//

#import "MongoServer.h"

@implementation MongoServer

+ (MongoServer *) getInstance {
    static MongoServer *_instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

@end
