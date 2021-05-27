---
layout: post
title: DesignPattern - Builder
categories: [DesignPattern]

---



<br>

오랫만에 블로그 글 남기기.

참고 서적: gof의 디자인 패턴

<br>

# 구성 요소

- Builder
- Concrete Builder
- Director



<br>

### Builder

Protocol



<br>

### Concrete Builder

builder를 준수한 구현 클래스



<br>

### Director

Concrete Builder를 이용하여 객체를 `return` 해주는 구현 클래스



<br>

<br>

**핵심 = Builder**

- Builder는 product를 속성 값을 셋팅하는 함수는 builder를 반환한다. (Chain을 쓰기 위함.)

- 메소드 생성시 묶을 수 있는 부분은 같이 묶는다
  - ex) UIButton에 테두리를 만들때 보통 Color와 Width는 둘다 입력하게 되므로 인자값에 Color와 Width를 넣어 하나로 묶는다.



<br>

**장점**

- Rxswift때처럼 체인 기능을 이용하여, 객체 생성때 필요한 모든 것을 한 라인(줄바꿈은 당연!)으로 생성이 가능하여, 해당 코드 분산이 적다.
- 위의 예시처럼 Bolder의 Width와 Color는 보통 묶어서 처리가 가능하므로 코드 라인이 더 적어진다.
- product를 생성시 미리 받은 속성 값을 이용해 필수 값을 누락 했는지 안했는지 확인 가능.



<br>

**그러면 Director는?**

배우면서 개인적인 생각으론, Builder와 Concrete Builder만으로 시작 했을 듯하다. 

체인 기능을 쓰며, 자기가 Builder에 추상화한대로 명확하게 새로운 객체 생성이 가능해졌으며,

하단의 버튼들이라던가 특정 뷰들이 생성하다보면 분명 같은 코드가 나올것이다. 

그럼, 이런 공통의 Concrete Builder들을 관리하는 것이 필요하다 느끼고 Builder를 Return하는 class를 만들고

이름을 Director라고 붙여준것 같다는 느낌을 받았다. 개인적으로 <



<br><br>

# UML - Class Diagram



![](/assets/images/2020-11-12/img1.jpg)



<br>

위와 같은 구조로 이루어져 있으며 눈여겨 볼 것은 다음과 같다

- build를 통해 객체를 돌려준다.
- 테두리 적용시 `width`와 `color`를 같이 받는다



<br>

그리고, Director는 미리 정의한 버튼의 Builder를 준수한 객체를 반환 해준다.



<br><br>



# CODE



<br>

### Builder & ConcreteBuilder

메소드들중 일부만 코드로 보자 

(프로토콜은 위에 그림으로 충분하므로 코드 생략.)



<br>

```swift
class ButtonConcreteBuilder: ButtonBuilder {
  	private var product = UIButton()

	  ... 생략
 		// 텍스트 입력
  	func setTitle(_ title: String) -> ButtonBuilder {
        self.product.setTitle(title, for: .normal)
        return self
		}
  	// 테두리 적용 (컬러와 폭을 한번에 받아 보다 쉽게 적용)
  	func setBolder(color: UIColor, width: CGFloat) -> ButtonBuilder {
        self.product.layer.borderWidth = width
        self.product.layer.borderColor = color.cgColor
        return self
		}
  	// 객체 반환
  	func build() -> UIButton? {
        return self.product
		}
}
```

간단.



<br>

### Director

```swift
class ButtonDirector {
    static func makeBottomButton() -> UIButton {
        let titleColor = UIColor(red: 1, green: 192/255, blue: 0, alpha: 1)
        let highLightColor = titleColor.withAlphaComponent(0.4)
        let bgColor = UIColor(red: 51/255, green: 59/255, blue: 67/255, alpha: 1)
        let font = UIFont.boldSystemFont(ofSize: 17)
        let radius: CGFloat = 8

        let screenFrame = UIScreen.main.bounds
        let screenSize = screenFrame.size
        let margin: CGFloat = 12.0
        let height: CGFloat = 45.0
        let size = CGSize(width: screenSize.width - (margin * 2), height: height)
        let point = CGPoint(x: margin, y: screenSize.height - height - (margin * 2))
        let frame = CGRect(origin: point, size: size)


      	// 1. Chain을 이용하여 값 셋팅
        let builder = ButtonConcreteBuilder()
            .setBGColor(bgColor)
            .setTitleColor(titleColor)
            .setTitleHighlightedColor(highLightColor)
            .setFont(font)
            .setFrame(frame)
            .setRadius(radius)
            .setTitle("Bottom")

        return builder.build()
    }
}
```

Director도 프로토콜을 생성하여 준수하게 만들면 좋겠지만? 얘는 일단 이렇게 합시다. 내가 필요한건 공통적으로 하단에서 쓰일 버튼이니깐!

<br>

여기서 눈 여겨 보아야할 것은 주석 부분이다. 

체인을 이용하여 연달아서 값을 적용 할 수 있으며, 분산이 안됨을 느낄 수 있었다.

<br>

그리고 마무리론 `build()`하여 버튼 객체 반환.

<br><br>

# 사용

```swift
class ViewController: UIViewController {

		...
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addBottomButton()
    }
    
    private func addBottomButton() {
        let bottomButton = ButtonDirector.makeBottomButton()
        self.view.addSubview(bottomButton)
    }
}
```



위와 같이 아주 간단하게 `Director`를 통해 화면에 버튼을 추가했다. 



결과는 아래와 같다.

<br>

![](/assets/images/2020-11-12/img2.png)



<br>

<br>

# 한줄평

<br>

Builder 패턴은 명확하고 통일성 있게 객체를 생성할 수 있으며 간단한 컴포넌트에 적당한 느낌.

