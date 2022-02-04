---
layout: post

title: "RxSwift-Single 알아보기(2)"

categories: [RxSwift]

---

# Single의 Create

구독은 더 이상 안봐도 될듯 하고,

단순히 만들어주는 `just` 말고 `create`까지만 이 글에서 보자.

<br>

이번엔 아까 `just`로 한 것을 `create`로 만들어보자.

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

시그니처 중에서도 파라미터를 보자. 

클로저이기 때문에 위와 같이 사용이 가능하고, 이것은 나중에 자세히 알아보자.

일단은 논하고 싶은 것은 `(@escaping SingleObserver)`이다.

