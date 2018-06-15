//
//  VeryBasicHelperTests.swift
//  VeryBasicHelperTests
//
//  Created by Bao Lei on 10/14/15.
//  Copyright © 2018 Bao Lei. All rights reserved.
//

import XCTest
@testable import VeryBasicHelper

class A : JsonObject {
    @objc var b = 0
    @objc var c = CGFloat(0)
    @objc var d = ""
    @objc var e = E(dict:nil)
}

class E : JsonObject {
    @objc var f = 0
    @objc var g = ""
}

class TreeNode : JsonObject {
    @objc var value = 0
    @objc var nodes = [TreeNode]()
    
    override func hydrate(_ dict: Any?, arraySetter: ((_ name: String, _ array: [[String : Any]]) -> Void)?) {
        super.hydrate(dict) { (name, array) -> Void in
            if name == "nodes" {
                self.nodes = array.map {TreeNode(dict: $0)}
            }
        }
    }
}

enum Position : String {
    case Right = "right"
    case Left = "left"
}

class H : JsonObject {
    @objc var p = ""
    var pValue = Position.Right
    
    override func hydrate(_ dict: Any?, arraySetter: ((_ name: String, _ array: [[String : Any]]) -> Void)?) {
        super.hydrate(dict, arraySetter: arraySetter)
        pValue = Position(rawValue: p) ?? pValue
    }
}

class VeryBasicHelperTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testJsonObject() {
        let a = A(dict: ["x":1, "b":2, "c":3, "d":"4", "e":["f" : 5]])
        assert(a.b == 2)
        assert(a.c == 3.0)
        assert(a.d == "4")
        assert(a.e.f == 5)
        assert(a.e.g == "")
        
        let node = TreeNode(dict: ["value":1, "nodes":[["value": 2] , ["value":3, "nodes":[["value": 4], ["value":5]]  ]] ])
        assert(node.value == 1)
        assert(node.nodes.first?.value == 2)
        assert(node.nodes.last?.value == 3)
        assert(node.nodes.last?.nodes.first?.value == 4)
        assert(node.nodes.last?.nodes.last?.value == 5)
        
        let h = H(dict: ["p":"left"])
        //Log("h.pValue = \(h.pValue)")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
