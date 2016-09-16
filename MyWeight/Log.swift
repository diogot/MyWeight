//
//  Log.swift
//  MyWeight
//
//  Created by Diogo Tridapalli on 9/13/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import Foundation

public struct Log {

    public static func info(
        _ items: Any...,
        functionName: String = #function,
        fileName: String = #file,
        lineNumber: Int = #line)
    {
        log(items,
            functionName: functionName,
            fileName: fileName,
            lineNumber: lineNumber)
    }

    public static func debug(
        _ items: Any...,
        functionName: String = #function,
        fileName: String = #file,
        lineNumber: Int = #line)
    {
        #if DEBUG
            log(items,
                functionName: functionName,
                fileName: fileName,
                lineNumber: lineNumber)
        #endif
    }

    private static func log(
        _ items: [Any],
        functionName: String,
        fileName: String,
        lineNumber: Int)
    {
        let url = NSURL(fileURLWithPath: fileName)
        let lastPathComponent = url.lastPathComponent ?? fileName
        #if DEBUG
            print("[\(lastPathComponent):\(lineNumber)] \(functionName):",
                separator: "",
                terminator: " ")
        #endif
        for item in items {
            print(item, separator: "", terminator: "")
        }
        print("")
    }

}
