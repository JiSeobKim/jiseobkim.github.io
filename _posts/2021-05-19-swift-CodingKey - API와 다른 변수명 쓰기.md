---

layout: post

title: "(swift) API와 다른 변수명 쓰기"

categories: [Swift, Network]


---

<br>
일반적으로 Codable을 기본으로만 사용하다보면 프로퍼티의 명칭을 API 문서를 따라갈 수 밖에 없다.

그치만 이 변수명이 내 개인적인 스타일과 달라 아쉬울때가 있다.

예를 들어, 

나는 변수명을 짧게 쓰는것보단 길게 쓰는것을 선호한다. 
지금이야 짧아도 쓰기 좋지만

한달뒤에 나는 "이 변수명이 뭐 줄임말이였지?"를 하게 되기 때문에 명확히 쓰는것을 좋아한다.

<br> 

그래서 이 글의 주제는 **API와 다른 변수명 쓰기** 이다.

<br>

---

통신 파트는 지난 번에 포스팅한 JSON 파일 불러오기로 대체한다! 관련 내용은 [(여기)](https://jiseobkim.github.io/swift/network/2021/05/16/swift-JSON-파일-불러오기.html)

---

<br>

다음과 같이 서버에서 값을 내려준다고 가정해보자

```
{
    "usrNm" : "js",
    "seqNo" : 23,
    "ordNo" : 1,
    "addr" : "seoul"
}
```

> 쉽게 설명하기 위해 간단한 줄임말로 예를 들었다.

<br>

위와 같은 결과값들을 나였다면 다음과 같이 쓰고 싶어할 것이다.

- usrNm -> userName
- seqNo -> sequenceNo
- ordNo -> orderNo
- addr -> address

<br>

왜? 그냥 내마음이 그렇다. 취향이랄까

그럼 이제 제목에 나온 CodingKey라는 것이 나온다.

<br>
<br>

# CodingKey

이제 JSON 데이터를 Codable을 이용하기 위해 구조체나 클래스 파일을 만들어보자

**프로퍼티 명은 내 마음대로!**

```
struct Model: Codable {
    let userName: String
    let sequenceNo: Int
    let orderNo: Int
    let address: String
}
```

<br>

이런식으로 적어준 다음 Codable을 사용하면 당연히? 오류가 난다.

왜냐면 프로퍼티명을 내 마음대로 했는데, 모든 타입이 옵셔널이 아니니깐!


<img src="/assets/images/2021-05-19/img-1.png" style="zoom:40%;" />

<br>

간단하게 코드 설명하면
- 주석 1: JSON 파일을 이용하여 `Data`를 받아온것
- 주석 2: `JSONDecoder`를 이용하여 `Data`를 `Codable`프로토콜을 준수하는 `Model`이라는 값을 뱉게 한다. 이 `decode` 는 `throws` 하기 때문에 `try`로 받아준다
- 주석 3: 2가 성공시 해당 값 출력
- 주석 4: 2가 실패시 error 내용을 출력

<br>

여기서 오류 출력값을 보면

```
keyNotFound(CodingKeys(stringValue: "userName", intValue: nil), Swift.DecodingError.Context(codingPath: [], debugDescription: "No value associated with key CodingKeys(stringValue: \"userName\", intValue: nil) (\"userName\").", underlyingError: nil))
```

라고 한다. 첫 프로퍼티인 `userName`부터 오류가 났다.

<br>

이래저래 복잡하지만 `userName`이라는 `key`를 찾을 수 없다. 이 `key`는 `Codingkey`를 의미하는 것 같다.

그렇다면 이 키라는 것을 `userName`과 매칭 시켜준다면 될듯하다.

<br>
<br>

# CodingKey 사용

해당 구조체 안에 다음과 같이 `enum`을 하나 생성해준다.

> 다른 곳 보면 CodingKeys라는 enum값을 많이 사용한다. 위 에러에 보듯 한 프로퍼티들을 각각의 키가 존재하니깐 이런 네이밍을 많이 쓰는듯 하다. 뒤에 프로토콜(CodingKey)이랑 항상 헷갈려서 그냥 주저리주저리 적기


```
struct Model: Codable {
    let userName: String
    let sequenceNo: Int
    let orderNo: Int
    let address: String
    
    // 추가해주기
    enum CodingKeys: String, CodingKey {
        case userName = "usrNm"
        case sequenceNo = "seqNo"
        case orderNo = "ordNo"
        case address = "addr"
    }
}
```

위와 같이 선언을 해주면 준비 끝! 각각의 키를 수동으로 셋팅을 해주는 것이다.

보는 바와 같이 각각 케이스들은 `String`들을 가지고 있고, 

`CodingKey` 프로토콜을 준수한다고 명시를 해줘야한다.

이것을 안하면 프로퍼티명 자체가 키가 되는듯 하다.

다시 실행해보자

<img src="/assets/images/2021-05-19/img-2.png" style="zoom:40%;" />


아주 성공적 크킄 좋다.

<br>

# 마무리

이 방식을 이용하면, 서버 변수명에 내 코드가 따라갈 필요가 없어진다.

이런식으로 하나씩 불편함을 해소하는 CodingKey 시리즈!

다음 불편함은 타입 자체를 바꾸는 것이다

예를 들어 useYn = "Y" 라고 오면, 

나는 이것을 `String` 이 아닌 `Bool`로 받고 싶을 것이며, 이것은 다음 주제!




