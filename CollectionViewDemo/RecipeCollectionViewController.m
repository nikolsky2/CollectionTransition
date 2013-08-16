//
//  RecipeCollectionViewController.m
//  CollectionViewDemo
//
//  Created by Simon on 9/1/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "RecipeCollectionViewController.h"
#import "RecipeViewCell.h"
#import "RecipeCollectionHeaderView.h"
#import "RecipeViewController.h"

#import <CoreGraphics/CoreGraphics.h>


#import <Social/Social.h>

@interface RecipeCollectionViewController ()

<UIViewControllerTransitioningDelegate,
UIViewControllerAnimatedTransitioning,
UIViewControllerContextTransitioning> {
    
    NSArray *recipeImages;
    BOOL shareEnabled;
    NSMutableArray *selectedRecipes;
    
    CGPoint collectionViewCellCenterRelativeToWindow;
    CGPoint newFromViewCenter;
    CGPoint newAnchorPoint;
}

@property (strong, nonatomic) RecipeViewController *destViewController;
@property (nonatomic) BOOL isPresentation;

@property (strong, nonatomic) UICollectionViewLayoutAttributes *attributes;



@end

@implementation RecipeCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Initialize recipe image array
    NSArray *mainDishImages = [NSArray arrayWithObjects:@"egg_benedict.jpg", @"full_breakfast.jpg", @"ham_and_cheese_panini.jpg", @"ham_and_egg_sandwich.jpg", @"hamburger.jpg", @"instant_noodle_with_egg.jpg", @"japanese_noodle_with_pork.jpg", @"mushroom_risotto.jpg", @"noodle_with_bbq_pork.jpg", @"thai_shrimp_cake.jpg", @"vegetable_curry.jpg", nil];
    NSArray *drinkDessertImages = [NSArray arrayWithObjects:@"angry_birds_cake.jpg", @"creme_brelee.jpg", @"green_tea.jpg", @"starbucks_coffee.jpg", @"white_chocolate_donut.jpg", nil];
    recipeImages = [NSArray arrayWithObjects:mainDishImages, drinkDessertImages, nil];
    
    UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(20, 0, 20, 0);
    
    selectedRecipes = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [recipeImages count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [[recipeImages objectAtIndex:section] count];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        RecipeCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        NSString *title = [[NSString alloc]initWithFormat:@"Products #%i", indexPath.section + 1];
        headerView.title.text = title;
        UIImage *headerImage = [UIImage imageNamed:@"header_banner.png"];
        headerView.backgroundImage.image = headerImage;
        
        reusableview = headerView;
    }
 
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];

        reusableview = footerview;
    }
        
    return reusableview;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    RecipeViewCell *cell = (RecipeViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    recipeImageView.image = [UIImage imageNamed:[recipeImages[indexPath.section] objectAtIndex:indexPath.row]];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo-frame-2.png"]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo-frame-selected.png"]];
    
    return cell;
}

/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showRecipePhoto"]) {
        NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
        RecipeViewController *destViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
        destViewController.recipeImageName = [recipeImages[indexPath.section] objectAtIndex:indexPath.row];
        [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
    }
}
*/

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.destViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RecipeViewControllerId"];
    self.destViewController.recipeImageName = [recipeImages[indexPath.section] objectAtIndex:indexPath.row];
    
    //id <UIViewControllerTransitioningDelegate> transitioningDelegate = self;
    self.destViewController.transitioningDelegate = self;
    
    //self.destViewController.modalPresentationStyle = UIModalPresentationCustom;
    //self.destViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    

    //self.destViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    //self.destViewController.edgesForExtendedLayout = UIRectEdgeTop;

    //RecipeViewCell *cell = (RecipeViewCell *)[self collectionView:self.collectionView cellForItemAtIndexPath:indexPath];
    
    
    [self presentViewController:self.destViewController animated:YES completion:nil];
    
    
    

    
    /*
    UIView *snapshotView = [destViewController.view snapshotViewAfterScreenUpdates:YES];
    UIView *resizableSnapshotView = [destViewController.view resizableSnapshotViewFromRect:destViewController.view.frame
                                                                        afterScreenUpdates:YES
                                                                        withCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    */
    /////////////////////////////////////////////////////////////////////////////////////////////
    
    
    //NSLog(@"didSelectItemAtIndexPath:%@", indexPath);
    
    self.attributes = [self.collectionView layoutAttributesForItemAtIndexPath:indexPath];
    
    if (shareEnabled) {
        NSString *selectedRecipe = [recipeImages[indexPath.section] objectAtIndex:indexPath.row];
        [selectedRecipes addObject:selectedRecipe];
    }
}

#pragma mark UIViewControllerTransitioningDelegate protocol

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.isPresentation = YES;
    
    //id <UIViewControllerContextTransitioning> context = self;
    //[self animateTransition:self];
    
    //return nil;
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.isPresentation = NO;
    
    //return nil;
    return self;
}

#pragma UIViewControllerAnimatedTransitioning protocol

// This is used for percent driven interactive transitions, as well as for container controllers that have companion animations that might need to
// synchronize with the main animation.
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5f;
}

/*
 
 
 Centring a CGAffineTransformScale around a given point
 http://stackoverflow.com/questions/17626217/centring-a-cgaffinetransformscale-around-a-given-point
 
 
 */
 

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    CGRect mainScreenBounds = [[UIScreen mainScreen] bounds];
    
    UIView *inView = [transitionContext containerView];
    UIView *toView = [[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey] view];
    UIView *fromView = [[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey] view];
    
    CGFloat toZoomScale = 6.f;
    CGFloat fromZoomScale = 3.2f;
    
    BOOL applyAlpha = YES;
    
    ////////////////////////////////////////////////////////////////////////////////////////////////
    if (self.isPresentation) {
        
        collectionViewCellCenterRelativeToWindow = [self.collectionView.window convertPoint:self.attributes.center fromView:self.collectionView];
        toView.transform = CGAffineTransformScale(toView.transform, 1.775/toZoomScale, 1/toZoomScale);
        toView.center = collectionViewCellCenterRelativeToWindow;
        
        if (applyAlpha)
            toView.alpha = 0;
        

        //////////////////////////////////////////////////////////////////////////////////////////
        
        CGFloat y = (collectionViewCellCenterRelativeToWindow.y)/CGRectGetHeight(mainScreenBounds)
        + ((collectionViewCellCenterRelativeToWindow.y-CGRectGetHeight(mainScreenBounds)/2.f)/2.f)/CGRectGetHeight(mainScreenBounds);
        
        CGFloat x = (collectionViewCellCenterRelativeToWindow.x)/CGRectGetWidth(mainScreenBounds)
        + ((collectionViewCellCenterRelativeToWindow.x-CGRectGetWidth(mainScreenBounds)/2.f)/2.f)/CGRectGetWidth(mainScreenBounds);
        
        newAnchorPoint = CGPointMake(x, y);
        
        /*
        50/320+
        (50-320/2)/2=
        0.15625-
         0.17
         
        */
        //////////////////////////////////////////////////////////////////////////////////////////
        
        
        fromView.layer.anchorPoint = newAnchorPoint;
        newFromViewCenter = CGPointMake(newAnchorPoint.x * CGRectGetWidth(fromView.bounds),
                                        newAnchorPoint.y * CGRectGetHeight(fromView.bounds));
        fromView.center = newFromViewCenter;
        
        //////////////////////////////////////////////////////////////////////////////////////////
        //Card Rect Helper
        /*
        CGRect cardInWindowRect = [self.collectionView.window convertRect:self.attributes.frame fromView:self.collectionView];
        UIView *cardInWindowView = [[UIView alloc] initWithFrame:cardInWindowRect];
        cardInWindowView.backgroundColor = [UIColor redColor];
        cardInWindowView.alpha = 0.2;
        [self.collectionView.window addSubview:cardInWindowView];
        */
        //////////////////////////////////////////////////////////////////////////////////////////
        
        NSLog(@"newAnchorPoint=%@", NSStringFromCGPoint(newAnchorPoint));
        //////////////////////////////////////////////////////////////////////////////////////////
        
        [inView addSubview:toView];
        
        
    } else {
        toView.layer.anchorPoint = newAnchorPoint;
        toView.center = newFromViewCenter;
        
        toView.transform = CGAffineTransformScale(toView.transform, fromZoomScale, fromZoomScale);
        //toView.center = newFromViewCenter;
        
        [inView insertSubview:toView belowSubview:fromView];
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
                         if (self.isPresentation) {
                             
                             toView.transform = CGAffineTransformScale(toView.transform, toZoomScale/1.775, toZoomScale);
                             toView.center = inView.center;
                             
                             //*
                             [UIView animateWithDuration:0.4
                                                   delay:0.1
                                                 options:UIViewAnimationCurveEaseInOut
                                              animations:^{
                                                  if (applyAlpha) toView.alpha = 1;}
                                              completion:^(BOOL finished) {}];
                              //*/
                             
                             
                             fromView.transform = CGAffineTransformScale(fromView.transform, fromZoomScale, fromZoomScale);
                             
                         } else {
                             fromView.center = collectionViewCellCenterRelativeToWindow;
                             fromView.transform = CGAffineTransformScale(fromView.transform, 1.775/toZoomScale, 1/toZoomScale);
                             
                             
                             [UIView animateWithDuration:0.3
                                                   delay:0.2
                                                 options:UIViewAnimationCurveEaseInOut
                                              animations:^{
                                                  if (applyAlpha) fromView.alpha = 0;}
                                              completion:^(BOOL finished) {}];
                                                  
                             
                             [self setAnchorPoint:CGPointMake(0.5, 0.5) forView:toView];
                             
                             toView.center = inView.center;
                             toView.transform = CGAffineTransformScale(toView.transform, 1/fromZoomScale, 1/fromZoomScale);
                         }
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:finished];
                     }];
}




- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didDeselectItemAtIndexPath:");
    
    if (shareEnabled) {
        NSString *deSelectedRecipe = [recipeImages[indexPath.section] objectAtIndex:indexPath.row];
        [selectedRecipes removeObject:deSelectedRecipe];
    }
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if (shareEnabled) {
        return NO;
    } else {
        return YES;
    }
}

- (IBAction)shareButtonTouched:(id)sender {
    if (shareEnabled) {
        
        // Post selected photos to Facebook
        if ([selectedRecipes count] > 0) {
            if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
                SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                
                [controller setInitialText:@"Check out my recipes!"];
                for (NSString *recipePhoto in selectedRecipes) {
                    [controller addImage:[UIImage imageNamed:recipePhoto]];
                }
                
                [self presentViewController:controller animated:YES completion:Nil];
            }
        }
        
        // Deselect all selected items
        for(NSIndexPath *indexPath in self.collectionView.indexPathsForSelectedItems) {
            [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
        }
        
        // Remove all items from selectedRecipes array
        [selectedRecipes removeAllObjects];
        
        // Change the sharing mode to NO
        shareEnabled = NO;
        self.collectionView.allowsMultipleSelection = NO;
        self.shareButton.title = @"Share";
        [self.shareButton setStyle:UIBarButtonItemStylePlain];
        
    } else {
        
        // Change shareEnabled to YES and change the button text to DONE
        shareEnabled = YES;
        self.collectionView.allowsMultipleSelection = YES;
        self.shareButton.title = @"Upload";
        [self.shareButton setStyle:UIBarButtonItemStyleDone];
        
    }
}


#pragma mark UIViewControllerContextTransitioning protocol

// The view in which the animated transition should take place.
- (UIView *)containerView
{
    //UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 20, 20)];
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    
    return containerView;
    
    //return self.destViewController.view;
}

// Most of the time this is YES. For custom transitions that use the new UIModalPresentationCustom
// presentation type we will invoke the animateTransition: even though the transition should not be
// animated. This allows the custom transition to add or remove subviews to the container view.
- (BOOL)isAnimated
{
    return YES;
}

- (BOOL)isInteractive; // This indicates whether the transition is currently interactive.
{
    return NO;
}

- (BOOL)transitionWasCancelled
{
    return NO;
}

- (UIModalPresentationStyle)presentationStyle
{
    return UIModalPresentationCustom;
}

// It only makes sense to call these from an interaction controller that
// conforms to the UIViewControllerInteractiveTransitioning protocol and was
// vended to the system by a container view controller's delegate or, in the case
// of a present or dismiss, the transitioningDelegate.
- (void)updateInteractiveTransition:(CGFloat)percentComplete
{
    
}
- (void)finishInteractiveTransition
{
    
}
- (void)cancelInteractiveTransition
{
    
}

// This must be called whenever a transition completes (or is cancelled.)
// Typically this is called by the object conforming to the
// UIViewControllerAnimatedTransitioning protocol that was vended by the transitioning
// delegate.  For purely interactive transitions it should be called by the
// interaction controller. This method effectively updates internal view
// controller state at the end of the transition.
- (void)completeTransition:(BOOL)didComplete
{
    
}

// Currently only two keys are defined by the
// system - UITransitionContextToViewControllerKey, and
// UITransitionContextFromViewControllerKey.
- (UIViewController *)viewControllerForKey:(NSString *)key
{
    if (self.isPresentation) {
        if ([key isEqualToString:UITransitionContextFromViewControllerKey]) {
            return self.navigationController;
        }
        if ([key isEqualToString:UITransitionContextToViewControllerKey]) {
            return self.destViewController;
        }
    }
    
    return nil;
}

// The frame's are set to CGRectZero when they are not known or
// otherwise undefined.  For example the finalFrame of the
// fromViewController will be CGRectZero if and only if the fromView will be
// removed from the window at the end of the transition. On the other
// hand, if the finalFrame is not CGRectZero then it must be respected
// at the end of the transition.
- (CGRect)initialFrameForViewController:(UIViewController *)vc
{
    return self.view.frame;
}
- (CGRect)finalFrameForViewController:(UIViewController *)vc
{
    return self.view.frame;
}

//////////////////////////////////////////////////////////////////////////////////////////////////

-(void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x, view.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x, view.bounds.size.height * view.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
    
    CGPoint position = view.layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    view.layer.position = position;
    view.layer.anchorPoint = anchorPoint;
}

//////////////////////////////////////////////////////////////////////////////////////////////////

@end
