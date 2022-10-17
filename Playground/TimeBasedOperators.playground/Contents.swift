import Foundation
import RxSwift
import RxCocoa
import UIKit
import PlaygroundSupport

let bag = DisposeBag()

print("-REPLAY-")
let 인사 = PublishSubject<String>()
let 앵무새 = 인사.replay(1)
앵무새.connect()

인사.onNext("1. 안녕")
인사.onNext("2. HELLO")

앵무새
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: bag)

인사.onNext("3. HI")

print("-REPLAY ALL-")
let 초능력자 = PublishSubject<String>()
let 타임머신 = 초능력자.replayAll()
타임머신.connect()

초능력자.onNext("나는 초능력자다")
초능력자.onNext("우하하")

타임머신
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: bag)

초능력자.onNext("나는 이런 사람이야~")

print("-BUFFER-")
/*
let count = PublishSubject<Int>()
count
    .buffer(timeSpan: .seconds(2), count: 3, scheduler: MainScheduler.instance)
    .take(3)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: bag)

for x in 0...2 {
    count.onNext(x)
}
sleep(1)

count.onNext(3)
*/

print("-WINDOW-")
/*
let 카운트 = PublishSubject<String>()
카운트
    .window(timeSpan: .seconds(2), count: 3, scheduler: MainScheduler.instance)
    .take(5)
    .flatMap{
        $0
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: bag)

카운트.onNext("첫번째")
카운트.onNext("두번째")
카운트.onNext("세번째")

sleep(2)
카운트.onNext("네번째")
카운트.onNext("다번째")
*/

print("-DELAY SUBSCRIPTION-")
/*
let 지연 = PublishSubject<Int>()

지연
    .delaySubscription(.seconds(1), scheduler: MainScheduler.instance)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: bag)

지연.onNext(1)
지연.onNext(2)
sleep(2)
지연.onNext(3)
지연.onNext(4)
*/

print("-DELAY-")
/*
let delay = PublishSubject<Int>()
delay
    .delay(.seconds(1), scheduler: MainScheduler.instance)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: bag)

delay.onNext(1)
delay.onNext(2)
sleep(2)
delay.onNext(3)
*/

print("-INTERVAL-")
/*
Observable<Int>
    .interval(.seconds(1), scheduler: MainScheduler.instance)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: bag)
*/

Observable<Int>
    .interval(.seconds(1), scheduler: MainScheduler.instance)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: bag)

print("-TIMER-")
/*
Observable<Int>
    .timer(.seconds(4), period: .seconds(1), scheduler: MainScheduler.instance)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: bag)
*/

print("-TIME OUT-")
let 폭탄 = PublishSubject<String>()

폭탄
    .timeout(.seconds(1), other: Observable<String>.just("폭탄이 터졌습니다."), scheduler: MainScheduler.instance)
    .subscribe{
        print($0)
    }
    .disposed(by: bag)

폭탄.onNext("터지지마 제발")
폭탄.onNext("터지지마 제발")
