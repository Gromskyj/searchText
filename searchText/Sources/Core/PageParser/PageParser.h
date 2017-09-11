//
//  PageParser.h
//  searchText
//
//  Created by User on 14.02.17.
//  Copyright © 2017 yevgen.gromsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PageParser : NSObject

- (NSArray *) parsePageForLinks:(NSString *)pageString;
- (BOOL) parsePage:(NSString *)pageString forText:(NSString *)searchText;

@end
