---

layout: post

title: "Swift - Property Wrapper(기본)"

categories: [Swift]


---

<br>

그 동안 `Property Wrapper`에 대한 글은 종종 보았지만, 

정확히 어떻게 어디에 써야겠단 생각이 확실하게 들지 않았었다.

그나마 많은 글에서 다루었던건 `UserDefault`에 쓰이는 것은 조금 흥미로웠다.

<br>

하지만 계속 미루고 미루고 미루고 미루다가 이제서야 흥미가 갈만한 사용처가 발견 되었다.

최근 글의 주제였던 `Codable`과 `CodingKey`과 관련이 있는 부분이라 마음을 먹게 됐다.


<br>

이번 주제는 `Property Wrapper` 개념부터 잡고 가기.

익혀가면서 느낀 소감은 

> 프로퍼티를 초기화 할때, 연산 프로퍼티(getter/setter) 개념을 추가 적용하는 것 (100% 개인 생각) 

한줄로 말하기 정말 어렵다. 몇번을 지운지 모르겠다.

사용하는 곳이 생각보다 다양하게 이루어져서 그렇다.

그래서 포스팅은 몇차례 나눠질것이고,

다양하게 소개를 해볼까한다.


<br>


# Property Wrapper 사용전

### 가정: 푸드트럭 Struct가 있고, 여기서 판매 되는 음식들은 10,000원 이하라는 특징이 있다.

<br>

첫째로 피자만 판매한다고 가정해보자.

```
struct FoodTruck {
    var pizzaPrice: Int
}

```

<br>

10,000원 이하라는 특징이 없다면 위와 같이 단순하게 값을 넣고 빼고 하게 될 것이다.

그렇지만 그 특징이 들어간다면 다음과 같이 바뀌어야 할 것이다.

```
struct FoodTruck {
    // 1. 최대 금액 설정
    private var maxPrice: Int = 10000
    // 2. 접근 제어자를 Private으로 해줌으로써 직접 접근 방지
    private var _pizzaPrice: Int
    
    // 3. setter를 이용하여 값 저장시 maxPrice을 넘을 수 없게 함. 
    var pizzaPrice: Int {
        get { return _pizzaPrice }
        set { _pizzaPrice = min(newValue, maxPrice)}
    }
}
```

<br>

자 여기까지는 뭐 그냥저냥 이렇게하면 되는거아닌가 싶다.

맞다.

근데, 여러개를 판다고 가정해보자. 피자, 파스타, 치킨, 수프, 김치 정도

```
struct FoodTruck {
    private var maxPrice: Int = 10000
    private var _pizzaPrice: Int
    private var _pastaPrice: Int
    private var _chickenPrice: Int
    private var _soupPrice: Int
    private var _kimchiPrice: Int
    
    
    var pizzaPrice: Int {
        get { return _pizzaPrice }
        set { _pizzaPrice = min(newValue, maxPrice)}
    }
    
    var pastaPrice: Int {
        get { return _pastaPrice }
        set { _pastaPrice = min(newValue, maxPrice)}
    }
    
    var chickenPrice: Int {
        get { return _chickenPrice }
        set { _chickenPrice = min(newValue, maxPrice)}
    }
    
    var soupPrice: Int {
        get { return _soupPrice }
        set { _soupPrice = min(newValue, maxPrice)}
    }
    
    var kimchiPrice: Int {
        get { return _kimchiPrice }
        set { _kimchiPrice = min(newValue, maxPrice)}
    }
}
```

오 굉장히 길어진다.

다른 방법은 뭐가 있을까, 지금 떠오르는 정도는 enum을 이용하기?

```
struct FoodTruck {
    
    enum Food {
        case pizza
        case pasta
        case chicken
        case soup
        case kimchi
    }
    
    private var maxPrice: Int = 10000
    private var pizzaPrice: Int
    private var pastaPrice: Int
    private var chickenPrice: Int
    private var soupPrice: Int
    private var kimchiPrice: Int
    
    func getPrice(_ food: Food) -> Int {
        switch food {
        case .pizza: return pizzaPrice
        case .pasta: return pastaPrice
        case .chicken: return chickenPrice
        case .soup: return soupPrice
        case .kimchi: return kimchiPrice
        }
    }
    
    mutating func setPrice(food: Food, price: Int) {
        let realPrice = min(price, maxPrice)
        switch food {
        case .pizza: self.pizzaPrice = realPrice
        case .pasta: self.pastaPrice = realPrice
        case .chicken: self.chickenPrice = realPrice
        case .soup: self.soupPrice = realPrice
        case .kimchi: self.kimchiPrice = realPrice
        }
    }
}
```

흠, 뭔가 그래도 코드 같긴 하지만 길어진듯하고,

`Property Wrapper`를 보고나니 `enum`도 너무 자리 차지 많이하며

그에 따라 `switch` 문도 너무 길게 느껴진다. 

심지어 `get/set` 2개다!



<br>

처음에 느낀점을 말한것 처럼,

프로퍼티 초기화시 ,getter와 setter의 개념을 추가해준다라는 것을 잘 보여 줄 수 있을 것 같다.


<br>


# Property Wrapper 사용후

### 사용 준비

단점이라고 하면 새로운 모델을 만들어줘야 한다는점? 그외에는 잘 모르겠다.

일단, 금액 제한을 걸린 객체를 하나 구성해보자

```
@propertyWrapper
struct MaxPriceOrLessWrapper {
    private var max = 10000
    private var value = 0
    
    var wrappedValue: Int {
        get { return value }
        set { value = min(newValue,max) }
    }
}
```

<br>

`struct`를 만들고 그 위에(혹은 앞에) `@propertyWrapper`를 붙여준다.

그러면 `wrappedValue`라는것을 선언해줘야하는데,

이 `Property Wrapper`가 붙은 모든 값은

`wrappedValue` 연산프로퍼티로 값을 뱉고 정의한다.

이게 핵심이다. 안써주면 오류남!

<br>

내용은 아주 간단하다. 최대 금액을 적어주었고, 연산 프로퍼티 하나를 적어주었다.

그럼 이것을 어떻게 적용하는가?

<br>

### 사용하기

```
struct FoodTruck {
    @MaxPriceOrLessWrapper var pizzaPrice: Int
    @MaxPriceOrLessWrapper var pastaPrice: Int
    @MaxPriceOrLessWrapper var chickenPrice: Int
    @MaxPriceOrLessWrapper var soupPrice: Int
    @MaxPriceOrLessWrapper var kimchiPrice: Int
}
```

아주 아주 아주 심플해졌다. 깔끔! 몇줄이 줄은거지?

<br>

그럼 실제로 잘 동작하는지도 확인해보자

<img src="/assets/images/2021-06-13/img-1.png" style="zoom:40%;" />


아주 아주 훌륭하다. 

하지만 보는것과 같이 아쉬운점은 조금 있다.


1. 위와 같이 초기값이 0이라는 점?
2. MaxPrice가 다 다를수도 있잖아? (디저트, 메인 음식 별로?)

<br>

그 아쉬움도 달랠 수 있다.

다음과 같이 `property wrapper`를 바꾸어준다

```
@propertyWrapper
struct MaxPriceOrLessWrapper {
    private var max: Int
    private var value: Int
    
    init(value: Int, maxPrice: Int) {
        self.max = maxPrice
        self.value = min(value, maxPrice)
    }
    
    var wrappedValue: Int {
        get { return value }
        set { value = min(newValue,max) }
    }
}
```

<br>

초기 세팅을 커스텀하겠다! 라는 것이고

`value`는 마찬가지로 `maxPrice`를 넘지 않는다.

어떻게 쓰는가?

이렇게 쓴다.

```
struct FoodTruck {
    @MaxPriceOrLessWrapper(value: 9000, maxPrice: 10000) 
    var pizzaPrice: Int
    
    @MaxPriceOrLessWrapper(value: 12000, maxPrice: 10000) 
    var pastaPrice: Int
    
    @MaxPriceOrLessWrapper(value: 7500, maxPrice: 10000) 
    var chickenPrice: Int
    
    @MaxPriceOrLessWrapper(value: 400, maxPrice: 500) 
    var soupPrice: Int
    
    @MaxPriceOrLessWrapper(value: 1000, maxPrice: 500) 
    var kimchiPrice: Int
}

```

대박.. 간단해..

그리고 이전 코드를 값 변경없이 처음 print만 보자


<img src="/assets/images/2021-06-13/img-2.png" style="zoom:40%;" />


너무 좋다.




<br>

# UserDefault에 적용해보기


WWDC 세션에도 등장했다는 `UserDefault`에 `Property Wrapper` 쓰기! 

기본적으로 `UserDefault`라 함은 `key`를 가지고 값에 접근하여

쓰거나 얻어 오거나 한다. 다른말로  setter 하거나 getter 한다.

이 또한 처음에 말한것처럼 `Property Wrapper`는 뭐다?

> 프로퍼티를 초기화 할때, 연산 프로퍼티(getter/setter) 개념을 추가 적용하는 것 (100% 개인 생각)

<br>

그럼  또 `Property Wrapper`가 있기 전과 후를 비교해보자

<br>

## UserDefault에 적용해보기 - 사용 전


```
struct UserDefaultManager {
    private static var ud = UserDefaults.standard
    
    static var userName: String {
        get {
            return ud.value(forKey: "userName") as? String ?? ""
        }
        set {
            ud.setValue(newValue, forKey: "userName")
        }
    }
    
    static var hasMembership: Bool {
        get {
            return ud.value(forKey: "hasMembership") as? Bool ?? false
        }
        set {
            ud.setValue(newValue, forKey: "hasMembership")
        }
    }
}
```


단 2개를 썼을 뿐인데 괄호와 이것 저것 너무 많다.

실제로도 저렇게 쓰인 코드 마지못해 썼지만 정말 거슬렸다.

반복에 반복이 너무 많다.

<br>

## UserDefault에 적용해보기 - 사용 후


차근차근 개선해보자

우선 `String`에 대해서만 보자

필요한 것

1. `Key` - 빠질 수 없지
2. `defaultValue` - 없을때 얻을 기본값 정도는 있으면 좋겠다.

```
@propertyWrapper
struct UserDefaultWrapper {
    private let ud = UserDefaults.standard
    // 1. 키
    private let key: String
    // 2. 기본 값
    private var defaultValue: String
    // 3. wrappedValue 정의
    var wrappedValue: String {
        get {
            return ud.value(forKey: key) as? String ?? defaultValue
        }
        set {
            ud.setValue(newValue, forKey: key)
        }
    }
    // 4. 초기값 및 키 셋팅
    init(key: String, defaultValue: String) {
        self.key = key
        self.defaultValue = defaultValue
    }
}
```

이제 이 코드는 어렵지 않을 것이다

그럼 한번 적용해보자.

```
struct UserDefaultManager {
    private static var ud = UserDefaults.standard
    
    // Property Wrapper 적용
    @UserDefaultWrapper(key: "userName", defaultValue: "")
    static var userName: String
    
    static var hasMembership: Bool {
        get {
            return ud.value(forKey: "hasMembership") as? Bool ?? false
        }
        set {
            ud.setValue(newValue, forKey: "hasMembership")
        }
    }
}
```

`userName`과 `hasMembership`중에 `userName`에만 적용을 해보았다. 

너무 심플하다. 괄호와 반복의 지옥에서 벗어난 느낌 ㅠ

근데, 걱정이 될 수 있다. `String`만 했으니깐 다른 타입들도 다 정의를 해야해? 라는 걱정.

<br>

그치만 우리에겐 `Generics`이 있다. 

적용해보자

```
@propertyWrapper
struct UserDefaultWrapper<T> { // 1. 여기에 제네릭 써주고
    private let ud = UserDefaults.standard
    private let key: String
    
    // 2. 여기도 제네릭 써주고
    private var defaultValue: T
    
    // 3. 여기도 제네릭 써주고
    var wrappedValue: T {
        get {
            // 4. 여기도 제네릭 써주고
            return ud.value(forKey: key) as? T ?? defaultValue
        }
        set {
            ud.setValue(newValue, forKey: key)
        }
    }
    
    // 5. 여기도 제네릭 써주고
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}
```

총 5군데에 제네릭을 적용해주었다.

이건 이제 타입 불문하고 다 써줄 수 있다.

<br>

해보자.

```
struct UserDefaultManager {
    private static var ud = UserDefaults.standard
    
    @UserDefaultWrapper(key: "userName", defaultValue: "")
    static var userName: String
    
    @UserDefaultWrapper(key: "hasMembership", defaultValue: false)
    static var hasMembership: Bool
}
```

와우 미쳤다.

<br>

사용은 사용 전후가 다를게 없지만 그래도 쓰는건 다음과 같이.

<img src="/assets/images/2021-06-13/img-3.png" style="zoom:40%;" />

<br>

# 마무리


공부를 하며 코드 작성하면서도 놀랬는데, 블로그 글 쓰면서 보니 더 놀라웠다.

굉장히 간결해진다는 점이 인상적이다.

왜 이제 공부했지?

<br>

코드를 보면 `init`이 굉장히 중요하다. 

없어도 쓸 수는 있지만 `init`이 들어가면 더 활용성이 좋다는것.

<br>

여기서 쓰인 `init`도 있지만, 이전 포스팅중에 `Codable`을 이용한  `init`이 존재한다. 

[여기 참고](https://jiseobkim.github.io/swift/network/2021/05/26/swift-CodingKey-API와-다른-자료형-쓰기.html)

```
init(from decoder: Decoder) throws {}
```


여기에도 적용을 할 수가 있었다.

정말 이거 적용해보고 소리 질렀다.

<br>

그래서 다음 주제는 `Codable`과 `Property Wrapper`에 관한것이다.

<br>

끝.

