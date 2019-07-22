---
layout: post                       
title: (Xcode) Configuration 파일 다루기 - (개념)
categories: [Xcode]
---

오늘의 주제의 제목은 뭔가 애매하다

하지만 Configuration 파일을 잘 이용하면

1. 같은 앱 다중설치
2. 서버 변경 방식

등등을 유용하게 쓰일 수 있다.

<br>
<br>

# 어쩌다 포스팅하게 되었나?

회사 앱중 전자 식권 앱이 있는데, 개발을 하다보니 서버를 왔다, 갔다 할 필요가 있었다.

그런데, 다음과 같은 문제들이 발생했다.

1. 서버가 다르다 보니 로그인이 자꾸 풀려서 재로그인해야한다, 귀찮
2. 개발 서버 깔고 나갔다가, 결제 직전 알아차려서 앱스토어에서 다시 받아야하는 귀차니즘 발생
    
그래서, 예전에 `Let's Swift 2017` 이란 Swift 컨퍼런스에서 봤던 세션이 기억이 났다.

(여러번 시도했었지만 실패,,, 하지만 성공했으니 포스팅을 아하하, 해당 세션 Toss개발자님 사랑합니다. 토스 가고싶어요)

<br>

같은 문제점을 역시나 고민하고 계신 선배 개발자분들이 계셨다.

<br>
<br>

# 핵심은 Configuration 파일

서버 변경, 앱 다중 설치 등등을 Configuration 파일 설정 외에는 다음과 같은 방식들을 알고 있었다.

1. Scheme 추가
2. Target 추가

각각 단점이 보였다.

<br>

### 1. Scheme    

이건 선택 가능 옵션이 Release? or Debug? 뿐이었다, 그렇단건 코드에서 아래와 같은 조건으로 주소 변경만 될뿐, 앱을 나눌수 없는거 같다
```
var address: String = ""
#if DEBUG
    address = "www.dev.com"
#else
    address = "www.dis.com"
#endif
```

이렇게 주소를 변경할 수 있었다. 하지만! 정작 중요한 앱나누기가 안댐.
<br>

**PASS**

<br>

### 2. Target 추가

이건 좀 괜찮아보였다. Build Setting이 별도이므로, Bundle ID만 따로 해주면 앱 2개 설치도 되며, 손쉽게 변경이 가능하다.

<br>

![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2019-07-22/img1.png)

하지만 문제점 있음!
- 문제점1: Build Setting이 별도라는건, 수정해야할게 두가지라는 점.
- 문제점2: 새로 파일을 만들경우 `Target Memebership`을 다 체크해줘야함

(Target Membership 체크해야하는 화면)

![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2019-07-22/img2.png)



<br>
<br>

그래서 위에서 언급한 세션 기억이 났고, 이거다! 싶었다.

# Configuration 파일이란?


깃블로그 하다보니  `_config.yml` 파일에 주로 속성?값이라 해야하나 그런것들이 적혀있었다.

- 블로그 타이틀
- 블로그 부제
- Analytics key값
- 페이징 갯수

등등 뭔가 앱으로 치면 

- 앱 이름
- 서버 URL 
- Bundle ID

이런것들이 들어가기 딱인 느낌이었고, 앱에도 그런 파일이 존재했다.

<br>
<br>

### Where?

![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2019-07-22/img3.png)

TARGET이 아닌 PROJECT의 Build Setting을 `Level` 형태로 보면  **Configurations**라는곳이 존재하고 여기에 셋팅을 해주게 된다.


여기서 눈여겨봐야 할 점은 다음과 같다. 
- **Debug**의 하위 - **Project**
- **Project**의 하위 - **Target**

속해있다는 점을 잘보고, **Target**의 **Build Setting**을 보자. 

<br>

빨간 영역을 보면, Resolved - Target - Config - Project 로 되어있다.

> Resolve- 결정하다.

**Resolved** 는 결정했다! 정도로 보면 될텐데, 무엇을 결정했다는 것일까.

<br>

결론적인 예를 들면 이런것이다,

각각 단계에서 앱 이름을 정의 했다 가정을 하자

- 앱 이름 A (in Project)
- 앱 이름 B (in Config)
- 앱 이름 C (in Target)

그럼 뭔가 결정이 나야하고 여기서는 가장 최하위단에서 적용한것이 이름이 되므로, 

위와 같은 경우 앱 이름은 **C**라고 표출이 된다.

<br>

여기서 클래스 상속과 같은 상속이 존재하며, $(inherited) 라고 써주면 바로 전단계가 적용된다.
> $(inherited) 같은 경우는 Build Setting에서 많이 보인다.

<br>

그럼 좀더 예를 들어보자

- 앱 이름 A (in Project)
- 앱 이름 B (in Config)
- 앱 이름 없음 (in Target)

-> 이름 비어있음

---

- 앱 이름 없음 (in Project)
- 앱 이름 없음 (in Config)
- 앱 이름 C (in Target)

-> C

---

- 앱 이름 A (in Project)
- 앱 이름 없음 (in Config)
- 앱 이름 C (in Target)

-> C

---

- 앱 이름 없음 (in Project)
- 앱 이름 없음 (in Config)
- 앱 이름 C (in Target)

-> C

---

- 앱 이름 A (in Project)
- 앱 이름 B (in Config)
- 앱 이름 $(inherited) (in Target)

-> B

---

- 앱 이름 A (in Project)
- 앱 이름 없음 (in Config)
- 앱 이름 $(inherited) (in Target)

-> 이름 비어있음

---


- 앱 이름 A (in Project)
- 앱 이름 $(inherited) (in Config)
- 앱 이름 $(inherited) (in Target)

-> A



<br>
이정도면 예시는 됐으려나, 어찌 됐든 중요한건 `$(inherited)`!

그럼 이걸 이제 어떻게 써먹을지 보자

<br>

# Config 활용

이런건 그림이 이해하기 제일 좋을것 같다.

**!!!!! 여기서 중요한것임 !!!!!**

**!!!!! 이것만 봐도 될정도 !!!!!**

**!!!!! 핵심임 !!!!!**

![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2019-07-22/img5.png)

1. Target은 $(inherited)
2. Config를 A 혹은 B로 변경해줌으로써 서버와 앱이름등등을 바꿔준다.


그렇담 어케 적용하는지는 다음편에!!!

크큭크ㅋᄏᆨ큭-크ㅡ큭






