---

layout: post

title: "(swift) CodingKey - API와 다른 자료형 쓰기(feat. Codable)"

categories: [Swift, Network]


---

<br>




이전 글에서 API 결과값의 변수명과 다른 변수명을 쓰는 것에 대해 포스팅을 하였다.
[(이전글 링크)](https://jiseobkim.github.io/swift/network/2021/05/19/swift-CodingKey-API와-다른-변수명-쓰기.html)

이러한 느낌으로 
이번엔 
"서버에서 내려준 자료형과 다른 자료형을 쓰고 싶다!"
라는 생각이 든적이 있었다.

<br>

예를 들어 서버에서 다음과 같이 준다.

```
{
    "userName" : "JS",
    "isHidden" : "Y"
}
```

<br>

그렇담,
일반적으로 서버와 자료명을 맞춰서 쓴다고 가정하면 
모델은 다음과  같을 것이다.

```
struct Model: Codable {
    let userName: String
    let isHidden: String
}
```

<br>

그럼 이제 이것을 쓸때 어떻게 쓰는지를 보자

```
let nameLabel: UILabel!

// ...
// label도 어디선가 초기화 했고, Model도 어디선가 Codable로 초기화 되었다고 가정!

// 통신 후 화면 업데이트
func updateView(model: Model) {
    // 1. 이름 적용
    nameLabel.text = model.userName
    // 2. 숨김 적용
    nameLabel.isHidden = (model.isHidden == "Y")
}
```

여기서 1의 경우 모델 그대로 가공 없이 넣어주면 그만이었다.

그런데 2의 경우는 `Bool` 타입으로 가공하여 적용을 해주었다.

<br>

이게 아쉬웠다.

쓰는 곳에서 별도로 처리하는게 뭔가 귀찮고 깔끔해보이지도 않는다.

모델 안에 `getter`를 써도 되겠지만 이또한 뭔가 아쉬움이 남는다.

<br>

그러다가 `CodingKey`를 알게 되고, 이 `Key`가 초기화 할때 사용이 된다는걸 알게 되었고,

<br>

**초기화할때 커스텀이 가능함을 알게 되었다.**

<br>
<br>


# CodingKey와 Init

지난편에 `CodingKey` 를 정의를 하였지만 구체적으로 어떻게 사용 되는지는 다루지 않았다.

마치 타입추론 같이 알아서 가져다 쓰나보다.

<br>


아래 코드를 보자
```
let value = try JSONDecoder().decode(Model.self, from: response)
```

<br>

자주본 Codable을 이용하여 객체를 얻는 부분이다.

`decode`를 기억하자.

<br>

그리고 모델 부분에 CodingKey Enum을 만들어주고

해당 모델 내에서 init을 입력해서 제안을 보자

<img src="/assets/images/2021-05-26/img-1.png" style="zoom:40%;" />

<br>

파란줄을 보면 `decoder`가 써있다. 

딱봐도 기억하자한 `decode`와 아래의 `decoder` 뭔가 관련이 있을듯 하다.

<br>

그리고 다음과 같이 `container`라는 변수를 만들어준다.

```
init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
}
```

<br>

저 `container`는 무엇인가?

<img src="/assets/images/2021-05-26/img-2.png" style="zoom:40%;" />

<br>

음 대충  **"디코더에 저장된 데이터를 새 키로 박아서 데이터를 반환한다."** 라는 것 같다.

다시 말해, 

```
let value = try JSONDecoder().decode(Model.self, from: response)
```

여기서 decode 했을때 들어간 `response`가 위에서 말한 `데이터`이고

그 데이터와 `Codingkeys.self` 의 키를 연결해서 뱉어 준값이 `container`인 것이다.

> 설명하자니 어렵다

<br>

아무튼,

그럼 현재 `Model`이라는 것은 초기화가 되지 않은 상태다.

이제 할 일은 `container` 데이터를 이용하여 `Model`을 **초기화** 해주는 것!

<br>

# Container와 초기화

```
init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    // 1. 사용자명 초기화
    self.userName = try container.decode(String.self, forKey: .userName)
    // 2. 숨김처리 초기화
    self.isHidden = try container.decode(String.self, forKey: .isHidden)
}
```

1,2의 `try` 부분을 보면 다음과 같이 해석할 수 있다.

**"컨테이너(데이터) 안에서 forKey로 넣은 것에 맞는 데이터를 빼오고, String 타입으로 가져와"**

라는 것이다.

<br>

그럼 이제 `Decode`하면 다음과 같이 이쁘게 출력된다.


<img src="/assets/images/2021-05-26/img-3.png" style="zoom:40%;" />


이 방식을 이용하여 글의 주제였던 **"API 결과 값과 다른 자료형 쓰기"**를 하는 것이다.

<br>

# 자료형 바꾸기

우리가 바꿀 것은 `isHidden`의 자료형을 `String` -> `Bool` 하는 것!

우선 모델의 자료형부터 바꾸자

```
let userName: String
let isHidden: Bool
```

<br>

그러면 자료형이 안맞기 때문에 `init` 부분에서 아래와 같이 에러가 발생한다.

<img src="/assets/images/2021-05-26/img-4.png" style="zoom:40%;" />

<br>

현재 저 결과 값은 `String`이므로 조건을 넣어 `Bool`로 바꿔주자.

```
self.isHidden = try container.decode(String.self, forKey: .isHidden) == "Y"
```

그럼 오류는 사라지게 된다. 

<br>

그리고 빌드해서 브레이크를 걸고 `Variables View`를 보면 다음과 같다.

<img src="/assets/images/2021-05-26/img-5.png" style="zoom:40%;" />

`isHidden`은 `Bool` 타입이라고 정확하게 나왔다!

그러면 이제 맨 처음 예제를 든 코드의 Before 와 After를 보자


### Before
```
// 1. 이름 적용
nameLabel.text = model.userName
// 2. 숨김 적용
nameLabel.isHidden = (model.isHidden == "Y")
```

### After
```
// 1. 이름 적용
nameLabel.text = model.userName
// 2. 숨김 적용
nameLabel.isHidden = model.isHidden
```

<br>

# 마무리

이건 예제이기 때문에 저 한줄을 위해 너무 많은 코드가 추가된 느낌이 든다면 기분탓으로 치자.

아래와 같이 이것을 이용하면 많은 것을 내 맘대로 바꿀 수 있다.

- 시간 타임 스탬프를 바로 `Date`로 정의하기
- enum과 연계하여 정의하기(이게 은근 꿀이다)

등등! 

<br>

끝!
