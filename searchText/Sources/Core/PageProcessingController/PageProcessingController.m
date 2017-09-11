//
//  PageProcessingController.m
//  searchText
//
//  Created by User on 15.02.17.
//  Copyright © 2017 yevgen.gromsky. All rights reserved.
//

#import "PageProcessingController.h"
#import "TaskOperation.h"

@interface PageProcessingController ()<TaskOperationDelegate>

@property (nonatomic, strong) NSOperationQueue *tasksQueue;
@property (retain, atomic) NSMutableArray<Task *> *objects;
@property (retain, nonatomic) NSString *searchText;

@end

@implementation PageProcessingController

#pragma mark - LifeCycle
- (instancetype) init{
    if (self = [super init]){
        self.objects = [NSMutableArray array];
        self.maxLinksCount = 0;
        self.maxConcurrentOperationCount = 1;
        self.progressStatus = [[ProgressStatus alloc] init];
    }
    return self;
}

- (instancetype) initWithRootURL:(NSString *)rootURL{
    if (self = [super init]){
        self.rootURL = rootURL;
        self.objects = [NSMutableArray array];
        self.maxLinksCount = 0;
        self.maxConcurrentOperationCount = 1;
        self.progressStatus = [[ProgressStatus alloc] init];
        
    }
    return self;
}

- (void)dealloc{
    [_tasksQueue removeObserver:self forKeyPath:@"operations"];
}

#pragma mark - Observer
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                         change:(NSDictionary *)change context:(void *)context
{
    if (object == self.tasksQueue && [keyPath isEqualToString:@"operations"]) {
        if ([self.tasksQueue.operations count] == 0) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if ([self.delegate respondsToSelector:@selector(controllerDidFinish:)]){
                    [self.delegate controllerDidFinish:self];
                }
            }];
        }
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object
                               change:change context:context];
    }
}

#pragma mark - Properties
- (NSOperationQueue *)tasksQueue {
    if (!_tasksQueue) {
        _tasksQueue = [[NSOperationQueue alloc] init];
        _tasksQueue.name = @"Tasks Queue";
        _tasksQueue.maxConcurrentOperationCount = 5;
        [_tasksQueue addObserver:self forKeyPath:@"operations" options:0 context:NULL];
    }
    return _tasksQueue;
}

#pragma mark - Actions
- (void) performSearchWithText:(NSString *)searchText{
    self.searchText = searchText;
    [self addTaskWithURL:self.rootURL];
    self.progressStatus.tasksMax = self.maxLinksCount;
}

- (void)setSuspend:(BOOL)isSuspend{
    [self.tasksQueue setSuspended:isSuspend];
}

- (void) invalidate{
    [self.tasksQueue cancelAllOperations];
}

#pragma mark - Properties
- (void) clear{
    self.objects = [NSMutableArray array];
    [self.progressStatus clean];
    
}

- (NSArray<Task *> *)tasks{
    return [NSArray arrayWithArray:self.objects];
}

#pragma mark - TaskOperation Delegate
- (void)taskOperation:(TaskOperation *)taskOperation withTask:(Task *)task foundURLs:(NSArray *)URLs{

    if ([self.delegate respondsToSelector:@selector(controllerWillChangeContent:)]){
        [self.delegate controllerWillChangeContent:self];
    }
    for (NSString *url in URLs) {
        [self addTaskWithURL:url];
    }
    if ([self.delegate respondsToSelector:@selector(controllerDidChangeContent:)]){
        [self.delegate controllerDidChangeContent:self];
    }

}

- (void)taskOperation:(TaskOperation *)taskOperation withTask:(Task *)task stateChanged:(TaskState)taskState{

    if ([self.delegate respondsToSelector:@selector(controllerWillChangeContent:)]){
        [self.delegate controllerWillChangeContent:self];
    }
    
    if (taskState == TaskStateFailed){
        self.progressStatus.tasksFailed += 1;
    }
    
    if (taskState == TaskStateProcessed){
        self.progressStatus.tasksProcessed += 1;
        if (task.resultsCount > 0){
            self.progressStatus.tasksTextFound += 1;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(controller:didChangeTask:atIndex:forType:)]){
        [self.delegate controller:self didChangeTask:task atIndex:[self.objects indexOfObject:task] forType:PageProcessingChangeTypeUpdate];
    }
    if ([self.delegate respondsToSelector:@selector(controllerDidChangeContent:)]){
        [self.delegate controllerDidChangeContent:self];
    }
}

#pragma mark - Internals
- (void) addTaskWithURL:(NSString *)url{
    //Validate Max Counts
    if (self.maxLinksCount != 0){
        if (self.objects.count >= self.maxLinksCount) return;
    }
    
    Task *task = [[Task alloc] initWithURL:url];
    [self.objects addObject:task];
    
    self.progressStatus.tasksTotal += 1;
    
    NSUInteger index = [self.objects indexOfObject:task];
    if ([self.delegate respondsToSelector:@selector(controller:didChangeTask:atIndex:forType:)]){
        [self.delegate controller:self didChangeTask:task atIndex:index forType:PageProcessingChangeTypeInsert];
    }
    
    TaskOperation *taskOperation = [[TaskOperation alloc] initWithTask:task andDelegate:self andSearchText:self.searchText];
    taskOperation.skipLinks = self.objects.count >= self.maxLinksCount;
    [self.tasksQueue addOperation:taskOperation];
}

@end
