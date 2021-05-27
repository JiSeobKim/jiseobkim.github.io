---
layout: post                       
title: "Swift - Generic & Codable"
categories: [Swift]
---

앞선 포스팅글들의 종합판!!

<br>





앞서 포스팅한것들을 나열해보면 

1. Alamofire: 통신을 쉽게 해주는 라이브러리
2. Codable: Swift4부터 생긴것으로 JSON 데이터를 구조체로 만들어주는 굉장히 좋은 프로토콜
3. Escaping: 비동기식 함수(ex: Alamofire)라 불가능했던 return값 처리를 가능하게 하는 방법

크게 이렇게 3가지의 주제로 진행 되었다고 볼 수 있습니다.
이번에 하게될 것은 이것들의 종합판이라 생각하면 될 것 같습니다.

여기까지 오게된 이유는 개발을 하면서 느낀것이지만, 통신이 굉장히 많은데 이것들을 알기 전까진 굉장히 반복적인 코드를 계속 사용해왔다는 것을 느꼈습니다.

그래서 어떻게하면 반복을 줄일까?로 시작해서 Codable, Escaping, Generic 등등을 익혀가면서 적용하게 되었습니다.

최종적 목표는 **반복을 줄여 불필요한 코드 줄이고 사용하기 쉽게 만들기** 이것이 목표입니다



# Q. 가정

여태껏 했던것으로도 충분히 시간과 코드를 줄일 수 있습니다. 그렇지만! Codable을 사용할 형태가 많아진다면? 복잡해질것입니다.



우선 구조체 1개가 있습니다.



```swift
struct StructA: Codable {
    var hp: String?
    var name: String?
    var age: Int?
}
```



총 3개의 구조인데요, 앞서 포스팅 했던 Codable과 Escaping을 이용한다면  Alamofire를 통해 얻은 응답값을 쉽게 해당 구조체의 객체를 얻어낼 수 있습니다.



다른 가정을 보겠습니다.



```swift
struct StructA: Codable {
    var hp: String?
    var name: String?
    var age: Int?
}

struct StructB: Codable {
    var country: String?
    var address: String?
}

struct StructC: Codable {
    var data1: StructA?
    var data2: StructB?
}
```



이번엔 구조체가 3개 입니다. URL도 3개를 사용할 것 입니다! 그렇담 여기서 Codable / Escaping / Alamofire를 똑같이 이용하려면  3가지의 Decodable 함수가 있어야 할까요? 



네 있어야합니다. 



Generic을 사용하지 않는다면 말이죠.



# Generic



> 영어 사전 generic
>
> 1. 일반적인
> 2. 포괄적인
> 3. 총칭적인



제네릭은 다소 낯설수도 있습니다. 저도 책에서 봤지만 책에서 비중도 크지 않았고, 예시는 있었으나 어떻게 사용할지 몰랐습니다. 



영어사전에서 1번의 의미와 같이 일반적인 경우로 만들어줄 수 있습니다. 



이정도 말로는 이해가 힘들기에 코드로 설명을 하겠습니다. 아래는 애플에서 제공하는 예시입니다.



```swift
// 두 숫자 변경
func swapTwoInts(_ v1: inout Int, _ v2: inout Int) {
    let temp = v1
    v1 = v2
    v2 = temp
}

var value1: Int = 10
var value2: Int = 20
print("value1 = \(value1), value2 = \(value2)")

// 함수 호출
swapTwoInts(&value1, &value2)
print("value1 = \(value1), value2 = \(value2)")
```



어렵지 않은 코드입니다. 두가지 인자를 넣고 서로 값을 바꿔주는 것이고,

함수인자 타입에 **inout**이 붙은 이유는 외부의 변수값을 바꿔주기 위해서 입니다. **보통의 경우 값이 복사**해서 들어가기 때문에 함수내에서 inout이 없다면 v1과 v2에 값을 할당할 수 없습니다.

**inout**을 적용해준다면 이를 가능캐합니다. 함수 호출 코드보면 &가 있습니다.

c언어를 배우셨다면 포인터 부분에서 &를 이용하여 주소값을 사용할 수 있었습니다. 그와 마찬가지로 생각이 되며

실제 value1과 value2가 있는 **주소 값을 함수에 넣기 때문에** 함수에서 값 변경시 **실제로 변경**이 됩니다.



그런데, Int형만 해당이 되기때문에 String이나 Double일 경우 사용이 불가능한 함수입니다.

오버라이드를 사용해서 모든 타입에 해야할까요? 그러면 굉장히 불편할것입니다. 



**이런 문제가 있을 때, Generic이 사용됩니다.**



```swift
// 두 변수값 교환
func swapTwoInts<T>(_ v1: inout T, _ v2: inout T) {
    let temp = v1
    v1 = v2
    v2 = temp
}
```



여기서 **T**가 추가되었는데요, 낯설수 있지만 간단합니다. T는 제가 임의로 적어서 만든 제네릭 타입명입니다.

그렇다는건 T가 아니라 V가 될수도 있고 Test가 될수도 있고 마음대로 입니다. 일반적으로 T를 쓰는것 같더군요.



String형과 Int형을 제네릭을 이용한 함수 하나로 사용한 결과 입니다.



![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-08-17/img1.png)



함수 하나를 일반적인 형태로 사용하게 되었습니다! '일반적인 형태로' << '일반적' << 'Generic!!' 훗

그렇다면 초반으로 돌아가 가정이었던, 3가지 다른 구조체를 Codable을 이용하여 객체로 만들어주는 함수를

3개 만드는게 아니라 **일반적으로 쓰일 함수**를 적용하는게 이 글의 최종 목적입니다.



# Enum

우선 enum을 이용해 url들을 정의하고 이를 이용하는 함수도 만들었습니다.



```swift
enum ListURL: String {
        case url1 = "http://localhost/Generic1.php"
        case url2 = "http://localhost/Generic2.php"
        case url3 = "http://localhost/Generic3.php"
        
        func alamofireDefault(handler: @escaping (NSDictionary?)->Void) {
            // url 정의
            let url = self
            // 통신 진행
            let network = Alamofire.request(url.rawValue)
            // 통신 응답
            network.responseJSON { (response) in
                
                switch response.result {
                case .success(let object):
                    // NSDictionary 형태로 변경
                    guard let nsDic = object as? NSDictionary else {
                        // 캐스팅 실패
                        handler(nil)
                        return
                    }
                    // 캐스팅 성공 & 반환
                    handler(nsDic)
                    break
                    
                case .failure(let e):
                    // 통신 실패
                    print(e.localizedDescription)
                    handler(nil)
                }
            }
        }

    }
```



앞선 포스팅의 대부분이 저기에 들어가있습니다. enum, Alamofire, Escaping!

> Enum(열거형)의 장점
>
> 선언한 케이스 외에는 적용 불가능 -> 오류 가능성 낮춤



열거형 안에 관련 함수도 만들어줬습니다. 사용은 어떻게 할까요?

```swift
// 선언
let url: ListURL = .url1
// ListURL 안의 함수 호출
url.alamofireDefault(type: StructA()) { (nsDic) in
    if let value = nsDic {
        print(value)
    }
}
```



결과값을 보기전에 각 url의 JSON 형태의 응답값들은 다음과 같습니다

```
//url1
{"hp":"01012341234","name":"KJS","age":27}

//url2
{"country":"Korea","address":"Seoul"}

//url3
{"data1":{"hp":"01012341234","name":"KJS","age":27},"data2":{"country":"Korea","address":"Seoul"}}
```



url3의 경우 data1에는 url1의 응답과 같은 값, data2의 경우는 url2의 응답값과 같은 값입니다.



![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-08-17/img2.png)



url1만 결과는 쉽게 나왔구요!

근데 여기서 Codable은 쓰지 않고 NSDictionary 형태로만 캐스팅후 돌려줬습니다.



그럼 이때 상황에 따라 Codable을 이용할것입니다.



변경전

```swift
// 선언
let url: ListURL = .url1
// ListURL 안의 함수 호출
url.alamofireDefault(type: StructA()) { (nsDic) in
    if let value = nsDic {
        print(value)
    }
}
```



변경후

```swift
let url: ListURL = .url1
        
        
url.alamofireDefault(type: StructA()) { (nsDic) in
    if let value = nsDic {
        do {
            // JSON으로 변환
            let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
			// Decodable 사용
            let codableObject = try JSONDecoder().decode(StructA.self, from: data)
            print("""
                hp : \(codableObject.hp!)
                name : \(codableObject.name!)
                age : \(codableObject.age!)
                """)

        } catch {
            print(error.localizedDescription)
        }

    }
}
```



이해가 안된다면 아래 링크를 참고해주세요

[참고 : Alamofire와 Codable](https://jiseobkim.github.io/swift/2018/07/21/swift-Alamofire와-Codable.html)

이해가 됐단 가정하에 포인트는 Decodable 사용 부분입니다

![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-08-17/img3.png)



decode함수의 인자가 2가지 입니다. Decodable프로토콜과 데이타



여기서 from부분은 JSON변환된 데이터니 공통 사용이 되지만, 첫번째 인자의 경우는 사용이 안됩니다.



이를 함수로 바꿔도 굉장히 난감할것입니다. 



위 Generic파트 처럼 여러개가 사용이 될 것입니다.



Generic파트에서 해당 문제를 해결한것처럼 **여기서도 Generic을 이용해봅시다.**



함수를 하나 만듭니다.



```swift
func useDecodable<T>(type: T, nsDic: NSDictionary) -> T? {
    // JSON 변환
    do {
        // JSON 변환
        let JSONData = try JSONSerialization.data(withJSONObject: nsDic, options: .prettyPrinted)
        // Decodable을 이용해 객체를 얻음
        let data = try JSONDecoder().decode(T.self, from: JSONData)
        // data 돌려주기
        return data
    } catch {
        // 에러시 출력
        print(error.localizedDescription)
        // nil돌려주기
        return nil
    }
}
```



T라는 타입을 제네릭 타입을 만들었고 문제가 되었던 decode쪽을 보면 아래와 같습니다

```swift
// 일반적인 타입을 넣음 T.self
let data = try JSONDecoder().decode(T.self, from: JSONData)
```



위와 같이 일반적인 타입이 들어가게 됩니다. 

( 주의 !! **이 방식의 단점은 type이라는 인자는 타입만 주기위해 가져올뿐 실제로 사용이 되지 않는다**는 단점이 있습니다. )





실행이 될까요?



![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-08-17/img4.png)



네 안됩니다. 그 이유는 뭘까요? 결론을 얘기하면 **제네릭 타입인 T는 Decodable 프로토콜이 없다**는 것 입니다.

제네릭 T에 프로토콜을 추가해주면 됩니다. 이렇게



```swift
func useDecodable<T: Codable>(type: T, nsDic: NSDictionary) -> T? {}
```

 

함수명 옆에 있던 T 화살표괄호 안에 위와 같이 정의해주면 됩니다.



복붙을 할 누군가 있을진 모르겠지만 편의를 위해 풀코드!

```swift
func useDecodable<T: Codable>(type: T, nsDic: NSDictionary) -> T? {
    // JSON 변환
    do {
        // JSON 변환
        let JSONData = try JSONSerialization.data(withJSONObject: nsDic, options: .prettyPrinted)
        // Decodable을 이용해 객체를 얻음
        let data = try JSONDecoder().decode(T.self, from: JSONData)
        return data
    } catch {
        print(error.localizedDescription)
        return nil
    }
}
```



에러는 사라졌습니다.



![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-08-17/img5.png)



그럼 사용법쪽으로 가서



변경전 

```swift
// 선언
let url: ListURL = .url1
// ListURL 안의 함수 호출
url.alamofireDefault(type: StructA()) { (nsDic) in
    if let value = nsDic {
        print(value)
    }
}
```



변경후

```swift
let url: ListURL = .url1
        
url.alamofireDefault(type: StructA()) { (nsDic) in
    if let value = nsDic {

        switch url {
        case .url1:
            let object = self.useDecodable(type: StructA(), nsDic: value)
            print(object!)
        case .url2:
            let object = self.useDecodable(type: StructB(), nsDic: value)
            print(object!)
        case .url3:
            let object = self.useDecodable(type: StructC(), nsDic: value)
            print(object!)
        }

    }
}
```



switch를 이용해 경우를 나누었고, 이는 보여주기 위해 다 썼습니다. 다르게 유동적으로 활용하면 좋을것입니다!

지금 저 상태는 단순히 보여주기 위함입니다~!



포인트는!! **함수 한가지를 가지고 서로 다른 구조체일지라도 Codable을 이용할 수 있다는 점**입니다. 실제로는 저 함수만 필요할때 따로 사용을 하겠죠?



결과를 보면



URL 1의 경우

![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-08-17/img6.png)



URL 2의 경우

![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-08-17/img7.png)



URL 3의 경우

![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-08-17/img8.png)



모두 잘나왔죠???



저 같은 경우 이런것을 이용해서 좀 더 편하게 실제 사용하고 있습니다! 좀더 편한 방법을 찾아 발견하면 포스팅 해야겠습니다.



이로써 Alamofire, Codable, Escaping, Generic을 모두 사용한 이번 포스팅을 마칩니다!
