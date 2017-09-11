//
//  Task.m
//  searchText
//
//  Created by User on 15.02.17.
//  Copyright © 2017 yevgen.gromsky. All rights reserved.
//

#import "Task.h"

@implementation Task

- (instancetype) initWithURL:(NSString *)URL{
    if (self = [super init]){
        self.urlString = URL;
        self.taskState = TaskStatePending;
    }
    return self;
}

- (NSUInteger)taskID{
    return [self.urlString hash];
}

- (NSString *)readableState{
    switch (self.taskState) {
        case TaskStatePending:
            return @"Pending";
            break;
        case TaskStateDownload:
            return @"Downloading";
            break;
        case TaskStatePause:
            return @"Paused";
            break;
        case TaskStateParse:
            return @"Parsing";
            break;
        case TaskStateProcessed:
            return @"Processed";
            break;
        case TaskStateFailed:
            return [NSString stringWithFormat:@"Failed: %@", self.error.localizedDescription];
            break;
        default:
            break;
    }
    return @"Unknown!";
}

@end
