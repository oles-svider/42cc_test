//
//  People.h
//  42cc_test
//
//  Created by oles on 3/30/13.
//  Copyright (c) 2013 42cc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface People : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * photo;
@property (nonatomic, retain) NSDate * birth;
@property (nonatomic, retain) NSString * bio;
@property (nonatomic, retain) NSString * surname;
@property (nonatomic, retain) NSString * contacts;

@end
