//
//  MongoServer.m
//  Mongo
//
//  Created by Pavel Kozlov on 01.03.14.
//  Copyright (c) 2014 Pavel Kozlov. All rights reserved.
//

#import <xpc/xpc.h>
#import "MongoServer.h"
#import "Constants.h"
#import "NSFileManager+DirectoryLocations.h"

@implementation MongoServer {
    __strong NSTask *_postgresTask;
    NSUInteger _port;
    NSString *pidFile;
    
    xpc_connection_t _xpc_connection;
}
+ (MongoServer *) getInstance {
    static MongoServer *_instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _xpc_connection = xpc_connection_create("ru.pkozlov.MongoService", dispatch_get_main_queue());
	xpc_connection_set_event_handler(_xpc_connection, ^(xpc_object_t event) {
        xpc_dictionary_apply(event, ^bool(const char *key, xpc_object_t value) {
			return true;
		});
	});
	xpc_connection_resume(_xpc_connection);
    
    return self;
}

- (void)startWithTerminationHandler:(void (^)(NSUInteger status))terminationHandler
{
    [self stopWithTerminationHandler:nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _binPath = [[NSBundle mainBundle].bundlePath stringByAppendingString:@"/Contents/MacOS/mongodb/bin"];
    NSString *dataDirectory = [defaults stringForKey:keyDataDirectory];
    if (!dataDirectory) {
        dataDirectory = valueDataDirectory;
    }
    _logFile = [defaults stringForKey:keyLogFile];
    if (!_logFile) {
        _logFile = valueLogFile;
    }
    
    pidFile = [defaults stringForKey:keyPidFile];
    if (!pidFile) {
        pidFile = valuePidFile;
    }

    BOOL enableRest = [defaults boolForKey:keyEnableRest];
//    NSUInteger port = [defaults integerForKey:keyDefaultPort];
    NSLog(@"Data directory: %@", dataDirectory);
    NSLog(@"Log file: %@", _logFile);
    NSLog(@"Pid file: %@", pidFile);
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataDirectory]) {
        if (![[NSFileManager defaultManager] createDirectoryAtPath:dataDirectory]) {
            if (terminationHandler) {
                terminationHandler(1);
            }
            return;
        }
	}
    
    NSMutableArray *arguments = [NSMutableArray array];
    [arguments addObject:@"--fork"];
    [arguments addObject:@"--dbpath"];
    [arguments addObject:dataDirectory];
    [arguments addObject:@"--logpath"];
    [arguments addObject:_logFile];
    [arguments addObject:@"--pidfilepath"];
    [arguments addObject:pidFile];
    if (enableRest) {
        [arguments addObject:@"--rest"];
    }

//    NSTask *task = [[NSTask alloc] init];
//    task.launchPath = [_binPath stringByAppendingString:@"/mongod"];
//    task.arguments = arguments;
//    NSLog(@"Starting server");
//    task.terminationHandler = ^(NSTask *task) {
//        if (terminationHandler) {
//            terminationHandler([task terminationStatus]);
//        }
//    };
//    [task launch];
    [self executeCommandNamed:[_binPath stringByAppendingPathComponent:@"mongod"] arguments:[arguments copy] terminationHandler:^(NSUInteger status) {
        _isRunning = (status == 0);
        NSLog(@"STATUS: %lu", status);
        if (terminationHandler) {
            terminationHandler(status);
        }
    }];
    
}

- (void)stopWithTerminationHandler:(void (^)(NSUInteger status))terminationHandler
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:pidFile]) {
        NSString *pid = [[[NSString stringWithContentsOfFile:pidFile encoding:NSUTF8StringEncoding error:nil] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] objectAtIndex:0];
        [self executeCommandNamed:@"/bin/kill" arguments:[NSArray arrayWithObjects:pid, nil] terminationHandler:terminationHandler];
        [[NSFileManager defaultManager] removeItemAtPath:pidFile error:nil];
    }
}

- (void)executeCommandNamed:(NSString *)command
                  arguments:(NSArray *)arguments
         terminationHandler:(void (^)(NSUInteger status))terminationHandler
{
    NSLog(@"Command: %@", command);
	xpc_object_t message = xpc_dictionary_create(NULL, NULL, 0);
    
    xpc_dictionary_set_string(message, "command", [command UTF8String]);
    
    xpc_object_t args = xpc_array_create(NULL, 0);
    [arguments enumerateObjectsUsingBlock:^(id argument, NSUInteger idx, BOOL *stop) {
        xpc_array_set_value(args, XPC_ARRAY_APPEND, xpc_string_create([argument UTF8String]));
    }];
    xpc_dictionary_set_value(message, "arguments", args);
    
    xpc_connection_send_message_with_reply(_xpc_connection, message, dispatch_get_main_queue(), ^(xpc_object_t object) {
        NSLog(@"%lld %s: Status %lld", xpc_dictionary_get_int64(object, "pid"), xpc_dictionary_get_string(object, "command"), xpc_dictionary_get_int64(object, "status"));
        
        if (terminationHandler) {
            terminationHandler(xpc_dictionary_get_int64(object, "status"));
        }
    });
}

@end
