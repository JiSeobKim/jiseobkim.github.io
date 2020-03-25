---
layout: post
title: (swift) UI 도전! - DragAnimation_Step2_Tranform
categories: [Swift, UI]

---


`Transform` 이란 주제로 설명을 하려다보니 대충 알고 있었음을 알게 되었다. 준비도 생각보다 오래걸림
귀찮아서 안올린거 아님..

아무튼, `Transform`이란 녀석을 배워보자. 단어부터 보자
> Transform
> 1. 바꾸어 놓다 2. 변화시키다 3. 만들다 4. 변모시키다 5. 변형시키다

전부 변화에 관한 얘기다

다음과 같은 코드가 많이 나온다.
```
view.transform = 블라블라
```
= 뒷부분은 뒤에서 설명하고 그 앞만 보면 "`view`를 변화,변경,변모 시키다." 로 되겠지? 영어권은 코딩이 참 쉬울거 같다. 부럽

대충 뭘 하겠단건 알겠고, 무엇을 할 수 있는지 보자.
1. 크기 (Scale)
2. 회전 (Rotate)
3. 좌표, 위치 (translation)


단어뜻과 아주 잘 맞는 역할들을 한다.
시각적인 효과를 먼저 보자

![](/assets/images/2020-03-25/gif1.gif)

차례대로 크기, 회전, 위치 변경이다.
> 제일 아래 스위치는 크기와 위치 두가지를 동시에 효과를 주는 스위치로 뒤에 나온다.

근데, 크기를  바꾸는것을 유심히 보면 특이한 점이 있다. 안에 하얀색 작은 사각형이 있는데, 이 녀석도 같이 커진다.
그럼 텍스트를 넣고 이번엔 스위치를 키면 **가로 사이즈는 작아지게** 하였고 세로는 동일하다.

![](/assets/images/2020-03-25/gif2.gif)


위와 같이 텍스트 세로로 늘어나고, 가로는 쭐어 들었다.

마치 저 자체가 **이미지**였던것처럼 변화하였다.

`Transform`이란 녀석에 타입은 `CGAffineTransform`이다.

그럼 이 녀석에 대한 문서를 보자


![](/assets/images/2020-03-25/img1.png)

음.. 자세한건 각자 보도록 하자.... [링크는 여기..](https://developer.apple.com/documentation/coregraphics/cgaffinetransform?language=objc)

여기서 `CGAffineTransform`이란 단어 아래 문구는 다음과 같다.

> An affine transformation matrix for use in drawing 2D graphics
기
아핀 행렬이 뭔지는 모르겠다만 뒤에 2D graphics를 보니 **Frame**을 바꾸고 그런게 아니라 **그래픽적**으로 처리를 하는 방식인가보다.


이러한 방식이다보니, 단순 도형이 아니라면 효과를 줄때 주의를 해야할 것 같다. 

그렇담 이제 사용법에 대해 알아보자

스위치 4개를 모두 하나의 `IBAction` 함수에 연결 시켰고 그 함수의 내용은 다음과 같다

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


굉장히 단순 하다

하나씩 봅시다. (인자들은 모두 `CGFloat` 타입)

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

`translation`은 변환인거 같은데,, 솔직히 다른것처럼 확 와닿진 않는다. 넣는 x,y 값만큼 기존 값에 더해지게 된다. <br>
여기선 x는 0, y는 -100 했기 때문에, 가로축 이동은 없고 세로축은 위쪽으로 100만큼 이동하였다.


