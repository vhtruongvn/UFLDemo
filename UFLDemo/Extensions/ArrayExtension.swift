//
//  ArrayExtension.swift
//  UFLDemo
//
//  Created by Truong Vo on 1/7/18.
//  Copyright © 2018 Truong Vo. All rights reserved.
//

import Foundation

extension Array {
    
    func groupBy<G: Hashable>(groupClosure: (Element) -> G) -> [[Element]] {
        var groups = [[Element]]()
        
        for element in self {
            let key = groupClosure(element)
            var active = Int()
            var isNewGroup = true
            var array = [Element]()
            
            for (index, group) in groups.enumerated() {
                let firstKey = groupClosure(group[0])
                if firstKey == key {
                    array = group
                    active = index
                    isNewGroup = false
                    break
                }
            }
            
            array.append(element)
            
            if isNewGroup {
                groups.append(array)
            }
            else {
                groups.remove(at: active)
                groups.insert(array, at: active)
            }
        }
        
        return groups
    }
    
}
