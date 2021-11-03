//
//  Stack.swift
//  CSSwifty
//
//  Created by Michael Osuji on 11/3/21.
//

import Foundation

public struct Stack<T: Hashable> {
    public init(collections: [T] = []) {
        self.collections = collections
    }
    
    fileprivate var collections: [T] = []
    
    public var isEmpty: Bool {
        return collections.isEmpty
    }
    
    mutating public func push(value: T) {
        collections.append(value)
    }
    
    @discardableResult mutating public func pop() -> T? {
        collections.popLast()
    }
    
    mutating public func peek() -> T? {
        collections.last
    }
}
