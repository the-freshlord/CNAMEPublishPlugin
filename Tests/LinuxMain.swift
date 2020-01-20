/**
*  CNAME file generator plugin for Publish
*  Copyright (c) Manny Guerrero 2020
*  MIT license, see LICENSE file for details
*/

import XCTest

import CNAMEPublishPluginTests

var tests = [XCTestCaseEntry]()
tests += CNAMEPublishPluginTests.allTests()
XCTMain(tests)
