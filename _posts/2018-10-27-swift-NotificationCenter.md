---
layout: post                       
title: "(Swift) Notification Center"
categories: [Swift]
---

 <u>**주의 : 혹시 읽지만 끝까지 안보시는 분들은 적용하고 `옵저버 제거`  검색해서 꼭 제거해주세요.</u>**

오늘 포스팅 주제는 **Notification Center**.

Swift를 사용하면서 사용한적이 없었던것 같아서 배우는김에 글로 포스팅으로!!!

하지만, 아직도 정말 이때 써야해!! 라는건 잘모르겠다… 이런 경우에 이걸 쓸수있겠다 정도 느낌...?

마치 if문 배운상태서 guard문을 알게된 느낌...

간단한 개념적부터 접근을 하자면

<br><br>

## 배우고난 느낌
----
느낌은 이랬다
<br>

<q> <무언가 액션이 있었을 때,>이 액션이 진행되었으니 담당자들은 처리바람.</q>

<q> 담당자 수신 완료, 처리하겠음 </q>

<br>
이런 느낌??



앱에서 예를 들면 다음과 같은 가능할것 같았다

<br>

<q>화면이 백그라운드에 들어갔을때, VC에 어떠한 처리를 하고 싶다.</q>

<q>여러 VC에 영향을 주고 싶다.</q>

<br>
보통의 경우 같은 클래스 내의 메소드나 프로퍼티들이 아니면 접근하기가 까탈스러웠던것 같다.

델리게이트 패턴을 쓴다거나 프로토콜을 사용해서 접근을 하게되지만 `Notification Center`로도 가능하단걸 알게 되었다.

> 하지만, 단순 값전달이라던가, 델리게이트 패턴, 프로토콜이 사용하기 난감한 상황이 아닌이상 Noti Center는 안쓸듯하다.

좀더 여러곳에 동시다발적으로 알리는게 가능하겠다란 생각이 들면서

책들이 왜 방송국에 예시를 드는지 조금 이해가 됐다.

<br><br>

## 사용법
----


방송국이다 뭐다해도 첨엔 난 이해가 안됐었기에 그런 설명은 생략



<q> <무언가 액션이 있었을 때,>이 액션이 진행되었으니 담당자들은 처리바람.</q>

<q> 담당자 수신 완료, 처리하겠음 </q>

이렇게 쓴 이유가 있다. 코드 동작을 풀어쓴것이었다.

<br><br>

### Post - "이 액션이 진행되었으니 담당자들은 처리바람"



우선 <q> <무언가 액션이 있었을 때,>이 액션이 진행되었으니 담당자들은 처리바람.</q>는 다음과 같다.

```swift
// doItSomeThing에 해당 되는 것들은 처리 바람
NotificationCenter.default.post(name: .doItSomeThing, object: nil)
```

중요 - `post`

나중 설명 - `.doItSomeTing`, `object`

> 참고로 `.doItSomeThing`은 원래 존재하는게 아니고 내가 생성한 프로퍼티,
>
> 아래에서 설명!

포스트라는 단어가 중요하다.뭔가 보내는 그런 의미니, 여기선 `name`에 해당자들에게 각자 일을 수행하라고 실행시키는 것이라 생각하는게 맞는것 같다.



그럼 실행하라 명령했으니 명령 받을 애들이 필요하다.

다소 특이한 개념이 나온다. `doItSomeThing`은 정말 name에 해당된다. 무슨 동작하란게 아니다.

`name`을 일 처리하는 스텝의 이름이라 생각해야한다.

스텝마다 각자의 일거리는 다르다.

그렇담, 일거리와 이름을 셋팅을 하자.



일단 일거리 하나 만든다. ( = 동작할 함수 생성 )

```swift
@objc func printSomeThing(_ notification: Notification) {
        print("do it something")
    }
```

간단하다. 하는일은 그저 print 한번 해주는것뿐.

눈여겨볼거라면 파라미터 타입이 `Notification`이라는 정도???

> @objc 붙은 이유는 NotificationCenter가 원래는 NSNotificationCenter다. Swift 몇인지 기억은 안나지만 이름이 바뀌었다. Objective-c 에서 쓰이는거니 붙여주자

<br><br>

### Observer - "담당자 수신 완료, 처리하겠음"

observer = 관찰자, 여기선 일하는 스텝(담당자)이라 생각하자, 스텝들 업무 지정정도?



```swift
// 담당자 인적사항 및 업무 추가
NotificationCenter.default.addObserver(self, selector: #selector(printSomeThing(_:)), name: .doItSomeThing, object: nil)
```

중요 - `addObserver`, `selector` , `name`



`addObserver` - 관찰자를 대기시키겠다는 것,

`selector` - 스테프 업무

`name` - 스테프 이름

<br>

여기서 가장 중요한건 이름이라 생각한다. Post 메소드가 `name`에 "누구씨 일해!!" 라고 한다면, 그 이름에 해당 되는 스텝들이 각자 등록된 업무 (= `selector`) 수행하게 된다. 이 코드에선 `.doItSomeTing`을 부르면 아까 만든 함수(print 한줄짜리)를 실행하게 된다.

> 스텝 이름은 중복가능하다, 다른 addObserver를 작성해도 이미 사용한 이름을 쓸수있다.
>
> 이럴경우 마지막만이 아닌 해당 이름 모두 실행됨.



<br>

<br>

### name 등록 방식

그럼 슬슬 이름 추가방법에 대해 쓰는게 맞는것 같다.

2가지 정도가 있다.



1) addObserver할때 한번에

```swift
// Post
NotificationCenter.default.post(name: Notification.Name("doItSomeThing"), object: nil)
// Add Observer
NotificationCenter.default.addObserver(self, selector: #selector(printSomeThing(_:)), name: Notification.Name("doItSomeThing"), object: nil)
```



이렇게 "doItSomeThing" 이라는 Notification.Name 데이터 타입을 만들수도 있지만

별로 추천하고 싶지 않다. 재사용도 힘들고 코드도 안깔끔

<br>

2) Extension으로 프로퍼티 추가

```swift
extension Notification.Name {
    static let doItSomeThing = Notification.Name("doItSomeThing")
}
```

이렇게 `Notification.Name`에 프로퍼티를 추가해주면,

위 코드들에 나오듯 `name`자리에 있던 `.doItSomeThing`을 쓸수 있기에

깔끔하고 사용하기도 수월해진다.



<br><br>

## 예시
----

이런식으로 사용가능하다

ex) 화면이 VC1 -> VC2 -> VC3 이렇게 있다고 치자, 그리고 각각 Label을 1개씩 가지고 있다.

네비게이션을 이용할것이며, 화면 이동도 위와 같다. 그림으로 이해돕자면 이정도?

그리고 그 3에는 버튼이 하나 있고, 이것을 누르면 Post를 한다.

![](https://jiseobkim.github.io/static/img/_post/2018-10-27/img1.png)



<br>

우선 이름부터 추가

```swift
extension Notification.Name {
    static let changeLabel = Notification.Name("changeLabel")
}
```

<br>

그리고,

ViewController 3개가 있고

각 ViewDidLoad에 addObserver해준다.

```swift
/////////////////VC1
// ViewDidLoad
NotificationCenter.default.addObserver(self, selector: #selector(change1), name: .changeLabel, object: nil)

// change1 함수 내용
self.label1.text = "Change Label1!!!"

/////////////////VC2
// ViewDidLoad
NotificationCenter.default.addObserver(self, selector: #selector(change2), name: .changeLabel, object: nil)

// change2 함수 내용
self.label2.text = "Change Label2!!!"

/////////////////VC3
// ViewDidLoad
NotificationCenter.default.addObserver(self, selector: #selector(change3), name: .changeLabel, object: nil)

// change3 함수 내용
self.label3.text = "Change Label3!!!"
```

<br>

마지막으로 Bnt 버튼 메소드 정의

```swift
NotificationCenter.default.post(name: .changeLabel, object: nil)
```

<br>

<br>

## 결과
----

~~그럼 gif는 할줄 모르니~~ (방금 배움. 단축어 짱짱)

![](https://jiseobkim.github.io/static/img/_post/2018-10-27/img2.gif)



위 Gif에 나온것처럼, 직전 VC2뿐만 아니라 현재 스택에 있는 VC1까지 모두 작동했다.



<br><br>

## 옵저버 제거
----

다른 의미로 여기서 잘 생각해봐야하는게, observer가 계속 살아있다는 것이다.

그렇담 제거는 따로 해줘야한다는것이다. 불필요한데 계속 남아있어서 좋을것은 1도 없으니깐!

제거는 간단.

```swift
NotificationCenter.default.removeObserver(self, name: .changeLabel, object: nil)
```





<br><br>

## 추가 : Post할때 값도 전달
----

Post메소드 파라미터에 `object`도 있었다. 위에선 `nil`을 넣었지만, 이 부분을 통해 값을 보낼수 있다.



기존 selector에 들어가던 함수를 변경해주자(VC2랑 VC3도 변경!)

```swift
// 기존
@objc func change1(_ notification: Notification) {
        self.label1.text = "Change Label1!!!"
    }

// 변경
@objc func change1(_ notification: Notification) {
    let getValue = notification.object as! String
    self.label1.text = "Change \(getValue)"
}
```

> 여기선 String으로만 보낼것이기 때문에 강제 다운 캐스팅! (as!)

<br>

btn의 Post도 이렇게 변경

타입이 `Notification`인 파라미터 `notification`에 `object`가 Post에 있던 `object`다.
```swift
// 기존
@IBAction func doPost(_ sender: UIButton) {
        NotificationCenter.default.post(name: .changeLabel, object: nil)
    }

// 변경
@IBAction func doPost(_ sender: UIButton) {
        NotificationCenter.default.post(name: .changeLabel, object: "Object")
    }
```

<br>

## 결과
----

![](https://jiseobkim.github.io/static/img/_post/2018-10-27/img3.gif)



----



PS. 더 적절한 예시를 아신다면 댓글 부탁 드립니다!! 같이 공부해요!
