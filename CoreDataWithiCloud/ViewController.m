//
//  ViewController.m
//  CoreDataWithiCloud
//
//  Created by Krzysztof Deneka on 02.07.2014.
//  Copyright (c) 2014 blastar. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Contacts.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    items = [[NSArray alloc] init];
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(contentDidChange:) name:NSPersistentStoreDidImportUbiquitousContentChangesNotification object:self.managedObjectContext.persistentStoreCoordinator];
    
    [self createEntry];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createEntry {
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm:ss"];
    NSString *theTime = [timeFormat stringFromDate:[[NSDate alloc] init]];
    
    Contacts* entry = [NSEntityDescription insertNewObjectForEntityForName:@"Contacts"
                                                    inManagedObjectContext:self.managedObjectContext];
    entry.name = theTime;
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
}

-(NSArray*)getAllRecords
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Contacts"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError* error;
    
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return fetchedRecords;
}

- (void)contentDidChange:(NSNotification *)notification {

    [self.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
    NSDictionary *changes = notification.userInfo;
    NSMutableSet *allChanges = [NSMutableSet new];
    [allChanges unionSet:changes[NSInsertedObjectsKey]];
    [allChanges unionSet:changes[NSUpdatedObjectsKey]];
    [allChanges unionSet:changes[NSDeletedObjectsKey]];
    
    for (NSManagedObjectID *objID in allChanges) {
        Contacts *item = (Contacts *)[self.managedObjectContext objectWithID:objID];
        NSLog(@"item = %@", item.name);
    }
    items = [self getAllRecords];
}

@end
