//
//  Algorithm.h
//  SolveTheCube2
//
//  Created by Tianyu Liu on 5/4/13.
//  Copyright (c) 2013 Tianyu Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Algorithm : NSObject

@property (strong, nonatomic) NSString *algorithmString;
@property (strong, nonatomic) NSString *imageName;

- (id) initWithString:(NSString *)aString imageName:(NSString *)aImageName;

+ (NSDictionary *) convertToDictionary:(Algorithm *)anAlgorithm;


@end
