//
//  ScheduledTimerPublisher.swift
//
//  Created by : Tomoaki Yagishita on 2022/11/26
//  © 2022  SmallDeskSoftware
//

import Foundation
import Combine
import SDSSwiftExtension

public class ScheduledTimerPublisher: Publisher {
    public typealias Output = Date
    public typealias Failure = Never

    let internalPublisher = PassthroughSubject<Date,Never>()

    let initialTrigger: Date
    let repeatDuration: Duration?
    var cancellable: AnyCancellable? = nil

    public init(fire: Date, repeatDuration: Duration? = nil) {
        self.initialTrigger = fire
        self.repeatDuration = repeatDuration
        let timer = Timer.init(fire: initialTrigger, interval: 100, repeats: false) { timer in
            self.internalPublisher.send(Date())
            timer.invalidate()
            self.setupRepeat()
        }
        RunLoop.current.add(timer, forMode: .common)
    }

    public init(after: Duration, repeatDuration: Duration? = nil) {
        self.initialTrigger = Date().advanced(by: after.timeInterval)
        self.repeatDuration = repeatDuration
        let timer = Timer.init(fire: initialTrigger, interval: 100, repeats: false) { timer in
            self.internalPublisher.send(Date())
            timer.invalidate()
            self.setupRepeat()
        }
        RunLoop.current.add(timer, forMode: .common)
    }

    func setupRepeat() {
        if let repeatDuration {
            cancellable = Timer.TimerPublisher(interval: repeatDuration.timeInterval, runLoop: .main, mode: .common)
                .autoconnect()
                .sink { newDate in
                    self.internalPublisher.send(newDate)
                }
        }
    }
    public func stop() {
        cancellable?.cancel()
        cancellable = nil
    }

    public func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Date == S.Input {
        internalPublisher.receive(subscriber: subscriber)
    }
}
