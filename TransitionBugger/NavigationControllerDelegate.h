//
//  NavigationControllerDelegate.h
//  TransitionBugger
//
//  Created by Tim Carr on 7/21/15.
//  Copyright (c) 2015 Tim Carr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "InteractiveAnimator.h"

@interface NavigationControllerDelegate : NSObject <UINavigationControllerDelegate>


@property (nonatomic, strong) InteractiveAnimator *myAnimator;


@end
