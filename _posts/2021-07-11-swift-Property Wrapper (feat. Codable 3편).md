---
layout: post

title: "Swift - Property Wrapper (feat. Codable 3편)"

categories: [Swift]



---

<br>

[지난 편](https://jiseobkim.github.io/swift/2021-06-27-swift-Property-Wrapper-(feat.-Codable-2편).html)에 이어서 진행!

<br>

**목표: 전편 마지막에 언급한것 처럼 Generic을 이용하여 반복되던 코드를 줄이기**

<br>

이 시리즈를 이어가면서 해온것들을 정리하면 단순하게는 다음과 같이 볼 수 있다.

JSON 값을 객체화 할때 다음과 같은 유형들이 있었다.

1. 옵셔널 Int -> Int (Default: 0)
2. 옵셔널 String -> String (Default: "")
3. 옵셔널 String -> Bool (Default: false)

(3의 경우는 `{ "abc": "Y" }` 같은 값을 `Bool` 형태로 바꿔주는 다른 타입 처리였다.)

<br>

이것을 이쁘게 묶어보면 다음과 같다.

<img src="/assets/images/2021-07-11/img.png" style="zoom:40%;" />

오른쪽의 경우는 각 처리방법이 다르므로 `Generic`으로 묶기가 힘들겠지만 

왼쪽의 경우는 공통적으로 "타입이 같고 기본값을 가진다." 라는 점을 이용하여 묶어보도록 하자

그리고 배열도 JSON 값으로 자주 나오니 이렇게 묶어보자.

<img src="/assets/images/2021-07-11/img-1.png" style="zoom:40%;" />

그리고 최종적으로 모든것은 JSON 데이터를 처리 하기 위한 것이므로 분산되어있으면 관리가 어려우니

전부를 묶자.

<br>

<img src="/assets/images/2021-07-11/img-2.png" style="zoom:40%;" />

기본값 처리는 이전편에 했으니 이번편은 `Generic`을 중점으로 보게 될것이고,

다른 타입처리 다음편에서 진행 예정(추가로 `decodable Array`도!)

<br>


> 단일의 Property Wrapper를 이용하여 사용은 불가능하다.
>
> 여기서의 경우 초반에 묶은 것처럼 같은 기본형 처리랩퍼, 다른 타입용 랩퍼는 별도로 운용되며
>
> Enum을 이용하여 묶어주게 된다.

<br>

# Property Wrapper & 기본값 처리 그리고 Generic

## Protocol

 Generic으로 묶기의 포인트는 프로토콜을 이용하며 초기값을 받는다는 점이다.

 ```swift
 protocol DefaultWrapperAvailable {
    associatedtype ValueType: Decodable
    static var defaultValue: ValueType { get }
}
 ```

<br>

위의 코드를 보자.

기본값 랩퍼를 이용할 수 있는 프로토콜을 만들었다.

`associatedtype`라는 것은 프로토콜에서 쓰일 수 있는데, 

느낌은 약간 `Generic`과 비슷하다.

이 자리에 어떤 타입이든 올 수가 있다.

<br>

프로토콜이라는 자체가 서로의 의존성을 줄여주고 적용시 해당 규약? 규칙?들을 따라야 한다는 것인데

그러다보니 범용성이 필요해서 만들어진게 아닌가 싶다. (개인적 생각)

<br>

두번째 줄을 보고 나서 좀더 설명을 해야 이해하기가 쉬울듯 하다.

`static var`로 선언을 해준 프로퍼티의 타입을 보면 `ValueType`이다.

저런 타입은 실제 없지만 그 윗줄에 `associatedtype`로 적어주었고, 그 타입이라는 의미다.

그래서 해당 프로토콜을 적용시키게 된다면 반드시 `ValueType`이란 어떤 타입인가를 명시를 해줘야한다.

<br>

하지만, 조건이 하나 더 붙어있다. 이 타입은 `Decodable`을 따라야 한다는 점이다.

<br>

`associatedtype`는 이정도로만 설명을 하고, 

왜 했는지가 중요하다.

<br>

통신후 `Decodable`을 이용하여 

**다양한 자료형의 기본값**을 처리하는 부분이기 때문에

`associatedtype`이 필요했고, 이 자료형들은 `Decodable`을 따라야한다.

그리고 기본값은 단순히 해당 프로토콜을 따르는 객체에서 

**기본값이 무엇인지만 필요**하므로  `타입 프로퍼티(static var)`로써 `get`만 필요하다.

<br>

초기화는 불필요하다.
> 이 글에서 초기화가 불필요하다는 말이 자주 나온다.

<br>


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

이전과 다른 부분은 `<T: JSONDefaultWrapperAvailable>`이 가장 먼저 눈에 들어오게 될텐데,

`Generic T` 라는 값을 선언시 정의 해줘야하며, 이는 위에서 만든 `프로토콜`을 따르게 된다.

`associatedtype` 였던 부분을 `typealias`를 이용하여 정의를 해주고, `기본 값` 또한 알 수 있다.

<br>

즉, 우리는 기본값을 미리 받아올 수 있고,

그 받아온 값을  `init` 을 호출할때 넣겠다는 것이다.

<br>

여기서 핵심이 위 부분이다.

<br>

`decode` 하게되면 `try`를 하게 될테고, `JSON` 에 **해당 키가 없을 경우 이는 뱉어지게 되는데**,

이때 `init`을 하게 되고, 그 때의 값이 저`defaultValue` 를 이용하여 `init`을 해줌으로써

키가 없어도 기본값을 정의할 수 있게 된다.

<br>

## Protocol과 Enum


위에 만든 프로토콜을 따르는 무언가가 필요하다.

그래야 각 자료형 별 기본값을 넣어주게 될테니깐!

그렇담 보통은 프로토콜을 적용시킬때 `class` ,`struct` 두가지에 적용을 많이 하게 될텐데,

<br> 

두가지의 공통점이 있다. 

**프로퍼티와 메소드가 없더라도 초기화가 된다**

<br>

다음을 보자



```swift
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

**프로퍼티와 메소드가 없음에도.**

<br>

다시 우리가 만든 프로토콜을 보자.

```swift
protocol JSONDefaultWrapperAvailable {
    associatedtype ValueType: Decodable
    static var defaultValue: ValueType { get }
}
```

여기서 이 프로토콜을 따르는 것은 초기화 될 필요성이 있는가?

<br>

아니다 전혀 필요없다. 

단순하게

1. 자료형은 무엇인가?
2. 이 자료형을 가진 기본값은 무엇인가?

이 두가지 정의만 필요할뿐 초기화될 이유는 전혀 없다.

<br>

그래서 `Enum`이 나오게 된다.

열거형에도 프로토콜을 적용시킬 수 있다. 그치만 다른점은 위와 같이 초기화가 안된다는 것이다.

<img src="/assets/images/2021-07-11/img-3.png" style="zoom:40%;" />

위의 스샷을 보면 두가지 열거형이 있다.

1. `CC`: 프로퍼티, 메소드 정의 x
2. `DD`: 프로퍼티, 메소드 정의 x, 프로토콜 o

`DD`의 내용물은 조금 뒤에 얘기하고, 이미지 아래 부분 에러를 보면

초기화를 할 수 없다는것이 중점이다. 불필요한 초기화는 애초에 차단!

<br>

그렇기에 여기선 `class`,`struct`가 아닌 `enum`에 프로토콜을 적용 할 것이다.

---

<br>

# Enum 정의

여기서부터는 각 자료형별로 `Enum`에 프로토콜을 적용하여 정의해보자

우선 `Bool`과 `String`부터!

```swift
enum True: JSONDefaultWrapperAvailable {
    // 기본값 - true
    static var defaultValue: Bool { true }
}

enum False: JSONDefaultWrapperAvailable {
    // 기본값 - false 
    static var defaultValue: Bool { false }
}

enum EmptyString: JSONDefaultWrapperAvailable {
    // 기본값 - "" 
    static var defaultValue: String { "" }
}
```

위에 에러 이미지 캡쳐본과 차이가 있다면(`enum DD`), `typealias`가 없다는점이다.

<br>

추론이 된 상황인데, 프로토콜 정의부를 보면  `defaultValue` 타입이 `ValueType` 이었는데,

이를 이용하여 `defaultValue`에 타입을 정의하면 `typealias`는 별도로 정의할 필요가 없다.

<br>

위의 내용은 간단하다. 기본값 프로토콜을 따른다는 것과 그리고 기본값을 각각 지정해줬다는 점이다.

<br>

`JSON` 데이터 처리 부분의 분산을 막기위해 `property wrapper`와 `enum`들을 다시 한번

`enum`으로 묶자

> `enum`으로 묶는 이유는 다시 한번 말하면, 불필요한 초기화를 방지 가능하기 때문이다.

<br>


이렇게.


```swift
enum JSONDefaultWrapper {
    // Property Wrapper
    @propertyWrapper
    struct Wrapper<T: JSONDefaultWrapperAvailable> {
        typealias ValueType = T.ValueType
        
        var wrappedValue: ValueType
        
        init() {
        wrappedValue = T.defaultValue
        }
    }
    
    // Type Enums
    enum True: JSONDefaultWrapperAvailable {
        // 기본값 - true
        static var defaultValue: Bool { true }
    }

    enum False: JSONDefaultWrapperAvailable {
        // 기본값 - false 
        static var defaultValue: Bool { false }
    }

    enum EmptyString: JSONDefaultWrapperAvailable {
        // 기본값 - "" 
        static var defaultValue: String { "" }
    }
}
```

그리고 이전편에 나온 것들을 되새겨보면, 
1. 랩퍼에 `init(from decoder: Decoder)` 정의가 필요하다

```swift
extension JSONDefaultWrapper.Wrapper: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.wrappedValue = try container.decode(ValueType.self)
    }
}
```

2. `KeyedDecodingContainer`에 `extension`하여  `decode` 메소드 추가 필요하다.

```swift
extension KeyedDecodingContainer {
    func decode<T: JSONDefaultWrapperAvailable>(_ type: JSONDefaultWrapper.Wrapper<T>.Type, forKey key: Key) throws -> JSONDefaultWrapper.Wrapper<T> {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
}
```

<br>

위와 같이 셋팅을 해주면 사용할 준비는 끝났다.

<img src="/assets/images/2021-07-11/img-4.png" style="zoom:40%;" />

실제 적용 코드와 출력 값이다.

<br>

위 이미지를 설명하면 다음과 같다.

1. 맨 첫줄에 `stringValue`는 옵셔널이 아닌 `String`이다.
2. `JSON` 형태의 데이터는 `stringValue`와 관련된 키가 없다. (이러한 이유 때문에 별도 처리가 없었다면 error를 뱉게 된다.) 
3. `Decode`를 했을때, `stringValue`가 빈값인지 확인이 되었다.

<br>

2가 핵심이다. 관련 키가 없지만 객체가 잘 생성 되었다.

<br>

그럼 위에 `enum`을 전부 적용하여 다시 결과를 보자.

<img src="/assets/images/2021-07-11/img-5.png" style="zoom:40%;" />

아주 아주 잘 되었다!

이제 `JSON` 데이터에 해당 키가 없어도 문제 없다!

<br>
<br>

**그치만 못생긴건 문제가 있다.**

<br>

```swift
@JSONDefaultWrapper.Wrapper<JSONDefaultWrapper.EmptyString> var stringValue: String
@JSONDefaultWrapper.Wrapper<JSONDefaultWrapper.True> var trueValue: Bool
@JSONDefaultWrapper.Wrapper<JSONDefaultWrapper.False> var falseValue: Bool
```

아 이 얼마나 해괴하게 생겼는가;;

굉장히 끔찍하고 가독성도 별로 그냥 별로다.

<br>

`typealias`를 통해 정리좀 해주자.

<br>

정리하기 앞서 원래 `enum`들은 `JSONDefaultWrapper`를 치고

`.`을 누르면 자동완성이 촤라락 뜨게 될텐데, 

이 부분을 정리 할 것이니 자동완성에 표출되길 원치 않는다.

이것들 또한 다시 한번 `enum`으로 묶어주자

```swift
enum TypeCase {
    // Type Enums
    enum True: JSONDefaultWrapperAvailable {
        // 기본값 - true
        static var defaultValue: Bool { true }
    }

    enum False: JSONDefaultWrapperAvailable {
        // 기본값 - false
        static var defaultValue: Bool { false }
    }

    enum EmptyString: JSONDefaultWrapperAvailable {
        // 기본값 - ""
        static var defaultValue: String { "" }
    }
}
```

이렇게 말이다.

<br>

그리고 나선 아까 못생긴 부분들을 `typealias`로 다시 적어주자

```swift
enum JSONDefaultWrapper {
    typealias EmptyString = Wrapper<JSONDefaultWrapper.TypeCase.EmptyString>
    typealias True = Wrapper<JSONDefaultWrapper.TypeCase.True>
    typealias False = Wrapper<JSONDefaultWrapper.TypeCase.False>
    
    // ...
}
```

그럼 다시 사용하는 부분을 보면 다음과 같이 정리가 된다.

<br>

```swift
@JSONDefaultWrapper.EmptyString var stringValue: String
@JSONDefaultWrapper.True var trueValue: Bool
@JSONDefaultWrapper.False var falseValue: Bool
```

<br>

오 훨씬 깔끔하다!

그럼 이제 사용법을 알았으니 숫자들에 대해서도 해보자.

---

<br>

# 숫자 처리

일부로 숫자 자료형들을 따로 뺐는데

`Int`, `Double`, `Float`, `CGFloat` 등등 숫자 관련 자료형이 많다.

그렇단 말은 `enum TypeCase` 안에  각 자료형별 `enum`이 추가 되어야 한다는 것인데

이것은 `Generic`으로 빼버리자

완성본은 다음과 같다
```swift
enum TypeCase {
    // Type Enums
    enum True: JSONDefaultWrapperAvailable {
        // 기본값 - true
        static var defaultValue: Bool { true }
    }

    enum False: JSONDefaultWrapperAvailable {
        // 기본값 - false
        static var defaultValue: Bool { false }
    }

    enum EmptyString: JSONDefaultWrapperAvailable {
        // 기본값 - ""
        static var defaultValue: String { "" }
    }
    
    enum Zero<T: Decodable>: JSONDefaultWrapperAvailable where T: Numeric {
        // 기본값 - 0
        static var defaultValue: T { 0 }
    }
}
```

제일 아래에 `Zero`라고 추가해줬는데 `Generic T`가 `decodeble`을 따르며, `Numeric`또한 따르게 된다.

여기서 포인트는 `Numeric` 이라는 점!

숫자 관련 처리를 다 해버릴 수 있다.

하지만 `typealias`는 정의 해줘야지 ㅠ 차마 이거까진 못 줄였다.

```swift
typealias IntZero = Wrapper<JSONDefaultWrapper.TypeCase.Zero<Int>>
typealias DoubleZero = Wrapper<JSONDefaultWrapper.TypeCase.Zero<Double>>
typealias FloatZero = Wrapper<JSONDefaultWrapper.TypeCase.Zero<Float>>
typealias CGFloatZero = Wrapper<JSONDefaultWrapper.TypeCase.Zero<CGFloat>>
```

<br>

자 그럼 다시 실행하여 출력값을 보자

<img src="/assets/images/2021-07-11/img-6.png" style="zoom:40%;" />

크킄.. 됐다..

쓰면서도 너무나 헷갈렸던 이번 포스팅

도대체 몇번을 썼다 지웠다 한지 모르겠네?

<br>

드디어 다음 포스팅이 이 시리즈의 마지막일듯 하다.

<br>

이 글에서 정의된 `JSONDefaultWrapper`의 전체 코드를 보고 마무리하기.

```swift
protocol JSONDefaultWrapperAvailable {
    associatedtype ValueType: Decodable
    static var defaultValue: ValueType { get }
}

enum JSONDefaultWrapper {
    typealias EmptyString = Wrapper<JSONDefaultWrapper.TypeCase.EmptyString>
    typealias True = Wrapper<JSONDefaultWrapper.TypeCase.True>
    typealias False = Wrapper<JSONDefaultWrapper.TypeCase.False>
    typealias IntZero = Wrapper<JSONDefaultWrapper.TypeCase.Zero<Int>>
    typealias DoubleZero = Wrapper<JSONDefaultWrapper.TypeCase.Zero<Double>>
    typealias FloatZero = Wrapper<JSONDefaultWrapper.TypeCase.Zero<Float>>
    typealias CGFloatZero = Wrapper<JSONDefaultWrapper.TypeCase.Zero<CGFloat>>
    
    // Property Wrapper
    @propertyWrapper
    struct Wrapper<T: JSONDefaultWrapperAvailable> {
        typealias ValueType = T.ValueType

        var wrappedValue: ValueType

        init() {
        wrappedValue = T.defaultValue
        }
    }

    enum TypeCase {
        // Type Enums
        enum True: JSONDefaultWrapperAvailable {
            // 기본값 - true
            static var defaultValue: Bool { true }
        }

        enum False: JSONDefaultWrapperAvailable {
            // 기본값 - false
            static var defaultValue: Bool { false }
        }

        enum EmptyString: JSONDefaultWrapperAvailable {
            // 기본값 - ""
            static var defaultValue: String { "" }
        }
        
        enum Zero<T: Decodable>: JSONDefaultWrapperAvailable where T: Numeric {
            // 기본값 - 0
            static var defaultValue: T { 0 }
        }
    }
}

extension JSONDefaultWrapper.Wrapper: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.wrappedValue = try container.decode(ValueType.self)
    }
}

extension KeyedDecodingContainer {
    func decode<T: JSONDefaultWrapperAvailable>(_ type: JSONDefaultWrapper.Wrapper<T>.Type, forKey key: Key) throws -> JSONDefaultWrapper.Wrapper<T> {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
}
```

<br>

끝.
