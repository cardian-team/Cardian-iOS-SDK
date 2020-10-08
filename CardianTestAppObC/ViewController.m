//
//  ViewController.m
//  CardianTestAppObC
//
//  Created by Mitchell Sweet on 9/19/20.
//  Copyright © 2020 Curaegis. All rights reserved.
//

#import "ViewController.h"
#import <Cardian/Cardian.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [CRDConnect connectWithCompletion:^(BOOL success) {
        NSLog(@"done");
    }];
}


@end
