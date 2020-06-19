import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(FGED_MathematicsTests.allTests),
    ]
}
#endif
