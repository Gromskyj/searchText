//
//  NetworkManager.m
//  searchText
//
//  Created by User on 14.02.17.
//  Copyright © 2017 yevgen.gromsky. All rights reserved.
//

#import "NetworkManager.h"

@interface NetworkManager ()

@end

@implementation NetworkManager

- (void) downloadPageWithURL:(NSString *)urlString completion:(PageResponse)completion{
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *dataTask;
    
    NSURL *url = [NSURL URLWithString:urlString]; 
    
    dataTask = [defaultSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    
        if (error){
            completion(nil, error);
        }else{
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (httpResponse.statusCode == 200){
                NSString *encodedString;
                [NSString stringEncodingForData:data encodingOptions:nil convertedString:&encodedString usedLossyConversion:nil];
                if (completion){
                    if (encodedString){
                        completion(encodedString, nil);
                    }else{
                        completion(nil, [NSError
                                         errorWithDomain:@"com.yevgen.gromsky.searchText"
                                         code:20000
                                         userInfo:@{NSLocalizedFailureReasonErrorKey : @"Parsing failed",
                                                    NSLocalizedDescriptionKey : @"Parsing failed. Not page."}]);
                    }
                    
                }
            }else{
                completion(nil, [NSError errorWithDomain:@"com.yevgen.gromsky.searchText"
                                                    code:10000+httpResponse.statusCode
                                                userInfo:@{NSLocalizedFailureReasonErrorKey : @"Wrong status code",
                                                           NSLocalizedDescriptionKey : [NSString stringWithFormat:@"Wrong status code. Status code: %ld",(long)httpResponse.statusCode]}]);
            }
        }
    }];
    [dataTask resume];
}



@end
