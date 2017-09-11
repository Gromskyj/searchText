//
//  PageProcessingController.h
//  searchText
//
//  Created by User on 15.02.17.
//  Copyright © 2017 yevgen.gromsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Task.h"
#import "ProgressStatus.h"

typedef enum : NSUInteger {
    PageProcessingChangeTypeInsert = 0,
    PageProcessingChangeTypeUpdate,
    PageProcessingChangeTypeDelete
} PageProcessingChangeType;

@class PageProcessingController;

@protocol PageProcessingControllerDelegate <NSObject>

@required

@optional
- (void) controllerWillChangeContent:(PageProcessingController *)controller;
- (void) controllerDidChangeContent:(PageProcessingController *)controller;
- (void) controller:(PageProcessingController *)controller didChangeTask:(Task *)task atIndex:(NSUInteger)index forType:(PageProcessingChangeType)type;
- (void) controller:(PageProcessingController *)controller progress:(float)progress;
- (void) controllerDidFinish:(PageProcessingController *)controller;

@end

@interface PageProcessingController : NSObject

- (instancetype) init;
- (instancetype) initWithRootURL:(NSString *)rootURL;

@property (weak, nonatomic) id <PageProcessingControllerDelegate> delegate;
@property (retain, nonatomic, readonly) NSArray<Task *> *tasks;
@property (retain, nonatomic) NSString *rootURL;
@property (assign, nonatomic) NSUInteger maxLinksCount;
@property (assign, nonatomic) NSUInteger maxConcurrentOperationCount;

@property (retain, nonatomic) ProgressStatus *progressStatus;

- (void) clear;
- (void) performSearchWithText:(NSString *)searchText;
- (void) setSuspend:(BOOL)isSuspend;
- (void) invalidate;

@end
