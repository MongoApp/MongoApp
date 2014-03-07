//
//  MongoServer.h
//  Mongo
//
//  Created by Pavel Kozlov on 01.03.14.
//  Copyright (c) 2014 Pavel Kozlov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MongoServer : NSObject

@property (readonly) BOOL isRunning;
@property (readonly) NSUInteger port;
@property (readonly) NSString *binPath;
@property (readonly) NSString *logFile;
@property (readonly) NSString *varPath;

+ (MongoServer *) getInstance;

- (id)init;
- (void)startWithTerminationHandler:(void (^)(NSUInteger status))terminationHandler;
- (void)stopWithTerminationHandler:(void (^)(NSUInteger status))terminationHandler;

- (void)executeCommandNamed:(NSString *)command
                  arguments:(NSArray *)arguments
         terminationHandler:(void (^)(NSUInteger status))terminationHandler;
@end
