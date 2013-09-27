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

@property (strong, nonatomic) PanelViewController *rightViewController;

@end

@implementation SlidingPanelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.rightViewController = [[PanelViewController alloc] initWithNibName:@"PanelViewController" bundle:[NSBundle mainBundle]];
    [self addChildViewController:self.rightViewController];
    [self.view addSubview:self.rightViewController.view];
    
    self.contentViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle] ] instantiateViewControllerWithIdentifier:@"testController"];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

#pragma mark - PanelViewController Delegate Methods

- (void)panelDidMoveTo:(CGFloat)xCoordinate
{
    CGRect newFrame = self.rightViewController.view.frame;
    newFrame.origin.x = xCoordinate;
    self.rightViewController.view.frame = newFrame;
}

- (void)panelDidSnapToGuide:(PanelGuide)guide location:(CGFloat)location
{
    [self.delegate panelWillSnapToGuide:guide];
    
    [UIView animateWithDuration:0.5f animations:^{
        
        CGRect newFrame = self.rightViewController.view.frame;
        newFrame.origin.x = location;
        self.rightViewController.view.frame = newFrame;
        
    } completion:^(BOOL finished) {
        [self.delegate panelDidSnapToGuide:guide];
    }];
}

#pragma mark - Property Methods

- (void)setContentViewController:(UIViewController *)contentViewController
{
    _contentViewController = contentViewController;
    contentViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.rightViewController.contentPanelView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.rightViewController addChildViewController:self.contentViewController];
    [self.rightViewController.contentPanelView insertSubview:self.contentViewController.view atIndex:5];

    NSDictionary* viewsDict = @{@"contentView" : self.contentViewController.view};
    [self.rightViewController.contentPanelView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:0 metrics:nil views:viewsDict]];
    [self.rightViewController.contentPanelView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[contentView]|" options:0 metrics:nil views:viewsDict]];
}

- (void)setPanelOffset:(CGFloat)panelOffset
{
    if (panelOffset < 0)
    {
        self.rightViewController.panelOffset = 0;
        _panelOffset = 0;
    }
    else
    {
        self.rightViewController.panelOffset = panelOffset;
        _panelOffset = panelOffset;
    }
}

@end
