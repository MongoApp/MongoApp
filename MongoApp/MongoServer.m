//
//  MongoServer.m
//  Mongo
//
//  Created by Pavel Kozlov on 01.03.14.
//  Copyright (c) 2014 Pavel Kozlov. All rights reserved.
//

#import <xpc/xpc.h>
#import "MongoServer.h"

@implementation MongoServer {
    __strong NSTask *_postgresTask;
    NSUInteger _port;
    
    xpc_connection_t _xpc_connection;
}
+ (MongoServer *) getInstance {
    static MongoServer *_instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        NSString *binDirectory = [[NSBundle mainBundle].bundlePath stringByAppendingFormat:@"/mongodb/bin"];
		NSString *databaseDirectory = @"/usr/local/var/mongodb";

        _instance = [[self alloc] initWithExecutablesDirectory:binDirectory databaseDirectory:databaseDirectory];
    });
    
    return _instance;
}

- (id)initWithExecutablesDirectory:(NSString *)executablesDirectory
                 databaseDirectory:(NSString *)databaseDirectory
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _binPath = executablesDirectory;
    _varPath = databaseDirectory;
    
    _xpc_connection = xpc_connection_create("ru.pkozlov.MongoService", dispatch_get_main_queue());
	xpc_connection_set_event_handler(_xpc_connection, ^(xpc_object_t event) {
        xpc_dictionary_apply(event, ^bool(const char *key, xpc_object_t value) {
			return true;
		});
	});
	xpc_connection_resume(_xpc_connection);
    
    return self;
}


@end
