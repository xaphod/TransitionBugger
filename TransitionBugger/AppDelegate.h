//
//  AppDelegate.h
//  TransitionBugger
//
//  Created by Tim Carr on 7/16/15.
//  Copyright (c) 2015 Tim Carr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationControllerDelegate.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@property (strong, nonatomic) NavigationControllerDelegate *navDel;

@end

