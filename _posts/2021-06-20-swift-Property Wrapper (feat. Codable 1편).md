---

layout: post

title: "Swift - Property Wrapper (feat. Codable 1편)"

categories: [Swift]


---


> 이편의 단점이 존재함으로 끝까지 읽기와 다음편은 필수로 읽는 것을 권장!

<br>

[지난 편](https://jiseobkim.github.io/swift/2021/06/13/swift-Property-Wrapper.html)에 이어서 진행!

<br>

지난번의 글의 주제가 `Property Wrapper` 의 기본과  `UserDefault` 에 적용하는 글이었다면,


이번편은 `Codable`에 적용을 해보는 것이 이번 글의 주제!

> 정확히는 Decodable에 적용! 하지만 Codable이 더 익숙할테니 Codable이라 하기.

<br>

---

# 이 포스팅을 하게된 이유


다음과 같은 `JSON`이 있다고 해보자


```json
{
  "isHidden" : "Y"
}
```

<br>

해당 코드를 보면 아쉬움이 있다.

`isHidden` 은 `Bool` 타입이 아니여서 조건문(`if` or `switch`) 등에서 `String` 비교가 들어간다

```swift
// 전제조건: Model이란 구조체에 파싱 되었다는 기준하에 작성
if model.isHidden == "Y" {
    // 어떤 어떤 처리
}
```

<br>

하지만, 개인적으론 다음과 같이 되길 바란다.

```swift
if model.isHidden {
    // 어떤 어떤 처리
}
```

<br>

그렇게 되기 위해선 `isHidden`이라는 값이 `Bool`형태여야 한다.

이 점은 이전에 `CodingKey` 관련 글에서 해결하였다. [참고](https://jiseobkim.github.io/swift/network/2021/05/26/swift-CodingKey-API와-다른-자료형-쓰기.html)

<br>

---

### 개선한 것의 단점

위의 방식은 실제 사용하는 코드에서 내가 원하는 스타일로 코딩을 할 수 있어서 좋았다.

하지만, 단점이 따라왔다. 
```swift
    init(from decoder: Decoder) throws {}
```

<br>

해당 코드가 같이 존재해야한다.

<br>

다시말해, 다음 코드의 주석1,2와 같이 각 프로퍼티들을 다 초기화 해주어야 한다.

```swift
// 이전글중 일부 부분 (https://jiseobkim.github.io/swift/network/2021/05/26/swift-CodingKey-API와-다른-자료형-쓰기.html)
init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    // 1. 사용자명 초기화
    self.userName = try container.decode(String.self, forKey: .userName)
    // 2. 숨김처리 초기화
    self.isHidden = try container.decode(String.self, forKey: .isHidden)
}
```

<br>

여기서는 값이 2개다. 따라서 라인도 2줄이 따라온다.

그런데 여기서 만약 자료형을 바꾸게 된다면 코드가 길어지거나 심하면 라인이 몇줄 추가가 된다.

<br>

이런 자료형 변경이나 프로퍼티가 많다면

각 `init`파트마다 라인의 수는 같이 증가하게 된다.

이게 은근 귀찮다.

편하자고 한건데, 편하자고 준비가 너무 긴 느낌이랄까?

<br>

**그래서 반복적인 이 부분을 개선하고 싶었던 찰나에 Property Wrapper를 적용 가능한 것을 알게 되었다.**

<br>

---

# Property Wrapper와 Codable 

`UserDefault`에서도 보았듯이 `Property Wrapper`를 이용하여 반복적인 행위를 제거하였다.
여기서도 마찬가지다.

**초기화 과정에서 반복되는 행위를 제거하는 것이 목적!**

<br>

### Property Wrapper 작성

```swift
@propertyWrapper
struct StringBoolConverter {
    let wrappedValue: Bool
}
```

이름과 같이 `Bool` 이지만 값은 `String`인 것을 바꿔주는 그런 역할이다.

<br>

이전과는 다르게 `init` 부분 또한 없으며 `get/set` 부분도 없다.

- `init`이 없는 이유는 `Decodable`에 의해 초기화가 될 것이기 때문이다.
- `get/set`이 없는 이유는 `UserDefault`처럼 값처리를 위한 연산이 필요 없기 때문이다.

<br>

> 이거하다가 저번글의 Property Wrapper를 
> "프로퍼티를 초기화 할때, 연산 프로퍼티(getter/setter) 개념을 추가 적용하는 것 (100% 개인 생각)" 
> 라고 요약했는데, 이 말에 대해 조금 더 고민 해봐야겠다.
> "초기화를 커스텀 할 수 있다." 라는 말이 더 어울릴려나...?

<br>

그럼 이제 `Extension`을 해보자

```swift
extension StringBoolConverter: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringBool = try? container.decode(String.self)
        wrappedValue = stringBool == "Y"
    }
}
```

<br>

이 부분은 어렵지 않을 것이다.

내 블로그에서 나오지 않은 `singleValueContainer()`의 경우 프로퍼티 네임과 동일한 것을 찾아서 `decode` 해주는 역할인듯하다.

`CodingKey`를 따로 작성하지 않으면 기본적으로 이루어지는 방식으로 예상된다.

<br>

쓰는 방식은 다음과 같다.

모델을 보자

```swift
struct Model: Codable {
    @StringBoolConverter var isHidden: Bool
}
```

<br>

아주 간단하다!

`@StringBoolConverter`만 붙여주면 이 `isHidden`이라는 값은 `String`으로 온 `Y` 또는 `N` 값에 의해 `Bool`로 변환 되어 초기화가 된다.

<br>

실제로 쓰고, 출력된 결과는 다음과 같다.

<img src="/assets/images/2021-06-20/img-1.png" style="zoom:40%;" />


잘나왔다!

---

<br>

전체 코드를 비교해보자.

<br>

### Property Wrapper 사용 전

```swift
struct Model: Codable {
    let isHidden: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        self.isHidden = try container.decode(String.self) == "Y"
    }
}
```

<br>

### Property Wrapper 사용 후

```swift
struct Model: Codable {
    @StringBoolConverter var isHidden: Bool
}
```

`init`부분이 제거됨에 따라 아주 심플해졌다!

위에 말한바와 같이 `Property Wrapper`로 인해 반복적인 작업이 제거되었다.

<br>

---

# 단점

굉장히 좋음에도 단점이 존재한다.

그것은 `nil`처리가 위와 같은 방식으로는 안된다는 점이다.

위의 코드 예시의 경우 `json`에 `isHidden`이라는 값이 존재한다.

하지만, `isHidden`이라는 값이 없을 경우, 모델에 해당 값을 옵셔널처리 해주더라도 이 코드는 `throw`하게 된다.

<br>

다시 말해 초기화가 안된다!

<br>

실제로 서버에서도 `Request`에 따라 `Response`가 달라질 가능성은 존재한다.

그렇기에 이 단점은 치명적이라 생각된다.

<br>

하지만, 이 단점 또한 커버가 가능하다.

그 포스팅은 다음편에~~
