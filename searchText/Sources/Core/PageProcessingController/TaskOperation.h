//
//  TaskOperation.h
//  searchText
//
//  Created by User on 15.02.17.
//  Copyright © 2017 yevgen.gromsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Task.h"

@class TaskOperation;

@protocol TaskOperationDelegate <NSObject>

@required
- (void) taskOperation:(TaskOperation *)taskOperation withTask:(Task *)task foundURLs:(NSArray *)URLs;
- (void) taskOperation:(TaskOperation *)taskOperation withTask:(Task *)task stateChanged:(TaskState)taskState;

@optional

@end


@interface TaskOperation : NSOperation

- (instancetype) initWithTask:(Task *)task andDelegate:(id <TaskOperationDelegate>)delegate andSearchText:(NSString *)searchText;
@property (assign, nonatomic) BOOL skipLinks;

@end
