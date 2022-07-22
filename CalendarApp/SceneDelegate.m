//
//  SceneDelegate.m
//  Calendar
//
//  Created by Angelina Zhang on 7/5/22.
//

#import "SceneDelegate.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *homeTabBarController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
        self.window.rootViewController = homeTabBarController;
    } else {
        // Is already showing login view at launch
    }
}

- (void)sceneDidEnterBackground:(UIScene *)scene {
    [(AppDelegate *)UIApplication.sharedApplication.delegate saveContext];
}


@end
