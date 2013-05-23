//
//  FYDWord.m
//  vocabulary
//
//  Created by Florian Kaiser on 23.05.13.
//  Copyright (c) 2013 Floyd UG (haftungsbeschränkt). All rights reserved.
//

#import "FYDVocable.h"

#import "FYDStage.h"

@interface FYDVocable ()

@end

@implementation FYDVocable

- (id)initWithNative:(NSString*)native AndForeign:(NSString*)foreign AndStage:(FYDStage*)stage;
{
    if (self = [super init])
    {
        self.native = native;
        self.foreign = foreign;
        self.stage = stage;
    }
    return self;
}

@end
