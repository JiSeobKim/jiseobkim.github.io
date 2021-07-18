---
layout: post

title: "Swift - Property Wrapper (feat. Codable 코드 정리)"

categories: [Swift]

---

<br>

이것은 이전 `Property Wrapper` 시리즈의 최종 코드 적어 두기용

나중에 내가 보기 쉽게!

관리가 용이하게 코코아팟이나 SPM으로 만들어보고 싶기도 하다.

```
protocol JSONDefaultWrapperAvailable {
    associatedtype ValueType: Decodable
    static var defaultValue: ValueType { get }
}

protocol JSONStringConverterAvailable {
    static var defaultValue: Bool { get }
}

enum JSONDefaultWrapper {
    typealias EmptyString = Wrapper<JSONDefaultWrapper.TypeCase.EmptyString>
    typealias True = Wrapper<JSONDefaultWrapper.TypeCase.True>
    typealias False = Wrapper<JSONDefaultWrapper.TypeCase.False>
    typealias IntZero = Wrapper<JSONDefaultWrapper.TypeCase.Zero<Int>>
    typealias DoubleZero = Wrapper<JSONDefaultWrapper.TypeCase.Zero<Double>>
    typealias FloatZero = Wrapper<JSONDefaultWrapper.TypeCase.Zero<Float>>
    typealias CGFloatZero = Wrapper<JSONDefaultWrapper.TypeCase.Zero<CGFloat>>
    typealias StringFalse = StringConverterWrapper<JSONDefaultWrapper.TypeCase.StringFalse>
    typealias StringTrue = StringConverterWrapper<JSONDefaultWrapper.TypeCase.StringTrue>
    typealias EmptyList<T: Decodable & ExpressibleByArrayLiteral> = Wrapper<JSONDefaultWrapper.TypeCase.List<T>>
    typealias EmptyDict<T: Decodable & ExpressibleByDictionaryLiteral> = Wrapper<JSONDefaultWrapper.TypeCase.Dict<T>>
    
    // Property Wrapper - Optional Type to Type
    @propertyWrapper
    struct Wrapper<T: JSONDefaultWrapperAvailable> {
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
        
        enum StringFalse: JSONStringConverterAvailable {
            // 기본값 - false
            static var defaultValue: Bool { false }
        }
        
        enum StringTrue: JSONStringConverterAvailable {
            // 기본값 - false
            static var defaultValue: Bool { true }
        }
        
        enum List<T: Decodable & ExpressibleByArrayLiteral>: JSONDefaultWrapperAvailable {
            // 기본값 - []
            static var defaultValue: T { [] }
        }
        
        enum Dict<T: Decodable & ExpressibleByDictionaryLiteral>: JSONDefaultWrapperAvailable {
            // 기본값 - [:]
            static var defaultValue: T { [:] }
        }
    }
}

extension JSONDefaultWrapper.Wrapper: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.wrappedValue = try container.decode(ValueType.self)
    }
}

extension JSONDefaultWrapper.StringConverterWrapper: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.wrappedValue = (try container.decode(String.self)) == "Y"
    }
}

extension JSONDefaultWrapper.TimestampToOptionalDate: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let timestamp = try container.decode(Double.self)
        let date = Date.init(timeIntervalSince1970: timestamp)
        self.wrappedValue = date
    }
}

extension KeyedDecodingContainer {
    func decode<T: JSONDecoderWrapperAvailable>(_ type: JSONDecoderWrapper.Wrapper<T>.Type, forKey key: Key) throws -> JSONDecoderWrapper.Wrapper<T> {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
    
    func decode<T: JSONStringConverterAvailable>(_ type: JSONDecoderWrapper.StringConverterWrapper<T>.Type, forKey key: Key) throws -> JSONDecoderWrapper.StringConverterWrapper<T> {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
    
    func decode(_ type: JSONDecoderWrapper.TimestampToOptionalDate.Type, forKey key: Key) throws -> JSONDecoderWrapper.TimestampToOptionalDate {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
}
```
