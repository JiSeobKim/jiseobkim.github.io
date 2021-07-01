---

layout: post

title: "Swift - Property Wrapper (feat. Codable 2편)"

categories: [Swift]


---

<br>

[지난 편](https://jiseobkim.github.io/swift/2021/06/20/swift-Property-Wrapper-(feat.-Codable-1편).html)에 이어서 진행!

<br>

지난편 마지막에 단점을 적어주며 마무리를 지었었다.

이번편은 그 단점을 보완하기 위한 편.

배우는 난이도가 생각보다 높았다.

<br>

지난편에 적은 단점의 일부분이다

> ...
> 하지만, `isHidden`이라는 값이 없을 경우, 모델에 해당 값을 옵셔널처리 해주더라도 이 코드는 `throw`하게 된다.
> ...
> 실제로 서버에서도 `Request`에 따라 `Response`가 달라질 가능성은 존재한다.
> 그렇기에 이 단점은 치명적이라 생각된다.

---

<br>

차근 차근 하나씩 풀어나가보자

우선은 `String`에 대해서만 보고 `Generic`을 이용해 범위를 넓혀 보자.

그리고 이전과 같이 다른 타입으로 캐스팅 하는 방법도 알아볼 예정이다.

Codable 파트만 3편으로 나눠야 할 듯 하다.

이것까지 하고 나서야 비로서 실무에 써도 되겠다는 확신이 들었다.

<br>

---

첫번째 JSON 형태는 다음과 같다

```json
{
    "usrNm" : "KJS"
}
```

<br>

그리고 `Class` 형태는 다음과 같다
```
class UserClass: Decodable {
    var usrNm: String
    var usrAddress: String
}
```

<br>

여기서 주목해야할 점은 `클래스`에는 `usrAddress`는 존재하지만 `JSON`에선 존재하지 않는다는점이다.

<br>

**다시 말해, JSON에 없을 경우 기본값 처리를 하고 싶다는 것이다.**

<br>

---


# Wrapper 생성



```swift
@propertyWrapper
struct JsonStringWrapper: Decodable {
    let wrappedValue: String
}
```

<br>

랩퍼가 `Decodable` 프로토콜을 받고 있다. 그리고 `init decode` 될때, 정의가 필요하다.

```swift
extension JsonStringWrapper {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.wrappedValue = try container.decode(String.self)
    }
}
```

<br>

여기까진 이전편까지 같다.

문제는 **없는 기본 값에 대해 처리가 필요하다.**

<br>

우선 위의 랩퍼에 `init()`을 추가해주자

```swift
@propertyWrapper
struct JsonStringWrapper: Decodable {
    let wrappedValue: String
    
    init() {
        wrappedValue = ""
    }
}
```

그럼 단순 초기화시 빈값을 가지게 된다.

<br>

그리고 다음이 핵심이다.


```swift
extension KeyedDecodingContainer {
    func decode(_ type: JsonStringWrapper.Type, forKey key: Key) throws -> JsonStringWrapper {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
}
```

`key`가 존재하면  `extension JsonStringWrapper` 부분에 `decode`를 타게되고 

해당 키가 없다면 `decodeIfPresent`는 nil을 뱉기 때문에 `.init()` 이 된다. 


> 이걸 먼저 했어야했는데, 전편 난이도가 더 높았던거 같네? 아닌가 모르겠다.
> 저 extension KeyedDecodingContainer은 나도 너무 생소해서 이게 더 어려운거 같기도하고...

<br>

위의 말을 거의 같지만 조금 다르게 해보자면

`key`는  위 예시 `JSON` 값 안에 `usrNm`이라는 것을 의미하고,

이게 존재하면 기존 `init(from decoder:)`를 태워서 초기화를 시키는 것이고

존재하지 않으면 미리 정의한 `init()`을 타게 되는 것이다.

<br>

거의 같은 말이지만 반복은 중요하니깐..!

결론은 저렇게하면 서버에서 `JSON`에 값이 안내려와도 `Decodable`을 이용해 미리 정한 초기값으로 객체를 생성할 수 있다는것!

왜 이것을 했는지가 중요하다. 

<br>

이것을 시작한 히스토리를 정리해보자면 아래와 같다.

<br>

--- 

# 1.`Codable`을 이용하여 
#   서버에서 `JSON` 결과 값을 객체화 할 수 있다 

### 아쉬운점

`JSON` 결과에 원하는 값이 없을때, `0`과 같은 초기값을 주고 싶다거나 자료형을 변경하고 싶다면

`init(from decoder: Decoder)` 부분에 모든 프로퍼티에 대해 다 설정을 해줘야 한다.   

```swift
init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    // 모든 프로퍼티 선언해주기
    self.propertyA = try container.decode(String.self)
    self.propertyB = try container.decode(Bool.self)
    self.propertyC = try container.decode(Int.self)
    self.propertyD = try container.decode(String.self)
    ... 
}
```

<br>

### 바라는점
프로퍼티 갯수 만큼 `init`파트에 쭉 나열하는 것은 개선의 필요성을 느낌

<br>

---

# 2. `Property Wrapper`를 이용하면 
#   `init(from decoder: Decoder)`를 안해도 된다.

### 장점

```swift
@propertyWrapper
struct StringBoolConverter {
    let wrappedValue: Bool
}

extension StringBoolConverter: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringBool = try? container.decode(String.self)
        wrappedValue = stringBool == "Y"
    }
}
```

위와 같은 랩퍼를 만들어 둔다면

<br>

```json
{
  "isHidden" : "Y"
}
```

위와 같은 `JSON` 결과는

<br>

```swift
struct Model: Codable {
    @StringBoolConverter var isHidden: Bool
}
```

위와 같이 해주면 깔끔하게 `init(from decoder:)`파트 없이 처리가 가능하다.

<br>

### 아쉬운점

`JSON` 결과 내에 `isHidden`이라는 값이 없다면 `init`시 `throw`를 하게 되어 객체 생성이 되지 않는다.

<br>

### 바라는점

프로퍼티는 만들어뒀지만 `JSON`결과 내에 해당 키가 내려오지 않을 경우 미리 지정한 `default`값으로 초기화 되길 바람.

<br>

---

# 3. 2의 `Property Wrapper` 개선

위에 세번이나 말했지만 한번더 말하자면 `key`가 존재하면 미리 정의한 `init`을 태우게 하고

키가 없다면 미리 정한 초기값으로 초기화되게 하자

```swift
@propertyWrapper
struct JsonStringWrapper: Decodable {
    let wrappedValue: String
    
    init() {
        wrappedValue = ""
    }
}

extension KeyedDecodingContainer {
    func decode(_ type: JsonStringWrapper.Type, forKey key: Key) throws -> JsonStringWrapper {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
}
```

<br>

### 장점

`JSON`에 정의한 키가 없어도 `init()`에 정의한대로 랩퍼값은 `""`으로 들어가게 된다.

<br>

### 아쉬운점

마지막 코드만 보자

```swift
extension KeyedDecodingContainer {
    func decode(_ type: JsonStringWrapper.Type, forKey key: Key) throws -> JsonStringWrapper {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
}
```

이부분은 `type`에 이번에 만든 `JsonStringWrapper`에 대해서만 반응을 하는 메소드이다.

<br>

다시 말해, 

`JSON` 결과 값들 처리를 위해 마찬가지로  `Int`, `Double`, `Float`, `Bool` 등을 랩퍼로 만들게 된다면

해당 메소드는 동일하게 증가되게 된다.

그럼에 따라 이것 또한 아쉽다고 느껴지며 개선의 필요성을 느끼게 되었다.

<br>

그래서 이 아쉬움을 또 달래기 위해 다음편엔 `Generic`을 이용하여 

해당 부분을 줄이는 것에 초점을 맞춰 글을 써보고자 한다.

<br>

끝.
