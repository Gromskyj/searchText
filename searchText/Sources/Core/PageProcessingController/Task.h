//
//  Task.h
//  searchText
//
//  Created by User on 15.02.17.
//  Copyright © 2017 yevgen.gromsky. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    TaskStatePending = 0,
    TaskStateDownload,
    TaskStatePause,
    TaskStateParse,
    TaskStateProcessed,
    TaskStateFailed
} TaskState;

@interface Task : NSObject

- (instancetype) initWithURL:(NSString *)URL;

@property (assign, nonatomic, readonly) NSUInteger taskID;
@property (retain, nonatomic) NSString *urlString;

@property (assign, nonatomic) TaskState taskState;

@property (retain, nonatomic) NSError *error;
@property (assign, nonatomic) int resultsCount;
@property (assign, nonatomic) int downloadProgress;
@property (retain, nonatomic) NSArray *subURLs;

@property (retain, nonatomic) NSData *resumeData; 

@property (retain, nonatomic, readonly) NSString *readableState;


@end
