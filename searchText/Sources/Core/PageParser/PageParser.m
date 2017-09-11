//
//  PageParser.m
//  searchText
//
//  Created by User on 14.02.17.
//  Copyright © 2017 yevgen.gromsky. All rights reserved.
//

#import "PageParser.h"

@implementation PageParser

- (NSArray *) parsePageForLinks:(NSString *)pageString{
    if (!pageString) return @[];
    NSDataDetector* detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    NSArray* matches = [detector matchesInString:pageString options:0 range:NSMakeRange(0, [pageString length])];
    
    //TEST
////    NSString *urlReg = @"_^(?:(?:https?|ftp)://)(?:\\S+(?::\\S*)?@)?(?:(?!10(?:\\.\\d{1,3}){3})(?!127(?:\\.\\d{1,3}){3})(?!169\\.254(?:\\.\\d{1,3}){2})(?!192\\.168(?:\\.\\d{1,3}){2})(?!172\\.(?:1[6-9]|2\\d|3[0-1])(?:\\.\\d{1,3}){2})(?:[1-9]\\d?|1\\d\\d|2[01]\\d|22[0-3])(?:\\.(?:1?\\d{1,2}|2[0-4]\\d|25[0-5])){2}(?:\\.(?:[1-9]\\d?|1\\d\\d|2[0-4]\\d|25[0-4]))|(?:(?:[a-z\\x{00a1}-\\x{ffff}0-9]+-?)*[a-z\\x{00a1}-\\x{ffff}0-9]+)(?:\\.(?:[a-z\\x{00a1}-\\x{ffff}0-9]+-?)*[a-z\\x{00a1}-\\x{ffff}0-9]+)*(?:\\.(?:[a-z\\x{00a1}-\\x{ffff}]{2,})))(?::\\d{2,5})?(?:/[^\\s]*)?$_iuS";
////    NSString *urlReg = @"@(https?|ftp)://(-\\.)?([^\\s/?\\.#-]+\\.?)+(/[^\\s]*)?$@iS";
//    NSString *urlReg = @"http?://([-\\w\\.]+)+(:\\d+)?(/([\\w/_\\.]*(\\?\\S+)?)?)?";
//    NSRegularExpression *detector2 = [NSRegularExpression regularExpressionWithPattern:urlReg options:NSRegularExpressionCaseInsensitive error:nil];
//    NSUInteger count1 = [detector numberOfMatchesInString:pageString options:0 range:NSMakeRange(0, [pageString length])];
//    NSUInteger count2 = [detector2 numberOfMatchesInString:pageString options:0 range:NSMakeRange(0, [pageString length])];
//    
//    NSLog(@"Result match DataDetector: %@ andRegExp: %@",@(count1), @(count2));
//    
//    ///END TEST
//    NSLinkCheckingResult
    NSArray* stringURLs = [matches valueForKeyPath:@"URL.absoluteString"];
    return [[NSOrderedSet orderedSetWithArray:stringURLs] array];
}

- (BOOL) parsePage:(NSString *)pageString forText:(NSString *)searchText{
    if (!pageString || !searchText) return NO;
    
    if ([[pageString lowercaseString] rangeOfString:[searchText lowercaseString]].location == NSNotFound){
        return NO;
    }
    
    return YES;
}

@end
