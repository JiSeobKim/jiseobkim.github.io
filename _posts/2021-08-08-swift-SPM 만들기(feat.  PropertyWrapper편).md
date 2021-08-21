---
layout: post

title: "Swift - SPM 만들기(feat.  PropertyWrapper편)"

categories: [Swift]

---

<br>

지난편에는 `SPM`에 대해서 만드는 기본 방법에 대해 알아보았다.

<br>


이번편에서는 지지난편에 마무리를 지었던
`Property Wrapper`를 SPM으로 만들어서 적용하자.

<br>

지난편 파일에다가 새로운 `swift`파일을 하나 만들어주자.
<img src="/assets/images/2021-08-08/img.png" style="zoom:40%;" />

<br>

그리고 [지난편의 글](https://jiseobkim.github.io/swift/2021/07/18/swift-Property-Wrapper-(feat.-Codable-코드-정리).html)에서 코드를 가져오자. 

<br>


```swift
protocol JSONDecodeWrapperAvailable {
    associatedtype ValueType: Decodable
    static var defaultValue: ValueType { get }
}

protocol JSONStringConverterAvailable {
    static var defaultValue: Bool { get }
}

enum JSWrapper {
    typealias EmptyString = Wrapper<JSWrapper.TypeCase.EmptyString>
    typealias True = Wrapper<JSWrapper.TypeCase.True>
    typealias False = Wrapper<JSWrapper.TypeCase.False>
    typealias IntZero = Wrapper<JSWrapper.TypeCase.Zero<Int>>
    typealias DoubleZero = Wrapper<JSWrapper.TypeCase.Zero<Double>>
    typealias FloatZero = Wrapper<JSWrapper.TypeCase.Zero<Float>>
    typealias CGFloatZero = Wrapper<JSWrapper.TypeCase.Zero<CGFloat>>
    typealias StringFalse = StringConverterWrapper<JSWrapper.TypeCase.StringFalse>
    typealias StringTrue = StringConverterWrapper<JSWrapper.TypeCase.StringTrue>
    typealias EmptyList<T: Decodable & ExpressibleByArrayLiteral> = Wrapper<JSWrapper.TypeCase.List<T>>
    typealias EmptyDict<T: Decodable & ExpressibleByDictionaryLiteral> = Wrapper<JSWrapper.TypeCase.Dict<T>>
    
    // Property Wrapper - Optional Type to Type
    @propertyWrapper
    struct Wrapper<T: JSONDecodeWrapperAvailable> {
        typealias ValueType = T.ValueType

        var wrappedValue: ValueType

        init() {
        wrappedValue = T.defaultValue
        }
    }
    
    // Property Wrapper - Optional String To Bool
    @propertyWrapper
    struct StringConverterWrapper<T: JSONStringConverterAvailable> {
        var wrappedValue: Bool = T.defaultValue
    }
    
    // Property Wrapper - Optional Timestamp to Optinoal Date
    @propertyWrapper
    struct TimestampToOptionalDate {
        var wrappedValue: Date?
    }
    
    @propertyWrapper
    struct TrueByStringToBool {
        var wrappedValue: Bool = true
    }
    
    @propertyWrapper
    struct FalseByStringToBool {
        var wrappedValue: Bool = false
    }

    enum TypeCase {
        // Type Enums
        enum True: JSONDecodeWrapperAvailable {
            // 기본값 - true
            static var defaultValue: Bool { true }
        }

        enum False: JSONDecodeWrapperAvailable {
            // 기본값 - false
            static var defaultValue: Bool { false }
        }

        enum EmptyString: JSONDecodeWrapperAvailable {
            // 기본값 - ""
            static var defaultValue: String { "" }
        }
        
        enum Zero<T: Decodable>: JSONDecodeWrapperAvailable where T: Numeric {
            // 기본값 - 0
            static var defaultValue: T { 0 }
        }
        
        enum StringFalse: JSONStringConverterAvailable {
            // 기본값 - false
            static var defaultValue: Bool { false }
        }
        
        enum StringTrue: JSONStringConverterAvailable {
            // 기본값 - false
            static var defaultValue: Bool { true }
        }
        
        enum List<T: Decodable & ExpressibleByArrayLiteral>: JSONDecodeWrapperAvailable {
            // 기본값 - []
            static var defaultValue: T { [] }
        }
        
        enum Dict<T: Decodable & ExpressibleByDictionaryLiteral>: JSONDecodeWrapperAvailable {
            // 기본값 - [:]
            static var defaultValue: T { [:] }
        }
    }
}

extension JSWrapper.Wrapper: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.wrappedValue = try container.decode(ValueType.self)
    }
}

extension JSWrapper.StringConverterWrapper: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.wrappedValue = (try container.decode(String.self)) == "Y"
    }
}

extension JSWrapper.TimestampToOptionalDate: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let timestamp = try container.decode(Double.self)
        let date = Date.init(timeIntervalSince1970: timestamp)
        self.wrappedValue = date
    }
}

extension KeyedDecodingContainer {
    func decode<T: JSONDecodeWrapperAvailable>(_ type: JSWrapper.Wrapper<T>.Type, forKey key: Key) throws -> JSWrapper.Wrapper<T> {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
    
    func decode<T: JSONStringConverterAvailable>(_ type: JSWrapper.StringConverterWrapper<T>.Type, forKey key: Key) throws -> JSWrapper.StringConverterWrapper<T> {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
    
    func decode(_ type: JSWrapper.TimestampToOptionalDate.Type, forKey key: Key) throws -> JSWrapper.TimestampToOptionalDate {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
}


```

<br>

 조금 길었다.
 
 아무튼! 이상태로 빌드해보면 실패한다.
 
 `CGFloat`을 사용 하였는데, `UIKit`을 `import` 안해줬기 때문이다.
 
 <br>


 
 그런데, `import UIKit`을 하더라도 타겟에 따라 성공할 수도 실패할 수도 있다.
 
 <img src="/assets/images/2021-08-08/img-1.png" style="zoom:40%;" />
 
 <br>

왜냐하면 공식 문서에 따르면 UIKit의 경우 iOS, tvOS에만 가능한 프레임워크이기 때문!

<img src="/assets/images/2021-08-08/img-2.png" style="zoom:40%;" />

타겟을 `Any iOS Device`에 맞춰주자,

<br>

그리고 여기서는 iOS에서만 가능하게 할거니깐 `package`를 살짝 손봐주자
<img src="/assets/images/2021-08-08/img-3.png" style="zoom:40%;" />

<br>

의미는 간단하다. 사용 가능한 플랫폼을 배열 형태로 정의 해준다.

배열에 들어가는 자료형은 `SupportedPlatform`으로 `구조체`이다

<br>

안에 있는 `iOS`는 `enum`을 쓸거라 예상 했는데, 기가막히게도 완벽히 틀렸다.

- `.iOS`: 타입 메소드
- `.v9`:  타입 프로퍼티

너무나도 직관적으로 해석된다. 사용 가능한 플랫폼은 `iOS`고 `v9`이상에서만 가능하다.

따라서 설명 패스.

<br>

타겟 맞추고, 플랫폼을 정의해주고 나서 빌드를 하면 성공을 하게 된다.

<br>

하지만, 

전의 글을 봤다면 실패할것이란 것을 알 수 있다.

<br>

접근제어자가 `internal`로 되어있기에 자신이 쓰려는 프로젝트에선

이 라이브러리를 `import`해주어도 접근이 불가하다.

써야할 곳들에 `접근제어자`를 `public`로 수정해주자.

```swift
public protocol JSONDecoderWrapperAvailable {
    associatedtype ValueType: Decodable
    static var defaultValue: ValueType { get }
}

public protocol JSONStringConverterAvailable {
    static var defaultValue: Bool { get }
}

public enum JSWrapper {
    public typealias EmptyString = Wrapper<JSWrapper.TypeCase.EmptyString>
    public typealias True = Wrapper<JSWrapper.TypeCase.True>
    public typealias False = Wrapper<JSWrapper.TypeCase.False>
    public typealias IntZero = Wrapper<JSWrapper.TypeCase.Zero<Int>>
    public typealias DoubleZero = Wrapper<JSWrapper.TypeCase.Zero<Double>>
    public typealias FloatZero = Wrapper<JSWrapper.TypeCase.Zero<Float>>
    public typealias CGFloatZero = Wrapper<JSWrapper.TypeCase.Zero<CGFloat>>
    public typealias StringFalse = StringConverterWrapper<JSWrapper.TypeCase.StringFalse>
    public typealias StringTrue = StringConverterWrapper<JSWrapper.TypeCase.StringTrue>
    public typealias EmptyList<T: Decodable & ExpressibleByArrayLiteral> = Wrapper<JSWrapper.TypeCase.List<T>>
    public typealias EmptyDict<T: Decodable & ExpressibleByDictionaryLiteral> = Wrapper<JSWrapper.TypeCase.Dict<T>>
    
    // Property Wrapper - Optional Type to Type
    @propertyWrapper
    public struct Wrapper<T: JSONDecoderWrapperAvailable> {
        public typealias ValueType = T.ValueType
        public var wrappedValue: ValueType
        public init() {
            wrappedValue = T.defaultValue
        }
    }
    
    // Property Wrapper - Optional String To Bool
    @propertyWrapper
    public struct StringConverterWrapper<T: JSONStringConverterAvailable> {
        public var wrappedValue: Bool = T.defaultValue
        public init() {
            wrappedValue = T.defaultValue
        }
    }
    
    // Property Wrapper - Optional Timestamp to Optinoal Date
    @propertyWrapper
    public struct TimestampToOptionalDate {
        public var wrappedValue: Date?
        public init() {
            wrappedValue = nil
        }
    }

    public enum TypeCase {
        // Type Enums
        public enum True: JSONDecoderWrapperAvailable {
            // 기본값 - true
            public static var defaultValue: Bool { true }
        }

        public enum False: JSONDecoderWrapperAvailable {
            // 기본값 - false
            public static var defaultValue: Bool { false }
        }

        public enum EmptyString: JSONDecoderWrapperAvailable {
            // 기본값 - ""
            public static var defaultValue: String { "" }
        }
        
        public enum Zero<T: Decodable>: JSONDecoderWrapperAvailable where T: Numeric {
            // 기본값 - 0
            public static var defaultValue: T { 0 }
        }
        
        public enum StringFalse: JSONStringConverterAvailable {
            // 기본값 - false
            public static var defaultValue: Bool { false }
        }
        
        public enum StringTrue: JSONStringConverterAvailable {
            // 기본값 - false
            public static var defaultValue: Bool { true }
        }
        
        public enum List<T: Decodable & ExpressibleByArrayLiteral>: JSONDecoderWrapperAvailable {
            // 기본값 - []
            public static var defaultValue: T { [] }
        }
        
        public enum Dict<T: Decodable & ExpressibleByDictionaryLiteral>: JSONDecoderWrapperAvailable {
            // 기본값 - [:]
            public static var defaultValue: T { [:] }
        }
    }
}

extension JSWrapper.Wrapper: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.wrappedValue = try container.decode(ValueType.self)
    }
}

extension JSWrapper.StringConverterWrapper: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.wrappedValue = (try container.decode(String.self)) == "Y"
    }
}

extension JSWrapper.TimestampToOptionalDate: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let timestamp = try container.decode(Double.self)
        let date = Date.init(timeIntervalSince1970: timestamp)
        self.wrappedValue = date
    }
}

extension KeyedDecodingContainer {
    public func decode<T: JSONDecoderWrapperAvailable>(_ type: JSWrapper.Wrapper<T>.Type, forKey key: Key) throws -> JSWrapper.Wrapper<T> {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
    
    public func decode<T: JSONStringConverterAvailable>(_ type: JSWrapper.StringConverterWrapper<T>.Type, forKey key: Key) throws -> JSWrapper.StringConverterWrapper<T> {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
    
    public func decode(_ type: JSWrapper.TimestampToOptionalDate.Type, forKey key: Key) throws -> JSWrapper.TimestampToOptionalDate {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
}

```
<br>

엮이고 엮이다보니 생각보다 많은 곳에 `public`을 붙여줬다.

거진 다붙였다고 봐야할 듯 하다.

<br>

이제 커밋하고 푸시까지 해주자.

이번에도 `Branch`로 불러오게 할 것이고, 이번 브랜치 명은 `Feature/PropertyWrapper`로 정했다.

그리고 가져오자.

<br>

<img src="/assets/images/2021-08-08/img-4.png" style="zoom:40%;" />

> 갑자기 다크모드 된것 같다면 그것은 기분탓.

<br> 

그리고, `import JSLibrary` 해주고 확인 코드와 결과는 다음과 같다

<img src="/assets/images/2021-08-08/img-5.png" style="zoom:40%;" />

<br>

```swift
// 주석1. wrapper 테스트할 클래스
class TestClass: Decodable {
    @JSWrapper.EmptyString var emptyString: String
    @JSWrapper.IntZero var zeroInt: Int
    @JSWrapper.False var falseBool: Bool
}
```

주석 1의 코드는 위와 같은데, SPM으로 만들어준 `JSWrapper`를 이용했다는게 중점이다.

그 역할은 위의 결과와도 같으며 사용법은 이전 글들을 참고하면 좋을 듯하다.

**결론은 잘된다!**

<br>

예전에 프레임워크 만들다가 실패한적이 있었는데,

SPM 만들기가 생각보다 너무 간단해서 유용하다 생각되는 것들을

내 이름을 넣고 라이브러리 하나 만들면 좋을 듯하다.

<br>


끝!
