---
layout: post

title: "Swift - 내가 쓰는 Network Request 스타일(Moya 착안)"

categories: [Swift]

---

통신문 관련해서 내가 쓰는 스타일을 적은 적이 없는듯하여

언젠간 포스팅 해야지 싶었는데

`롤 API` 관련해서 작성하다가

마침 API 관련 글 적던 중이라 

한번 적고 넘어가면 좋을 듯 하여 적게 되었다.

<br> 

원래는 `Alamofire`만 쓰다가

`Moya`에 대해 알게 되고, 접근 방식이 굉장히 좋다고 생각되었다.

<br>

그렇지만, 미숙함에 의해서 불편함을 느꼈고,

좀더 단순화하자 싶어서 다음과 같은 방식을 쓰게 되었다.

<br>

*ps 글의 기준은 롤 API 관련 되어 있음을 참고바랍니다.

---

<br>
 
# Enum을 사용하다

그전엔 단순히 `Moya`에서 아이디어를 착안하여 쓰다보니

그냥 썼다. 이유는 생각 안하고!

그런데,

`Property Wrapper`편 공부하다보니

class, struct, enum으로 선언하는 것들중 

enum 선언은 class, struct와 다른 점이있다.

<br>

class와 struct의 경우 별도 `init`문을 작성하지 않아도 

기본값이 모두 제공 되면 `default initializer`를 제공하고,

`class`의 경우 기본값이 제공 되지 않고 초기화 구문이 없으면 컴파일 에러를 낸다.

`struct`의 경우 기본값이 제공 되지 않으면 자동으로 `Memberwise initializer`문이 생성된다. 

> 위 내용은 요즘 공식 문서로 공부하다보니 좀더 명확하게 알게 되었다.
 
<br>

여기서 `enum`의 차이는 별도의 초기화가 자동으로 생성되지도 않으며,

컴파일 에러가 나지 않는다는 것이다.

<br>

이에 장점은 `case`에 보다 집중할 수 있다는 점이다.

<br>

그래서 `Enum`을 쓰나보다.

이제 차근차근 코드를 보자.

<br>

---

<br>

# Case 정의

<br>

```swift

import Alamofire
import Foundation

/// 에러 정의
enum NetworkError: Error {
    case notValidateStatusCode  // 유효하지 않는 StatusCode
    case noData                 // 결과 데이터 미존재
    case failDecode             // Decode 실패
}

/// 통신 Enum
enum API {
    /// 유저 정보가져오기
    case getUserInfo(name: String)
    /// 챔피언 리스트 가져오기
    case getChampionList
}
```


### Enum - Error

`Result`를 사용하게 될텐데, 이 부분은 나중에 따로 포스팅하기로하고,,

말 그대로 결과에 대해 정의하기 좋다.

성공과 실패를 나눠서 보내기때문에 `swich`문과 찰떡이다,

> `Almofire`에서 먼저 작성되었는데 `Swift`에도 나중에 추가된것으로 알고 있다.

<br>

위에 말했듯이 실패에 대해서 정의를 해야한다. 이는 `Error`로 정의되어야 하므로,

위에 `NetworkError: Error` 라는 열거형을 하나 생성하게 되었다.

내용은 주석과 같으므로 패쓰.

<br>

### Enum - API

여기에 API들이 차곡 차곡 추가 되면 된다

- 소환사 정보 가져오기
- 챔피언 리스트 가져오기

<br>

두가지에 대해 우선 정의해두었으며,

파라미터가 필요한 소환사 정보 가져오는 API는

`Associate Value`(name: String)를 넣어줌으로써 필요한 값들을 받을 수 있게 된다.

<br>

API의 종류를 정의해줬으니,

통신에 필요한 것들을 정의해보자.

<br>

---

<br>

# 통신에 필요한 정보 정의

```swift
// MARK: 통신 필요 정보 관련
extension API {
    /// API Key
    private var key: String {"발급 받은 API 키"}
    
    /// 도메인
    private var domain: String {
        switch self {
        case .getUserInfo:
            return "https://kr.api.riotgames.com"
        case .getChampionList:
            return "http://ddragon.leagueoflegends.com"
        }
    }
    
    /// URL Path
    private var path: String {
        switch self {
        case .getUserInfo(name: let name):
            return "/lol/summoner/v4/summoners/by-name/\(name)"
        case .getChampionList:
            return "/cdn/11.16.1/data/en_US/champion.json"
        }
    }
    
    /// HTTP 메소드
    private var method: Alamofire.HTTPMethod {
        switch self {
        case .getUserInfo, .getChampionList:
            return .get
        }
    }
    
    /// API Key 필요 여부
    private var isNeedAPIKey: Bool {
        switch self {
        case .getUserInfo:
            return true
        default:
            return false
        }
    }
    
    /// 통신 헤더
    private var header: HTTPHeaders {
        
        var result = HTTPHeaders([
            HTTPHeader(name:"Accept-Language", value: "ko-KR,ko;q=0.9"),
            HTTPHeader(name:"Accept-Charset", value: "application/x-www-form-urlencoded; charset=UTF-8"),
            HTTPHeader(name:"Origin", value: "https://developer.riotgames.com")
        ])
        
        if isNeedAPIKey {
            result.add(HTTPHeader(name: "X-Riot-Token", value: key))
        }
        return result
    }
    
    /// Body Parameter - 주로 Get으로 예상되어 필요 x
    private var parameter: [String:Any]? {
        switch self {
        case .getUserInfo: return nil
        case .getChampionList: return nil
        }
    }
}
```

통신하면서 기본적으로 필요한 것들을 정의 해둔것이다.

거의 `Moya`와 같다고 봐야한다.

이 부분이 너무 매력적이 었으니깐!

<br>

그리고 연산 프로퍼티들이 다 자기 자신 `enum`에 연관되어 있으므로,

새로운 `API`가 `case`로 추가될 경우 여기 부분들이 전부

`컴파일에러`를 뱉게 되므로 실수 없이 다 정의를 해줘야한단 점이 있다.

> 프로토콜 마냥 강압적인것 아주 좋아.  


<br>

그리고 `case`에 따라 다르게 `return`하게 된다.

> 외부에선 따로 호출될 이유가 없기에 모두 `private` 처리


<br> 

---

<br>

# Request 정의


이 부분은 2가지로 나눌 수 있을 것 같다.

- 단순 결과를 NSDictionary로 얻기
- 결과를 원하는 객체로 받기

<br>

`Codable` 관련해선 포스팅한적이 있다. [포스팅](https://jiseobkim.github.io/swift/2018/07/21/swift-Alamofire와-Codable.html)

근데, 회사에서 쓰다보니 정말 단순한건 그냥 `NSDictionary`로 처리하는게 편할때가 있었다.

그래서 베이스를 `NSDictionary`로 처리하는걸 베이스로 잡았다.

<br>

### NSDictionary를 이용한 클로저

```swift
/// 통신 요청
/// - Parameter complete: 결과 클로저 - 성공시 NSDictionary, 실패시 정의 해둔 에러
func request(complete: @escaping ((Result<NSDictionary?,NetworkError>)->())) {
    var url = domain
    
    if let convertedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) {
        url += convertedPath
    }
    AF.request(url, method: method, parameters: parameter, headers: header)
        .responseJSON { response in
            
            // 통신 결과 처리
            switch response.result {
            case .success(let dict):
                // 성공
                complete(.success(dict as? NSDictionary))
            case .failure:
                
                // 결과는 없지만 statusCode에 따라 확인이 필요할 수 있음.
                if let stCode = response.response?.statusCode, 200..<300 ~= stCode {
                    // 성공
                    complete(.success(nil))
                } else {
                    // 진짜 실패
                    complete(.failure(.notValidateStatusCode))
                }
            }
        }
}
```

<br>

위와 같이 메소드를 만들 수 있는데,

파라미터는 단순하게 `Result`를 인자로 갖는 클로저다.

<br>

이때, 성공시 `NSDictionary` 뱉고, 실패시 위에 선언 해둔 `NetworkError`를 뱉게 된다.

주석을 간단히 설명하면 다음과 같다

- **1,2:** 도메인을 가져오고 `path`와 조합을 해야하는데, 한글이 들어갈 수 있으니 인코딩해서 정의
- **3:** 실질적 요청인데 이때, 위에 정의해둔 `url`, `method`, `parameter`등을 조합하게 된다.
- **4:** `Alamfore`도 `Result` 형식을 쓰게 되며 `switch`로 성공과 실패에 대응한다.
- **5:** `responseJSON`이기 때문에 `Any`로 온것을 `NSDictionary`로 캐스팅하여 클로저를 이용
- **6:** 간혹 있는 경우인데, 성공만하고 `response`를 안주는 경우가 있었다.(롤 API말고!)
이럴 경우 이 `switch`문에선 실패로 떨어지지만, 실제론 성공이기 때문에 `statusCode`를 체크해줬다.
- **7:** 성공 범위의 코드이므로 성공
- **8:** 이건 진짜 실패다. 유효하지 않는 `StatusCode`라는 에러 케이스를 사용했다.


<br> 

### Generic을 이용한 클로저

```swift
/// 통신 요청 (with Generic)
/// - Parameters:
///     - dataType: Generic으로 선언된 자료형의 타입을 받는다.
///     - complete: 클로저 - 성공시 T의 객체, 실패시 선언해둔 에러
func request<T: Decodable>(dataType: T.Type, complete: @escaping ((Result<T,NetworkError>)->())) {
    
    // 1. 위에 선언한 요청 메소드를 통해 NSDictionary를 받는다.
    request { result in
        switch result {
        case .success(let dict):
            
            // 2. 데이터 존재 확인
            guard let dicData = dict else {
                // 데이터 미존재 에러
                complete(.failure(.noData))
                return
            }
            
            // 3. 얻은 NSDictionary를 JSON 데이터로 바꾼뒤 T형태로 Decode 해준다.
            guard
                let json = try? JSONSerialization.data(withJSONObject: dicData, options: .prettyPrinted),
                let data = try? JSONDecoder().decode(T.self, from: json)
            else {
                // 4. Decode실패
                complete(.failure(.failDecode))
                return
            }
            
            // 5. T 객체 생성 성공!
            complete(.success(data))
            
        case .failure(let e):
            // 6. Request 실패
            complete(.failure(e))
        }
    }
}

```

<br>

지난 [포스팅](https://jiseobkim.github.io/swift/2018/07/21/swift-Alamofire와-Codable.html) 부분에 자세한건 적혀있지만 간단하게 설명하면 다음과 같다.

<br>

**메소드 선언 부분**
- 메소드에 제네릭 사용, `T`는 `Decodable`을 준수한다.
- 받고 싶은 객체의 타입을 `dataType`으로 파라미터로 받는다.
- 성공 여부에 따라 응답값을 원하는 객체로 담거나 또는 에러를 `Result`로 감싼 인자를 담는 클로저다.

<br> 
**메소드 내용**
- **1:** 이 API에 호출은 그전에 `NSDictionary`로 처리하는 메소드에서 끝났다. 호출만 해서 `NSDictionary`를 처리하자.
- **2:** `NSDictionary`가 잘 왔는지 확인
- **3:** `NSDictionary`를 `Data`로 바꾸고, `JSONDecoder`를 이용해 `Data`를 `T`로 얻어낸다.
- **4:** 3 과정중 실패하면 `Result`를 실패로 보내자
- **5:** T 인스턴스가 잘 생성되었다. 돌려주자
- **6:** 이건 그냥 통신 부분에서 실패.. 그대로 실패로 돌려주자 


> 3의 부분은 `Alamofire.ResponseData`로 받을 경우 안해도 되지만 그러면 또 `StatusCode` 분기 타고 ㅠ 번거롭다 


<br>

이렇게 되면 준비는 끝난다.

<br>

---

<br>

# 사용

하나는 `NSDictionary`, 하나는 `객체`로 받아보자

우선 간단하게 챔피언 리스트를 가져오는 API

<br>

### NSDictionary 클로저로 요청

```swift
// 정의
let api = API.getChampionList

// 요청
api.request { result in
    switch result {
    case .success(let dict):
        print(dict)
        
    case .failure(let e):
        print(e)
    }
}
```

<br> 

굉장히 심플해보인다!

아주 좋다 ㅠ

저 `dict`를 이제 원하는대로 처리 해주면 된다.

<br>

> 실제 저 API는 정말 엄청나게 길다. <br>
> 그래서 따로 출력값은 안보여주고, <br>
> 나중에 롤 포스팅할때 살펴보자. <br>

<br>


### Generic을 이용한 클로저로 요청

객체로 받을거니깐 객체를 정의부터 해보자

이번에 사용될 API는 `소환사 정보` 가져오기다.

<br>

```swift
struct SummonerDTO: Codable {
    let id, accountId, puuid, name: String
    let profileIconId, revisionDate, summonerLevel: Int
}
```

이렇게 생겼다!

> 사실 Codable까진 받을 필요 없다, Decodable만 해줘도 된다.

<br>

이제 사용해보자

```swift
// 사용
let api = API.getUserInfo(name: name)

api.request(dataType: SummonerDTO.self) { result in
    switch result {
    case .success(let data):
        printSummonerInfo(data)
    case .failure(let e):
        print(e)
    }
}

// ...
// 출력
func printSummonerInfo(_ summoner: SummonerDTO) {
    print("""
        ** 결과 **
        id: \(data.id)
        accountId: \(data.accountId)
        puuid: \(data.puuid)
        name: \(data.name)
        profileIconId: \(data.profileIconId)
        revisionDate: \(data.revisionDate)
        summonerLevel: \(data.summonerLevel)
        """)
}
```

<br>

`print`부분을 제외하면 정말 뭐 없다.

`API`정의시, `Associate Value`로 `name`을 내 아이디 넣어주고

요청시, 얻고자하는 객체 타입(`SummonerDTO`)을 넣어줬다.

<br>

그리곤, 결과를 출력 함수 `printSummonerInfo`에 넣어줬다.

<br>

결과는 다음과 같다.

```
** 결과 **
id: waVzd7W1xB47_2P650Jn67EO8iijoAoX6fOEdWqDQVvs0io
accountId: 8VOqFMdQDXwTKPsbSBg5wo08GjcaZlpUmjBs9aSHUn0ap8Y
puuid: ywGOQDCvN_7PsLZChEIyW-4c535T2w5Hi2WfB8E-uIeVpCuQZHT3LuuGIUQ9g7XX-dysavsFfHFtnA
name: 2세트짬뽕2탕슉1
profileIconId: 4569
revisionDate: 1628400316000
summonerLevel: 274
```

<br>

개인적으론 사용하기 넘편하다 생각된다!

> 물론,, 내 사용 범위 한도 내에서...

끝!
