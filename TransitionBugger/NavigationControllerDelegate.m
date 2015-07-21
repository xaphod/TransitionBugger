//
//  NavigationControllerDelegate.m
//  TransitionBugger
//
//  Created by Tim Carr on 7/21/15.
//  Copyright (c) 2015 Tim Carr. All rights reserved.
//

#import "NavigationControllerDelegate.h"

@implementation NavigationControllerDelegate


- (instancetype)init {
    self = [super init];
    if (self) {
        _myAnimator = [[InteractiveAnimator alloc] init];
    }
    return self;
}

#pragma mark - UINavigationController Delegate methods

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    NSAssert(self.myAnimator, @"ERROR");
    return self.myAnimator;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    
    NSAssert(self.myAnimator, @"ERROR");
    return self.myAnimator;
}


@end
