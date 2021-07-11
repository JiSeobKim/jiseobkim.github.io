---
layout: post

title: "Swift - Property Wrapper (feat. Codable 3편)"

categories: [Swift]



---

<br>

[지난 편](https://jiseobkim.github.io/swift/2021-06-27-swift-Property-Wrapper-(feat.-Codable-2편).html)에 이어서 진행!

<br>

목표: 전편 마지막에 언급한것 처럼 Generic을 이용하여 반복되던 코드를 줄이기

이 시리즈를 이어가면서 해온것들을 정리하면 단순하게는 다음과 같이 볼 수 있다.

JSON 값을 객체화 할때 다음과 같은 유형들이 있었다.

1. 옵셔널 Int -> Int (Default: 0)
2. 옵셔널 String -> String (Default: "")
3. 옵셔널 String -> Bool (Default: false)

(3의 경우는 `{ "abc": "Y" }` 같은 값을 `Bool` 형태로 바꿔주는 다른 타입 처리였다.)

이것을 이쁘게 묶어보면 다음과 같다.

<img src="/assets/images/2021-07-11/img.png" style="zoom:40%;" />

오른쪽의 경우는 각 처리방법이 다르므로 `Generic`으로 묶기가 힘들겠지만 

왼쪽의 경우는 공통적으로 "타입이 같고 기본값을 가진다." 라는 점을 이용하여 묶어보도록 하자

그리고 배열도 JSON 값으로 자주 나오니 이렇게 묶어보자.

<img src="/assets/images/2021-07-11/img-1.png" style="zoom:40%;" />

그리고 최종적으로 모든것은 JSON 데이터를 처리 하기 위한 것이므로 분산되어있으면 관리가 어려우니

전부를 묶자.

<img src="/assets/images/2021-07-11/img-2.png" style="zoom:40%;" />

기본값 처리는 이전편에 했으니 바로 `Generic`으로 묶는 부분 부터 시작!



> 단일의 Property Wrapper를 이용하여 사용은 불가능하다.
>
> 여기서의 경우 초반에 묶은 것처럼 같은 기본형 처리랩퍼, 다른 타입용 랩퍼는 별도로 운용되며
>
> Enum을 이용하여 묶어주게 된다.

# Property Wrapper & 기본값 처리 그리고 Generic

## Protocol

 Generic으로 묶기의 포인트는 프로토콜을 이용하며 초기값을 받는다는 점이다.

 ```swift
 protocol DefaultWrapperAvailable {
    associatedtype ValueType: Decodable
    static var defaultValue: ValueType { get }
}
 ```

위의 코드를 보자.

기본값 랩퍼를 이용할 수 있는 프로토콜을 만들었다.

`associatedtype`라는 것은 프로토콜에서 쓰일 수 있는데, 

느낌은 약간 `Generic`과 비슷하다.

이 자리에 어떤 타입이든 올 수가 있다.

프로토콜이라는 자체가 서로의 의존성을 줄여주고 적용시 해당 규약? 규칙?들을 따라야 한다는 것인데

그러다보니 범용성이 필요해서 만들어진게 아닌가 싶다. (개인적 생각)

두번째 줄을 보고 나서 좀더 설명을 해야 이해하기가 쉬울듯 하다.

`static var`로 선언을 해준 프로퍼티의 타입을 보면 `ValueType`이다.

저런 타입은 실제 없지만 그 윗줄에 `associatedtype`로 적어주었고, 그 타입이라는 의미다.

그래서 해당 프로토콜을 적용시키게 된다면 반드시 `ValueType`이란 어떤 타입인가를 명시를 해줘야한다.

하지만, 조건이 하나 더 붙어있다. 이 타입은 `Decodable`을 따라야 한다는 점이다.

`associatedtype`는 이정도로만 설명을 하고, 왜 했는지가 중요하다.

통신후 `Decodable`을 이용하여 다양한 자료형의 기본값을 처리하는 부분이기 떄문에 `associatedtype`이 필요했고,

이 자료형들은 `Decodable`을 따라야한다.

그리고 기본값은 단순히 해당 프로토콜을 따르는 객체에서 기본값이 무엇인지만 필요하므로 초기화 할 필요없이

`타입 프로퍼티(static var)`로써 `get`만 필요하다.



## Property Wrapper 선언



```swift
@propertyWrapper 
struct Wrapper<T: JSONDefaultWrapperAvailable> {
		typealias ValueType = T.ValueType
		var wrappedValue: ValueType
		init() {
				wrappedValue = T.defaultValue
		}
}
```



랩퍼 생성 부분이다.



이전과 다른 부분은 `<T: JSONDefaultWrapperAvailable> `이 가장 먼저 눈에 들어오게 될텐데.



`Generic T` 라는 값을 선언시 정의해줘야하며 이는 위에서 만든 프로토콜을 따르게 된다.



associatedtype 였던 부분을 typealias를 이용하여 정의를 해주고, 기본 값 또한 알 수 있다.



즉, 우리는 기본값을 미리 받아올 수 있고,

그 받아온 값을  `init` 을 호출할때 넣겠다는 것이다.



여기서 핵심이 위 부분이다.



`decode` 하게되면 `try`를 하게 될테고, `JSON` 에 해당 키가 없을 경우 이는 뱉어지게 되는데,

이때 `init`을 하게 되고, 그 때의 값이 저`defaultValue` 를 이용하여 `init`을 해줌으로써

키가 없어도 기본값을 정의할 수 있게 된다.



## Protocol과 Enum



위에 만든 프로토콜을 따르는 무언가가 필요하다.



그래야 각 자료형 별 기본값을 넣어주게 될테니깐!



그렇담 보통은 프로토콜을 적용시킬때 `class` ,`struct` 두가지에 적용을 많이 하게 될텐데,



두가지의 공통점이 있다. 



**프로퍼티와 메소드가 없더라도 초기화가 된다**



다음을 보자



```
// 1. 생성
class AA {
}
struct BB {        
}

// 어딘가..
// 2. 선언 및 초기화
let aa = AA()
let bb = BB()
```

클래스 AA와 구조체 BB를 만들어 주었고 주석2와 같이 선언과 초기화를 해주었다.

프로퍼티와 메소드가 없음에도.


다시 우리가 만든 프로토콜을 보자.

```swift
protocol JSONDefaultWrapperAvailable {
    associatedtype ValueType: Decodable
    static var defaultValue: ValueType { get }
}
```

여기서 이 프로토콜을 따르는 것은 초기화 될 필요성이 있는가?

아니다 전혀 필요없다. 

단순하게

1. 자료형은 무엇인가?
2. 이 자료형을 가진 기본값은 무엇인가?

이 두가지 정의만 필요할뿐 초기화될 이유는 전혀 없다.

그래서 `Enum`이 나오게 된다.

열거형에도 프로토콜을 적용시킬 수 있다. 그치만 다른점은 위와 같이 초기화가 안된다는 것이다.

<img src="/assets/images/2021-07-11/img-3.png" style="zoom:40%;" />

위의 스샷을 보면 두가지 열거형이 있다.

1. `CC`: 프로퍼티, 메소드 정의 x
2. 'DD': 프로퍼티, 메소드 정의 x, 프로토콜을 따른다.

2의 내용물은 조금 뒤에 얘기하고, 스샤 아래 부분 에러를 보면

초기화를 할 수 없다는것이 중점이다. 불필요한 초기화는 애초에 차단!

그렇기에 여기선 `class`,`struct`가 아닌 `enum`에 프로토콜을 적용시킬것이다.
