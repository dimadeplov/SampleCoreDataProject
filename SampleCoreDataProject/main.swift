//
//  main.swift
//  SampleCoreDataProject
//
//  Created by Dmitry Deplov on 04/08/2019.
//  Copyright © 2019 Dmitry Deplov. All rights reserved.
//

import UIKit

let appDelegateClass: AnyClass = NSClassFromString("TestingAppDelegate") ?? AppDelegate.self

UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(appDelegateClass))

