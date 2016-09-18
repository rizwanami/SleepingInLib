//
//  GCDBlackBox.swift
//
//  Created by Jarrod Parkes on 11/3/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: @escaping () -> Void) {
    dispatch_get_main_queue().asynchronously() {
        updates()
    }
}
