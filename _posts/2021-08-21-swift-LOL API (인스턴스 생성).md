---
layout: post

title: "Swift - JSON 데이터 쉽게 모델 만들기(feat. QuickType)"

categories: [Swift]

---


오늘도 LOL API와 관련이 있다.

<br>

그리고 툴을 하나 소개하려한다.

`QuickType`이라는 것인데,

[앱스토어](https://apps.apple.com/kr/app/paste-json-as-code-quicktype/id1330801220?mt=12)에서 받아도 되고, 다운받기 싫다면 [웹사이트](https://quicktype.io)에서 진행해도 된다.

## 언제 쓸까

<br>

`Codable` 관련해서 글을 많이 쓰다보니

글을 게제하기 위해서 다음과 같은 순서로 진행 했었다.

1. `JSON`파일을 만들거나 `String`을 `JSON`형태로 만든뒤 `Data`로 변경
2. `JSON` 형태 기준으로 구조체 또는 클래스를 만든다.
3. `Codable`을 이용하여 `JSON` 데이터로 인스턴스를 생성한다.


여기서 3번! 3번이 은근히 귀찮았다.

그치만 짧기 때문에 해볼만한 귀찮음이었다.

<br>

회사에서는 데이터 파악할겸 프로퍼티  하나하나 복붙하느라

`QuickType`을 적용해볼 생각 조차 안했다.

> 복붙한 이유는,,, 타이핑 치다가 오타나면 귀찮음이 x3

<br>


그러다가 `LOL API` 관련 포스팅하다가 아주 아주 소름 돋는 경험을 했다.


<br>

제공하는 정보중에 `챔피언 리스트` 라는 것이 있다.

이는 `JSON` 형태로 주는데,  아래 링크를 들어가보면

[링크](http://ddragon.leagueoflegends.com/cdn/11.16.1/data/en_US/champion.json)

> macOS 빅서 사파리에선 파싱이 이상하네? 

> 몬테레이에선 잘됐는데,, 

> 크롬에선 잘된다.

<br>

다음과 같이 거부감이 팍드는 `JSON 데이터`가 나온다.

<img src="/assets/images/2021-08-21/img.png" style="zoom:40%;" />

<br>

이것을 파악하고 하나하나 타이핑 친다는것은

블로그 주제를 포기해야하나 할만큼 내적 갈등을 일으켰다.

<br>

그러다가 `QuickType`이 생각 났고 적용 해보았다.

그랬더니 놀랍게도 다음과 같은 처리가 되었다.

<img src="/assets/images/2021-08-21/img-1.png" style="zoom:40%;" />

<br>

**와우**

뭔가 딱 보기에도 상당히 정리된 느낌의 데이터들이 나왔다.

<br>

그런데 가장 놀라웠던 점은

`enum`까지 정의를 해준다는게 가장 신기했다.


<br>

---

<br>

# Quick Type과 Enum


자동으로 추출되는 `Enum`들을 가져왔다.

```swift
enum TypeEnum: String, Codable {
    case champion = "champion"
}

enum Sprite: String, Codable {
    case champion0PNG = "champion0.png"
    case champion1PNG = "champion1.png"
    case champion2PNG = "champion2.png"
    case champion3PNG = "champion3.png"
    case champion4PNG = "champion4.png"
    case champion5PNG = "champion5.png"
}

enum Tag: String, Codable {
    case assassin = "Assassin"
    case fighter = "Fighter"
    case mage = "Mage"
    case marksman = "Marksman"
    case support = "Support"
    case tank = "Tank"
}

enum Version: String, Codable {
    case the11161 = "11.16.1"
}
```

이것들은 `String` 또는 `[String]` 중 일부가 자동으로 생성 된건데,

어떤 `String`은 `String`으로 남아있고 어떤 것은 `enum`으로 생성되었다.

> 기준은 제작자만 알 수 있으려나? 조금 애매하다

<br>

개인적으로 다른 것은 쓸지 말지 고민 해봐야겠지만

`Tag`라 생성된 것은 굉장히 좋아 보였고,

망설임 없이 그대로 사용할만한 케이스였다.

<br>

---

# 사용

자동으로 파싱하고 모델도 생성된 것은 보았다.

이제 잘 작동을 하는지 보자.

[지난편](https://jiseobkim.github.io/swift/2021/08/16/swift-내가-쓰는-Network-Request-스타일(Moya-착안).html)에서 

통신을 쉽게 할 수 있게 정리를 해두었고, 

해당 주소로 호출 한 뒤, `NSDictionary` 형태로 그대로 출력 해보자


### 통신 - NSDictionary

```swift
let api = API.getChampionList

api.request { result in
    switch result {
    case .success(let dict):
        guard let dict = dict else { return }
        print(dict)
    case .failure(let e):
        print(e.localizedDescription)
    }
}
```

<br>

### 결과 - NSDictionary

<img src="/assets/images/2021-08-21/img-2.png" style="zoom:40%;" />

오케이 통신엔 문제 없고,

너무 기니깐 그만 보자.

<br>

### 통신 - ChampionList

이제 `QuickType`으로 만들어진 `ChampionList`라는 타입으로 통신해보자

너무 많을 테니 한 캐릭터만 가져오자

> Dictionary라 순서 보장이 안된다

```swift
let api = API.getChampionList

api.request(dataType: ChampionList.self) { result in
    switch result {
    case .success(let list):
        guard let first = list.data.first else { return }
        print("""
            name: \(first.key)
            info: \(first.value)
            """)
    case .failure(let e):
        print(e)
    }
}
```

### 결과 - ChampionList

<img src="/assets/images/2021-08-21/img-3.png" style="zoom:40%;" />

인스턴스가 잘 생성되었다!

> 안이쁜건 넘어가자

<br>

인스턴스가 잘 생성되었다는건 쓰기에도 이제 편하게 쓸 수 있다는것~

으 이것들 하나하나 입력했으면 시간이 많이 걸렸을 텐데

이렇게 만들어 주다니 너무 좋다.

마음에 안드는 부분은 살짝만 손보면 되니, 앞으론 적극적으로 사용해봐야겠다.

<br>

끝!
