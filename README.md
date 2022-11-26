# SDSCombineExtension

Convenient extension on top of Combine

## ScheduledTimerPublisher

Repeat Timer which start at specific date.

```
    public init(fire: Date, repeatDuration: Duration? = nil) {
```

Repeat Timer which start after specified Duration
```
    public init(after: Duration, repeatDuration: Duration? = nil) {
```

if repeatDuration != nil, then timer will fire repeatedly with repeatDuration
if repeatDuration == nil, timer will stop after first fire.

with calling "stop()", timer will stop.
