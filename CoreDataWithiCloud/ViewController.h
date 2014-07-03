//
//  ViewController.h
//  CoreDataWithiCloud
//
//  Created by Krzysztof Deneka on 02.07.2014.
//  Copyright (c) 2014 blastar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    NSFileManager* fileManager;
    BOOL isSignedIntoICloud;
    NSArray* items;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
