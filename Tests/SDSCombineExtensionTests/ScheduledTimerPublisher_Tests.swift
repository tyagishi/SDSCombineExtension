//
//  CustomTimerTests.swift
//
//  Created by : Tomoaki Yagishita on 2022/11/25
//  © 2022  SmallDeskSoftware
//
@testable import SDSCombineExtension
import XCTest
import SDSXCTestExtension

final class ScheduledTimerPublisher_Tests: XCTestCase {

    func test_ScheduledTimerPublisher_after_withoutRepeat() async throws {
        let trigger = Date().advanced(by: 5)
        let sut = ScheduledTimerPublisher(after: .seconds(5))

        let receiver = PublisherReceiver(sut)

        let expec = expectation(description: "Expectation")

        let check = sut.sink { date in
            expec.fulfill()
        }
        wait(for: [expec], timeout: 10)

        let value = try XCTUnwrap(receiver.lastValue)
        XCTAssertEqual(value.timeIntervalSinceReferenceDate, trigger.timeIntervalSinceReferenceDate, accuracy: 0.1)
    }

}
