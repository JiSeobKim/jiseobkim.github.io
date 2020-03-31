---
layout: post
title: (swift) DragAnimation(2/3) - Transform
categories: [Swift, UI]

---


`Transform` 이란 주제로 설명을 하려다보니 대충 알고 있었음을 알게 되었다. <br> 
그러다보니 여기서 생각보다 오래걸렸다 <br>

아무튼, `Transform`이란 녀석을 배워보자. 단어부터 보자
> Transform
> 1. 바꾸어 놓다 2. 변화시키다 3. 만들다 4. 변모시키다 5. 변형시키다

전부 변화에 관한 얘기다. <br><br>

이후에 다음과 같은 코드가 많이 나온다.
```
view.transform = 블라블라
```
블라블라 부분은 뒤에서 설명하고 그 앞만 보면 <br>
"`view`를 변화,변경,변모 시키다." 로 되겠지? <br> 
영어권은 코딩이 참 쉬울거 같다. 부럽다 <br><br>

대충 뭘 하겠단건 알겠고, 무엇을 할 수 있는지 보자.
1. 크기 (Scale)
2. 회전 (Rotate)
3. 좌표, 위치 (translation) <br><br>

단어뜻과 아주 잘 맞는 역할들을 한다.<br>
시각적으로 효과를 먼저 보자.<br>
(Animation으로 해야 좀더 이해하기 쉬워서 이용하였으며, 기본적으로 적용되지 않는다.)


![](/assets/images/2020-03-25/gif1.gif)

차례대로 크기, 회전, 위치 변경이다. <br>
(제일 아래 스위치는 크기와 위치 두가지를 동시에 효과를 주는 스위치로 뒤에 나온다.) <br>

근데, 크기를  바꾸는것을 유심히 보면 특이한 점이 있다. <br>
안에 하얀색 작은 사각형이 있는데, 이 녀석도 같이 커진다. <br>
그럼 텍스트를 넣고 이번엔 스위치를 키면 **가로 사이즈는 작아지게** 하였고 세로는 동일하다.

![](/assets/images/2020-03-25/gif2.gif)


위와 같이 텍스트 세로로 늘어나고, 가로는 줄어 들었다. <br>
마치 저 자체가 **이미지**였던것처럼 변화하였다. <br>
`Transform`이란 녀석에 타입은 `CGAffineTransform`이다. <br> <br>

그럼 이 녀석에 대한 문서를 보자

![](/assets/images/2020-03-25/img1.png)

음.. 자세한건 각자 보도록 하자.... 링크는 [여기..](https://developer.apple.com/documentation/coregraphics/cgaffinetransform?language=objc) <br><br>

여기서 `CGAffineTransform`이란 단어 아래 문구는 다음과 같다.

> An affine transformation matrix for use in drawing 2D graphics <br>


아핀 행렬이 뭔지는 모르겠다만 뒤에 2D graphics를 보니 **Frame**을 바꾸고 그런게 아니라 <br> 
**그래픽적**으로 처리를 하는 방식인가보다. <br>
이러한 방식이다보니, 단순 도형이 아니라면 효과를 줄때 주의를 해야할 것 같다. <br><br> 

그렇담 이제 사용법에 대해 알아보자 <br> 
(스위치 4개를 모두 하나의 `IBAction` 함수에 연결 시켰고 그 함수의 내용은 다음과 같다)

```
// 1. 선언
var transform: CGAffineTransform?

// sender = 스위치 / 스위치 종류에 따른 Switch문
switch sender {
case scaleSwitch:
    // 2-1. 초기화(크기)
    transform = CGAffineTransform(scaleX: 0.5, y: 2)
case rotateSwitch:
    // 2-2. 초기화(회전)
    transform = CGAffineTransform(rotationAngle: .pi)
case translationSwitch:
    // 2-3. 초기화(위치)
    transform = CGAffineTransform(translationX: 0, y: -100)
case complexSwitch:
    // 2-4. 초기화(크기 & 위치)
    transform = CGAffineTransform(scaleX: 2, y: 2).translatedBy(x: 0, y: -100)
default:
    return
}

// 애니메이션 효과
UIView.animate(withDuration: 0.3) {
    // 3. 적용
    self.justView.transform = transform!
}
```

굉장히 단순 하다. <br>
하나씩 봅시다. (인자들은 모두 `CGFloat` 타입) <br>

## 크기
```
transform = CGAffineTransform(scaleX: 2, y: 2)
```
원하는 배율을 적어주면 된다. 가로로 몇배, 세로로 몇배. 쉽다.

## 회전
```
transform = CGAffineTransform(rotationAngle: .pi)
```

원하는 회전 각을 적어주면 된다. `.pi`,  `.pi / 4`  등등 원하는대로! 

## 위치
```
transform = CGAffineTransform(translationX: 0, y: -100)
```

`translation`은 변환인거 같은데,, <br> 
솔직히 다른것처럼 확 와닿진 않는다. <br> 
넣는 x,y 값만큼 기존 값에 더해지게 된다. <br>
여기선 x는 0, y는 -100 했기 때문에, 가로축 이동은 없고 세로축은 위쪽으로 100만큼 이동하였다. <br>

그리고 해당 뷰의 `transform`에 적용해 주면 된다.

## 원상 복구

적용했으니 되돌리는것도 필요한건 당연 <br>
아주 간단하다. <br>

```
self.justView.transform = CGAffineTransform.identity
// or 
self.justView.transform = .identity
```

---

(혹시 누군가 본다면, 아래 주의 꼭 보시길) <br>
두가지 이상의 조합을 원할땐 어떻게 할까? <br>
예를 들어, 위치가 이동하면서 크기에 변화를 주고 싶다면? <br> 
혹은 회전하면서 크기 변화도 같이 주고 싶다. <br><br>

그럼 위의 코드 2-4 부분에 보면 다음과 같은 코드가 있었다.

```
// 2-4. 초기화(크기 & 위치)
transform = CGAffineTransform(scaleX: 2, y: 2).translatedBy(x: 0, y: -100)
```
 
 딱보면 누가 봐도 `크기`에 대해 변화도 주고, `위치`값도 조절하게 생겼다. <br>
 위에 gif에 생략된 마지막 4번째 스위치에 대한 동작을 보자. <br>
 
![](/assets/images/2020-03-25/gif3.gif) 

위의 짤과 같이 크기(`scale`)변화가 있으면서 위치(`translate`)에 대한 변화도 있다.<br>
저기서 끝이아니라 회전도 가져다 붙여줄 수 있다. <br>


> Q.이미 Scale이 있는데, Scale을 한번더 붙이면 어떻게 되나? <br>
> A. scale이 둘다 안먹힐때도 있고 마지막만 먹힐때도 있고 중구 난방이었다. <br><br>

## 주의!!
쓰다가 발견했는데, 아래 심화 부분글 쓰다보니 잘못 이해한게 있었다. <br>
아래 보면 알겠지만, 행렬 곱셈이 들어가기 때문에 두개의 순서가 바뀌면 예상치랑 달라진다. <br>
A * B와,,, B * A는 다르다.....  더 자세한건 아래에. <br><br>


---

## 살짝 심화

(기본적인 사용법은 위가 전부. 아래는 아주 아주 살짝 심화랄까? ..) <br><br>


저 `Transform`이란 아이를 콘솔에 찍어보면 어떻게 나올까? <br>

먼저 원상 복구 값인 `.identity` 출력 값을 보자 <br>

```
CGAffineTransform(a: 1.0, b: 0.0, c: 0.0, d: 1.0, tx: 0.0, ty: 0.0)
```

음 `a`,`b`는 1이고 나머진 0이 기본이란걸 알 수 있다.

위에 `switch`문에 있던 애들을 각각 찍어보자. 아래 코드처럼.


```
// 1. 선언
var transform: CGAffineTransform?

switch sender {
case scaleSwitch:
    // 2-1. 초기화(크기)
    transform = CGAffineTransform(scaleX: 2, y: 2)
case rotateSwitch:
    // 2-2. 초기화(회전)
    transform = CGAffineTransform(rotationAngle: .pi)
case translationSwitch:
    // 2-3. 초기화(위치)
    transform = CGAffineTransform(translationX: 0, y: -100)
case complexSwitch:
    // 2-4. 초기화(크기 & 위치)
    transform = CGAffineTransform(scaleX: 2, y: 2).translatedBy(x: 0, y: -100)
default:
    return
}

// 3. 출력
print(transform!)
```
<br>

3에 보면 transform이란 것에 대해 출력이 추가 되었다.( 이쁘게 출력하기 위해 강제해제`!` )
```
// 1. 크기
CGAffineTransform(a: 2.0, b: 0.0, c: 0.0, d: 2.0, tx: 0.0, ty: 0.0)
// 2. 회전
CGAffineTransform(a: -1.0, b: 1.2246467991473532e-16, c: -1.2246467991473532e-16, d: -1.0, tx: 0.0, ty: 0.0)
// 3. 위치
CGAffineTransform(a: 1.0, b: 0.0, c: 0.0, d: 1.0, tx: 0.0, ty: -100.0)
// 4. 크기 & 위치
CGAffineTransform(a: 2.0, b: 0.0, c: 0.0, d: 2.0, tx: 0.0, ty: -200.0)
```
<br>

`a`,`b`,`c`,`d`,`tx`,`ty` <br>
문서에서 얼핏 본듯 하여 문서를 다시 보았다. <br>

![](/assets/images/2020-03-25/img2.png) <br><br>

`Transform` 그래픽적으로 표현하는구나 하였었고, 이는 3x3 행렬로 보여주는 형식이었다. <br> 
근데 아랫줄에 보면 다음과 같이 적혀있다. <br>

> 3번째 컬럼은 항상 (0,0,1)이다. 고로 CGAffineTransform은 1열과 2열에 대한 값을 가지고 있다. <br>

그렇다 한다. <br> 
그렇지만 아핀행렬에 대해서 공부하기엔,,, ㅎ <br>
이 문서로만 이해해보자 <br>

![](/assets/images/2020-03-25/img3.png)

위와 같이 이미지 같은 형식으로 각각 초기화하게 된다. <br> 
가장 기본은 위에 나온것 처럼 `a`,`b`,`c`,`d`,`tx`,`ty` 이며, <br> 
이건 필자처럼 어렵게 생각하니 쉽게 쓰라고 <br>
`scale`, `rotationAngle`, `translation`을 이용하여 사용성을 높힌듯 하다. <br><br>

그리고 두가지를 이용한 4를 보면, 저 값은 (위치 행렬 x 크기 행렬)과 같다. <br>

하.. 잘봐야한다.. <br>
2-4의 순서가 `scale`, `translate`라서 <br>
당연히  `scale` x `translate`인줄 알았더만 <br>
`translate` x `scale` 이었다.... <br><br>

A * B와 B * A는 다르니..... 사용에 굉장히 주의바람 <br>

![](/assets/images/2020-03-25/img5.png) <br>

(A: `scale` B: `translation`)<br>
의도는 -100 이었지만 -200에 해당되는 이동을 하게된다. 조심바람.... <br>
-100 만큼 이동하고 2배로 키우고 싶었다면 아래 O 부분처럼 해야한다. <br>


```
// X
transform = CGAffineTransform(scaleX: 2, y: 2).translatedBy(x: 0, y: -100)

// O
transform = CGAffineTransform(translationX: 0, y: -100).scaledBy(x: 2, y: 2)
```

윗 부분은 스케일도 두배만큼 이동하나보다... <br>
B * A는 다음과 같다. <br>

![](/assets/images/2020-03-25/img4.png) <br> 

- a = 2 x 1
- d = 2 x 1
- tx = 0 x 1
- ty = -100 x 2

```
(a: 2.0, b: 0.0, c: 0.0, d: 2.0, tx: 0.0, ty: -200.0)
```


이렇게 정의가 된다. 위에 4번과 일치 <br>

이것을 정말 잘 이해한다면, 멋지게 사용이 가능할 것 같다. <br>

하 수정을 도대체 몇번을 한건지.... 몇시간이며 끝날줄 알았던 내용이 역대급으로 오래 걸린듯하다.

## 끝.
