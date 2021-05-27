---
layout: post                       
title: "Swift - Alamofire와 Codable"
categories: [Swift]
---

요즘 시대엔 앱을 사용하면서 통신은 필수인듯 하다. 
여러 기기간의 동기화, 결제, 등등 통신을 통해 데이터를 다루는 분야가 훨씬 많다.

필자도 맨처음 시작했던 Swift 스터디에서 로컬 앱을 만들었으나 통신의 필요성을 느껴서 졸업 작품때 통신을 하는 앱을 시도 했었으며, 취업에 많은 도움이 되었던 것 같다.

여담으로 아무것도 모르는 상태서 html, php, MariaDB, 포트포워딩 등등 배우려니 너무 힘들었던 기억이 있다. 서버는 집에 있던 NAS를 조금이나마 돈값하게 이용했었다.

그때 Alamofire 라는 훌륭한 라이브러리를 알게 되었다.

CocoaPod을 이용해서 설치했으며, 설치법은 시간이 된다면 나중에 다뤄보기로.....

로컬 서버를 이용한 응답값을 먼저 보자.
(응답값)
![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-21/img1.png)
JSON 형태이며, 값은 간단하게 3개가 온다.

1. hp (String)
2. name (String)
3. age (Int)

간단하지만, 이것을 앱에서 받으려면 처음 사용자는 엄청난 혼란이 온다.
내가 그랬다.

Alamofire만 있다면 아주아주 간단하게 할 수 있다. 라이브러리를 안쓰고 통신도 가능하지만, 라이브러리를 쓴다면 편해지는건 사실! 아직 사용을 안해봤다면 한번쯤 써보게 된다면 아~ 이렇게 쓰는거군! 하게 될것이다.

* 주의: Alamofire를 설치했다는 가정하부터 진행

(앱화면)
![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-21/img2.png)
처음 이미지에 보았던 전화번호, 이름, 나이를 서버로부터 받아서 위의 이미지에 알맞게 데이터를 넣어줄 것이다.

순서는 다음과 같다
1. 통신을 통해 값 받아오기
2. 가져온 값에서 필요한값 빼내오기
3. 빼내온값 표출하기

** * 주의사항 (아래서 추가 설명) **
1. Alamofire 통신시 **비동기**로 진행됨을 잊으면 안된다.
2. UI 관련 작업은 메인쓰레드에서만 가능하다, Alamofire 통신하여 UI 관련 작업이 제대로 안된다면 DispatchQueue.main.async를 이용해서 **메인 쓰레드에서 비동기로** 진행 시켜보자.



<br>

## 1. 통신을 통해 값 받아오기
우선 데이터를 받아오자, 코드는 아주 간단하다. 사진으로 첨부!

![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-21/img3.png)


주석에 따라 설명을 진행!
### 1. Alamofire import하기
가장 중요한 설정인 Alamofire를 import 해줘야한다! 잊지말기


### 2. URL 정의
이건 별다른 설명이 필요하지 않을듯 싶다. 통신을 하기위해선 누구에게 요청을 할것인가는 당연히 필요하기에 URL을 정의해야한다.


### 3. 전송(request)
비록 한줄이지만 이번에 글의 가장 중요한 부분이다. Alamofire 라이브러리를 이용해주면 저렇게 단 한줄에 요청(request)을 할 수있다. 여기서 요청이란 주소창에다가 해당 URL을 입력했다. 정도로 생각하면 된다. 

(RESTFull API의 경우 추후 별도 포스팅 예정)


### 4. 응답(response) 처리
응답이란 3에서 말한 URL을 입력했다가 전송(request)이라면, 입력했을때 반응(response)한것이 응답값이다. 
![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-21/img1.png)
> 이해가 잘안된다면, "내가 주소창에 URL을 입력(요청)했더니 위와 같은 화면(응답)이 나왔다" 정도로?? 생각하자.


**그렇담 여기서 doNetwork 뒤의 responseJSON이란 ??**

위의 이미지는 JSON 형태로 응답을 하고 있다. 그렇기에 responseJSON을 써주는 것이다.

바로뒤에 중괄호가 있다. 이건 클로져 구문이다. 일반적인 함수에는 소괄호'()'안에 인자값들이 있다. '**in**' 앞에 부분이 인자값이다. 다시말해 응답한 값은 response라는 변수에 담아주는 것이다. '**in**'이후에 나오는 것은 일반적인 함수에서  중괄호'{}' 에 해당되는 부분이다.   ****

> 이 부분은 엄밀히 따지면 response  데이터가 저 JSON만을 의미하는게 아니다. 
>
> 아 그런거구나 정도만 일단 생각하고, 아래서 추가 설명


### 5. 결과에 따른 switch문
명확히 얘기하면 **response**는 JSON 문구를 의미하는게 아니다. 우리가 그다음 판별 해야할것은 내가 요청한 통신이 성공 or 실패를 먼저 따져야한다. 실패의 경우 여러가지가 있다, 정확하지않은 URL, 인터넷 끊김 등등?

성공에 의미는 위의 JSON 데이터를 성공적으로 가져왔다는 것이다. 즉, 우리가 사용할 수가 있다는 것이다. 
쓸 수 있는 값을 못가져 온경우를 모두 실패로 생각하자! 



response.result 에 대해 좀 더 깊숙히 들어가보면 아래와 같다.

![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-21/img4.png)

우선 타입은 enum이다, 그리고 그 케이스는 2가지다 

1. **success**
2. **failure**

그래서 위에서 switch문을 썼을때 2가지만 써도 **"default일 경우에 대비하세요"**라는 경고를 안띄운다. <br>

1. **isSuccess는 성공 여부**
2. **isFailur는 실패 여부**
3. **value는 받아온 값**
4. **error는 Error 타입** 

이 둘중 한가지는  nil이기 때문에 옵셔널으로 감싸져있다.

필요할때 알맞게 사용하도록 하자. 여기서 우리가 필요한건 success의 value이다.

### 5-1. 통신 성공
타입을 먼저보자.
![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-21/img5.png)
Any 형태이다. 왜 Any일진 생각해보면 간단하다.

그럼 실행을 해보자
![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-21/img6.png)
콘솔창에 보면 성공적으로 가져왔다. 위에서 말했듯이 이 값의 타입은 Any이다. NSDictionary로 캐스팅을 먼저해야하자.

![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-21/img7.png)
NSDictionary 타입으로 캐스팅 후 for문으로 출력해주었다. 아주 잘나왔다. 끝이 보인다.


각 데이터를 빼오자.
![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-21/img8.png)
각각 전화번호/이름/나이 데이터를 비강제 해제 (unwrapping) 해주었다.

어려운말이다. 써보고 싶었다. 그치만 하도 안썼더니 나도 어색하다. 쉽게 말해 if문을 써서 안전빵으로 데이터를 가져오고 설정해줬다.

다운캐스팅 할때 `as?`을 써줌으로써 실패시 nil로 바뀌게 될것이고, 이 경우엔 swift에선 해당 라인을 실행 안한다고한다! 훌륭해.

우선, 통신 하기전 화면을 보자
![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-21/img9.png)
못생겼다.

그럼 통신 후!
![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-21/img10.png)
번호/이름은 잘들어갔다. 그치만 나이는 적용이 안되었다.

해당부분 값을 출력해보자.

![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-21/img11.png)
새로 배운 기술이다. 브레이크 포인트에 lldb(Low Level Debugger) 명령어를 입력해주면, 해당 부분 가서 알아서 해당 명령어를 실행해준다. 해당 명령어 입력부분 아래에 옵션 체크를 해주면 원래는 break 걸면 해당 라인에서 멈춰야하지만 명령어 실행 후 자동으로 다시 진행한다. 

아직 print 찍는게 편하지만 자주 쓰는곳에 걸어두면 편하다. disable 했다가 On/Off해주기만 하면 되니깐!


그게 중요한게 아니고, 콘솔창에 nil이 찍혔다. 

캐스팅이 실패한것이다. response 사진을 다시 보자
![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-21/img1.png)
자세히보면 휴대폰 번호에는 쌍따옴표(" ")가 있지만, 나이 부분엔 없다. 문자가 아니라 숫자이다.
옵셔널 강제해제 였으면 앱이 크래쉬 났을 것이다.


당연한거아니야? 할수 있겠지만, 소소하게 실수할때가 있었었다.... 심지어 스펠링 틀릴경우도 빈번하게 있다!
하지만 Codable를 알게된 후론 세상 편해졌다. 궁금해지지 않는가 Codable? 나만 궁금한가.

이유는 알았으니 일단 고치고
![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-21/img12.png)

실행!
![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-21/img13.png)

완성!!


데이터가 아무리 많아도 이젠 할 수 있다.
![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-21/img14.png)
데이터가 훨~씬 많다. 이것도 해보자.

우선 UI부터 만들고,
![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-21/img15.png)

슬슬 재앙이 일어날 것 같은 예감이 드는가?

코드를 보자

![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-21/img16.png)

위에서 했던 방식대로 진행하면 이렇다. 하는건 쉽다. 하는 것만 쉽다. 굉장히 반복적이다. 별로다.

데이터는 잘왔나?
![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-21/img17.png)

잘왔다. 그런데 힘들다. 예시로 쓰는것도 힘들었다. 이 방식은 쓰지말자

![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-21/img18.png)

하지만, 실제 업무상 데이터가 많이 올때도 있다. 그러므로 우린 방법을 찾아야한다.


이때 아주 훌륭한 Codable을 쓰면 된다. 

# Codable
Codable은 Swift4에서 추가된것이다. 이것 사용하기전엔 위에처럼 비효율적이지만 어쩔수없이 사용을 했을것이다!(추측), 이것을 알게된건 let's Swift라는 컨퍼런스? 에서였다. 카카오톡, 라인, 토스 등등 개발자들이 짧게 20~30분씩 강연들을 했었던 것이었고, 난 학생이었기 때문에 반값? 수준으로 갔었던것 같다. 이때 옆자리분이 여기 슬랙따로 있나요? 했을때, 당시 나는 슬랙을 한번도 안써봐서 못알아 들었던 기억이 난다. 또한, 토스트는 맛있었고, 옷도 받고, 뱃지도 받았다, 스위프트 뱃지는 내 가방에 달려있다.



마지막 강연에는 아주아주 스페셜한분이 강연을 했었는데 보안상? 비밀이었기 때문에 나도 비밀을 유지하겠다.


아무튼 그때, 첫번째 강연하신분께서 Swift4의 새 기능에 대해서 소개를 하셨고, 그때 졸작으로 한창 통신에 관해서 시작하며 삽질하던 나에게 단비같은 Codable을 소개해주셨다. 덕분에 아주 잘쓰고 있다.

하지만, 나도 기능의 전체를 사용하진 못하고 있다. 간단하게 말하자면 JSON 데이터를 미리 생성해둔 Struct 혹은 Class의 인스턴스로 만들어주며, 심지어 데이터를 이름에 맞게 넣어준다! 아주 훌륭하다. 살펴보자

순서는 다음과 같다
1. **Class or Struct 생성**
2. **response받은 데이터를 JSON으로 변경**
2. **Codable 이용하여 인스턴스 생성**

> * 인스턴스란?
> Class와 Struct는 실질적으로 사용하는 데이터가 아니다. 구조를 알려주는 것이다. 그래서 설계도, 주틀 등등으로 설명을 해준다.
> 설계도로 설명해보자면, 가정집 설계도(클래스or구조체)가 있다 가정하자. 화장실, 방이 그려져있다.
> 내가 이 설계도의 화장실에 들어가는 행위는 불가능하다. 왜냐? 이건 설계도지 진짜 무엇이 아니기 때문이다.
> 내가 이 설계도로 A 아파트를 지었다. 이 A아파트가 인스턴스다! 이 A아파트에 내가 화장실을 들어가거나 방에 들어가는 행위 모두 가능하다!  이것이 인스턴스.

### 1. Class or Struct 생성
![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-21/img19.png)

구조체를 사용하기로 했다 참조에 의한 사용은 필요없으니깐! (다른 이유도 더찾아봐야하는데..)

일반적인것들과 차이는 없지만, 하나 있다면 Codable!

Codable을 좀더 들어가보자

![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-21/img20.png)

조금 생소한 **typealias**가 나타났다. 알기만하고 아직 적절한곳을 못찾아서 필자도 써본적이 없지만, 타입의 이름을 다르게 만들어주는것이다. 사람 이름으로 치면 개명정도? 다만 본명, 개명 둘다 사용가능하다.
위의 사진을 보면 Encodable 과 Decodable을 묶은 것의 명칭을 Codable이라고 해준다는 의미다. 이렇게보니
쓸만한 사용법을 찾은것 같다. 두가지 프로토콜을 합쳐주다니! 더 확인 해봐야겠다.

그렇담 새로나온 **Decodable**과 **Encodable**이란?

두가지 기능이 반대이니 한개만 보자 우리가 사용할 **Decodable**
![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-21/img21.png)





설명이 아주 친절하다

```
디코딩해서 새로운 인스턴스를 생성해준다!
디코더가 읽기를 실패하거나, 데이터가 손상 혹은 유효하지 않을경우 에러를 던진다.
```
알아서 에러 처리도 해준다 좋다! 

### response받은 데이터를 JSON으로 변경
처음에 사용할때 여기서 삽질을 많이 했다. 사진을 보자.
![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-21/img22.png)
do,catch 구문을 써서 오류에 대비를 해주자 왜냐? 위에 말했듯이 Decodable은 실패시 에러를 던져주기 때문에!


Swift는 읽기도 참 좋다! 회색 채워야할 부분을 보자
>JSONDecoder()를 사용할거고, 데이터(from 인자)를 특정 타입(type 인자)으로 디코딩한다

읽기 쉽다. 여기서 타입은 아까 만든 **Class or Struct**정보가 들어가게 되고, data는 통신해서 받은 데이터다!

채워보자 

```swift
let getInstanceData = try JSONDecoder().decode(UserData.self, from: obj)
```
이렇게 하면 될까?

![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-21/img23.png)

안된다. 타입이 안맞다고 한다. 왜냐? 아까도 확인 했지만 obj는 타입이 Any 이기 때문이다.



그렇다면 Data 타입으로 바꿔주면될까? 아니다,

try 뒤에 써있듯 JSON을 디코더 해야하므로 우리는 JSON 데이터가 필요하다

obj를 JSON으로 변경해보자

```swift
try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
```

간단하다! 그렇다면 실제로 사용하고 출력까지 해보자

![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-21/img24.png)



실질적으로 do, catch 부분 빼면 단 2줄만에 JSON 데이터의 정보를 가진 인스턴스를 얻어냈다. 비강제해제 같은 작업들이 전혀 필요없었다. 그럼 다음과 같은 경우 궁금할수가 있다.

1. **변수 이름은 같지만 타입이 틀렸을 경우**
2. **데이터가 비어있을 경우**
3. **옵셔널이 아닐경우?**





### 변수 이름 같지만 타입이 틀렸을 경우

![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-21/img25.png)



콘솔창에보면 타입이 맞지 않아 읽어 올 수 없다고 한다



### 데이터가 비어있을 경우

![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-21/img26.png)

구조체에 test라는 변수를 추가했다. 하지만 웹 응답값에는 존재하지 않는다. 



결과창을 보면 nil로 들어가있다. 타입이 옵셔널 스트링이기때문에 가능하다!



### 옵셔널이 아닐경우

우선 구조체 정보와 웹 정보가 일치할 경우를 보자

![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-21/img27.png)

사용할때 !나 ? 붙여주지 않는다는 점 외엔 보다싶히 결과는 똑같다

하지만, 데이터가 없거나 타입이 틀렸을 경우엔?



```
1. 데이터가 없을 경우 (옵셔널x)
- The data couldn’t be read because it is missing.
2. 타입이 틀릴 경우 (옵셔널x)
- The data couldn’t be read because it isn’t in the correct format.
```



이와 같이 콘솔창에 찍히게 된다. 1번의 경우 옵셔널이었을땐 nil로 찍혔다. 따라서, 옵셔널로 가는게 여러모로 장점이 더 있는 것 같다.



마무리로 결과를 보자

![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-21/img28.png)



ps.

얘기가 생각보다 길어졌다, Part1,2로 나눌것 그랬나?


