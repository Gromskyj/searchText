//
//  ProgressStatus.h
//  searchText
//
//  Created by User on 15.02.17.
//  Copyright © 2017 yevgen.gromsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProgressStatus : NSObject

- (instancetype) init;

@property (assign, nonatomic) NSUInteger tasksTotal; //currently in queue
@property (assign, nonatomic) NSUInteger tasksMax; //max count
//@property (assign, atomic) NSUInteger tasksDownloading; //download in progress
//@property (assign, atomic) NSUInteger tasksParsing; //parsing
@property (assign, nonatomic) NSUInteger tasksProcessed; //processed
@property (assign, nonatomic) NSUInteger tasksFailed; // or failed
@property (assign, nonatomic) NSUInteger tasksTextFound; //textFound


- (NSString *)readableState;
- (void) clean;
- (NSUInteger) value;
- (NSUInteger) maxValue;

@end
