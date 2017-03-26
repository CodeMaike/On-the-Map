//
//  GCDBlackBox.swift
//  On the Map
//
//  Created by Maike Schmidt on 02/03/2017.
//  Copyright © 2017 Maike Schmidt. All rights reserved.
//

import Foundation

func performUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
