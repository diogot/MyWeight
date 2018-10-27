//
//  UITableViewExtensionsTests.swift
//  MyWeight
//
//  Created by Bruno Koga on 22/06/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import XCTest
@testable import MyWeight

class InvarianteTableViewCell: UITableViewCell { }

class UITableViewExtensionsTests: XCTestCase {
    fileprivate var tableView: UITableView!
    
    override func setUp() {
        super.setUp()
        tableView = UITableView()
    }
    
    override func tearDown() {
        tableView = nil
        super.tearDown()
    }
    
    func testDefaultReuseIdentifier() {
        var cellClass = UITableViewCell.self
        var cellDefaultReuseIdentifier = cellClass.defaultReuseIdentifier
        var expectedDefaultReuseIdentifier = "UITableViewCell"
        XCTAssertEqual(cellDefaultReuseIdentifier, expectedDefaultReuseIdentifier)
        
        cellClass = InvarianteTableViewCell.self
        cellDefaultReuseIdentifier = cellClass.defaultReuseIdentifier
        expectedDefaultReuseIdentifier = "InvarianteTableViewCell"
        XCTAssertEqual(cellDefaultReuseIdentifier, expectedDefaultReuseIdentifier)
    }
    
    func testDefaultNibName() {
        var cellClass = UITableViewCell.self
        var cellDefaultReuseIdentifier = cellClass.defaultNibName
        var expectedDefaultNibName = "UITableViewCell"
        XCTAssertEqual(cellDefaultReuseIdentifier, expectedDefaultNibName)
        
        cellClass = InvarianteTableViewCell.self
        cellDefaultReuseIdentifier = cellClass.defaultNibName
        expectedDefaultNibName = "InvarianteTableViewCell"
        XCTAssertEqual(cellDefaultReuseIdentifier, expectedDefaultNibName)
    }
    
    func testRegisterCellClassWithDefaultReuseIdentifier() {
        var cellClass = UITableViewCell.self
        var cell = tableView.dequeueReusableCell(withIdentifier: cellClass.defaultReuseIdentifier)
        XCTAssertNil(cell)
        tableView.registerCellClass(cellClass)
        cell = tableView.dequeueReusableCell(withIdentifier: cellClass.defaultReuseIdentifier)
        XCTAssertNotNil(cell)
        XCTAssertTrue(type(of: cell!) == UITableViewCell.self)
        cell = tableView.dequeueReusableCell(withIdentifier: "UnknownIdentifier")
        XCTAssertNil(cell)
        
        cellClass = InvarianteTableViewCell.self
        cell = tableView.dequeueReusableCell(withIdentifier: cellClass.defaultReuseIdentifier)
        XCTAssertNil(cell)
        tableView.registerCellClass(cellClass)
        cell = tableView.dequeueReusableCell(withIdentifier: cellClass.defaultReuseIdentifier)
        XCTAssertNotNil(cell)
        XCTAssertTrue(type(of: cell!) == InvarianteTableViewCell.self)
        cell = tableView.dequeueReusableCell(withIdentifier: "UnknownIdentifier")
        XCTAssertNil(cell)
    }
    
    func testRegisterCellClassWithCustomReuseIdentifier() {
        var cellClass = UITableViewCell.self
        var customIdentifier = "Abobrinha"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellClass.defaultReuseIdentifier)
        XCTAssertNil(cell)
        tableView.registerCellClass(cellClass, forCellReuseIdentifier: customIdentifier)
        cell = tableView.dequeueReusableCell(withIdentifier: cellClass.defaultReuseIdentifier)
        XCTAssertNil(cell)
        cell = tableView.dequeueReusableCell(withIdentifier: customIdentifier)
        XCTAssertTrue(type(of: cell!) == UITableViewCell.self)
        
        cellClass = InvarianteTableViewCell.self
        customIdentifier = "www.invariante.com"
        cell = tableView.dequeueReusableCell(withIdentifier: cellClass.defaultReuseIdentifier)
        XCTAssertNil(cell)
        tableView.registerCellClass(cellClass, forCellReuseIdentifier: customIdentifier)
        cell = tableView.dequeueReusableCell(withIdentifier: cellClass.defaultReuseIdentifier)
        XCTAssertNil(cell)
        cell = tableView.dequeueReusableCell(withIdentifier: customIdentifier)
        XCTAssertTrue(type(of: cell!) == InvarianteTableViewCell.self)
        cell = tableView.dequeueReusableCell(withIdentifier: "UnknownIdentifier")
        XCTAssertNil(cell)
    }
}
