---
layout: post

title: "(RIBs) Uber/Tutorial의 이해 (하위 리블렛 붙이기) (Without Component)"

categories: [Architeture]

---

<br>

[이전편](https://jiseobkim.github.io/architeture/2022/02/28/Swift-RIBs-Uber-Tutorial의-이해(Launch-Router-만들기).html)에서 `LaunchRouter`를 만들고

립스로 최초 화면을 띄우는 것에 대해 포스팅을 하였다.

이번 편에서는 하위 리블렛을 붙이는 것을 주제로 잡았다.

> 리블렛(Riblet): Ribs 라는 요리를 본적 있다면, 그 뼈대 하나를 리블렛이라고 한다고 한다.
> 아키텍쳐에서 의미는 이전편에 Root처럼 하나의 단위를 리블렛이라한다고 한다.

<br> 
<br>

# 분류

<br>

쉽게 이해를 돕기 위해 나눠서 설명을 하고자 한다.

1. 의존성 주입이 필요없는 경우

2. 의존성 주입이 필요한 경우 (`Component`가 필요한 경우) 

<br>

그 이유는 `Router`의 역할을 먼저 알아보기만해도 처음엔 저세상 이야기 같은데

의존성 주입까지 하려하면 너무 끔찍했다.

<br>

그래서 이번 편에서는 `Component`가 없이 기본적인 화면 붙이기만 다룰 예정

<br>
<br>

# 구조 설명

<br>

Uber/Ribs Tutorial을 기반으로 설명을 할 예정이다.

그리고 이번편에서 하고자 하는 것의 구조는 다음과 같다.

<img src="/assets/images/2022-03-02/img.png" style="zoom:40%;" />

<br>

- `Root`: 이전편에 생성

- `LoggedOut`: 사용자 이름 2개를 입력 받는 화면 (이번편에서는 빈 화면만)


<br>

그리고 `LoggedOut` 리블렛을 생성해주자.

<img src="/assets/images/2022-03-02/img-1.png" style="zoom:40%;" />

<br>

<br>
<br>

# Attach LoggedOut

<br>

`Root`는 하는게 없다. 단순히 로그아웃된 화면을 띄워줄 뿐이다.

그렇다는 말은 로그아웃된 화면에선 의존성 주입을 받을 필요가 없다.

<br>

`attach`를 통해 화면 전환이 어떻게 이뤄지는지 

시작하기 딱 좋은 예제라 생각 된다.

<br>

중점은 `Attach`를 어떻게 하는지이다.

<br>
<br>

### Root Interactor

<br>

누구한테 명령을 해야할까? 

화면 전환을 담당하는 `Router`에게 명령을 해야한다.

<br>

누가 지시를 해야할까?

두뇌 역할을 하는 `Interactor`가 명령을 내려야한다.

<br>

그러기 위해선 `RootRouting`에 시그니처를 다음과 같이 적어준다.

```swift
// In RootInteractor.swift

protocol RootRouting: ViewableRouting {
    func attachLoggedOut()
}
```

<br>

이제 `Router`에게 명령을 할 수 있다.

<br>

그럼 언제 지시를 내릴까?

<br>

시점은 `interactor` 안에 존재하는 메소드인 

`didBecomeActive()`가 적당해 보인다.

다음과 같이 작성하자.

<br>

```swift
override func didBecomeActive() {
    super.didBecomeActive()
    
    router?.attachLoggedOut()
}
```

<br>

그러면 이제 빌드를 해보면 에러가 날 것이다.

<br>

왜냐하면 `attachLoggedOut()`을 명시해준 것은 프로토콜이었고,

이를 준수하는 실제 `RootRouter`는 이 메소드를 구현 해주지 않았기 때문이다.

> 직접적으로 `router`에게 하는것이 아닌 
> `protocol` 타입의 객체를 통해 명령을 내려줌으로써 
> 서로간의 의존성을 끊을 수 있다는 장점도 존재.

<br>

그럼 이제 실제 `RootRouter`로 가서 빈 메소드를 만들자.

<br>
<br>

### Root Router

<br>

```swift
// in RootRouter Class

func attachLoggedOut() {
    
}
```

<br>

일단은 에러는 피했고, 이제 화면 전환을 하기 위한 준비물들이 필요하다.

<br>

리블렛의 생성을 담당하는건 `Builder`다.

그래서 이 `Builder`가 필요하지만, 

위에서 본 것과 같이 `interactor`도 직접 `router`객체를 들고 있지 않았다.

<br>

여기서도 실제 `Builder`가 아닌 빌더가 따르는 `Buildable`을 프로퍼티로 들고 있자.

 
```swift
// in RootRouter Class
private let loggedOutBuildable: LoggedOutBuildable
private var loggedOutRouting: Routing?
```

<br>

`loggedOutRouting`은 화면을 띄우고 끝이 아닌 제거도 필요할때가 있다. 

따라서, 화면을 띄우면 객체로써 들고 있자! 

<br>

`loggedOutBuildable`은 초기화가 안되어 있어서 오류가 난다.

`init`시 초기화 해주자 (`override`는 제거!)

```swift
init(
    interactor: RootInteractable,
    viewController: RootViewControllable,
    loggedOutBuildable: LoggedOutBuildable
) {
    self.loggedOutBuildable = loggedOutBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
}
```

<br>

그럼 우선은 `RootRouter.swift`파일 내의 오류는 사라진다.

<br> 

하지만, 다른 오류가 나온다.

`init`을 수정했기 때문에 어디선가 해당 `init`을 쓰고 있던 부분은 오류가 난다.

<br>

`Router`가 생성되는 곳은 어딜까

역시 리블렛의 생성 담당인 `Builder`에 있다.

`RootBuilder.swift`로 이동하자.

<br>
<br>

### Root Builder

<br>

아래에 이미지와 같이 `RootRouter` 생성하는 부분인을 채워줘야한다.

<img src="/assets/images/2022-03-02/img-2.png" style="zoom:40%;" />

<br>

빌더를 하나 생성해준다.

```swift
let loggedOutBuilder = LoggedOutBuilder(dependency: ??)
```

이제 또 위 코드의 `??`을 채워야한다.

<br>

하 개인적으로 처음에 이정도 왔을때 

뭐이리 할게 많아...? 싶었다... 



<br>

결론은 같은 메소드 내에 있는 `component`가 들어가면 된다.

`Component`는 이전편에서 필요한 객체를 담아두는 주머니 정도로 설명을 했다.

<br>

즉, `LoggedOutBuilder`에 필요한 의존성을 주입하라는 얘기다.

<br>

그런데 `component`를 넣어주게 되면 에러가 난다.
 
`LoggedOutBuilder`가 뭐가 필요한지도 모르는데,

일단 아무거나 껴넣었기 때문이다.

<br>

따라서 `RootComponent`가 `LoggedOutDependency`를 준수하도록 해줘야

비로서 에러는 사라지며 정상적으로 사용이 가능하다.

<br>

<img src="/assets/images/2022-03-02/img-3.png" style="zoom:40%;" />

위의 사진을 보면 3개의 빨간 박스가 있으며 위의 말들을 정리한 것이다.

<br>
<br>

### 다시 Root Router

<br>

돌고 돌아 다시 라우터로 왔다.

화면 하나 붙이기 위한 준비 과정이 이제서야 끝났다.

<br>

처음엔 이게 뭐야 도대체 왜이래 싶었지만,

하면 할수록 빨라지고 명확해서 좋다는 기분이 들어서 좋다.

> 그럼에도 가끔씩 너무많아... 싶긴하다...

 
<br>

아까 빈 메소드로 남겨두었던 `attachLoggedOut()`를 채워보자

<br>

`router`가 이제 `loggedOutBuildable`이 있으니 

`build`메소드를 통해 `router`를 얻을 수 있다.

```swift
let router = loggedOutBuildable.build(withListener: interactor)
```

<br>
 
`interactor`를 넣어주는 이유는 

하위 리블렛(`LoggedOut`)과 상위 리블렛(`Root`)의 

`interactor`끼리 상호작용이 가능하게 하기 위함이다!

<br> 

예를 들어, 화면을 띄울 리블렛은 

띄운 리블렛을 닫을 책임도 있기 때문에 

하위가 상위한테 "화면 닫아줘" 같은 요청을 해야할 때도 있다.

<br>

그럴때 하위 `interactor`가 상위 `interactor`에게 전달할 방법이 필요하므로

`listener`로써 위 코드와 같이 

현재의 `interactor`가 전달되어야 한다.

<br>

하지만, 아직 하위 리블렛이 무엇을 요청할 수 있는 지를 모른다.

<br>

따라서, 현재 `interactor`가 하위 `interactor`의 요청을 처리할 수 있도록 

같은 파일내에 존재하는 `RootInteractable` 또한 프로토콜을 추가해줘야한다.

<img src="/assets/images/2022-03-02/img-4.png" style="zoom:40%;" />

<br>

다시 `attachLoggedOut()` 메소드로 돌아가서 아래 코드를 추가 해주자

```swift
attachChild(router)
loggedOutRouting = router
```

<br>

`attachChild`는 이전편에서 본 것과 같이 몇가지 로직이 수행된다.  

이때, `interactor`도 활성화가 된다는 정도만 알면 될 듯 하다.

<br>

그리고 나중에 `detach`할 경우를 대비해, 

아까 만들어둔 `loggedOutRouting`를 `router`로 초기화 해주자.

<br>

보험처리로 이미 `attach` 되어 있는데 또 하면 안되니깐

안전 장치 하나 마련해주고 나면 전체 코드는 다음과 같다.

```swift
func attachLoggedOut() {
    // 안전 장치
    guard loggedOutRouting == nil else { return }
    
    let router = loggedOutBuildable.build(withListener: interactor)
    
    attachChild(router)
    loggedOutRouting = router
}
```

<br>

사실 여기까지는 하위 리블렛을 붙여서 활성화 하기까지의 과정이었다.

이제부터는 어떻게 화면을 쓸 것인지를 결정하면 된다!

`present`하던지 `navigation`에 `push`하던지 

`navigation`이 없다면 `navigation`으로 감싸서 `present` 하던지 등등...

<br>

하지만, 여기서 Tutorial의 불편한 점이 나온다.

프로토콜 `RootViewControllable` 안에 `present`, `dismiss`를 넣어주고,

이를 `RootViewController`에서 구현을 하여, 

`router`가 `viewController`에게 명령을 내리는 식으로 작성되어 있다.

<br>

각각의 리블렛마다 그것을 구현하기엔 너무나도 불편했다

<br>

그래서 다른 사람들은 아래 코드처럼

`extension`을 이용해서 이를 해소했다.

```swift
public extension ViewControllable {
    
    func present(_ viewControllable: ViewControllable, animated: Bool, completion: (() -> Void)?) {
        self.uiviewController.present(viewControllable.uiviewController, animated: animated, completion: completion)
    }

    func dismiss(completion: (() -> Void)?) {
        self.uiviewController.dismiss(animated: true, completion: completion)
    }
}
```

<br>

이제 우리는 이 추가된 메소드를 통해서 호출을 할것이다.

그러면 화면 전환까지 추가된 전체 코드는 다음과 같다.

```swift
func attachLoggedOut() {
    guard loggedOutRouting == nil else { return }
    
    let router = loggedOutBuildable.build(withListener: interactor)
    
    attachChild(router)
    loggedOutRouting = router
    
    // 추가된 화면 전환 코드
    viewControllable.present(
        router.viewControllable,
        animated: true,
        completion: nil
    )
}
```

아 너무 힘들었다.

뷰컨하나 `present`하기에 대한 설명이 이토록 길다니!!

<br>

실행 해보자.

<img src="/assets/images/2022-03-02/img-5.png" style="zoom:40%;" />

<br>

이런 화면이 나와도 놀라지 말자

`LoggedOutViewController`의 백그라운드 컬러가 없는 것이다.

아래 코드를 뷰컨에 추가 해주자.

<br>

```swift
// In LoggedOutViewController
init() {
    super.init(nibName: nil, bundle: nil)
    setUI()
}

required init?(coder: NSCoder) {
    super.init(coder: coder)
    setUI()
}

private func setUI() {
    view.backgroundColor = .systemPink
}
```

<br>

<img src="/assets/images/2022-03-02/img-6.png" style="zoom:40%;" />

이제 나온다. 핑크 화면!!

<br>
<br>

# 마무리

<br>

뷰컨 하나를 띄우기 위해서 기존 대비 정말 많은 일을 해야한다. 

하지만 중간에 썼던 것처럼 각각의 요소가 할 일이 잘 나뉘어져 있는 것이 포인트이다.

<br>

다음편에서는 `Component`가 실제로 사용되는 리블렛을 붙일 예정이다.

`LoggedOut`에 입력받을 UI도 그때 추가가 맞다 판단되어,

UI도 다음편에 꾸밀 예정!


