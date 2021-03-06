//
//  THViewController.m
//  THPinViewControllerExample
//
//  Created by Thomas Heß on 19.4.14.
//  Copyright (c) 2014 Thomas Heß. All rights reserved.
//

#import "THViewController.h"
#import "THPinViewController.h"

@interface THViewController () <THPinViewControllerDelegate>

@property (nonatomic, strong) UIButton *contentButton;
@property (nonatomic, copy) NSString *correctPin;
@property (nonatomic, assign) NSUInteger remainingPinEntries;

@end

@implementation THViewController

static const NSUInteger THNumberOfPinEntries = 6;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.correctPin = @"1234";
    self.remainingPinEntries = THNumberOfPinEntries;

    self.contentButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.contentButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentButton setTitle:@"Enter PIN" forState:UIControlStateNormal];
    [self.contentButton addTarget:self action:@selector(showPinView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.contentButton];
    
    NSDictionary *views = @{ @"contentButton" : self.contentButton };
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentButton]|" options:0
                                                                      metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentButton]|" options:0
                                                                      metrics:nil views:views]];
}

#pragma mark - User Interaction

- (void)showPinView:(id)sender
{
    THPinViewController *pinViewController = [[THPinViewController alloc] initWithDelegate:self];
    pinViewController.backgroundColor = [UIColor lightGrayColor];
    pinViewController.promptTitle = @"Enter PIN";
    pinViewController.promptColor = [UIColor whiteColor];
    pinViewController.view.tintColor = [UIColor whiteColor];
    [self presentViewController:pinViewController animated:YES completion:nil];
}

- (void)logout:(id)sender
{
    self.remainingPinEntries = THNumberOfPinEntries;
    
    [self.contentButton setTitle:@"Enter PIN" forState:UIControlStateNormal];
    [self.contentButton removeTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentButton addTarget:self action:@selector(showPinView:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - THPinViewControllerDelegate

- (NSUInteger)pinLengthForPinViewController:(THPinViewController *)pinViewController
{
    return 4;
}

- (BOOL)pinViewController:(THPinViewController *)pinViewController isPinValid:(NSString *)pin
{
    if ([pin isEqualToString:self.correctPin]) {
        return YES;
    } else {
        self.remainingPinEntries--;
        return NO;
    }
}

- (BOOL)userCanRetryInPinViewController:(THPinViewController *)pinViewController
{
    return (self.remainingPinEntries > 0);
}

- (void)incorrectPinEnteredInPinViewController:(THPinViewController *)pinViewController
{
    if (self.remainingPinEntries > THNumberOfPinEntries / 2) {
        return;
    }
    
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:@"Incorrect PIN"
                               message:(self.remainingPinEntries == 1 ?
                                        @"You can try again once." :
                                        [NSString stringWithFormat:@"You can try again %lu times.",
                                         (unsigned long)self.remainingPinEntries])
                              delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];

}

- (void)pinViewControllerWillDismissAfterPinEntryWasSuccessful:(THPinViewController *)pinViewController
{
    [self.contentButton setTitle:@"This is the secret content / Logout" forState:UIControlStateNormal];
    [self.contentButton removeTarget:self action:@selector(showPinView:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentButton addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)pinViewControllerWillDismissAfterPinEntryWasUnsuccessful:(THPinViewController *)pinViewController
{
    self.remainingPinEntries = THNumberOfPinEntries;
    
    [self.contentButton setTitle:@"Access Denied / Enter PIN" forState:UIControlStateNormal];
    [self.contentButton removeTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentButton addTarget:self action:@selector(showPinView:) forControlEvents:UIControlEventTouchUpInside];
}

@end
