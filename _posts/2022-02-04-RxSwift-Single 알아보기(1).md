---
layout: post

title: "(RxSwift) Single 알아보기(1)"

categories: [RxSwift]

---

<br>

RxSwift의 포스팅은 이게 처음인듯하다.

사용은 많이 했지만 심도있게 알고 싶으니깐 이제 글로도 써보기!


<br>

주제는 `Single`! 순서가 이상하긴 한데,,,

아무튼 내가 생각한 `RxSwift`는 단순하다.

> 방출하고 구독한다

<br>

개인적으로 생각하는 Rx의 이점은 다음과 같다.

- 방출하는 입장에선 누가 구독을 하던 방출만 하면 된다. (의존성 낮추기)
- 구독하는 입장에선 방출된 값을 실시간으로 받을 수 있다.
- 한 방출자에 대해 여러 구독자가 생길 수 있다.

<br>

하지만, 개발자라면 욕심이 생기기 마련인듯 싶다.

OOP나 디자인 패턴이라던가 아키텍쳐라던가

어떠한 목적에 대해 조금 더 편하고, 

좋게 발전시키고자 하는 욕심들은 있는 듯 하다.

<br>

`Rx` 또한 비슷하다 생각한다. 방출을 하고 구독하면 끝이지만

어떻게 조금 더 방출을 쉽고 편하게 할까?

어떻게 조금 더 구독을 쉽고 편하게 할까?

라는 생각에서 `Rx`에서 `Operator`들과 `Single`등등 많은 것이 생겨난 것으로 생각한다.

> 지극히 개인적인 견해입니다. 

<br>

이러한 생각을 가지고 있기 때문에 Rx에 대해 글을 쓴다면

"왜 이 Operator가 나왔을까?, Single은 왜 나왔을까?"

라는 식의 접근을 할 예정이다.


<br>

---

# 기존 `Observable`의 불편한 점.

개인적으로 `Swift 5`부터 지원되는 문법인 `Result`를 정말 좋아한다. 

이름도 결과 라는 직설적인 이름이고, `Result`는 `열거형`이다

해당되는 `case`는 다음과 같다.
- `success`
- `failure`

<br>

이처럼, 단순화 시키고 명확하게 만들 수 있다면 좋겠지만

`Observable`이 방출하는 이벤트의 종류는 조금 다양하다

1. onNext
2. onError
3. onCompleted
4. onDisposed

<br>

그런데, 나 같은 경우는 보통 데이터 바인딩 목적을 위해서 써서 그런걸까?

`onNext`만 엄청나게 사용 비중이 높았다.

나만 그런가..

<br>

아무튼 나는 다른 것을 많이 사용 안하기 때문에

단순하고 명확하게 방출에 대해서 `성공`과 `실패` 두가지만 받고 싶었고,

나같은 사람들이 많았는지?

이를 해소 할 수 있는 것이 역시나 존재 하였고,

<br>

그게 `Single`이었다.

<br>

---

# Single

이번 글의 목적은 불편함을 해소하는 것에 초점을 맞췄기 때문에

단순하게 알아보고 다음편에서 조금더 심도있게 글을 쓰려한다.

그리고 `Single`의 중요한 점은 `성공`, `실패`에 대해서

방출한다는 점이 포인트다.

<br>

**성공 방출**

```swift
let singleString = Single<String>.just("hi")
let singleArray = Single<[Int]>.just([1,2,3])
let singleInt = Single<Int>.just(5)
```

`just`를 이용해 단순히 방출 할수 있음을 보았고,

이는 타입 추론을 통해 조금더 축약을 하자면 이렇게도 가능하다.

```swift
let singleString = Single.just("hi")
let singleArray = Single.just([1,2,3])
let singleInt = Single.just(5)
```

<br>

**실패 방출**

```swift
let error = NSError(domain: "test", code: 0, userInfo: nil)
let singleError = Single<String>.error(error)
```

`error`를 사용해서 간단하게 가능하다.

<br>

**구독**

```swift
// 1. Single & DisposeBag 생성
let singleString = Single.just("hi")
let bag = DisposeBag()

// 2. Single 구독
singleString
    .subscribe { event in
    
        // 3. event switch 처리 
        switch event {
        case .success(let text):
            // 4. 성공시 text 출력
            print(text)

        case .failure(let error):
            // 5. 실패시 에러 출력
            print(error.localizedDescription)
        }
    }.disposed(by: bag)
    
--- Console Result ---
"hi"
```

여기서 중요한 것은 `Single`을 구독 할 때, 

`event`를 받고 이것의 타입은 `Result<String, Error>` 이다.

<br>

`Result`!! 위에 나왔던 내가 좋아하는 그것.

이를 통해 구독시 `성공`, `실패`만으로 구문되기 때문에

`Observable` 보단 단순해지기 때문에 굉장히 마음에 든다.

<br>

사실 이렇게만 쓸 일은 거의 없을 듯하지만,

이것을 알아두면 `create`를 사용할때, 어떻게 사용하지?는 패스 해도 되므로,

이런게 있다 정도 알아두자.

<br>

그리고 흥미로운건 `create`의 시그니처다

> 시그니처: 간단하게 말해서 (메소드 이름, 파라미터의 이름&자료형, 리턴 값의 자료형)을 나타내는 것 

`closer`와 `escaping`이 많이 나와서 이해하는데 시간이 조금 걸렸지만,

이해하고 나니 재밌는 점이 많았다.

<br>

이거슨 2편에 계속.

<br>

끝!
