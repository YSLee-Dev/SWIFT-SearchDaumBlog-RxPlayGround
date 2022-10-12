import Foundation
import RxSwift

let bag = DisposeBag()

print("-START WITH-")
let 노랑반 = Observable.of("한","두", "세")

노랑반
    .enumerated()
    .map{ index, value in
        value + " 명" + "\(index)"
    }
    .startWith("영 명")
    .subscribe{
        print($0)
    }
    .disposed(by: bag)

print("-CONCAT1-")
let student = Observable.of("김재석", "정홍철", "김준하")
let teacher = Observable.just("선생님")

let 순서 = Observable
    .concat([student, teacher])

순서
    .subscribe{
        print($0)
    }
    .disposed(by: bag)

print("-CONCAT2-")
teacher
    .concat(student)
    .subscribe{
        print($0)
    }
    .disposed(by: bag)

print("-CONCAT MAP-")
let 타이틀 : [String : Observable<Int>] = [
    "영" : Observable<Int>.just(0),
    "하나" : Observable<Int>.just(1)
]

Observable.of("영", "하나")
    .concatMap { title in
        타이틀[title] ?? .empty()
    }
    .subscribe{
        print($0)
    }
    .disposed(by: bag)

print("-MERGE1-")
let 경기도 = Observable.of("성남", "수원", "용인", "의정부")
let 서울 = Observable.of("강남", "강북", "강서", "강동")

Observable.of(경기도,서울)
    .merge()
    .subscribe{
        print($0)
    }
    .disposed(by: bag)

print("-MERGE2-")
let 광역시 = Observable.of("부산", "광주", "대구", "인천")
Observable.of(경기도, 서울, 광역시)
    .merge(maxConcurrent: 2)
    .subscribe{
        print($0)
    }
    .disposed(by: bag)

print("-COMBINE LASTEST1-")
let 성 = PublishSubject<String>()
let 이름 = PublishSubject<String>()

let 성명 = Observable
    .combineLatest(성, 이름){ 성, 이름 in
        성 + 이름
    }

성명
    .subscribe{
        print($0)
    }
    .disposed(by: bag)

성.onNext("이")
성.onNext("김")
이름.onNext("재석")
이름.onNext("호동")
성.onNext("박")

print("-COMBINE LASTEST2-")
let fullName = Observable
    .combineLatest([성, 이름]){
        $0.joined(separator: " ")
    }

fullName
    .subscribe{
        print($0)
    }
    .disposed(by: bag)
성.onNext("이")
성.onNext("김")
이름.onNext("재석")

print("-ZIP-")
let 브랜드 = Observable.of("애플", "삼성", "LG", "구글", "현대")
let 스마트폰 = Observable.of("아이폰", "갤럭시", "G", "픽셀")

let 결과 = Observable
    .zip(브랜드, 스마트폰){ 브랜드, 스마트폰 in
        브랜드 + "의 스마트폰 브랜드는 " + 스마트폰
    }

결과
    .subscribe(onNext: {
      print($0)
    })
    .disposed(by: bag)

print("-WITH LATEST FROM-")
let 정각알림 = PublishSubject<Void>()
let 시각 = PublishSubject<Int>()

정각알림
    .withLatestFrom(시각)
    .subscribe(onNext: {
      print($0)
    })
    .disposed(by: bag)

시각.onNext(12)
시각.onNext(1)
시각.onNext(2)
정각알림.onNext(Void())
정각알림.onNext(Void())

print("-SAMPLE-")
let alert = PublishSubject<Void>()
let time = PublishSubject<Int>()

time
    .sample(alert)
    .subscribe(onNext: {
      print($0)
    })
    .disposed(by: bag)

time.onNext(1)
time.onNext(2)
alert.onNext(Void())
alert.onNext(Void())

print("-AMB-")
let 백번버스 = PublishSubject<String>()
let 백일번버스 = PublishSubject<String>()

let 정류소 = 백번버스.amb(백일번버스)

정류소
    .subscribe(onNext: {
      print($0)
    })
    .disposed(by: bag)

백일번버스.onNext("101 - 1")
백번버스.onNext("100 - 1")
백일번버스.onNext("101 - 2")
백번버스.onNext("100 - 2")

print("-SWITCH LATEST-")
let 김모씨 = BehaviorSubject<String>(value: "안녕하세요.")
let 이모씨 = BehaviorSubject<String>(value: "안뇽")

let 권한 = PublishSubject<Observable<String>>()
let 대화방 = 권한.switchLatest()

대화방
    .subscribe(onNext: {
      print($0)
    })
    .disposed(by: bag)

권한.onNext(김모씨)
권한.onNext(이모씨)
김모씨.onNext("HELLO")
권한.onNext(김모씨)
권한.onNext(이모씨)

print("-REDUCE-")
Observable.from((1...5))
    .reduce(0, accumulator: +)
    .subscribe(onNext: {
      print($0)
    })
    .disposed(by: bag)

print("-SCAN-")
Observable.from((1...5))
    .scan(0, accumulator: +)
    .subscribe(onNext: {
      print($0)
    })
    .disposed(by: bag)
