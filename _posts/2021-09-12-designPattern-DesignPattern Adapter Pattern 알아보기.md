---
layout: post

title: "DesignPattern - Adapter Pattern 알아보기"

categories: [DesignPattern]

---

<br>



> 요즘 체텔카스텐과 롬 리서치 매력에 빠졌다. 이것도 포스팅 해봐야지


오랫만에 디자인 패턴 적용하기!

오늘의 주제는 어댑터 패턴이다.

<br>

# 어댑터의 의미

현실에서 가장 이해하기 쉬운건 역시나 돼지코인듯 하다.

해외 전자 제품은 110v인 경우가 있다.

그런데 이것을 국내로 가져와서 사용하려면 코드와 돼지코를 연결해줘야한다.

이때 돼지코의 역할이 오늘 포스팅 주제인 어댑터 패턴이라고 이해하면 될 것 같다.

<br>

# 어댑터 패턴의 필요성
위와 같은 예제는 이해하기 참 쉽다.

하지만 코드로 적용하려면 어쩌지 라는 생각이 많이 들었다.

<br>

나름 열심히 고심해서 나온 예제는 다음과 같다.

주제는 재난 지원금이다.

<br>

기존 카드사에서 돈을 쓰고 나면 남기는 기록 형태가 있을 것이다.

 ```swift
 class UsedInfo {
     var userName: String
     var id: Int
     var usedDate: Date
     var usedPrice: Double
     
     init(userName: String, id: Int, usedDate: Date, usedPrice: Double) {
         self.userName = userName
         self.id = id
         self.usedDate = usedDate
         self.usedPrice = usedPrice
     }
 }
```

<br>

그런데, 정부에서 지원을 했으므로 그에 맞게 기록을 남기던 어떤 처리를 하던간에

그에 맞는 맞춤형 객체를 따로 만들어두는게 여러모로 편할 것이다.

<br>

근데 고맙게도 아래처럼 형태를 지정해줬다.

```swift
protocol GovUsedInfoAvailable {
    var name: String { get }
    var id: Int { get }
    var date: String { get } // yyyy.MM.dd
    var price: Int { get }
}
```

<br>

그런데, 프로퍼티의 의미적으론 같으나, **이름이 조금씩 다르고, 자료형 또한 다르다.**

간단하게 생각하면, 이 `프로토콜`을 적용해버리면 그만이다.

하지만, 그랬을 경우 다음과 같은 문제가 생긴다.

<br>

### `UsedInfo`의 객체의 코드가 늘어난다.

`getter`로 만들면 되지만 이와 같은 방식을 이용하게 된다면, 또 다른 어딘가와 협업을 할때도

프로토콜을 적용해버리겠지? 

그렇담 얼마나 지저분해질지는 개인의 판단에 맡기겠다.

<br>

### `UsedInfo`의 객체에 영향을 끼친다.
    
미관상도 별로지만, 만에 하나 이 프로토콜을 따르는 어떤 값을 정부와 관련된 코드 외에서 써버린다?

그랬을 경우 나~중에 정부와 협업이 끝나서 필요 없어질 경우, 정부와 일한 코드 부분 외에도 다른 곳도 손을 봐야한다.

<br>

이 행위를 돼지코로 비유해보자 생각해보자.

쓰고자 하는 전자 제품을 분해해서 원하는 형태로 바꾸고 다시 재조립하는 격이다.

<br>

돼지코의 장점은 무엇인가?

220v에 필요한곳에서만 끼우고, 필요 없어지면 빼면 그만이다.

기존 제품에 전혀 영향을 주지 않는다.

<br>

마찬가지로 어댑터 패턴을 쓰려는 이유는

**기존 객체에 영향을 주지 않으면서, 다른 곳에 이용을 하는 것**이라 생각한다.

<br>

# Adapter Pattern 사용

어댑터 패턴을 사용해보자

기존 `UsedInfo`란 객체를 초기화 인자를 받는 새로운 객체 `UsedInfoForGov`를 만들자.

```swift
class UsedInfoForGov: GovUsedInfoAvailable {

    // 0. 기존 객체를 받는 지정 초기화 구문
    init(usedInfo: UsedInfo) {
        self.usedInfo = usedInfo
    }

    // 1. 프로토콜 규약을 따른 프로퍼티들
    var name: String { return usedInfo.userName }
    var id: Int { return usedInfo.id}
    var date: String { return formatter.string(from: usedInfo.usedDate) }
    var price: Int { return Int(usedInfo.usedPrice) }
    
    // 2. 기존 객체를 받는 프로퍼티
    private var usedInfo: UsedInfo
    
    // 3. 날짜 형 변환을 위한 프로퍼티
    private lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }()
}
```
<br>

내용은 정말 간단하다. 

- `GovUsedInfoAvailable` 프로토콜을 준수한다.
- 주석`0` - 기존 객체를 받는다
- 주석`1` - 정부 요청대로 필요한 규격을 따르며 전부 `getter`로만 구현함으로써 필요시 다른 연산이 들어 갈 수 있다.
- 주석`2` - 기존 객체를 담는 프로퍼티
- 주석`3` - `date`에서 쓰일 `DateFormatter`이다. 요청 사항 형태가 `yyyy.MM.dd` 였어서 그렇다!

<br>

다시 한번 장점을 말하자면,

**원본 객체를 전혀 손상 시키지 않는다. 이 부분만 버려도 무방하다. 즉, 유지보수가 쉬워진다.**

끝!
