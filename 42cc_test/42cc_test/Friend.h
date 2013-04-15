//
//  Friend.h
//  42cc_test
//
//  Created by oles on 4/15/13.
//  Copyright (c) 2013 42cc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Friend : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * photo;
@property (nonatomic, retain) NSNumber * priority;
@property (nonatomic, retain) NSString * friend_id;


@end
