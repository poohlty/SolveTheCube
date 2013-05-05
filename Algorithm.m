//
//  Algorithm.m
//  SolveTheCube2
//
//  Created by Tianyu Liu on 5/4/13.
//  Copyright (c) 2013 Tianyu Liu. All rights reserved.
//

#import "Algorithm.h"

@implementation Algorithm

- (id)init {
    self = [super init];
    return self;
}

- (id)initWithString:(NSString *)aString imageName:(NSString *)aImageName {
    self = [super init];
    if(self) {
        self.algorithmString = aString;
        self.imageName = aImageName;
    }
    return self;
}

+ (NSDictionary *) convertToDictionary:(Algorithm *)anAlgorithm{
    NSDictionary *algorthmDict = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[anAlgorithm imageName], [anAlgorithm algorithmString], nil] forKeys:[NSArray arrayWithObjects:@"imageName",@"algorithmString",nil]];
    return algorthmDict;
}

@end
