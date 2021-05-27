---
layout: post                       
title: Swift - setNeedsLayout() VS layoutIfNeeded() (feat. animation)
categories: [Swift]
---


참고: 
1. [zedd님 블로그](https://zeddios.tistory.com/359?category=682195)
2. [어느 사이트](http://www.iosinsight.com/setneedslayout-vs-layoutifneeded-explained)


막연하게 layoutIfNeeded() 를 써왔었는데, 볼때마다 유사해 보이는 setNeedsLayout()은 뭘까 싶었다,

updateConstraints()도 궁금하고, 비슷한 다른것들도 궁금하지만, 자료좀 찾아보니 저둘이 비교하는게 많았기에 정리!

`Zedd`님 블로그가 너무 정리가 잘되어있어서 기본적인건 간단하게 설명하고, 이해력이 딸려 살짝 갸우뚱 했던 부분들을 적어야겠다

<br>
<br>

# 들어가기전 먼저 알아야 이해가 되는것!
<br>

`Life cycle`중 view layout을 `update` 해주는 부분이 있다고 한다! 글들을 보니 `layoutSubviews()`가 그 역할인가보다. (Zedd님 감사합니다)

근데 말 그대로, Cycle이다, 한번 지나가면 나중에 오는 그런것! 요게 포인트다.

또한 해당 싸이클이 왔어도 그 view의 layout이 무효화 되있어야 새로 짜는것 같다

그래서, Constraint를 수정해도 바로 적용이 안되고, 

SetNeedsLayout() 또는 LayoutIfNeeded() 를 해서 적용을 해줘야 했나보다.


<br>
<br>

# setNeedsLayout()

### Point
- Async
- 대기

<br>

위에서 무효화가 돼있어야 한다고 적었는데, 무효화 하는 방법은 `setNeedsLayout()`을 써주는 것이다. 

"해당 view 다음 사이클때 업데이트 해줘" 라는 의미며, [참고 2번 사이트](http://www.iosinsight.com/setneedslayout-vs-layoutifneeded-explained)에 의하면, 그 `subviews`도 업데이트가 된다.

바로 바뀌지 않으며 대기 상태이고, 비동기로 진행된다, 그리고 **이 cycle은 언제오는지 알기 힘들다고 한다.**

> --2번 사이트 표현--  
> "please update but you can wait until the next update cycle"  
> 업데이트 해줘, 근데 다음 업데이트까지 기다릴게

<br><br>


# layoutIfNeeded()
### point
- Sync
- 즉시

<br>

차이점이라면 동기로 진행되고, 다음 cycle이 될때까지 기다리지 않고 바로 업데이트 시킬때 쓸 수 있다

> --2번 사이트 표현--  
> "update immediately please"  
> 업데이트 해줘, 당장!



<br>
<br>

# 예시를 통한 이해



`Zedd`님께서 이 [링크](https://github.com/lmacfadyen/UIViewLifecycleLayoutDisplay)를 추천해주셨다.

- `setNeedsLayout()`은 다음 업데이트때 기다릴게!
- `layoutIfNeeded()`은 지금 당장 업데이트 해줘!

<br>

결론은 "둘다 새 값으로 업데이트 해줘!" 로 이해를 했다. 근데 이렇게 생각하니 잘 이해가 안됐다,



```
self.blueHeight.constant = 100

UIView.animate(withDuration: 2.0, animations: {
    self.view.setNeedsLayout()
    // 또는
    self.view.layoutIfNeeded()
})
```
<br>

예제에서 이게 이해가 안된다. `layoutIfNeeded()`는 높이값 `constant`가 변경 되었을때, 애니메이션 효과가 보이면서 `height`값이 바뀐다.

반면, `setNeedsLayout()`은 애니메이션 효과없이 바로 새로운 `height`값이 적용된다.

<br>

기존값은 `0`, 새값을 `100`이라 해보자, 둘다 `constant`가 100으로 됐다는 의미다.

그럼 위에 서술한 내용들을 붙여보자

- `setNeedsLayout()` : 100으로 바꿨어, 다음 업데이트때 적용해줘
- `layoutIfNeeded()`: 100으로 바꿨어, 당장 바꿔줘

이렇게 생각을 해서 이해가 안됐다. 

<br>

왜 이해가 안됐는지 적어보면,

1. 결국엔 이미 애니메이션 호출전 `100`으로 선언해줬으니  애니메이션 시작할때면, 이미 100아닌가?? 그럼 cycle돌다가 업데이트할때 이미 100인거 같아! 근데 애니메이션 주면 `layoutIfNeeded()`는 효과가 있다? 그럼 애니메이션동안 cycle이 적용 안된건가? 그럼 `setNeedsLayout()`은 2초 뒤에 값이 바뀌어야하는것 아닌가?!
 
 이상한점: `setNeedsLayout()`이 2초뒤가 아닌 시작하자마자 값이 바뀜??? 잉 아예 틀려버림
 
 2. 1번이 이상했다, 시작과 동시에 cycle이 돈거라면 height는 `100`으로 이미 박혀있는거고 적용이 된거다? 근데! 이미 100이면 `layoutIfNeeded()` 도 cycle 시작시 이미 100이니깐, 점점 100이 되는게 아니라, 이미 100이겠네?
 
 이상한점: 왜 애니메이션 효과가 적용된거지? 바로 100으로 되야하는거 아닌가?!
 
 <br>
**바보였다. 글쓸때까지도 잘 못 이해하고 있었다...**


<br><br>

# 원인 파악

### Point_A
- `update cycle`은 돌고 돈다, 유저는 알 수 없다

그렇다, 나는 알 수 없었다...

이걸 빼먹고 생각하니 이상한 추론만 했다.

중점은 이거다.

<br>


### Point_B
- animations 블록 안에 내용이 animation 효과가 적용된다, 


<br>

### Point_C
- `setNeedsLayout()`는 다음 update cycle때.
- `layoutIfNeeded()`는 즉시.


<br>
포인트 B와 C를 섞어서 보자

- animation 블럭 내에서 `setNeedsLayout`은 다음번에 update cycle 때 해달라고 요청한다. **즉, 지금 한것은 요청만함.**
- animation 블럭 내에서 `layoutIfNeeded()`는 즉시 update를 요청한다, 블럭 내에서! **즉, 지금 요청과 동시에 변화가 시작된다.**

<br>
포인트는 블럭내에서 요청만 했느냐, 요청 + 적용이 되었느냐 였다.

<br>

현재 `height = 0` 이었고 신규값 `height = 100`은 요청 사항이었다. `layoutIfNeeded()`는 그 값이 animation때 적용했기에 `0~100`이 되는 과정이 animation으로 보였다. 

그런데, `setNeedsLayout()`의 경우  animations 블럭에선 요청만 했기에 별다른 UI적으로 변경 요소가 없었다.


<br>
그렇다면, 한번에 바뀐건 어떻게 생각할까? **Point_A**가 해답이다. 

`Animations 블럭`이 지난후 cycle이 돌다가 update cycle이 된것이라 본다.

그렇기에 해당사이클은 `setNeedsLayout()`이 요청한 `height = 100`을 적용한것이며, 

이는 애니메이션과 관련이 없기에 한번에 적용된것이다.

사람 눈이 착각한 느낌이랄까? 시각적으론 `height = 100`이 적용되고 애니메이션이 시작된것 같지만 

1. `animations 블럭`에서 `update` 요청
2. 이후 `update cycle` 적용 & `animation` 진행중...
3. `animation` 진행중 ... 끝

이렇게 되는게 맞다고 본다. 


<br>

**cycle을 내가 컨트롤하지 않아서 생각을 못했다. 완전 바보였다....**




