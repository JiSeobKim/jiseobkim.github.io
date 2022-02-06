---
layout: post

title: "(RxSwift) Single 알아보기(2)"

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

<br>

### Create 시그니처의 입력 파라미터

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

`typealias`이고 또 다시 안에 있는`SingleEvent`는 또 `typealias`다.

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



---

### create 내용

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

- 성공시: `next`후 `completed` 방출
- 실패시: `error` 방출

<br>

성공과 실패로만 나누기 위해서 `Observable`과 `Result`를 어떻게 응용했는지 알 수 있는 부분이다.

<br>

---

### create 시그니처의 escaping

`주석 1`을 보면 `Observable<Element>.create`라는 부분 또한 클로저이며, 

이것 또한 `escaping`으로 작성되어 있기 때문에 그 안에서 `주석2`와 같이  `subscribe`를 쓰기 위해선 `escaping`이 있어야한다.

<br>

이게 시그니처에 있던 첫번째 `escaping`의 이유이다.

그렇다면, 시그니처의 두번째 `escaping`은 왜 필요한 것일까?

<br>

이것은 글의 첫번째 코드 블록으로 가보자.



```swift
let singleString = Single<String>.create { singleCloser -> Disposable in
    singleCloser(.success("hi"))
    return Disposables.create()
}
```

`singleCloser`라는 파라미터를 사용하고 있다. 

<br>

여기서 만약 지금 당장 `success`나 `failure`를 넣을 수 없다면?

통신과 같이 값을 지금 당장 보낼 수 없고, 캡쳐하고 후에 처리를 해야한다면 아래처럼 작성될 것이다.

```swift
let singleString = Single<String>.create { singleCloser -> Disposable in

    let url = URL(string: "www.naver.com")!
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        // 1. 통신 후 분기 처리
        guard data != nil else {
            // 2. 실패 에러 방출
            let error = NSError(domain: "", code: 0, userInfo: nil)
            singleCloser(.failure(error))
            return
        }
    
        // 3. 성공 방출
        singleCloser(.success("Hi"))
    }
        
    task.resume()

    return Disposables.create()
}
```

<br>

여기서 `singleObserver` 또한 캡쳐가 되기 위해선 두번째 `escaping`을 넣어주지 않는다면 이런 오류가 나온다.

```
Escaping closure captures non-escaping parameter 'singleCloser'
```

<br>

따라서 `singleCloser`도 `escaping`이 붙어야한다.

이게 두번째 이유이다.

<br>

---

### 마무리



이렇게 쓰다보니 시간이 생각보다 오래걸렸다. 알았다 싶었는데, 정리와는 역시 별개였다.

`Single`은 확실히 통신과 잘 어울린다 생각이 된다. 앞으로는 통신 모듈 붙일때 적극적으로 도입을 해봐야겠다.

<br>

끝!
