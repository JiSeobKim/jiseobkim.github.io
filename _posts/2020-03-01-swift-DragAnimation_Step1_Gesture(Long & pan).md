---
layout: post
title: (swift) UI 도전! - DragAnimation_Step1_Gesture(Long &pan)
categories: [Swift, UI]

---



오랫만에 포스팅............. 여러모로 힘든 시기였다 ㅠ 기운내자

개인적으로는 iOS의 장점중 하나가 부드러운 동작이라 생각한다.

그래서 개인적으론 웹뷰를 선호하지 않는 이유중 하나는 웹뷰로도 동작이 부드러울수는 있으나,

네이티브의 부드러움을 따라가는 앱은 보지 못했다.

그리고 부드러운 동작과 잘 맞는 애니메이션은 사용자가 앱에 더 관심을 갖게 해주고, 좋은 경험(UX)를 준다고 생각한다.

화면 하나를 띄울때도 단순히 보여주는게 아닌 어떻게 해야 더 자연스럽고 좋은 경험을 유저에게 선사할 수 있을지

고민하고 시도하는 개발자가 좋은것 같다. 

<br>

그래서 시도한 UI 따라하기!

몇몇 앱들보면 특정 UIView 또는 UIButton 등을 길게 누르면 이동 시키고, <br> 
다른 뷰 위에 올릴시 새로운 액션이 일어남을 볼 수 있는 앱들이 있었다. 

이런 앱들 보면서 어떻게 하면 저렇게 될까? 라는 생각하다가 시도를 해보았다.

<br>

이번 편은 3편으로 이루어질것이고, 순서는 다음과 같다.

1. Gesture - Long Press
2. Transition
3. 응용하기 (1 + 2)

<br>

무엇을 만들게 될지 결과물부터 보고 이야기를 진행하는게 좋을 것 같다.

![](/assets/images/2020-03-01/gif1.gif)


<br>
~~아아... 테마 바꾸고 이미지를 로컬에서 못불러서 푸시하고 확인하는것 반복하다 이건 아니다 싶어서
로컬로 불러오게끔 하는데, 삽질을 너무 많이 했다.....
그건 성공했는데, 이미지 왜케 크니?....
내일 이어서 적어야겠다.~~


<br>

위에 gif 파일을 보면 특징은 다음과 같다.

1. 스크롤뷰이며 위 아래 스크롤이 가능하다.
2. 롱터치시 터치된 뷰의 Frame과 Alpha값이 변화하며 클릭(터치)한채로 움직이면 따라 움직인다.
3. 2의 상태로 가운데 사각형의 영역에 들어가면 가운데 사각형이 반응을 한다.

<br>

이와 같은 점이 다른 유명 앱들에서 보이는 액션들이었다. 그렇담 위와 같은 액션에서 주목해야할 점은 무엇일까?

1. 스크롤뷰이며 위 아래 스크롤이 가능하다. 
> 롱터치 후에 위아래 움직이는 것과 스크롤뷰의 터치후 위아래 움직이는것의 구분이 필요하다.
> (쉽게 말해 터치된 후 위아래로 움직이는데 스크롤뷰도 위아래로 움직이면 안된다는 뜻)

2. 롱터치시 터치된 뷰의 Frame과 Alpha값이 변화하며 클릭(터치)한채로 움직이면 따라 움직인다.
> 롱터치 후 Frame과 Alpha값에 변화를 주고 드래그에 따라가도록 해야한다.

3. 2의 상태로 가운데 사각형의 영역에 들어가면 가운데 사각형이 반응을 한다.
> 사각형 안에 들어갔을때 사각형이 반응하게 하려면, 현재 터치된 정확한 위치 정보를 알아야 한다.

<br>

>### 주의: 
>이 시리즈에선 스크롤뷰를 생성하고 적용하는 법은 따로 다루지 않는다. <br>
필자는 스크롤 뷰 안에 스택뷰를 넣고 코드로 뷰를 추가하는 형식을 이용하였기에 gif 하단에 Add와 Clear버튼이 존재

<br>

그래서 글의 도입부와 같이 3가지로 포스팅을 나눠서 진행!

이 글에선 상대적으로 쉬운 제스쳐에 관해서 글을 적어본다.

<br>

---


# Gesture?

제스처란 순수하게 한글로 얘기하면 동작이라 볼 수 있다.
<br><br>
그렇담 앱에서 동작이란 무엇일까?
사용자의 액션이라고 볼 수 있을 것 같다.
<br><br>
가장 간단한 제스쳐는 터치다.<br>
기본적으로 앱을 사용하려면 사용자가 해야할 액션은 터치일 것이다.
<br><br>
내가 원하는 화면으로 이동을 해야하고, 원하는 아이템을 선택해야하고,<br>
그 아이템을 삭제하던 추가하던 저장하던 원하는것을 하려면 그에 해당되는 것을 눌러야한다.
<br><br>
이와 같이 누르는 행위가 하나의 제스쳐이다.<br> 
이 터치 외엔 무엇이 있을까<br>
- 드래그(두손가락 터치,세손가락, 네손가락...)
- 롱터치
- 스와이프
- 핀치 투 줌

<br><br>
지금은 여기까지만 생각난다.. <br>
뭐 아무튼 이런 것들이 있다.
<br><br>
이 글에서는 롱터치 대해서 알아볼 것이다. <br>
여기서부터는 필요한 내용만 간결하게 씁시다. 읽기 쉽게.

<br><br>

---

# Long Press Gestrue (롱터치)

롱 프레스는 뭔가 거부감이 드니 롱터치라고 하겠다.

일단 적용하는 코드부터 보자

```
// Long Press Gesture - 선언
let longTouchGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTouchAction(_:)))
```

뒷부분이 어디서 많이 본거 같다. 버튼에 액션 넣을때 많이 봤을 것이다. 그리고 인자들은 다음과 같다. 

>타겟: 롱터치 했을 때, 어디서 처리할거야? <br>
>액션: 롱터치 했을 때, 무슨 처리할래?

<br>

이건 제스쳐에 대한 정의만 된 것이다. 그렇담 이 제스쳐를 어딘가에 적용을 시켜줘야겠지?

```
// Long Press Gesture - 적용
view.addGestureRecognizer(panGestrue)
```

다시말해 의미는 다음과 같다. <br>
`view`를 롱터치 했을 때, `self`에 있는 `longTouchAction(_:)` 라는 함수를 실행하자~

<br>

근데 여기서 longTouchAction이라는 함수를 보면 다음과 같다.


```
@objc
func longTouchAction(_ recognizer: UILongPressGestureRecognizer) {
    print(recognizer.state.rawValue)
}
```
`@objc`는 `selector`에다 써주려면 써야하고, <br>
`recognizer`라는 애가 제스쳐에 대한 정보를 가지고 있다

<br>

이를 통해 많은 것을 알 수 있지만 여기서는 `.state`에 대해서 알아보자.
![](/assets/images/2020-03-01/img1.png)

그렇다 `enum`이고 자료형은 `Int`이다. 그렇단건 `switch`랑 궁합이 잘 맞겠다는 말~

<br>

그럼 `enum`이니 종류를 한번 보자.
![](/assets/images/2020-03-01/img2.png)

뭐가 많다. 세분화해서 사용 가능하다.

근데 이 글에선 롱터치의 시작, 종료, 변화에 대해서 알면 된다.

다시말해 `.began`과 `.ended` 그리고 `.changed`만 알면 된다.

<br>

아래의 코드를 보자.
```
@objc
func longTouchAction(_ recognizer: UILongPressGestureRecognizer) {
    switch recognizer.state {
    case .began:
        // 롱터치 시작
        break
    case .ended:
        // 롱터치 종료
        break
    case .changed:
        // 터치 후 변화
        // 1
        let point: CGPoint = recognizer.location(in: self.view)
        // 2
        let point2: CGPoint = recognizer.location(in: self.longTouchView)
    default:
        // 나머지 불필요
        break
    }
}
```

`.began` <br>
롱프레스가 시작 됐다를 알려준다.

`.ended` <br>
롱프레스가 끝났다를 알려준다.

`.changed` <br>
얘를 주목하자,

<br>

저 `location(in:_)`이 무엇이냐 하면, 문서상 이렇게 써있다.

> Summary<br>
Returns the point computed as the location in a given view of the gesture represented by the receiver.<br><br>
Declaration<br>
func location(in view: UIView?) -> CGPoint<br><br>
Discussion<br>
The returned value is a generic single-point location for the gesture computed by the UIKit framework. It is usually the centroid of the touches involved in the gesture. For objects of the UISwipeGestureRecognizer and UITapGestureRecognizer classes, the location returned by this method has a significance special to the gesture. This significance is documented in the reference for those classes.<br><br>
Parameters<br>
view    <br>
A UIView object on which the gesture took place. Specify nil to indicate the window.<br><br>
Returns<br>
A point in the local coordinate system of view that identifies the location of the gesture. If nil is specified for view, the method returns the gesture location in the window’s base coordinate system.

<br>

어렵다, 쉽게 말해 다음과 같다.

> 당신이 터치한 위치 정보(좌표)를 알려 줄게! 어느 `view`를 기준으로 할지 알려줘

즉, 전체 화면상 x,y가 몇인지 알면 좋긴 하겠지만, <br>
특정 `view`위에서 x,y가 몇인지 계산하기 귀찮으니 기준점을 알려주면 알아서 계산된 값을 알려준다.

<br>

다시 말해, <br>
위에 주석 `1`은 `self.view` 기준으로 x,y를 알려주는 값이고 <br>
위에 주석 `2`는 `self.panGetstureView` 기준으로 x,y를 알려주는 값이다. <br>
(마치 view의 frame과 bound 차이 그런 느낌...?)

<br>

그럼 여기서 `point`와 `.changed`를 잘 생각해보자, <br>
`.began`과 `.ended`는 한번만 호출되지만 `.changed`는 바뀔때마다 호출이 된다.

<br>

한마디로 롱터치 시작 후 **변화**되는 **위치값**을 알 수 있다.<br>
이를 이용하면, 위에 GIF와 같이 롱터치후 변화 되는 값에 따라 `view`를 이동시켜줄 수 있다는 말이 된다!

<br>

(잘 이해가 안된다면 위 코드에서 `point`와 `point2`를 주석걸고 `print`해서 x, y값에 대해 보면 이해에 도움이 될 것 같다.)

