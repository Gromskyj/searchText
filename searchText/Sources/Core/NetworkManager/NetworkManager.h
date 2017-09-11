//
//  NetworkManager.h
//  searchText
//
//  Created by User on 14.02.17.
//  Copyright © 2017 yevgen.gromsky. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^PageResponse)(NSString *, NSError *);

@interface NetworkManager : NSObject

- (void) downloadPageWithURL:(NSString *)urlString completion:(PageResponse)completion;

@end
