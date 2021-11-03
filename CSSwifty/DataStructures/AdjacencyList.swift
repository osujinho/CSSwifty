//
//  AdjacencyList.swift
//  CSSwifty
//
//  Created by Michael Osuji on 11/3/21.
//

import Foundation

public class Vertex<T: Comparable & Hashable>: Comparable & Hashable, CustomStringConvertible {
    var value: T
    
    public init(value: T) {
        self.value = value
    }
    
    public static func == (lhs: Vertex<T>, rhs: Vertex<T>) -> Bool {
        return lhs.value == rhs.value
    }
    
    public static func < (lhs: Vertex<T>, rhs: Vertex<T>) -> Bool {
        return lhs.value < rhs.value
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
    
    public var description: String { return "\(value)" }
}

public enum EdgeType {
    case directed, undirected
}

public class Edge<T: Comparable & Hashable> {
    public var source: Vertex<T>
    public var destination: Vertex<T>
    public let weight: Double
    
    public init(source: Vertex<T>, destination: Vertex<T>, weight: Double) {
        self.source = source
        self.destination = destination
        self.weight = weight
    }
}

public class Graph<T: Comparable & Hashable> {
    public init(graphDict: [Vertex<T> : [Edge<T>]] = [:]) {
        self.graphDict = graphDict
    }
    
    public var graphDict: [Vertex<T> : [Edge<T>]] = [:]
    //public init() {}
    
    public func createVertex(value: T) -> Vertex<T> {
        let vertex = Vertex(value: value)
        
        if graphDict[vertex] == nil {
            graphDict[vertex] = []
        }
        return vertex
    }
    
    public var vertexCount: Int {
        return graphDict.count
    }
    
    public var isCyclic: Bool {
        var stack = Stack<Vertex<T>>()
        var visitedVertices: Set<Vertex<T>> = []
        
        guard let source = graphDict.keys.first(where: { graphDict[$0] != nil }) else { return false }
        
        stack.push(value: source)
        
        while let currentVertex = stack.pop() {
            if visitedVertices.contains(currentVertex) {
                continue
            }
            
            visitedVertices.insert(currentVertex)
            
            if let neighbors = getEdges(source: currentVertex) {
                
                for neighbor in neighbors {
                    stack.push(value: neighbor.destination)
                    
                    if visitedVertices.contains(neighbor.destination) {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    fileprivate func directedEdge(source: Vertex<T>, destination: Vertex<T>, weight: Double) {
        let edge = Edge(source: source, destination: destination, weight: weight)
        graphDict[source]?.append(edge)
    }
    
    public func addEdge(type: EdgeType, source: Vertex<T>, destination: Vertex<T>, weight: Double) {
        switch type {
        case .directed:
            directedEdge(source: source, destination: destination, weight: weight)
        case .undirected:
            directedEdge(source: source, destination: destination, weight: weight)
            directedEdge(source: destination, destination: source, weight: weight)
        }
    }
    
    public func getWeight(source: Vertex<T>, destination: Vertex<T>) -> Double? {
        guard let edges = graphDict[source] else {
            return nil
        }

        for edge in edges {
            if edge.destination == destination {
                return edge.weight
            }
        }
        return nil
    }
    
    public func lowestWeight() -> Double {
        var minWeight = 0.0
        var edgesWeight = [Double]()
        
        for edges in graphDict.values {
            edgesWeight.append(contentsOf: edges.map { $0.weight })
        }
        
        if let min = edgesWeight.min() {
            minWeight = min
        }
        return minWeight
    }
    
    public func lowestEdge() -> Edge<T>? {
        var minEdge: Edge<T>?
        
        for edges in graphDict.values {
            for edge in edges {
                if edge.weight == lowestWeight() {
                    minEdge = edge
                }
            }
        }
        return minEdge
    }
    
    public func deleteEdge(edge: Edge<T>) {
        for (vertex, edges) in graphDict {
            if vertex == edge.source {
                let newEdges = edges.filter { $0.destination != edge.destination }
                graphDict.updateValue(newEdges, forKey: vertex)
            }
        }
    }
    
    public func getEdges(source: Vertex<T>) -> [Edge<T>]? {
        guard let edges = graphDict[source] else { return nil }
        return edges
    }
    
    public func allVertices() -> Set<Vertex<T>> {
        return Set(graphDict.keys.map { $0 })
    }
    
    public func allEdges() -> Set<Vertex<T>> {
        let sources = graphDict.values.flatMap{ $0 }
        return Set(sources.map { $0.destination })
    }
}
