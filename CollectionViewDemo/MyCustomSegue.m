//
//  MyCustomSegue.m
//  CollectionViewDemo
//
//  Created by Sergey Nikolsky on 9/08/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "MyCustomSegue.h"

@implementation MyCustomSegue

/*
- (void)perform {
    UIViewController *src = (UIViewController *)self.sourceViewController;
    UIViewController *dst = (UIViewController *)self.destinationViewController;
    
    [UIView transitionWithView:src.navigationController.view
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionFlipFromLeft | UIViewAnimationOptionCurveEaseOut
                    animations:^{
                        [src.navigationController pushViewController:dst animated:NO];
                    }
                    completion:NULL];
}
*/

- (void)perform {
    
    UIViewController *src = (UIViewController *) self.sourceViewController;
    UIViewController *dst = (UIViewController *) self.destinationViewController;
    
    id <UIViewControllerTransitioningDelegate> transitioningDelegate;
    dst.modalPresentationStyle = UIModalPresentationCustom;
    
    [dst setTransitioningDelegate: transitioningDelegate];
    [src presentViewController:dst animated:YES completion:nil];
    
}

@end
