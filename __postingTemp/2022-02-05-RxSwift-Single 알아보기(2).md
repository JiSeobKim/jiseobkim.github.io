---
layout: post

title: "RxSwift-Single 알아보기(2)"

categories: [RxSwift]

---

[이전 글](https://jiseobkim.github.io/rxswift/2022/02/04/RxSwift-Single-알아보기(1).html)에서 `just`로 간단하게 방출을 보았다.

이번 글에서는 `create`에 대해 좀더 심도 있게 보면서 원리를 보고자 한다.



<br>

# Single의 Create

이전 편 `just`로 한 것을 `create`로 만들어보자.

```swift
// 1. just로 구현
let singleString = Single.just("hi")

// 2. create로 구현
let singleString = Single<String>.create { singleCloser -> Disposable in
    singleCloser(.success("hi"))
    return Disposables.create()
}
```

그런데, 여기서 흥미로운 점은 `create`의 시그니처이다.

> 시그니처: 간단하게 말해서 (메소드 이름, 파라미터의 이름&자료형, 리턴 값의 자료형)을 나타내는 것

```swift
public static func create(subscribe: @escaping (@escaping SingleObserver) -> Disposable) -> Single<Element>
```

<br>

`escaping`은 일단 무시하고 파라미터 값만 보면 다음과 같다.

```swift
subscribe: (SingleObserver) -> Disposable)
```

<br> 

여기서 `SingleObserver`은 뭘까? (`Disposable`은 안다는 가정하에)

```swift
public typealias SingleObserver = (SingleEvent<Element>) -> Void
```

<br>

`SingleEvent`는 또 `typealias`다.

```swift
public typealias SingleEvent<Element> = Result<Element, Swift.Error>
```

<br>

드디어 알아 볼 수 있는 것 까지 나왔다.

즉, `subscribe`는 클로저였고, 그 클로저의 입력 파라미터 또한 클로저였다.

<br>

저 `Result`를 이용해서 `성공`과 `실패`를 나타낸 것이었다.

별것 없다! 그저 `Observable`에 `Result`를 이용한 것이 `Single`이다.

<br>

이제 어떻게 이용을 했는지 `create` 메소드의 내용을 보자.

<br>

```swift
// 1. Observable 생성
let source = Observable<Element>.create { observer in

    // 2. 입력 파라미터였던 subscribe는 Disposable을 리턴 하기에 return에 사용 가능하다.
    return subscribe { event in
    
        // 3. event는 Result이므로 switch를 이용한 분기 처리
        switch event {
        case .success(let element):
            // 4. 입력 받은 element를 곧바로 방출.
            observer.on(.next(element))
            // 5. completed 방출
            observer.on(.completed)
            
        case .failure(let error):
            // 6. 실패시 error 방출
            observer.on(.error(error))
        }
    }
}

// 7. Single<Element> 또한 PrimitiveSequence의 typealias이다.
return PrimitiveSequence(raw: source)
```

메소드 내용에서 `Observable`을 생성하였고, `Result`을 다음과 같이 이용했다.

- 성공시: next후 completed 방출
- 실패시: error 방출

여기서 알 수 있는 점은 다음과 같다.








<br>

시그니처 중에서도 입력 파라미터 `subscribe`를 보자. 

일단 눈에 띄는 것은 `escaping`이 많다. 두개나 있다.

보통은 한개만 쓰는데!

<br>

`escaping`은 값이 캡쳐 되어야할 경우 쓰인다.

예를 들어 통신 후에 값이 처리 되어야 한다거나? 

일반적으로 봤을 때는 함수는 끝났지만 별도로 돌아갈때 쓰인다고 보면 된다.

<br>

이것은 우선 `SingleObserver`를 보고 난 뒤 보자

