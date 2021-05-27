---
layout: post                       
title: "Swift - UIButton과 클래스"
categories: [Swift]
---

이번의 주제는 클래스를 좀 더 잘써보기 위한 글이다디자인적 요소에서 class를 효율적으로 사용해보자

<br>

지금하는 프로젝트도 그렇고 어디서든  디자이너는 있다. 개인 프로젝트도 본인이 디자이너인것이다. 물론 퀄리티 차이는 어마어마하다.

그런데 디자이너건 개인프로젝트건 사용하는 것중에 반복 되는 요소는 있기마련이다.
예를 들자면 `저장` 같은 버튼?
통일성도 있을 뿐더러 시간 절약도 되는 것 같다.

이번에도 이전글과 같이 **아!! 이렇게 쓰면 좋겠네!** 하는 경우이다<br>[이전글: Class, Struct 값 전달 방식이 다른건 알지만 언제쓰지?](https://jiseobkim.github.io/2018/07/08/swift-class,struct-값-전달-방식-차이.html)

다루게 내용은 다음과 같다
1. Class 없이 구현
2. Class 사용하여 구현
3. Class의 상속 이용


오늘은 Play Grounds 말고 Xcode가 사용된다.


우선 화면을 보자,
![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-15/img1.png)
(왼쪽부터)
1. 네비게이션바
2. 메인 화면 - 버튼 선택 -> 입력화면으로 이동
3. 입력 화면 - 텍스트 필드 입력 후 저장 -> 메인으로 이동


구성은 오늘도 심플하다.

여담으로 Xcode가 다크모드인것은 WWDC 2018에서 발표한 새로운 macOS인 Mojave에서 지원하는 다크모드이다! 다크모드 발표때 개발자들 환호성이 제일 크게 들렸던 것 같다. 현재 베타에서만 사용 가능하다.

여기서 추가적으로 Xcode beta 10버전에서 오브젝트 라이브러리의 위치가 바뀌었다!

(Xcode9)
![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-15/img2.png)
기존의 위치는 위 사진 처럼 빨간색 영역이 오브젝트 라이브러리 이다.

바뀐 위치를 보자
(Xcode10 베타)
![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-15/img3.png)
다음과 같다. 기존의 영역은 비어있고. 저렇게 새로운 창으로 영역이 바뀌었다.<br>
(단축키 : `Shift - option - L`)<br>
(* bear 글쓰기 프로그램에 Xcode 10 베타 코드 복붙하면 이상해서 다시 9로 사용 .. ㅠㅠ)

다시 본론으로 돌아가서

주목해야할 부분은 `저장` 버튼이다.

## 기획자: TextField가 글자 있는지 없는지에 따라,<br>저장 버튼 비활성화/활성화로 해주세요.

이런 경우는 많고 많은 앱들에서도 보인다.

여기서 추가 조건

## 디자이너: 비활성화 색은 회색, 활성화 색은 기본 파란색이요
디자이너의 요구사항이라 가정하자.

그럼 요약하자면
1. 글자 입력됨 - 기본색, 활성화
2. 글자 입력 안됨 - 회색, 비활성화


(기본 화면)
![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-15/img4.png)


## 1. Class 없이 구현
어디서 또는 어떻게 처리할지 부터 보면,
1. 화면 진입시, 비활성화 상태 - viewDidLoad()
2. 글자 입력시 - (TextField의 Editing Changed 사용)

1을 코드로 하면 다음과 같다
``` swift
@IBOutlet var btnSave:
override func viewDidLoad() {
        super.viewDidLoad()
        *// 1. 반응 없게 비활성화*
        btnSave.isUserInteractionEnabled = false
        *// 2. 회색으로 변경*
        btnSave.setTitleColor(.gray, for: .normal)
    }
```


![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-15/img5.png)

아주 아주 간단하다. 그럼 바로 이어서 2번째 조건

Conection Inspector 에서

연결은 먼저 하고
![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-15/img6.png)

코드

```swift
@IBAction func editChanged(_ sender: UITextField) {
        // 조건: 글자가 비어있는가??
        if sender.text?.isEmpty == true {
            // 글자
            // 1. 반응 없게 비활성화
            btnSave.isUserInteractionEnabled = false
            // 2. 회색으로 변경
            btnSave.setTitleColor(.gray, for: .normal)

        } else {
            // 글자 o
            // 1. 활성화
            btnSave.isUserInteractionEnabled = true
            // 2. 기본 색으로 변경
            btnSave.setTitleColor(**self**.view.tintColor, for: .normal)
}
```

이것도 아주 간단하다.

그렇지만 같은 코드가 계속 반복 된다.

마음에 안드니 함수로 빼주자.

![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-15/img7.png)

훨씬 깔끔하다.

솔직히 이렇게만 끝내면 Class가 왜필요해? 라고 할 수 있다.
그런데 위의 활성,비활성화를 함수로 만든 이유를 다시 생각해보자.
- 같은 코드가  반복된다
- 정리 안하면 코드가 지저분해 보인다.
- 만약 1개라도 변경하면 모든 부분을 찾아 바꿔야한다

여기서 솔직하게 2번째 부분은 뭐 그러려니 할수있다. 그치만 1,3번 문제가 정말 크다
1번 때문에 3번이 발생하는 것인데, 지금이 화면이 1개라 그렇지 많다고 하면 끔찍하다

## 화면이 1개가 아니라면?
만약에 입력해야할 화면이 1개가 아니고
1. 이름 입력
2. 이메일 입력
3. 전화번호 입력
![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-15/img8.png)

위처럼 입력 화면이 여러개일 경우 어떻게 할 것인가?

각 UIVIewController 클래스 마다 함수를 만들것인가??
그럼 다시 똑같은 문제가 발생한다.
- 같은 코드가  반복된다
- 정리 안하면 코드가 지저분해 보인다.
- 만약 1개라도 변경하면 모든 부분을 찾아 바꿔야한다

그렇다면 어떻게 할까?
방법은 2가지 정도 생각이 난다
1. Util 클래스를 만들어서 그안에 함수를 만들고 공통적으로 호출한다. (관리하기 편하게 Util에 모음)
2. UIButton을 상속한 클래스를 만들어서 사용한다.

둘은 비슷하다.  차이가 있다면 기능은 같지만 **약간의 차이점이 있는 버튼** 을 만들어야한다면 차이가 발생한다.

예를 들어 아래 사진을 보자
![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-15/img9.png)
새로운 버튼이 생겼다. 저장 후 메인으로 돌아가는 버튼이다.
기능은 동일하다고 했을때 차이점이 있다.
- 배경색
- cornerRadius가 있다.

기존 문제였던 바뀌었을 경우 어떻게 할것인가? 와는 다른 문제다.
왜냐면 함수 내에것을 바꾸면 모두 바뀌지만 이건 성격이 좀 다른애가 생긴거니깐,

물론 인자를 받아서 다르게 처리 할수는 있다!
그렇지만 클래스의 상속을 이용한다면 더 편하게 할 수 있다.

# Class 사용하여 구현
우선 가장 기본이 되는 버튼의 클래스를 만들어보자
```swift
class DefaultBtn: UIButton {
    // 1. 스토리보드로 버튼 구현시
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    // 2. 코드로 버튼을 구현시
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}
```

`UIButton`을 상속 받은 클래스이다.
2가지 초기화 구문이 있다.
위에 주석을 달아 놓은듯이
<br>1은 스토리보드에서 버튼을 추가할경우 사용될 init 구문
<br>2는 코드로 구현할시 사용


1을 이용해서도 코드로 짤수는 있지만 해당부분은 아직 필자도 잘모르는 영역

우리가 이용할 상태를 enum을 이용해서 표현해보자

```swift
class DefaultBtn: UIButton {

    // 버튼 상태 종류
    enum btnState {
        case On
        case Off
    }

    // 기본 값 = off 상태
    var isOn: btnState = .Off

    // on 컬러
    var onTintColor: UIColor = UIColor(red: 0, green: 122/255, blue: 1/255, alpha: 1)

    // off 컬러
    var offTintColor: UIColor = .gray

// ----------- 기존 코드
}
```
기존 클래스에서 추가되었다. enum을 요즘 자주 이용하는데, 딱 필요한 케이스들만 나열하여, 다른 값을 방지할 수 있으며, switch문과 같이 쓰면 굉장히 좋다. 추가적으로 컬러값도 지정해놓았다.

그럼 이제  셋팅을 해보자

```swift
class DefaultBtn: UIButton {

    // 버튼 상태 종류
    enum btnState {
        case On
        case Off
    }

    // 기본 값 = off 상태
    var isOn: btnState = .Off {
        didSet {
            setting()
        }
    }

	  //.. 컬러변수 생략
    // 1. 스토리보드로 버튼 구현시
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // 기본 셋팅
        setting()
    }
    // 2. 코드로 버튼을 구현시
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 기본 셋팅
        setting()
    }


    func setting() {
        // on 컬러 (기본색)

        switch isOn {
        case .On:
            self.setTitleColor(onTintColor, for: .normal)
            self.isUserInteractionEnabled = true
        case .Off:
            self.setTitleColor(offTintColor, for: .normal)
            self.isUserInteractionEnabled = false
        }
    }
}
```

차이점은 세가지가 있다
1. setting() 함수가 생긴것
2. setting 함수가 init구문에 적용된것
3. isOn 변수에 didSet을 추가

설명이 필요한건 3번만 설명하면 될 것 같다, 3번 didSet의 경우 해당 변수기 초기화 되었을때,  호출되는 내용이다. 이것도 잘 활용하면 장점이 많다.

뭔가 보기엔 **뭐야? 오히려 더 힘든데?** 할수 있다, 그렇지만 처음에 셋팅만 어렵지 사용은 아주 간단하다.

우선 버튼에 클래스를 넣어주고
![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-15/img10.png)
IBOutlet도 변경
``` swift
//@IBOutlet var btnSave: UIButton!
@IBOutlet var btnSave: AnotherBUtton!
```

그럼 이제 사용해보자
```swift
class AddNameViewController: UIViewController {
    @IBOutlet var btnSave: DefaultBtn!

    override func viewDidLoad() {
        super.viewDidLoad()
        // 버튼 비활성화
        btnSave.isOn = .Off
    }

    @IBAction func editChanged(_ sender: UITextField) {
        // 조건: 글자가 비어있는가??
        if sender.text?.isEmpty == true {
            // 버튼 비활성화
            btnSave.isOn = .Off
        } else {
            // 버튼 활성화
            btnSave.isOn = .On
        }
    }
}
```

심플의 끝이다. 마음에 평화가 찾아온다....

물론 전역 함수로해도 한줄로 하면 끝이긴 하지만 위에 말했듯이 차이점이 있다.
그리고 enum을 써서 가독성도 훨씬 좋다. 사용성도 좋다, 아래 사진처럼 .을 누르면 알아서 나오니깐 다른곳에서도 적절히 잘 사용하자.
![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-15/img11.png)

그렇담 아까 문제가 되었던 활성/ 비활성은 같으나 특성이 다른것은 어떻게 구현을 할까?


# Class 상속을 사용하여 구현
아까 만들어둔 클래스를 상속하는 클래스를 만들고 override를 이용하는 것이 결론이다.

만약 전역 함수나 Util 클래스를 생성해서 거기다가 함수를 만들어서 사용한다면
1. 오버로드를 이용해서 같은 이름의 함수를 여러개 만든다
2. 인자값에 따라 다르게 처리되게 한다
라던가, 뭐 방식은 있다. 그렇지만 가독성도 안좋다!

배경색과 cornerRadius이 첨가된 활성/비활성 버튼 클래스를 만들어보자
``` swift
class BtnWithBackGroundColor: DefaultBtn {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // 새로운 조건
        addSomeThing()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        // 새로운 조건
        addSomeThing()
    }

    func addSomeThing() {
        self.backgroundColor = .green
        self.layer.cornerRadius = 5
    }
}
```
처음에 만든 클래스보다 굉장히 간단하다. 내가 새로 필요한것만 override 해주고
기존것은 그대로 가져다 쓴다.

사용법은? 같다
```swift
class AddNameViewController: UIViewController {

    @IBOutlet var btnSave: DefaultBtn!
    @IBOutlet var btnSave2: BtnWithBackGroundColor!


    override func viewDidLoad() {
        super.viewDidLoad()
        // 버튼 비활성화
        btnSave.isOn = .Off
    }


    @IBAction func editChanged(_ sender: UITextField) {

        // 기존 생략..

        // 배경색 있는 버튼
        if sender.text?.isEmpty == true {
            btnSave2.isOn = .Off
        } else {
            btnSave2.isOn = .On
        }
    }
}
```

실행 사진은? 잘나온다
![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-15/img12.png)



## 디자이너: 저장후 메인 가는 버튼 글자 크기는 볼드17로, 글자색은 비활성:흰색, 활성: 빨간색으로 변경해주세요

이럴 경우 어떻게 하면 되는가!

`BtnWithBackGroundColor` 클래스의 `addSomeThing()` 만 손보면 된다
``` swift
func addSomeThing() {
        self.backgroundColor = .green
        self.layer.cornerRadius = 5
        // 추가 요청
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17) // 폰트 볼드 및 사이즈 17
        self.offTintColor = .white // off 컬러 흰색
        self.onTintColor = .red // on 컬러 레드
        self.setting() // 바뀐것으로 셋팅 !
    }
```

저렇게만 추가해주면 아래 사진처럼 바뀐게 나오게 된다!
저기만 손보고 여러곳의 버튼들을 한꺼번에 수정이 된다니 너무좋다.

다만 이해 안될 소지가 있는건  `self.setting()`인데, 저것을 안해주면 컬러값이 안변한다. 저 변수들은 setting()에서 사용이 되는데, init 구문에서 부모클래스가 사용을 하고 바뀐 값으론 사용이 안되었기 때문이다!


![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-15/img13.png)


만약 여러가지 복합 적으로 추가할 경우에도 크게 다르지 않지만 만들기 편함과 유지보수 면에서도 굉장히 편리하게 진행할 수 있다.

이렇게 해두면, 요청으로 인해서 변경할때도 한꺼번에 변경 및 수정이 가능하니
필요한곳에 잘사용하면 좋을 것 같다!

정말 심플한 예제로 시작을 하였고, 아직 복잡한 곳엔 많이 이용안해봤지만
좀더 쓸곳을 찾아봐야겠다.
