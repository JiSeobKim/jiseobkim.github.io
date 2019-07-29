---
layout: post
title: (Xcode) Configuration 파일 다루기 - (적용)
categories: [Xcode]

---



처음으로 vi를 이용해 글쓰다가 iterm이 죽음,, 다날라감….. 이 포스팅 절반은 쓴거 같은데……….

안그래도 아파서 힘든데………. 부들부들



허허허,, 다시 쓰는거니 좀더 깔끔하게 글이 나올려나?

최대한 간결하게 해야겠다

다시 처음 쓰는것 마냥 고고



---

<br>


이번엔 Config 파일을 만들고 적용하는것을 포스팅 할 것이다! [이전편 보러가기](https://jiseobkim.github.io/xcode/2019/07/22/swift-Configuration-파일-다루기-(개념).html)



새 파일을 만든다. Command + n

거기서 `Configuration Settings File` 라는 파일을 찾고, 만약 찾기 힘들다면



검색 기능을 이용해서 찾자



![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2019-07-29/img1.jpg)


<br>


총 2개를 만들어 준다.

1. 개발
2. 상용



이 포스팅에서 Config 파일에 적어둘 내용은 다음과 같다.



1. 앱 이름
2. Bundle Identifier
3. 서버 URL (개발 서버 or 상용 서버)


<br>


간략하게 설명하면, 이 글을 시작한 이유가 개발자인 내가 식권앱을 쓰다가, 개발용을 설치하면 실사용 하기 위해


재설치를 해야하는 귀차니즘이 있기 생기기 때문에 시작한 포스팅.



그렇기에 위의 3가지를 예를 들려한다.

<br>

### 앱이름

앱이 2개 설치될 예정인데, 앱 이름이 동일하면, 구분이 안되니깐!

<br>

### Bundle Identifier

앱을 2개 설치하기 위해!

<br>

### 서버 URL

코드내에 상용서버, 개발 서버 선언할필요 없이 Config 설정에 따라 바뀌게 설치

ex) 상용 config 셋팅시 URL은 상용 URL을 불러오게 끔 (개발은 개발 URL)



<br>



---



<br>

<br>



어디를 건들여야하는지 알아보자.



우선 만든 Config를 설정하는곳은 여기다.

![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2019-07-29/img2.jpg)



보통 Target 안에 부분은 손은 댓었어도 이곳은 손대본적이 없었다.



근데 이제와서 생각해보니 어차피 Target한테 밀리는 설정들이라서 그랬나보다.


<br>

사진에 보면, Project(파란색)과 Target(빨간색)이 존재한다.


우린 각각 Target의 Config를 손볼 예정이다.


Target의 Config에 **Config_Dis**를 넣어주자


![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2019-07-29/img3.jpg)


<br>

Target의 BuildSetting 부분을 보자, 기존에는 없던 Level이 추가된다.


- Config.File (Config_dev.xcconfig. None)


이젠 활용만 하면 된다.

<br>
<br>


# Bundle ID 적용



Target의 Build Setting에서 Bundle 이라고 검색하면 `Product BUndle Identifier`라는 항목이 보인다.

![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2019-07-29/img4.jpg)

현재는 고정값이 들어가있지만, 이 부분이 Config에 따라 다르게 적용되게 해야한다.

(사진엔 Config를 넣기 전이라 Config.File 이라는 레벨이 안보임!) 

<br>


그럼 여기는 `$(inherited)`를 넣어줌으로써 Config따라 값이 바뀌게 해준다.

> 이 부분이 가장 중요. 나머진 응용 & 반복!


아래처럼 바꿔주기만 하자

![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2019-07-29/img5.jpg)

<br>

그리고 Build setting 말고 General 보면 나오는 Bundle ID는 깔끔하게 결과값만 나온다! 아마 `Resolved`값을 표출하는것 아닌가 싶다.

![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2019-07-29/img6.jpg)

<br>

그럼 Bundle ID 셋팅이 끝났다.

Config만 바꿔줘도 Bundle ID가 바뀐다. 이말을 다시 말하면 앱에서는 Config에 따라 서로 다른 앱으로 인식한다는 것이다.

그렇단건 앱이 2개가 설치가 된다는 것이다!

<br>

실행해보면 다음과 같이 2개가 설치 될것이다.

![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2019-07-29/img7.jpg)


<br>
<br>



# 앱 이름 바꾸기

두개 설치까진 됐으나, 뭐가 뭔지 알기가 힘들다.

그러니 앱이름을 Config에 따라 달리 셋팅을 해주자

<br>

이건 간단하지만 살짝 다르다.

BuildSetting 부분에 보면 `Product Name`이란 부분이 있는데, 이 부분을 수정하고 빌드하면 2개가 설치 되긴하는데,

두번째꺼 설치후 다시 빌드하면 오류를 뿜는다. 쓰지말자,

<br>

Config파일에 `DISPLAY_NAME`이라는 항목을 넣어줬으며, 이것을 검색하면 보인다.

보면 DISPLAY_NAME 위에 User-Defined 라는 항목이 보이며, 이 부분 아래는 전부

기존 Build Setting이 아닌 추가된 부분이다. Level 옆에 + 버튼을 눌러서 추가도 가능하다.

<br>

그럼, 이 부분을 가져다 쓰기만 하면 된다.

![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2019-07-29/img8.jpg)

위와 같이 Display 부분에 `$(DISPLAY_NAME)` 이라고 적어주면 끝!

<br>

아래는 결과

![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2019-07-29/img9.jpg)

<br>

가장 마지막단의 값이 `Resolved`되니 Config에 정의한 그 값이 곧 그 값!

<br>
<br>

# 서버 URL 변경



위에 간략하게 설명한 바와 같이 많은 현업에서 상용 서버, 개발 서버 나눠서 쓰고 있을것이다.

근데, 지금 회사에선



```swift
static var isReal: Bool = false
static let url = (Class).isReal ? "realServer.com" : "devServer.com"
```

이런식으로 코드를 수정하는 방식을 쓰고있었다.

간편한 방법이긴 하지만, 배포전 신경을 항상 써줘야했다.

하지만! Config를 이용하여 셋팅만 잘 해둔다면, 배포시 별다른 걱정을 하지않아도 된다!

<br>

 그렇담 이것을 앱에서 어찌 가져다 쓸까?

<br>

**`Info.plist`를 이용!**

<br>

Info.plist 파일에서 오른쪽 클릭을하면 아래와 같이 `Add Row`가 보일것이다! 클릭

![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2019-07-29/img10.jpg)

<br>

이름은 `Server URL`이 적당하려나? (다른값 보고 따라함)

아무튼 그렇게 해주고 타입은 `String`  값은 `$(SERVER_URL)`! 아래처럼 적용

![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2019-07-29/img11.jpg)

<br>

그럼 이제 가져다 써보자

```
if let url = Bundle.main.object(forInfoDictionaryKey: "Server URL") as? String {
    print("plist에서 받은 값은 \(url)")
}
```

이런식으로 `plist`에 접근해서 값을 가지고 올 수 있다.

>  object 함수 Summary 부분 발췌
>
> Returns the value associated with the specified key in the receiver's information property list
>
> 해석: plist꺼 값 꺼내옴


<br>

아래 이미지는  출력 코드는 동일하지만 Config 파일만 교체하고 결과 값이 다른 것을 보여준다.

![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2019-07-29/img12.jpg)

이렇게 나온다면, 충분히 응용 가능할것으로 보인다.

길어진 관계로 고급편을 만들어야겠다. (vi 쓰다 날아가서 나누는거 암튼 아님)

크큭크크크ㅡ크ㅋ
