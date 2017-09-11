//
//  NotPastableTextField.m
//  searchText
//
//  Created by User on 15.02.17.
//  Copyright © 2017 yevgen.gromsky. All rights reserved.
//

#import "NotPastableTextField.h"

@implementation NotPastableTextField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(paste:))
        return NO;
    return [super canPerformAction:action withSender:sender];
}

@end
