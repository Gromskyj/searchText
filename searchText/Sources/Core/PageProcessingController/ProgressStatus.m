//
//  ProgressStatus.m
//  searchText
//
//  Created by User on 15.02.17.
//  Copyright © 2017 yevgen.gromsky. All rights reserved.
//

#import "ProgressStatus.h"

@implementation ProgressStatus

- (instancetype) init{
    if (self = [super init]){
        [self clean];
    }
    return self;
}
- (NSString *)readableState{
    float generalProgress = ((float)_tasksProcessed / (float)_tasksTotal) * 100;
    return [NSString stringWithFormat:@"Progress: %lu%%. Links in queue: %lu. Processed: %lu. Pages with text: %lu. Failed: %lu",(unsigned long)generalProgress, (unsigned long)[self maxValue], (unsigned long)[self value], (unsigned long)_tasksTextFound, (unsigned long)_tasksFailed];
}

- (NSUInteger) value{
    return _tasksProcessed;
}

- (NSUInteger) maxValue{
    return MIN(_tasksMax, _tasksTotal);
}

- (void) clean{
    self.tasksTotal = 0;
    self.tasksMax = 0;
    self.tasksProcessed = 0;
    self.tasksFailed = 0;
    self.tasksTextFound = 0;
}

@end
