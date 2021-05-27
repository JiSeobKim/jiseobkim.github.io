---
layout: post                       
title: "Swift - 화면간 데이터 전달. 1편"
categories: [Swift]
---

델리게이트 패턴을 이용해보자

<br>





이번 포스팅부터는 아이패드로 그림을 그리면서 설명을 진행 해보고자합니다~! 

(그림엔 소질이 없지만 집에서 동영상 머신으로 쓰이는 비싼 아이패드 활용을 어떻게든 하고 싶어서……....)



어플을 만들다보면 데이터를 전달하는 빈도수는 상당히 높을것 입니다.

예를 몇가지 들어볼까요? (실제는 다르겠지만 이해를 위해 최대한 간결하게 설명을 진행을...!)



크게는 2가지로 볼수 있을겁니다!

아래 삐뚤삐둘한 그림을 보면서 설명을 하죠

![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-09-02/img1.png)





그림이 예술입니다. 

연락처 화면  - 문자 화면 - 사진 전송을 위한 사진첩



이렇게 화면이 이루어져있습니다!



어떻게 2가지냐! 우선 이경우는 뷰는 스택 형식으로 쌓입니다



목록에서 친구 누군가를 탭할경우 그 화면이 목록 화면 위로 올라오게 되죠,

마찬가지로 문자 화면에서 사진 전송을 위해 사진 목록 화면을 띄우면 그화면은 문자 화면 위에 떠있게 됩니다!



그래서 하나씩 제거하면서 앞 화면으로 돌아가죠! 이렇게 되면 굳이 똑같은 화면을 다시 띄울 필요도 없고, 별도 처리 하지 않는 이상 데이터도 남아있으니깐요!

<br>

### 연락처 목록 to 문자 화면

이 경우에 리스트에서 친구1,2,3 중 한명을 탭하게 되면 문자 화면엔 누군가 친구x라고 뜨게 될것입니다.

그렇다는건 어떤 정보를 받아 왔으니깐 그 친구에 대한 정보를 통해 화면을 뿌려주고 연락을 주고 받겠죠!

이건 책에서도 많이 나오죠,  문자View 클래스의 인스턴스를 만들어주고 데이터를 넣어준뒤  present나 네비게이션바를 사용한다면 push 형식으로 띄워주겠죠! 일반적인 방법으로 소개하는 segue도 있을 수 있구요!

<br>

### 사진첩 to 문자 화면

이경우는 어떤 경우일까요? 사진 첨부를 위해 사진 추가버튼을 누르면 사진첩이 뜨게 되고, 이때, 사진을 누르게 되면 문자View에

첨부가 됩니다! 그렇다는 말은 사진첩의 사진 데이터가 문자view로 전달이 된거죠



이 케이스는 책에선 많이 없었던거 같네요.



그래서 이 케이스를 다루고자 합니다.



델리게이트 패턴을 이용하는것이죠, 프로토콜을 이용하기도 할것이고 인스턴스를 만들어서 사용하기도 할것입니다!



> 윗 말이 낯설고 어려울수도 있겠지만 결론적으로 궁극적인 목표는 VC2의 데이터를 VC1으로 보내는게 목표입니다!



<br>

# 델리게이트

델리게이트는 한국어 의미론 대리자 그러한 의미인데, 처음엔 이게 무슨 말인지 참 어렵더군요

쉽게 말하면 

> "내가 다 만들어 놨어, 넌 가져다써"

정도로 지금은 생각하고 있습니다.



VC2에서 VC1으로 데이터를 수정해봅시다.



우선 VC1의 구성은 다음과 같습니다.

![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-09-02/img2.png)



![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-09-02/img3.png)





아주 심플하죠? '이름 써질곳' Label이 있고, 그 Label에 텍스트를 넣는 함수가 있습니다.

이제 이 코드를 VC2에서 실행시킬것입니다.



VC2 구성은 다음과 같습니다.

![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-09-02/img4.png)

![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-09-02/img5.png)



여기또한 아주 심플하죠

눈여겨 봐야할 것은 

```swift
var delegate: VC1?
```



이 부분 입니다. 타입이 VC1입니다.



그리고 버튼 실행 내용쪽에 보면

```swift
delegate?.insert(name: text!)
```



여기 입니다! VC2에는 저런 함수가 없죠. 타입이 VC1인 delegate의 내부 함수이니깐요.

> VC1에 다 만들어져있습니다. 가져다 쓰세요



실행해볼까요?



안될겁니다.



왜냐! VC1 타입을 선언해줬지만 어떤 VC1인지 모릅니다.



이게 무슨 해괴한 소리냐면



해괴한 그림과 함께 설명들어갑니다.

![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-09-02/img6.png)



(직선 깔끔히 그리는 방법 찾았어요)

이 그림을 보면 많은분들이 이렇게 생각하실겁니다.

"VC1꺼 불러왔잔아!!" 

네 VC1꺼 부른것 맞습니다. 그치만 누군지 모릅니다

또 해괴한 소리였죠.

만약 VC1화면이 3개가 있고, insert(name:_)를 호출 하면 어떻게 될까요?

이해가 안되신분들이라면 이렇게 생각하실 겁니다.

![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-09-02/img7.png)



그렇지 않나요?



개념적으로 생각의 변화가 필요합니다! 

VC2에서 delegate는 단순히 타입을 VC1인 변수를 선언한거고 각 VC1들과는 별개입니다.



그럼 어떻게 하냐

VC1에서 아래 코드를 추가해줍니다. (segue 사용했습니다.)

```swift
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc2 = segue.destination as? VC2 {
            vc2.delegate = self
        }
    }
```



우선! override니깐 상속 받은 UIViewController에 기본적으로 들어있던 함수고 내용을 살짝 바꾼겁니다

함수 내부를 보면,

vc라는 변수를 안전하게 만들어줍니다, let과 if를 사용해서 vc라는 상수를 만들지만 nil일 경우 if문은 실패 처리되어 앱이 죽지 않고 단순히 다음코드로 넘어가게 됩니다. 



```swift
segue.destination as? VC2
```

이 코드를 보면, segue의 목적지를 VC2로 캐스팅을 합니다! 즉, 화면 이동하려는곳이 VC2가 맞는지 확인 하는겁니다.



if문에 문제가 없다는 가정하에 vc를 하죠



```swift
vc2.delegate = self
```

여기가 포인트 입니다. 

> vc2에 delegate의 VC1이 나야!!

이런 의미입니다. 그 타입의 대상자가 누군지 말해주는거죠.



아래 이미지처럼 대상자를 지목 하는거라고 보면 됩니다.



![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-09-02/img8.png)



그럼 결과를 볼까요?



![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-09-02/img9.png)

![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-09-02/img10.png)



잘 넘어왔네요~ 스탠포드 교수님께선 이런 방식을 델리게이트 패턴이라 칭하더군요! (유투브 공개강의) (아직 용어가 어려워요)



못난 아이패드 그림이었지만! 핵심이었으니 꼭 그린 부분을 중점으로 봐야 이해가 수월 할것 같네요



다음번엔 Protocol로 데이터 넘기는 방식을 써보겠습니다.
