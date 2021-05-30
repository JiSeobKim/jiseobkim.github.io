---

layout: post

title: "Swift - API에 잘못된 값 처리 (feat. CodingKey)"

categories: [Swift, Network]


---

<br>

CodingKey 관련 글을 먼저 읽는 것을 추천!
[(CodingKey 변수명 다르게 쓰기)](https://jiseobkim.github.io/swift/network/2021/05/19/swift-CodingKey-API와-다른-변수명-쓰기.html) , [(CodingKey 자료형 다르게 쓰기)](https://jiseobkim.github.io/swift/network/2021/05/19/swift-CodingKey-API와-다른-변수명-쓰기.html)

---

오늘은 짧게 쓰기.

<br>

서버에 데이터를 쓰다보면 어김없이 예외처리는 필수.

오늘의 주제는 그 예외처리를 어떻게 할지이다.

필자가 아는 선에선 2가지 정도 처리가 있다.

"만약에 데이터가 잘못 or 안내려온다" 

라는 가정을 해보자

<br>

그렇담 여기서는 이렇게 처리 할 수 있다.

1. 데이터를 nil 처리 해준다
2. 기본값을 넣어준다

<br>

나는 2의 방식을 선호하는 편이다

왜냐면 옵셔널은 정말 좋다 생각하지만, 

결국엔 쓰기 위해선 옵셔널을 벗겨내야하기 때문에

사용하는 곳에 여기저기 `if`문이 붙기 마련이다.

> 어차피 안전하게 벗겨서 쓸거면 미리 안전하게 벗기자를 선호하는편!

<br>


예시를 들게 될 JSON 형태는 다음과 같다.


### 일반적 형태
```
{
    "age" : 1,
    "name" : "학생1"
}

```

### 문제가 발생하는 형태
```
{
    "name" : "학생1"
}

```

<br>

# 옵셔널 처리

이 방식은 아주 간단하다.

```
struct Model: Codable {
    let age: Int?
    let name: String
}
```

위와 같이 단순하게 `age`라는 값에 `?`옵셔널만 붙여주면 

해당 값은 `nil`처리가 될뿐 `Codable`을 통해 `decoding`을 진행해도 문제가 없다.

<br>

근데 만약 `CodingKey`를 사용한다면?

약간의 처리가 필요하다.

<br>

이전 글에서 방식을 배웠다면 다음과 같이 정의를 할 것이다.

```
struct Model: Codable {
    let age: Int?
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case age
        case name
    }
    
    init(from decoder: Decoder) throws {
        let contianer = try decoder.container(keyedBy: CodingKeys.self)
        // 주석1 - sequence값이 없기 떄문에 에러 발생
        self.age = try contianer.decode(Int.self, forKey: .age)
        self.name = try contianer.decode(String.self, forKey: .name)
    }
}
```


주석1에 써둔 이유로 문제의 JSON을 이 코드로 처리하게 된다면 에러가 발생한다.

<br>

그럼 2가지 방식이 있다.

1. try에 `?`붙여주기
2. `decode` 대신 `decodeIfPresent`쓰기

```
// 1
self.age = try? contianer.decode(Int.self, forKey: .age)

// 2
self.age = try contianer.decodeIfPresent(Int.self, forKey: .age)
```

필자의 생각엔 두 방식이 차이는 없다.

단순하게 nil을 넣어도 초기화는 문제가 없기에 try 해도 문제가 되지 않는다.

<br>

# 기본값 처리

옵셔널 처리가 되었고, 이전 포스팅을 보았다면 자료형을 변경하듯이 `nil`일 경우 기본값을 넣어주면 된다.


```
// age의 값이 nil일 경우 기본값 0 처리 하기
self.age = try? contianer.decodeIfPresent(Int.self, forKey: .age) ?? 0
```

<br>

# 마무리

근데 단점이 있다.

옵셔널로 쓰면 간단하지만,

자료형을 바꿀 경우 `enum`도 정의 해야하고 `init` 또한 정의를 해야한다.

그 말은 즉, 코드가 너무 길어진다.

이 단점은 `Protperty Wrapper`로 해결이 가능할것으로 보인다.

`Protperty Wrapper` 써보고 싶었는데 이참에 공부해봐야지

끝.

