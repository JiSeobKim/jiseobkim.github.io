---
layout: post
title: (swift) UI 도전! - DragAnimation_Step1_Gesture(Long &pan)
categories: [Swift, UI]

---

![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2020-03-01/img1.jpg)

오랫만에 포스팅............. 여러모로 힘든 시기였다 ㅠ 기운내자

개인적으로는 iOS의 장점중 하나가 부드러운 동작이라 생각한다.

그래서 개인적으론 웹뷰를 선호하지 않는 이유중 하나는 웹뷰로도 동작이 부드러울수는 있으나,

네이티브의 부드러움을 따라가는 앱은 보지 못했다.

그리고 부드러운 동작과 잘 맞는 애니메이션은 사용자가 앱에 더 관심을 갖게 해주고, 좋은 경험(UX)를 준다고 생각한다.

화면 하나를 띄울때도 단순히 보여주는게 아닌 어떻게 해야 더 자연스럽고 좋은 경험을 유저에게 선사할 수 있을지

고민하고 시도하는 개발자가 좋은것 같다. 

<br>

그래서 시도한 UI 따라하기!

몇몇 앱들보면 특정 UIView 또는 UIButton 등을 길게 누르면 이동 시키고, 다른 뷰 위에 올릴시 새로운 액션이 일어남을 볼 수 있는 앱들이 있었다. 

이런 앱들 보면서 어떻게 하면 저렇게 될까? 라는 생각하다가 시도를 해보았다.

이번 편은 3편으로 이루어질것이고, 순서는 다음과 같다.

1. Gesture - Long Press & Pan
2. Transition
3. 응용하기 (1 + 2)


무엇을 만들게 될지 결과물부터 보고 이야기를 진행하는게 좋을 것 같다.

![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2020-03-01/gif1.gif)
