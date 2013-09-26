//
//  ViewController.m
//  SlidingPanel
//
//  Created by Ivelin Ivanov on 9/25/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import "SlidingPanelViewController.h"
#import "PanelViewController.h"

@interface SlidingPanelViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *panelLeftConstraint;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (strong, nonatomic) PanelViewController *panelViewController;

@end

@implementation SlidingPanelViewController
- (id)initWithCoder:(NSCoder *)aDecoder
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SlidingPanel" bundle:[NSBundle mainBundle]];
    
    return [storyboard instantiateViewControllerWithIdentifier:@"slidingPanelController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - PanelViewController Delegate Methods

- (void)panelDidMoveTo:(CGFloat)xCoordinate
{
    self.panelLeftConstraint.constant = xCoordinate;
}

- (void)panelDidSnapToGuide:(PanelGuide)guide location:(CGFloat)location
{
    [self.delegate panelWillSnapToGuide:guide];
    
    [UIView animateWithDuration:0.5f animations:^{
        self.panelLeftConstraint.constant = location;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.delegate panelDidSnapToGuide:guide];
    }];
}

#pragma mark - Segue Methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"panelSegue"])
    {
        self.panelViewController = (PanelViewController *)segue.destinationViewController;
        self.panelViewController.delegate = self;
    }
}


@end
