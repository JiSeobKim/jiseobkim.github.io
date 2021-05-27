---
layout: post
title: Swift - 서버 연동 기본과 Encodable
published: true
author: Kim Ji Seob
category: Network
tags: 
- Swift
- Network
- Encodable
---

라이브러리(Almofire) 없이 통신하기!
<br>


이전편에선 Alamofire를 가지고 통신을 연습했고. 그리고 같이 나왔던 Codable은 < Encodable&Decodable >로 이루어져있었습니다.

[참고: Alamofire와 Codable](https://jiseobkim.github.io/swift/2018/07/21/swift-Alamofire와-Codable.html)
[참고: Alamofire와 Escaping](https://jiseobkim.github.io/swift/2018/07/29/swift-Alamofire와-Escaping.html)

위 내용중 Decodable을 이용하여, 별도의 비강제 해제처리 없이 응답값으로 만든 새 인스턴스를 얻는건 완소기능이었죠.

하지만, Encodable을 사용하진 못했습니다. 실제로 사용할때 Alamofire의 파라미터를 넣을때 형식은 아래와 같습니다

```swift
let param: [String:Any] = [
  value1 : a1,
  value2 : a2
]
```

딕셔너리 형태이며 키는 String 값은 Any 타입입니다. 하지만 Encodable을 이용한다면, JSON 형태의 데이터로 들어가게 됨으로 사용이 불가능 했죠
(Alamofire Codable 이라 검색하면 관련 라이브러리는 많이 있습니다.)

솔직히 개인적으론 라이브러리가 많이 추가되는건 좋지 않다고 생각합니다, 훌륭한 라이브러리들이 많지만 내가 원하는 기능 외에도 차지하는것들이 많을 수도 있기에
자신이 비교적 쉽게 구현을 할 수 있다면, 필요한 정도로만 만들어 쓰는게 좋다고 **개인적으로 생각합니다!**

이번엔 Encodable을 이용하기 위해 라이브러리 없이 통신을 구현해보고자 합니다!



<br>

---

# 서버 연동 기본

## RESTFul API

RESTFul API의 자세한건 나중에 알아보고 쉽게 통신을 하기 위해 생긴 구조적 약속? 정도로 생각을 합시다!

RESTFull API를 찾다보면 CRUD라 용어가 나옵니다.

| CRUD |  의미  | Http Method |
| :--: | :----: | :---------: |
|  C   | Create |    POST     |
|  R   |  Read  |     GET     |
|  U   | Update |     PUT     |
|  D   | Delete |   DELETE    |

이러한 용어들의 약어이며, 만들고, 읽고, 수정하고, 삭제할때 각각 기능을 쓰게 되는것입니다.

이글에선 CRUD 이런건 모르더라도 해당 메소드들이 사용되기에 (POST / GET / PUT / DELETE) 4가지가 있다는걸 숙지하고, 

이 4가지 외엔 사용이 안되기에, 이럴 경우엔 열거형(enum)이 제격입니다

```swift
enum HttpMethod: String {
        case post = "POST"
        case get = "GET"
        case put = "PUT"
        case delete = "DELETE"
    }
```

이제 해당 필요한 자리엔 **`HTTPMethod`** 를 쓰면 됩니다. 



<br>

## 구조

오늘 필요한 함수를 미리 한번 훑어 보면 아래와 같습니다

```swift
func requestTest(url: String, type: HttpMethod, body: Data? = nil) {
    guard let url = URL(string: url) else { return }
    
    // 1. 요청 객체 생성
    var request = URLRequest(url: url)
    // 2. 요청 방식
    request.httpMethod = type.rawValue
    // 3. 헤더
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    // 4. 바디
    request.httpBody = body
    // 5. Session
    let session = URLSession.shared
    let task = session.dataTask(with: request) { (data, response, error) in
        guard error == nil else {
            print(error!.localizedDescription)
            return
        }
        
        do {
            let anyData = try JSONSerialization.jsonObject(with: data!, options: [])
            print(anyData)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    // 6. 실행
    task.resume()
}
```



<br>

### 1. 요청 객체 생성

통신을 요청할때 사용되는 **URLRequest** 라는 Swift 기본 제공 구조체가 있습니다. 여기에 인자 값으로는 URL만 넣어주면 객체가 생성됩니다. 쉽죠?

<br>



### 2. 요청 방식

위에서 만든 열거형이 사용될때가 왔습니다. 함수를 내용없이 다시 보면

```swift
func requestTest(url: String, type: HttpMethod, body: Data? = nil) {}
```

2번째 인자값인  **`type`** 이 위에 만든 열거형입니다! 



실제 사용될땐 이렇게 됩니다



![]({{ site.baseurl }}/assets/img/post/2018-08-05/img1.png)



빨간색 오류 없을때 캡쳐 실패해서 아쉽지만, 중요한건 입력 목록에 (delete / get / post / put) 만 뜨는 점이 매력적이죠

다른 값은 입력이 불가능합니다. 즉, 오타나 다른 값을 넣어서 실수하는것이 방지 되는것이죠.



```swift
// 2. 요청 방식
request.httpMethod = type.rawValue
```

위의 코드에 보면 request라는 구조체에는 httpMethod라는 **String 타입**인 저장 프로퍼티가 있습니다. (저에겐 저장 프로퍼티는 잘 안쓰는 말이라 어색하지만 블로그이기에 사용해야할것 같아서 사용했습니다! Struct 내의 선언된 변수로 생각하시면 됩니다.)

근데 보면 **type.rawValue** 라는것이 써있는데 이건 간단합니다. type이라고 안쓰는 이유는 type은 자료형이 HttpMethod입니다. 즉 String이 아니죠, 그렇지만 각각 case의 String값이 부여 되어있었죠. 그 값들을 사용하기 위해 위와 같은 방법으로 값을 꺼내올 수 있습니다.



<br>

### 3. 헤더 (Header)

여기서 통신에 필요한 개념이 나옵니다. 바로 **헤더**와 **바디** 입니다. 좀 더 쉽게 표현하자면, 통신의 정보(Header)와 전달할 내용(Body)라고 생각하고 있습니다. **(통신에 대해 지식이 짧기때문에 조금더 찾아보시는걸 권장합니다)**



여긴 헤더 파트이니 헤더만 보면!

적힌곳에 컨텐츠 타입이란 것이 있습니다.

```swift
// 3. 헤더
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
```

<br>

즉, 내가 무언가 정보를 전달할껀데 이건 JSON으로 되어있어! 이런 정보입니다. (틀리다면 말씀해주세요!)

> 이 통신의 타입("Content-Type")은 JSON("application/json") 이야! 정도??



여기엔 컨텐츠 타입말고도 다른것도 들어갈수 있습니다. 정보를 비밀스럽게 담고있는 토큰(Token)같은 것들?? 자세한건 나중에!

<br>

### 4. 바디(Body)

그럼 이제 바디를 설명하기전에 로그인 절차를 생각해봅시다

1. 아이디 입력
2. 비밀번호 입력
3. 로그인 버튼 클릭



이런 과정이 있겠죠. 여기서 3은 기능이고 1,2번은 정보입니다. 즉 파라미터죠 이게 바디입니다.

(Alamofire에선 [String:Any]에 해당되고 해당 값들은 라이브러리내에선 JSON 데이터로 형변환하게됩니다!)

우리가 로그인을 요청할때 이런 파라미터는 꼭 필요합니다. 

하지만 정보를 얻어오기만 한다면? 예를들어 음, 현재 시간을 가져오는 API일 경우 필요가 없죠 그래서 

```swift
func requestTest(url: String, type: HttpMethod, body: Data? = nil) {}
```



위와 같이 body에 해당 되는 데이터는 없을수도 있기에 옵셔널 처리 하고 default는 nil로 해놨기에 함수 사용할땐 없애도 되는 부분입니다. 이렇게



```swift
// 바디없이 사용
requestTest(url: url, type: .post)
```



<br>

### 5. 세션 (Session)

세션은 코드가 위것들보단 조금 어려워보입니다. 일단 코드를 보면



```swift
// Session
	// 1. 객체 생성
    let session = URLSession.shared
	// 2. 이 객체가 할일 (with: 요청값)
    let task = session.dataTask(with: request) { (data, response, error) in
		// 2-1. error가 발생여부
        guard error == nil else {
            // 2-2. error 출력
            print(error!.localizedDescription)
            return
        }
        
        do {
            // 2-3. 받은 Data을 Any 형태로 변환
            let anyData = try JSONSerialization.jsonObject(with: data!, options: [])
            // 2-4. 결과값 출력
            print(anyData)
        } catch {
            print(error.localizedDescription)
        }
    
    }
	// 3. 실행    
	task.resume()
```



1. 통신하게될 객체 생성
2. 요청값(위에서 만든 URLRequest)를 가지고 통신 및 응답값 처리(클로져)를 구성
3. 2번 실행



이렇게 됩니다. 1과 3은 단순하고 2를 좀더 보면

통신을 위한 셋팅이라고 생각하면 됩니다! 뒤에 클로져의 경우 응답이 왔을 경우 처리이며, 그 값들을보면

1. data: JSON Data
2. response: 페이지의 응답
3. error: 에러났을 경우 정보



2의 경우엔 여러가지 정보가 있습니다. 인터넷중에 404 에러 페이지라는 오류 보신적있나요? 

이는 상태 코드중 하나입니다. 페이지가 없다는 것이고, 200의 경우 이상없이 성공 했을 경우입니다!

여기선 Status Code라고 값을 돌려줍니다. 그리고 "Content-Type" 등등 오는데, 지금은 이값을 이용하여 따로 사용하는건 없습니다! 

이건 데이터를 받은게 아니라 이 통신 응답의 정보를 받은 겁니다!



해당 값 출력하면 아래와 같아요

```swift
<NSHTTPURLResponse: 0x604000036ec0> { URL: (주소값이 나와요) } { Status Code: 200, Headers {
    Connection =     (
        "Keep-Alive"
    );
    "Content-Type" =     (
        "application/json;charset=UTF-8"
    );
    Date =     (
        "Sun, 05 Aug 2018 11:57:54 GMT"
    );
    "Keep-Alive" =     (
        "timeout=5, max=100"
    );
} }
```





> data == Body
>
> response == Header 
>
> 라고 생각하면 편해요
>
> 

2-1,2는 에러났을 땐 출력, 아니면 코드진행 이니 심플하게 패스

<br>

이제 여기가 핵심입니다.  

```swift
do {
    // 2-3. 받은 Data을 Any 형태로 변환
    let anyData = try JSONSerialization.jsonObject(with: data!, options: [])
    // 2-4. 결과값 출력
    print(anyData)
    // + 추가 확인
    if anyData is Any {
        print("It's Any")
    }
} catch {
    print(error.localizedDescription)
}
```



**do ~ try ~ catch**를 짧게 설명하자면 



**do**는 **"내가 무언가 할건데, 이안에서 오류가 날수있어!!"** 하는 부분입니다

**try**는 **"do 안에서 이 코드가 오류 날수 있는부분이야!!"**

**catch**는 **"오류 났을땐 이렇게 처리해줘!"** 입니다.

> try 부분에서 error가 났을 경우 에러를 던진다고 표현합니다. 던졌으면 누가 받아야겠죠? 
>
> 그 누군가가 catch 입니다. 



<br>

위 코드에서 에러가 발생할수 있는 부분은 JSON 데이터를 형변환 하다가 오류가 날 수 있습니다.

그래서 try를 써줘서 대응을 하게 됩니다. 그럼 위에 코드에만 추가로 적은 (+ 추가확인)부분은 저번편에서도 나왔지만

"저 객체의 타입 is Any" 이며 결과 값은 Boolean 형입니다. 타입을 확인 하는 용도입니다! 콘솔창 결과는 아래와 같습니다



![]({{ site.baseurl }}/assets/img/post/2018-08-05/img2.png)



Any 타입입니다! Alamofire에서 response의 성공시 가져온 값에 타입 기억이 나시나요?

전에 쓰던 이미지를 가져왔습니다.

![]({{ site.baseurl }}/assets/img/post/2018-08-05/img3.png)



response라는 응답값을 가지고 통신 성공하였을시 obj로 받았는데 이게 Any 형이었죠. 

이게 위에서 anyData에 해당되는겁니다! 

그럼 이값을 돌려주고 싶다면 지난편에 썼던 **escaping**을 사용하면 되겠죠? 하지만 여기선 패스

<br>

기본 통신이 이렇게 끝났습니다!

그럼 이제 이 함수를 사용해야겠죠

<br>

---

# Encodable

글초반에 말했듯이  **<u>기본적인 Alamofire에선 Ecodable을 사용을 못했습니다.</u>** 

여기서 **포인트는** 위의 함수의 바디값에 들어갈 구조체값을 **Encodable을** 이용하여 **JSON 데이터 형식으로** 바꿔주는것입니다.



일단 구조체 부터 만들고.

```swift
struct LoginData {
    var id: String?
    var pass: String?
}

```



인스턴스를 만들고!

```swift
let info = LoginData(id: "KJS", pass: "1234")

```



이제 형변환을!!

``` swift
do {
    // 1. JSON 데이터로 변환
    let JSONData = try JSONEncoder().encode(info)
    // 2. 위에 만든 함수 실행
    requestTest(url: url, type: .post, body: JSONData)
} catch {
    // 3. 오류 났을 경우
    print(error.localizedDescription)
}
```



1의 경우 **JSONEncoder**라는 것을 사용하게 됩니다. 이것을 **try** 하게 되고 실패시 **catch** 로 오류를 던지겠죠?

성공적으로 JSONData 객체가 만들어졌을 경우 2를 실행하여 우리가 만든 함수를 실행하게 됩니다! 결과를 볼까요?

**( 보안상 URL은 숨김 처리! )**



![]({{ site.baseurl }}/assets/img/post/2018-08-05/img4.png)



네 오류 났습니다. 이유는 Encodable 프로토콜을 구조체에서 빼먹었기때문입니다! 강조를 위해 뺐습니다. 프로토콜을 추가해줍시다.

<br>

```swift
struct LoginData: Encodable {
    var id: String?
    var pass: String?
}
```



그리고 실행!



![]({{ site.baseurl }}/assets/img/post/2018-08-05/img5.png)



네 오류가 없습니다!! 결과창은 보안상 숨겼습니다 ㅎㅎ 그래도 플레이 그라운드에서 빨간줄 안떴으니 JSON 형변환 무사히 마쳤단걸 볼수 있었습니다!!





ps.

글 쓰다보니 네트워크 기본쪽이 많이 빈약한걸 느끼네요, 리스트에 적어놓고 더 공부해야겠습니다. 이만!

