---
layout: post

title: "Swift - Property Wrapper (feat. Codable Final)"

categories: [Swift]



---

<br>

[지난 편](https://jiseobkim.github.io/swift/2021-07-11-swift-Property-Wrapper-(feat.-Codable-3편).html)에 이어서 진행!

<br>

이제 진짜 마지막 파트다.

<br>

이전편에서는 `JSON`데이터에 해당 키가 없어도 에러가 나지 않고
기본값을 지정할 수 있게 했다. 

<br>

이때, `Generic`을 이용하였었다.

<br>

이번 편은 아주 간단하게 끝낼 것이다.

다른 타입으로 형변환 하는 것과 리스트에 대한 처리다.

<br>

다른 타입으로 바꾸는건 옵셔널인 타입과 옵셔널이 아닌 타입을 적용할 것이다.

<br>

# 옵셔널이 아닌 타입

옵셔널이 아니고 다른 타입 캐스팅을 보자

이전에 했던

```swift
{
    "isHidden" : "Y"
}
```

<br>

이 값을 `Bool` 형태로 받기를 진행 할건데,

이것도 기본값이 `true` 또는 `false`이므로 

다음 것들도 2개가 나올 것이다.

- `init(from decoder: Decoder){}`
- `extension KeyedDecodingContainer{}`

<br>

그러므로 그냥 `protocol`로 묶어주고

```swift
protocol JSONStringConverterAvailable {
    static var defaultValue: Bool { get }
}
```

<br>

이전에 만든 `JSONDefaultWrapper`안에 `Property Wrapper` 를 만들어주고

```swift
enum JSONDefaultWrapper {
    // ...
    
    // Property Wrapper - Optional String To Bool
    @propertyWrapper
    struct StringConverterWrapper<T: JSONStringConverterAvailable> {
        var wrappedValue: Bool = T.defaultValue
    }
    
    // ...
}
```

<br>

`Decodable`도 적용해주고

```swift
extension JSONDefaultWrapper.StringConverterWrapper: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.wrappedValue = (try container.decode(String.self)) == "Y"
    }
}
```

<br>

`KeyedDecodingContainer` 확장도 해주고

```swift
extension KeyedDecodingContainer {
    // ...
    
    func decode<T: JSONStringConverterAvailable>(_ type: JSONDefaultWrapper.StringConverterWrapper<T>.Type, forKey key: Key) throws -> JSONDefaultWrapper.StringConverterWrapper<T> {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
}
```

<br>

이전 편들을 봤다면 이해하기 훨씬 수월할 것이다.
그리고 쓰기 위해 이전편의 `JSONDefaultWrapper.TypeCase`에도 정의를 해준다.

<br>

기본값 `true`, `false` 둘다!

```swift
enum TypeCase {
    enum StringFalse: JSONStringConverterAvailable {
        // 기본값 - false
        static var defaultValue: Bool { false }
    }

    enum StringTrue: JSONStringConverterAvailable {
        // 기본값 - false
        static var defaultValue: Bool { true }
    }
}
```

<br>

그리고 마무리로 `typealias`를 통해 간추려준다.

```swift
enum JSONDefaultWrapper {
    //...
    typealias StringFalse = StringConverterWrapper<JSONDefaultWrapper.TypeCase.StringFalse>
    typealias StringTrue = StringConverterWrapper<JSONDefaultWrapper.TypeCase.StringTrue>
}
```

그럼 쓸 준비는 끝났다.

> 그냥 property wrapper 2개 만드는게 나을려나?

<br>

쓰는 방법은 마찬가지로 이전과 같다.

```swift
class Posting: Decodable {
    @JSONDefaultWrapper.StringFalse var stringFalseValue: Bool
    @JSONDefaultWrapper.StringTrue var stringTrueValue: Bool
}
```

<br>

이렇게 해주면 아주 잘 된다.

<br>

# 옵셔널 타입

이번에는 조금 다른걸 해보자,

`nil`로 냅두는게 나은 케이스가 있을 수 있다.

예를 들어 `timestamp`를 `Date`로 바꾼다거나..?

<br>

이 경우에는 기본 값으로 오늘 날짜를 넣는다거나 이런건 별로다

차라리 `nil`로써 냅두는게 낫다고 본다.

그래서 적용을 해보자.

> 독단적인 케이스니 `protocol`을 적용하지 않는다.

<br>

마찬가지로 `enum JSONDefaultWrapper {}` 안에 선언을 해준다.

```swift
enum `JSONDefaultWrapper` {
    // Property Wrapper - Optional Timestamp to Optinoal Date
    @propertyWrapper
    struct TimestampToOptionalDate {
        var wrappedValue: Date?
    }
}
```

<br>

여기서 봐야할 점은 wrappedValue가 옵셔널이라는 점?

그렇담 초기화해도 문제가 없다. 

어차피 `nil`로 들어가면 되니깐.

<br>

(여기서 `struct` 생성과 동시에 `Decodable`을 넣고 `init(from decoder: Decoder)`을 만들면 
자동으로 `init()`은 생성 되지 않는 것을 알게 되었다.)

<br>

그 다음은 마찬가지로

`Decoadable` 받아주고

```swift
extension JSONDefaultWrapper.TimestampToOptionalDate: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let timestamp = try container.decode(Double.self)
        let date = Date.init(timeIntervalSince1970: timestamp)
        self.wrappedValue = date
    }
}
```

<br>

`KeyedDecodingContainer` 확장해주고

```swift
func decode(_ type: JSONDefaultWrapper.TimestampToOptionalDate.Type, forKey key: Key) throws -> JSONDefaultWrapper.TimestampToOptionalDate {
    try decodeIfPresent(type, forKey: key) ?? .init()
}
```

이러면 준비끝.

<br>

# 리스트

진짜 진짜 마무리로 리스트 처리 던지고 끝내기

별도로 랩퍼 만들 필요 없다. 이미 다 갖춰 졌다.

<br>

`JSONDefaultWrapperAvailable.TypeCase`에 정의만 해주고!

```swift
enum TypeCase {
    enum List<T: Decodable & ExpressibleByArrayLiteral>: JSONDefaultWrapperAvailable {
        // 기본값 - []
        static var defaultValue: T { [] }
    }
}
```

<br>

`typealias`만 조끔 어렵게 손봐주면

```swift
enum JSONDefaultWrapper {
    typealias EmptyList<T: Decodable & ExpressibleByArrayLiteral> = Wrapper<JSONDefaultWrapper.TypeCase.List<T>>
}
```

<br>

사용 준비 끝!!

<br>

---

# 결과


### 키 미존재
<img src="/assets/images/2021-07-12/img.png" style="zoom:40%;" />

---

### 키 존재
<img src="/assets/images/2021-07-12/img-1.png" style="zoom:40%;" />


<br>

아주 좋아ㅏㅏㅏ 드디어 끝!
