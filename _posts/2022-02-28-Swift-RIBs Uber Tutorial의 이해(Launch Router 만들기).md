---
layout: post

title: "(RIBs) Uber/Tutorial의 이해 (Launch Router 만들기)"

categories: [Architeture]

---

<br>

`Tutorial`을 따라하고, 

"프로젝트 생성부터 다시 해봐야지!" 

라고 생각해본 사람들은 다음과 같이 생각 해봤을 것이라 예상된다.

<br>

"시작 어떻게 하지?"

<br>
<br>

### 글의 목적

우버의 튜토리얼은 도움이 많이 되었다. 

하지만 아무리 생각해도 생략된게 많다고 생각이 된다.

<br>

그래서 그 생략된 부분들을 글로 적어서

조금 더 이해를 돕기 위해 쓰기로 했다.

<br>
<br>

### 글의 순서

1. Launch Router 생성 (Root)
2. Root에 텍스트 필드 2개 만들기 (유저 네임 2개 입력 받기)

(Project 생성과 RIBs 설치는 생략!)

<br>
<br>

### 초기 설정 제거

기본적으로 프로젝트를 생성하면 

`Main.storyboard`와 `ViewController`가 있고

셋팅 또한 저 두개로 되어있어서

앱 실행시 빈 화면이 뜨게 된다.

<br>

하지만 우리는 `RIBs`를 쓰고 싶다.

<br>

초기 셋팅을 제거하자

<br>

**Info.plist 에서 StoryBoard Name 제거**

`Scene Delegate`가 생긴 이후로 `plist` 파일도 구성이 달라졌다.

이에 따라 아래 사진에 `-`버튼을 눌러 해당 부분을 지워버리자. 우린 코드로 짤거다.

<img src="/assets/images/2022-02-28/img.png" style="zoom:40%;" />


<br>

**Target에 Main Interface 제거**

<img src="/assets/images/2022-02-28/img-1.png" style="zoom:40%;" />

빨간 부분에 `Main`이라고 적혀있는 부분 또한 제거 해주자.

<br>

이제 실행하면 까만 화면이 나올 것이다.

<br>
<br>

### Root 리블렛 생성

RIBs를 설치 했지만, 각 요소들을 일일히 생성하는건 매우 귀찮을테고, 쉽지도 않을 것이다.

<br>

그래서 우버는 멋지게도 간단하게 생성할 수 있도록 해주었다.

튜토리얼 받은 파일에 `ios/tooling/`의 경로로 들어가보면 

`install-xcode-template.sh` 라는 파일이 있을 것이다. 

<br>

터미널로 해당 폴더로 이동한 후에 다음 명령어 실행

`sh install-xcode-template.sh`


<br> 

이제 `Xcode`에서 `Command + n`을 해보면 아래 사진과 같이 빨간 부분이 생겼을 것이다.


<img src="/assets/images/2022-02-28/img-2.png" style="zoom:40%;" />


<br>

`RIB`을 선택 후 `Next`

그 다음은 아래 사진처럼 `Root`라고 입력 후 `Next`


<img src="/assets/images/2022-02-28/img-3.png" style="zoom:40%;" />

<br>

여기서 살짝 위사진에 체크 박스 설명을 하자면,

`RIBs`는 `ViewLess`가 가능하다.

<br>

즉, `ViewController` 처럼 `View`는 없지만, 

비즈니스 로직을 가지고 (interactor),

그 로직에 따라 필요한 화면 전환이 가능하다 (Router) 

<br>

첫번째의 체크 요소는 위에 설명처럼 `ViewLess`에 대해 여부다.

첫번째가 체크 되어있다면, 코드로도 화면을 짤 수 있지만

`XIB`, `Storyboard`으로도 화면 구성을 하고 싶다면 필요에 맞게 체크하면 된다.

<br>


그럼 `Root` 라는 폴더를 만들고 그 안에 생성을 했다면 다음과 같은 모습일 것이다.

<img src="/assets/images/2022-02-28/img-4.png" style="zoom:40%;" />

<br>

<br>

### SceneDelegate에서 RootViewController 설정?

`SceneDelegate`에서 `RootViewController` 설정을 위해서 다음과 같이 코드를 짰을 것이다.

```swift
var window: UIWindow?

func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
    guard let scene = (scene as? UIWindowScene) else { return }
    
    let window = UIWindow(windowScene: scene)
    self.window = window
    
    // 1. Root 설정
    window.rootViewController = UIViewController()
}
```

<br>
    
그치만 우리는 만든 `Root` 리블렛을 이용해서 화면을 붙여야하므로

내 생각의 흐름은 이랬다.

<br>

**그래 builder를 우선 만들자**

```swift
let rootBuilder = RootBuilder(dependency: ??)
```

<br> 

시작과 동시에 막혔다.

`dependency`에 보통 `component`를 넣어줬었는데, 여기서 뭘 넣어야해..?

주입 받을 것도 없어서 안넣어도 되는데, `nil`도 안된다. 

> component가 뭔지 몰라도 된다. 해당 리블렛에서 쓰일 객체들을 모아둔 주머니 정도로 생각하자.

<br> 


**필요한 것은 비어있는 Component**

nil은 안되지만 아무것도 없는 비어있는 `Component`를 생성해줘야 한다.

`swift` 파일 하나 만들자. 파일 이름은 튜토리얼을 따라 `AppComponent`.

<br>

```swift
import RIBs
 
class AppComponent: Component<EmptyComponent> {
    
    init() {
        // 1. 비어있는 Component 생성 
        let emptyComponent = EmptyComponent()
        super.init(dependency: emptyComponent)
    }
}
```

위의 코드를 보면 `Component`를 상속 받는다. 

`<>`안에는 `DependencyType`을 넣어줘야하는데,

비어있는 것을 만들어야하니깐 `EmptyComponent`라는 타입을 넣어주겠다고 명시해준다.


<br>

** 생성한 AppComponent를 넣어준다.**

다시 `SceneDelegate`로 돌아가 막혔던 부분을 채워준다.

<img src="/assets/images/2022-02-28/img-5.png" style="zoom:40%;" />

<br>

오류난다! `AppComponent`가 `RootDependency`를 따르지 않는다고...

하 빈것 하나 만드는것도 쉽지 않다고 생각이 들었다.

<br>


아래 코드처럼 `AppComponent` 클래스로 돌아가 해당의 것을 준수하도록 추가해준다.

```swift
class AppComponent: Component<EmptyComponent>, RootDependency
```


<br>

**builder로부터 router를 생성한다.**

```swift
let router = rootBuilder.build(withListener: ??)
```

빌드하려면 `listener`를 넣으란다. 

> 이 listener는 상위의 인터렉터와 상호작용을 하기 위해 사용된다.

<br>

근데, 여긴 `Root`다 더 상위 리블렛이 없다.

<br>

따라서, `Builder`로 이동해서 없애버리자.

```swift
// 변경 전
protocol RootBuildable: Buildable {
    func build(withListener listener: RootListener) -> RootRouting
}

// 변경 후
protocol RootBuildable: Buildable {
    func build() -> RootRouting
}
```

<br>

위에 것은 protocol이므로 이것을 따르는 `Builder`도 수정해야한다.

```swift
// 변경 전
func build(withListener listener: RootListener) -> RootRouting {
    let component = RootComponent(dependency: dependency)
    let viewController = RootViewController()
    let interactor = RootInteractor(presenter: viewController)
    interactor.listener = listener
    return RootRouter(interactor: interactor, viewController: viewController)
}

// 변경 후
func build() -> RootRouting {
    let component = RootComponent(dependency: dependency)
    let viewController = RootViewController()
    let interactor = RootInteractor(presenter: viewController)
    // listener 제거
    return RootRouter(interactor: interactor, viewController: viewController)
}
```

<br>

위에 코드처럼 바꿔주면 입력 파라미터 `listener`도 사라지기 때문에

위에 주석처럼 `interactor.listener = listener` 또한 제거 되어야한다.

<br>

이제 `router`를 다시 만들수 있을 것 같다.

```swift
let router = rootBuilder.build()
```

`Router`를 간단히 설명하면 화면 전환을 담당하며, 해당 `ViewController` 또한 가지고 있다.

근데 위에 `Builder`는 `RootRouting`을 반환한다. (Router다)

<br>

그렇다면 `Router`로 부터 `ViewController`를 꺼내서 `RootViewController`로 쓰자!

```swift
let component = AppComponent()
let rootBuilder = RootBuilder(dependency: component)

let router = rootBuilder.build()
let vc = router.viewControllable.uiviewController

window.rootViewController = vc
window.makeKeyAndVisible()
```

이렇게 하고 실행하면, 아래와 같은 에러 로그를 남기고 앱이 죽는다.

```
RIBs/LeakDetector.swift:102: Assertion failed: <<RIBs_Tutorial_Blog.RootViewController: 0x12271bd60>: 1633788724632257609> has leaked. Objects are expected to be deallocated at this time: NSMapTable {
[11] 1633788724632257609 -> <RIBs_Tutorial_Blog.RootViewController: 0x12271bd60>
}

2022-02-28 16:41:34.747920+0900 RIBs_Tutorial_Blog[24724:352936] RIBs/LeakDetector.swift:102: Assertion failed: <<RIBs_Tutorial_Blog.RootViewController: 0x12271bd60>: 1633788724632257609> has leaked. Objects are expected to be deallocated at this time: NSMapTable {
[11] 1633788724632257609 -> <RIBs_Tutorial_Blog.RootViewController: 0x12271bd60>
}
```

<br>

보통 이런건 해당 리블렛을 제거 했을 때, 메모리에 살아있어서 죽는다는 오류였다.

(이 부분은 조금더 공부가 필요한 부분...)

<br>

여기서도 많이 헤맸다.

왜 죽을까... 난 죽인적이 없다. 루트니까 계속 살려야한다.

<br>

그러다 생각해보니 `SceneDelegate`에서 생성된 `router`가 해당 메소드가 끝남과 동시에

메모리가 해제되어서 위와 같은 오류가 난듯하였다.

(이 부분은 조금더 공부가 필요한 부분...2)

<br>

그래서 `SceneDelegate`에 프로퍼티로 `router`를 가지고 있자 생각 해봤다.

```swift
// MARK: In SceneDelegate.swift

var window: UIWindow?

// 1. 해제되지 않도록 가지고 있을 프로퍼티
private var routing: RootRouting?

func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
    guard let scene = (scene as? UIWindowScene) else { return }
    
    let window = UIWindow(windowScene: scene)
    self.window = window
    
    let component = AppComponent()
    let rootBuilder = RootBuilder(dependency: component)
    
    let router = rootBuilder.build()
    
    // 2. router 생성 후 프로퍼티에 저장
    self.routing = router
    let vc = router.viewControllable.uiviewController
    
    window.rootViewController = vc
    window.makeKeyAndVisible()
}
```

<br>

이렇게 해주면 죽지 않는다.

<br>

그렇지만 화면이 검정이다.

<br>

`RootViewController`에 셋팅이 좀 필요하다. 

아래 코드 복붙하자

```swift
init() {
    super.init(nibName: nil, bundle: nil)
    setUI()
}

required init?(coder: NSCoder) {
    super.init(coder: coder)
    setUI()
}

private func setUI() {
    view.backgroundColor = .systemMint
}
```

그리고 실행하면 아래처럼 나온다.

<img src="/assets/images/2022-02-28/img-6.png" style="zoom:40%;" />


<br>

와 화면 보기까지 이렇게 어려운거였나 싶다.

글도 너무 길어졌다.

<br>

근데, 소름 돋게 끝이 아니다.

<br>

비즈니스 로직을 담당하는 `interactor`는 해당 리블렛을 붙이고 나면,

`didBecomeActive()`이라는 메소드가 실행이 된다.

<br>

그리고 이를 통해, 활성화 되었을때 이런 저런 처리를 한다.

<br>

근데, `RootInteractor`에 해당 메소드가 호출이 안된다.

<br>

여기서 3차 멘붕이 왔다.

<br>
<br>

**Root 리블렛 활성화**


튜토리얼을 해본 개발자라면 알겠지만 `Router`가 다른 리블렛을 띄우기 위해선

`attachChild`라는 메소드를 해줘야 한다.

이 부분이 안된듯 해서 해당 메소드를 보았다.

<br>

```swift
public final func attachChild(_ child: Routing) {
    assert(!(children.contains { $0 === child }), "Attempt to attach child: \(child), which is already attached to \(self).")

    children.append(child)

    // Activate child first before loading. Router usually attaches immutable children in didLoad.
    // We need to make sure the RIB is activated before letting it attach immutable children.
    
    // 1 여기
    child.interactable.activate()
    // 2 여기
    child.load()
}
```

음 딱 보니, 위 코드의 주석 1,2가 안된듯 했다.

`SceneDelegate`로 돌아가서 해주자.

<br>

```swift
func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
    // 기타 생략...
    
    let router = rootBuilder.build()
    self.routing = router
    let vc = router.viewControllable.uiviewController
    
    window.rootViewController = vc
    window.makeKeyAndVisible()
    
    // 추가 1
    router.interactable.activate()
    // 추가 2
    router.load()
    
}
```

<br>

위 코드처럼 1,2를 추가 해준 후 빌드를 해주면 

`RootInteractor`에 `didBecomeActive`이 실행 되는 것을 알 수 있다.

<img src="/assets/images/2022-02-28/img-7.png" style="zoom:40%;" />

<br>

후 이제야 정상적으로 동작한다....

<br>

아직 끝이 아니다. `LaunchRouter`가 안나왔다. 

`SceneDelegate`의 코드를 정리 해보자
