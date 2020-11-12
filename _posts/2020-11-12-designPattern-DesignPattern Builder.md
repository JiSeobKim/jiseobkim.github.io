---
layout: post
title: (DesignPattern) builder
categories: [DesignPattern]

---



오랫만에 블로그 글 남기기.



참고 서적: gof의 디자인 패턴



# 학습 패턴: Builder



## 구성 요소

- Builder
- Concrete Builder
- Director



### Builder

Protocol



### Concrete Builder

builder를 준수한 구현 클래스



### Director

Concrete Builder를 이용하여 객체를 `return` 해주는 구현 클래스







## 핵심은 Builder

- Builder는 product를 속성 값을 셋팅하는 함수는 builder를 반환한다. (Chain을 쓰기 위함.)
- 메소드 생성시 묶을 수 있는 부분은 같이 묶는다
  - ex) UIButton에 테두리를 만들때 보통 Color와 Width는 둘다 입력하게 되므로 인자값에 Color와 Width를 넣어 하나로 묶는다.



## 장점

- Rxswift때처럼 체인 기능을 이용하여, 객체 생성때 필요한 모든 것을 한 라인(줄바꿈은 당연!)으로 생성이 가능하여, 해당 코드 분산이 적다.
- 위의 예시처럼 Bolder의 Width와 Color는 보통 묶어서 처리가 가능하므로 코드 라인이 더 적어진다.
- product를 생성시 미리 받은 속성 값을 이용해 필수 값을 누락 했는지 안했는지 확인 가능.





### 그러면 Director는?

배우면서 개인적인 생각으론, Builder와 Concrete Builder만으로 시작 했을 듯하다. 

체인 기능을 쓰며, 자기가 Builder에 추상화한대로 명확하게 새로운 객체 생성이 가능해졌으며,

하단의 버튼들이라던가 특정 뷰들이 생성하다보면 분명 같은 코드가 나올것이다. 

그럼, 이런 공통의 Concrete Builder들을 관리하는 것이 필요하다 느끼고 Builder를 Return하는 class를 만들고

이름을 Director라고 붙여준것 같다는 느낌을 받았다. 개인적으로 <





