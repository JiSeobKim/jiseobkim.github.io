---

layout: post

title: (swift) JSON 파일 불러오기 (feat. Codable)

categories: [Swift, Network]


---

<br>

개발을 하다보면 서버와 같이 일을 해야하는데,

API가 아직 안나왔다면 조금 돌아가는 일을 선택한 적이 많았다.

예를 들어 일단 기획에 나온대로 화면 미리 짜고 API가 나오면 추후에 붙인다거나?

이럴 경우 2가지 경험이 있었다.

<br>

### 통신 파트를 제외하고 화면에 필요한 데이터 구조를 내 마음대로 만든다.

눈에 보이는 데이터로 모델을 만들다보니 화면을 구성하기엔 편했다.
단점은 제대로된 API가 나왔을때 구조적으로 틀어진게 너무 많다. 

몇번 겪어보고선 쓰지 않는 방식.

<br>

### 통신 파트를 제외하고 문서에 나온대로 모델을 만든 후 화면을 구성한다.
고려해야할 부분도 이미 같이 구성했기 때문에 API가 나와도 크게 손댈 곳이 없다.
다만,, 테스트를 위해 더미 데이터를 만드는게 너무나도 귀찮았다.

<br>
**그래서 그 귀찮은 부분을 해결하기 위한 글.**

결론: 프로젝트 안에 json 파일을 생성 후 이 파일을 `Data` 형태로 불러와서, 실제로 통신 데이터 받은 것처럼
처리를 한다.

> 단점: 리스트 더불러오기 같은 경우는 여전히 API가 나온 후에 해야 편한것 같다. 
좋은 방법이 있으면 공유 해주세요!


<br>
<br>

# JSON 파일 만들기


1. 새 파일을 생성하자
<img src="/assets/images/2021-05-16/img-1.png" style="zoom:40%;" />

  
2. String을 검색해주고
<img src="/assets/images/2021-05-16/img-2.png" style="zoom:40%;"/>

   

3. 파일명과 확장자는 `user.json`으로 한뒤 `Next`를 눌러주면 다음과 같은 창이 뜬다. `User .json` 선택
<img src="/assets/images/2021-05-16/img-3.png" style="zoom:40%;" />

   

4. 생성된 파일의 모든 내용을 제거 한후 다음과 같이 JSON 스타일의 코드를 넣어주자 (나름 친절하게 타입도 써보았다.)

   ```swift
   // Type: Dictionary
   {
       "totalCount" : 3, 			// value type: Int
       "users" : [ 						// value type: [Dictionary]
           {
               "name" : "js",  // value: String
               "age" : 30			// value: Int
           },
           {
               "name" : "jw",	// value: String
               "age" : 28			// value: Int
           },
           {
               "name" : "ch",	// value: String
               "age" : 31			// value: Int
           }
       ]
   }
   ```



그럼 이제 프로젝트내에 준비는 끝났다.

<img src="/assets/images/2021-05-16/img-4.png" style="zoom:80%;" />


<br>
<br>

그럼 이제 이 `JSON` 파일을 불러오는 코드를 작성

```
func load() -> Data? {
    // 1. 불러올 파일 이름
    let fileNm: String = "User"
    // 2. 불러올 파일의 확장자명
    let extensionType = "json"
    
    // 3. 파일 위치
    guard let fileLocation = Bundle.main.url(forResource: fileNm, withExtension: extensionType) else { return nil }
    
    
    do {
        // 4. 해당 위치의 파일을 Data로 초기화하기
        let data = try Data(contentsOf: fileLocation)
        return data
    } catch {
        // 5. 잘못된 위치나 불가능한 파일 처리 (오늘은 따로 안하기)
        return nil
    }
}
```

3을 보면 파일명과 확장자는 나눠서 불러온다는 점을 잘 봐야하고,

대소문자도 주의해주고,

4의 부분에서 해당 위치의 파일을 데이터로 초기화 해주는 아주 간단한 코드.

<br>

그럼 이것을 이용하여 `data`로 받은 뒤 `String`으로 형변환을 하여 출력을 해보자.

```
guard
    let jsonData = load(),
    let dictData = String(data: jsonData, encoding: .utf8)
else { return }

print("결과: \(dictData)")
```

위의 코드 결과는 다음과 같다.
<img src="/assets/images/2021-05-16/img-5.png" style="zoom:40%;" />


<br>
<br>

# Codable 더하기

위에서 JSON을 잘불러왔으니 모델을 만들어서 Codable을 이용해보자
[(Codable 관련 글)](https://jiseobkim.github.io/swift/2018/07/21/swift-Alamofire와-Codable.html)

우선 모델을 생성해주자

```
struct UserList: Codable {
    let totalCount: Int
    let users: [User]
}

struct User: Codable {
    let name: String
    let age: Int
}

```

<br>

그리고 이번엔 `Data`를 Codable을 이용하여 `UserList`로 얻어 보자
```
guard
    let jsonData = load(),
    let userList = try? JSONDecoder().decode(UserList.self, from: jsonData)
else { return }
```

<img src="/assets/images/2021-05-16/img-6.png" style="zoom:40%;" />

성공!

<br>
<br>

# 마무리

예제야 짧으니 실제 작업 파일에 써도 무방하겠지만, 

프로퍼티만 수십가지일 경우 정말 지저분해지는 것을 봐야한다

위와 같이 JSON 파일을 별도로 생성해야하는 귀찮음은 있지만, 

실제 작업시 더미 데이터 값을 따로 선언 및 초기화 할 필요가 없다.

<br>
그래서 개인적으론 API가 아직 문서만 나온 단계라면, 이 방식을 요즘 선호한다
