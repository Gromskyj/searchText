//
//  TaskOperation.m
//  searchText
//
//  Created by User on 15.02.17.
//  Copyright © 2017 yevgen.gromsky. All rights reserved.
//

#import "TaskOperation.h"
#import "NetworkManager.h"
#import "PageParser.h"
#import "PageProcessingController.h"

@interface TaskOperation()

@property (retain, nonatomic) Task *currentTask;
@property (weak, nonatomic) id <TaskOperationDelegate> delegate;
@property (retain, nonatomic) NSString *searchText;

@end

@implementation TaskOperation

- (instancetype) initWithTask:(Task *)task andDelegate:(id <TaskOperationDelegate>)delegate andSearchText:(NSString *)searchText{
    if (self = [super init]){
        self.currentTask = task;
        self.delegate = delegate;
        self.searchText = searchText;
        self.skipLinks = NO;
    }
    return self;
}

- (void) main{
    @autoreleasepool {
        if (self.isCancelled)
            return;
        
        self.currentTask.taskState = TaskStateDownload;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if ([self.delegate respondsToSelector:@selector(taskOperation:withTask:stateChanged:)]){
                [self.delegate taskOperation:self withTask:self.currentTask stateChanged:TaskStateDownload];
            }
        }];
        
        if (self.isCancelled)
            return;
        //Download page
        NetworkManager *networkManager = [[NetworkManager alloc] init];
        dispatch_semaphore_t sem = dispatch_semaphore_create(0);
        __block NSString * page;
        __block NSError *error = nil;
        [networkManager downloadPageWithURL:self.currentTask.urlString completion:^(NSString *pageString, NSError *error_n) {
            if (error_n){
                error = error_n;
            }else{
                page = pageString;
            }
            dispatch_semaphore_signal(sem);
        }];
        
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
        if (self.isCancelled)
            return;
        
        if (error){
            self.currentTask.error = error;
            self.currentTask.taskState = TaskStateFailed;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if ([self.delegate respondsToSelector:@selector(taskOperation:withTask:stateChanged:)]){
                    [self.delegate taskOperation:self withTask:self.currentTask stateChanged:TaskStateFailed];
                }
            }];
            return;
        }
        
        self.currentTask.taskState = TaskStateParse;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if ([self.delegate respondsToSelector:@selector(taskOperation:withTask:stateChanged:)]){
                [self.delegate taskOperation:self withTask:self.currentTask stateChanged:TaskStateParse];
            }
        }];
        
        if (self.isCancelled)
            return;
        //ParseLinks
        PageParser *pageParser = [[PageParser alloc] init];
        if (!self.skipLinks){
            NSArray *urls = [pageParser parsePageForLinks:page];
            
            //Process Links
            NSMutableArray *processedURLs = [NSMutableArray array];
            for (NSString *url in urls) {
                if ([self isValidURL:url]){
                    [processedURLs addObject:url];
                }
            }
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if ([self.delegate respondsToSelector:@selector(taskOperation:withTask:foundURLs:)]){
                    [self.delegate taskOperation:self withTask:self.currentTask foundURLs:[NSArray arrayWithArray:processedURLs]];
                }
            }];
        }
        
        
        if (self.isCancelled)
            return;
        //ParseText
        BOOL isFound = [pageParser parsePage:page forText:self.searchText];
        self.currentTask.taskState = TaskStateProcessed;
        self.currentTask.resultsCount = isFound;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if ([self.delegate respondsToSelector:@selector(taskOperation:withTask:stateChanged:)]){
                [self.delegate taskOperation:self withTask:self.currentTask stateChanged:TaskStateProcessed];
            }
        }];
        
        if (self.isCancelled)
            return;
    }
}

- (BOOL) isValidURL:(NSString *)stringURL{
    //Validate if page (not image/script etc.)
    if (![self checkIfPage:stringURL]) return NO;
    
    
    //Validate dublicates
    if (self.delegate){
        PageProcessingController *controller = (PageProcessingController *)self.delegate;
        
        //Validate Max Counts
        if (controller.maxLinksCount != 0){
            if (controller.tasks.count >= controller.maxLinksCount) return NO;
        }
        
        if ([[controller.tasks valueForKey:@"urlString"] containsObject:stringURL]) return NO;

    }
    
    return YES;
}

- (BOOL) checkIfPage:(NSString *)urlString{
    NSArray *imageFontsEtcExtensions = @[@"png", @"jpg", @"gif", @"jpeg", @"css", @"js", @"ico", @"xml", @"mov", @"mp3", @"swf"]; //can be fullfilled with more extensions.
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSString *extension = [url pathExtension];
    if ([imageFontsEtcExtensions containsObject:extension]) {
        return NO;
    }
    
    return YES;
}


@end
