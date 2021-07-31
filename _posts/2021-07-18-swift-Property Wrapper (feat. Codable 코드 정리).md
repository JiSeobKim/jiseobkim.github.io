---
layout: post

title: "Swift - Property Wrapper (feat. Codable 코드 정리)"

categories: [Swift]

---

<br>

이것은 이전 `Property Wrapper` 시리즈의 최종 코드 적어 두기용

나중에 내가 보기 쉽게!

관리가 용이하게 코코아팟이나 SPM으로 만들어보고 싶기도 하다.

```swift
protocol JSONDecodeWrapperAvailable {
    associatedtype ValueType: Decodable
    static var defaultValue: ValueType { get }
}

protocol JSONStringConverterAvailable {
    static var defaultValue: Bool { get }
}

enum JSONDecodeWrapper {
    typealias EmptyString = Wrapper<JSONDecodeWrapper.TypeCase.EmptyString>
    typealias True = Wrapper<JSONDecodeWrapper.TypeCase.True>
    typealias False = Wrapper<JSONDecodeWrapper.TypeCase.False>
    typealias IntZero = Wrapper<JSONDecodeWrapper.TypeCase.Zero<Int>>
    typealias DoubleZero = Wrapper<JSONDecodeWrapper.TypeCase.Zero<Double>>
    typealias FloatZero = Wrapper<JSONDecodeWrapper.TypeCase.Zero<Float>>
    typealias CGFloatZero = Wrapper<JSONDecodeWrapper.TypeCase.Zero<CGFloat>>
    typealias StringFalse = StringConverterWrapper<JSONDecodeWrapper.TypeCase.StringFalse>
    typealias StringTrue = StringConverterWrapper<JSONDecodeWrapper.TypeCase.StringTrue>
    typealias EmptyList<T: Decodable & ExpressibleByArrayLiteral> = Wrapper<JSONDecodeWrapper.TypeCase.List<T>>
    typealias EmptyDict<T: Decodable & ExpressibleByDictionaryLiteral> = Wrapper<JSONDecodeWrapper.TypeCase.Dict<T>>
    
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

extension JSONDecodeWrapper.Wrapper: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.wrappedValue = try container.decode(ValueType.self)
    }
}

extension JSONDecodeWrapper.StringConverterWrapper: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.wrappedValue = (try container.decode(String.self)) == "Y"
    }
}

extension JSONDecodeWrapper.TimestampToOptionalDate: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let timestamp = try container.decode(Double.self)
        let date = Date.init(timeIntervalSince1970: timestamp)
        self.wrappedValue = date
    }
}

extension KeyedDecodingContainer {
    func decode<T: JSONDecodeWrapperAvailable>(_ type: JSONDecodeWrapper.Wrapper<T>.Type, forKey key: Key) throws -> JSONDecodeWrapper.Wrapper<T> {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
    
    func decode<T: JSONStringConverterAvailable>(_ type: JSONDecodeWrapper.StringConverterWrapper<T>.Type, forKey key: Key) throws -> JSONDecodeWrapper.StringConverterWrapper<T> {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
    
    func decode(_ type: JSONDecodeWrapper.TimestampToOptionalDate.Type, forKey key: Key) throws -> JSONDecodeWrapper.TimestampToOptionalDate {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
}


```
