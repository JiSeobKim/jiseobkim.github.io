---
layout: post

title: "(RIBs) Uber/Tutorial의 이해 (하위 리블렛 붙이기) (With Component)"

categories: [Architeture]

---

<br>

요즘 열심히 했더니 깃헙 잔디밭이 잘 자라고 있다.

연속으로 채워졌더니 중간에 비면 마음 아플거 같아서 

더 하게 되는 좋은 효과가 나타나는 중!

<br>

[이전 편](https://jiseobkim.github.io/architeture/2022/03/02/Swift-RIBs-Uber-Tutorial의-이해(하위-리블렛-붙이기).html) 에서는 `Component`를 신경 쓸 필요 없는 단순한 화면 붙이기를 하였다.

이번 편에서는 화면 전환시 `Component`를 신경써야할 부분을 다룰 예정!

<br>
<br>

# 포인트

<br>

- 화면을 떼는것 (Detach)을 해보기

- 이전편 화면 전환은 `Router`는 중점으로 다뤘으니 이번엔 `Component`에 초점을 맞추자.


<br>

# 결과 화면

<br>

전체 구조는 다음과 같다.

<img src="/assets/images/2022-03-03/img.png" style="zoom:40%;" />

<br>

이전 `LoggedOut` 화면은 입력을 받기 위해 다음과 같이 구성된다.

<img src="/assets/images/2022-03-03/img-1.png" style="zoom:40%;" />

<br>

이번에 추가될 `OffGame` 화면은 다음과 같다.

<img src="/assets/images/2022-03-03/img-2.png" style="zoom:40%;" />

<br>

로직은

1. 사용자가 두개의 플레이어 네임 입력후 `Enter`를 누른다.
2. `LoggedOut`은 `Detach` 된다.
3. `OffGame`은 `Attach` 된다.

<br>

여기서 우버 튜토리얼과 다른 점은 `ViewLess` 특징을 갖는 `LoggedIn`이 없다.

그 이유는 `Component`에 조금 더 초점을 맞추고 싶었기 때문이다.

<br>

그리고 `ViewLess`는 별도로 포스팅을 할 예정!

<br>
<br>

# LoggedIn UI 구성

전에는 핑크 핑크 화면만 띄우고 끝났다.

이번엔 간단하게 `TextField` 2개, `Button` 1개 넣었다.

<br>

하지만, UI 그리는데에 시간 낭비를 막기 위해 뷰컨의 풀코드 공유

```swift
final class LoggedOutViewController: UIViewController, LoggedOutPresentable, LoggedOutViewControllable {

    weak var listener: LoggedOutPresentableListener?
    
    private let firstTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Player 1"
        field.borderStyle = .roundedRect
        field.font = .systemFont(ofSize: 20, weight: .semibold)
        return field
    }()
    
    private let secondTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Player 2"
        field.borderStyle = .roundedRect
        field.font = .systemFont(ofSize: 20, weight: .semibold)
        return field
    }()
    
    private lazy var enterButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .systemCyan
        btn.setTitle("Enter", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 30, weight: .bold)
        btn.addTarget(self, action: #selector(enterAction), for: .touchUpInside)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 12
        btn.layer.cornerCurve = .continuous
        return btn
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .fill
        stack.spacing = 20
        return stack
    }()
    
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
        
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(firstTextField)
        stackView.addArrangedSubview(secondTextField)
        stackView.addArrangedSubview(enterButton)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            firstTextField.heightAnchor.constraint(equalToConstant: 40),
            secondTextField.heightAnchor.constraint(equalToConstant: 40),
            enterButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc
    func enterAction() {
        print("탭탭탭 엔터 탭")
    }
}

```

<br> 

따로 링크를 걸까도 했지만, 이게 나은 듯하다.

<br>

그럼 이제 버튼을 누르면 콘솔창에 프린터문 하나가 찍힐 것이다.

<br>
<br>

# OffGame이 필요한 것

<br>

`OffGame`은 게임의 결과 화면이라고 보면 좋을 듯하다.

예상 구성은 다음과 같다.

1. Player 1 & 2의 이름
2. Player 1 & 2의 결과 점수

<br>

최대한 튜토리얼과 비슷하게 간다면,

이름과 점수의 데이터는 구분을 지어둔다.

<br>

이름은 한번 입력하고 나면 변하지 않는 고정 값이다.

하지만 점수는 게임에 따라 변동이 일어나는 값이다.

<br>

그렇다면 이름은 `String`이면 충분할 듯 하다.

점수는 변동이 있기 때문에 `RxSwift`의 `BehaviorRelay`가 적당할 듯 하다.

<br>

그렇다면, 우선 아래 사진처럼 만들어두자

<img src="/assets/images/2022-03-03/img-3.png" style="zoom:40%;" />

<br>
<br>

# 필요한 것은 Component에 정의

<br>

위에서 말한 필요 정보들을 명시해줄 차례이다.

`OffGameBuilder.swift`에 가보면 `OffGameComponent`가 있다.

<br>

여기에 이 정보들을 적어준다.

```swift
final class OffGameComponent: Component<OffGameDependency> {
    fileprivate var player1Name: String
    fileprivate var player2Name: String
    fileprivate var score: BehaviorRelay<GameScore>
    
    init(
        player1Name: String,
        player2Name: String,
        dependency: OffGameDependency
    ) {
        self.player1Name = player1Name
        self.player2Name = player2Name
        self.score = .init(value: GameScore(player1Score: 0, player2Score: 0))
        super.init(dependency: dependency)
    }
}
```

<br>

위에서 말한것 처럼 고정 값 `String` 2개, 변동 값 `BehaviorRelay` 1개 선언 해주었다.

> 해당 프로퍼티들은 하위 리블렛이 참고할 일도 없다. 따라서 이 파일만 쓰이면 되므로 `filePrivate` 접근제어자 사용

<br>

그러면 이제 아래 이미지처럼 `Component`를 생성하는 곳에서 에러가 하나 생겼을 것이다.

<img src="/assets/images/2022-03-03/img-4.png" style="zoom:40%;" />

<br>

이 필요 값들은 `OffGame`이 생성되는 당시에 받아와서 초기화 해주는게 맞다.

따라서, `build` 메소드 관련 프로토콜과 구현부를 수정해주자


```swift
protocol OffGameBuildable: Buildable {
    // 수정 전
    func build(withListener listener: OffGameListener) -> OffGameRouting
    // 수정 후
    func build(withListener listener: OffGameListener, player1: String, player2: String) -> OffGameRouting
}
```

<br>

그리고 이를 따르는 구현체도 수정을 해준다.

```swift



func build(withListener listener: OffGameListener, player1: String, player2: String) -> OffGameRouting {
    // 변경 전
    let component = OffGameComponent(dependency: dependency)
    
    // 변경 후
    let component = OffGameComponent(dependency: dependency, player1Name: player1, player2Name: player2)
    
    // 아래는 생략
}
```

<br>

그럼 이제 한가지 고민을 할 수 있다.

추가한 `String` 2개와 `BehaviorRelay`를 누가 가지고 있을 것인가?

<br>

사실, 죄다 `Interactor`에 넣고 `Interactor`에서 쓰던지 `VC`에게 넘기던지 할 수있다.

그치만, 하다보니 튜토리얼처럼 화면 고정 값 같은 것들은

`ViewController`에 바로 넘기는 것도 좋다고 생각이 되었다.

<br>

바뀔 일이 없다면, 굳이 `Interactor` 거쳐서 `Presentor`에 메소드를 추가해서 `View`로 전달 하느니

`Builder`에서 바로 `View`로 넘기는 것도 좋다 판단 되었다.

<br>

그래서 우선 `OffGameViewController`로 이동해서 초기화 구문과 UI셋팅 부분을 작성해주자.

```swift
final class OffGameViewController: UIViewController, OffGamePresentable, OffGameViewControllable {

    weak var listener: OffGamePresentableListener?
    
    private let player1Name: String
    private let player2Name: String
    
    init(
        player1Name: String,
        player2Name: String
    ) {
        self.player1Name = player1Name
        self.player2Name = player2Name
        super.init(nibName: nil, bundle: nil)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setUI() {
        view.backgroundColor = .systemOrange
    }
}
```

<br>

그럼, 초기화 부분에 `String`을 2개 받게 해두었으니, 

다시 `Builder`로 돌아가서 초기화할때 값을 할당해주자

```swift
// OffGameBuilder Class
// In build Method

// 변경 전
let viewController = OffGameViewController()

// 변경 후
let viewController = OffGameViewController(
    player1Name: component.player1Name,
    player2Name: component.player2Name
)
```

<br>

그리고, 다른 프로퍼티 `BehaivorRelay` 타입의 변동 가능한 값이고 

`score`는 여러 조건이 붙을 수도 있으니 `Interactor`가 적당해보인다.

<br>

따라서, `OffGameInteractor`의` `init`도 수정해주자

```swift
// 변경 전
override init(presenter: OffGamePresentable) {
    super.init(presenter: presenter)
    presenter.listener = self
}

// 변경 후
import RxRelay

private let score: BehaviorRelay<GameScore>

init(
    presenter: OffGamePresentable,
    score: BehaviorRelay<GameScore>
) {
    self.score = score
    super.init(presenter: presenter)
    presenter.listener = self
}
```

<br>

사실 여기서는 구독만 하면 되기 때문에 `Observable`이면 충분하고

굳이 `BehaivorRelay`로 받을 필요는 없지만,,,

설명이 너무 길어지니..... Pass...

<br>

그럼 이제 빌드하면 에러가 나고 어디서 날지는 감이 점점 온다.

`Builder`로 가서 수정해주자

```swift
// In OffGameBuilder class

func build(withListener listener: OffGameListener, player1: String, player2: String) -> OffGameRouting {
    
    let component = OffGameComponent(dependency: dependency, player1Name: player1, player2Name: player2)
    // ... 중간 생략
    
    // 변경 전
    let interactor = OffGameInteractor(presenter: viewController)
 
    // 변경 후
    let interactor = OffGameInteractor(
        presenter: viewController,
        score: component.score
    )
    
    // .. 여기도 생략...
}
```

<br>

이제 에러는 안나지만 지금 여기까지 한김에 `Interactor` 넘어온 `score`를 구독해서

값 방출시 `viewController`에게 전달하는 코드도 짜놓자.


<br>

같은 `OffGameInteractor.swift` 파일을 보면 `OffGamePresentable`가 있다.

이것은 `OffGameViewController`가 준수하고 있다.

<br>

그러므로, 저 프로토콜에 메소드를 만든다면 뷰컨트롤러는 이를 지켜야한다.

<br>

이 점을 이용해서 방출된 값을 업데이트 해주도록 하자.

아래 코드를 추가

```swift
protocol OffGamePresentable: Presentable {
    var listener: OffGamePresentableListener? { get set }
    
    // 추가
    func updateScore(playerScore1: String, playerScore2: String)
    
}
```

<br>

그리고 이제 `Interactor`가 활성화되면 구독을 할 수 있도록

`didBecomeActive()` 또한 수정해주자.

```swift
override func didBecomeActive() {
    super.didBecomeActive()
    
    score
        .observe(on: MainScheduler.instance)
        .subscribe(onNext: { score in
            let score1 = String(score.player1Score)
            let score2 = String(score.player2Score)
            
            self.presenter.updateScore(playerScore1: score1, playerScore2: score2)
            
        }).disposeOnDeactivate(interactor: self)
}
```

<br>

여기서 재밌는 점이있다. 

`RxSwift`를 쓰면 항상 `DisposeBag`을 만들어줬는데,

자체적으로 이미 다 구현이 되어있어서 저렇게 메소드를 이용하여

쉽게 처리할 수 있다.

<br>

그럼, `OffGameViewController`의 오류만 잡기 위해 우선 빈 메소드로 두자

```swift
// In OffGameViewController
func updateScore(playerScore1: String, playerScore2: String) {
    // 이따가 채우기
}
``` 

<br>

UI는 안만들었지만, `score` 방출시 `Interactor`는 `View`에게 새로운 값을 넘겨주도록 완성 됐다.

이제 `Root` 하위에 있던 `LoggedOut`의 `Enter`버튼을 눌렀을때

`LoggedOut`을 제거하고 `OffGame`을 띄워보도록하자

<br>
<br>


# LoggedOut Enter 버튼 처리

<br>

로직은 다음과 같다.

1. `Ènter` 터치
2. `Interactor`에게 `TextField` 두개의 입력된 값 전달

<br>

2번을 하기 위해서 `Interactor`에게 전달할 수 있도록 

같은 파일 내에 존재하는 `LoggedOutPresentableListener`에 메소드를 추가하자.

```swift
protocol LoggedOutPresentableListener: AnyObject {
    func didTapEnter(player1: String?, player2: String?)
}
```

<br>

이렇게 해두면 전달해줄 수 있다.

<br>

여담으로 직접적으로 `Interactor`라 안쓰고 `Listener`라 쓰는 것은

RIBs 가이드에 보면 아래 사진처럼 실제로는 `View`와 `Interactor` 사이에

`Presenter`가 존재하므로 `PresentableListener`라는 표현을 쓰는듯 하였다.

<img src="/assets/images/2022-03-03/img-5.png" style="zoom:40%;" />

(이미지 출처: [RIBs Github](https://github.com/uber/RIBs/wiki))

<br>

그럼 이제 실제 버튼 탭 되었을때 액션을 정의해주자

```swift
@objc
func enterAction() {
    let player1Text = firstTextField.text
    let player2Text = secondTextField.text
    
    listener?.didTapEnter(player1: player1Text, player2: player2Text)
}
```

<br>

그리고 빌드를 해보면 에러가 날텐데

`LoggedOutInteractor`로 이동해서 프로토콜에 적었던 메소드를 구현해주자.
 
> 프로토콜은 이게 너무 좋다. 구현은 조금 나중에 하더라도

> 현재 화면에서는 코드를 계속 짤 수 있으니깐 !
 

<br>

```swift
// 
// in LoggedOutInteractor of LoggedOutInteractor.swift
func didTapEnter(player1: String?, player2: String?) {
    
}
```

위의 메소드를 만들어주고 나면 이제 해야할 일은 무엇일까?

<br>

현재는 `LoggedOut`의 `Interactor`이다.


`LoggedOut`을 띄운 `Root`의 `Router`한테 `LoggedOut`을 닫아달라고 해야할까?

<br>

아니다

닫아 달라고 명령하는 것은 `Router`의 역할이고 

`Router`에게 명령을 하는 것은 `Interactor`가 할 일이다.

<br>

다른 리블렛끼리 상호작용을 하는 것은 `Interactor`의 몫이다.

`LoggedOutInteractor`는 `RootÌnteractor`에게

입력을 받았다고 정도만 알려주면 된다.

<br>

그럼 `RootInteractor`가 `RootRouter`에게 

"오케이, 입력했으니깐 `LoggedOut`닫고 `OffGame` 띄워!"

라고 해야한다.

<br>

> 문서를 보니 다음과 같이 써있었다. 

> 상위 리블렛 to 하위 리블렛: 스트림 이용,

> 하위 리블렛 to 상위 리블렛: 리스너의 인터페이스 이용

<br>

그럼 `RootInteractor`에게 액션을 전달 할 수 있게 다음과 같이 코드를 추가하자

```swift
// In LoggedOutInteractor.swift

protocol LoggedOutListener: AnyObject {
    func loggedOutDidTapEnter(player1: String, player2: String)
}
```

<br>


네이밍은 몇가지 방식을 보았지만 

위와 같이 `어디서` + `무엇을` 형식으로 

위 코드와 같이 작명을 하였을 경우, 보기가 더 좋았던 것 같다.

<br>

그러면 아까 공백이었던 메소드를 채워주자 

```swift
// In LoggedOutInteractor Class

func didTapEnter(player1: String?, player2: String?) {
    // 옵셔널 제거
    let name1 = (player1 == nil || player1?.isEmpty == true) ? "Player 1" :  player1!
    let name2 = (player2 == nil || player2?.isEmpty == true) ? "Player 2" :  player2!
    
    listener?.loggedOutDidTapEnter(player1: name1, player2: name2)
}
```

<br>

이제 또 빌드 해주면 에러가 난다.

`RootInteractor`에 메소드를 구현 안해줬기 때문이다!

<br>

드디어 `Root`쪽으로 넘어간다..

<br>
<br>


# Detach

<br>


`RootInteractor`에 에러를 없애기 위해 프로토콜에 적었던 메소드를 구현해주자.

```swift
func loggedOutDidTapEnter(player1: String, player2: String) {
    
}
```

<br> 

여기엔 무슨 내용이 들어가야할까?

"붙였던 `LoggedOut`을 제거하고 `OffGame`을 붙여!"

<br>

하지만, 튜토리얼에 있는 메소드명은 제거하라는 뉘앙스가 없다.

그래서 좀더 명확히 하기 위해, `router`에게 내리는 명령을 두가지로 나눠보자

```swift
protocol RootRouting: ViewableRouting {
    // 기존에 있던 시그니처
    func attachLoggedOut()
    
    // 추가된 시그니처
    func detachLoggedOut()
    func attachOffGame(player1: String, player2: String)
}
```

<br>

그러면 아까 비워있던 메소드를 채워보자


```swift
func loggedOutDidTapEnter(player1: String, player2: String) {
    router?.detachLoggedOut()
    router?.attachOffGame(player1: player1, player2: player2)
}
```

<br> 

이렇게 짜두면 이해가 조금 더 쉬울 것이라 예상된다.

메소드를 파악할때

메소드 명을 보고는 `LoggedOut에서 엔터 눌렀을때 이름 정보를 받는 메소드임을 알 수 있고,

실행되는 코드는 `LoggedOut`을 제거하고 `OffGame`을 파라미터 넘겨주면서 띄우라는 것을 알 수있다.

<br>

여기서 중요한건 의존성 주입이 이뤄지기 위해선 이런식으로 진행이 되어야한다는 점을

다시 한번 상기하고

`Router`로 이동해 계속 해보자

<br>

`RootRouter`에 위의 메소드들을 만들어준다.

<br>

```swift
// In RootRouter Class

func detachLoggedOut() {
    guard let router = loggedOutRouting else { return }
    
    detachChild(router)
    viewController.dismiss(completion: nil)
    loggedOutRouting = nil
}

func attachOffGame(player1: String, player2: String) {
    
}
```

`attach`는 조금 후에 보고, `detach`의 코드는 위와 같다.

어려울 것 없다!

`detach`해주고 `viewController` 닫아 주었고, 저장해두었던 값을 날렸다.

<br>

이 상태로 앱 실행 후 `Enter`를 눌러보자.

그럼 핑크 화면이 닫히고 민트 화면이 나오는 것을 볼 수 있다.

<br>

`Detach`는 잘 되었다. 그럼 이제 `attach`차례!

<br>
<br>

# Attach

<br>

지난편에 상세히 다뤘기 때문에 간단히 보면

`buildable` & `routing 프로퍼티를 선언해주고

```swift
private let offGameBuildable: OffGameBuildable
private var offgameRouting: Routing?
```

<br>

초기화 구문 수정해주고

```swift
init(
    interactor: RootInteractable,
    viewController: RootViewControllable,
    loggedOutBuildable: LoggedOutBuildable,
    offGameBuildable: OffGameBuildable
) {
    self.offGameBuildable = offGameBuildable
    self.loggedOutBuildable = loggedOutBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
}
```

<br>

`attach` 메소드 수정해주고

```swift
func attachOffGame(player1: String, player2: String) {
    guard offgameRouting == nil else { return }
    
    // 현재는 withListener의 interactor를 넣으면 오류난다
    let router = offGameBuildable.build(withListener: interactor, player1: player1, player2: player2)
    offgameRouting = router
    attachChild(router)
    viewControllable.present(router.viewControllable, animated: true, completion: nil)
}
```

<br>

위의 주석처럼 현재는 `interactor` 넣으면 에러가 나기 때문에 아래처럼 `RootInteractable`을 수정해주면 에러는 사라진다.

```swift
// 변경전
protocol RootInteractable: Interactable, LoggedOutListener

// 변경후
protocol RootInteractable: Interactable, LoggedOutListener, OffGameListener
```

<br>

그리고 마지막으로 `Router`를 초기화 했던 `Builder`를 수정해준다.

```swift
func build() -> LaunchRouting {
    
    // 위는 생략..
    
    // component를 넣으면 현재는 오류난다.
    let offGameBuilder = OffGameBuilder(dependency: component)
    
    return RootRouter(
        interactor: interactor,
        viewController: viewController,
        loggedOutBuildable: loggedOutBuilder,
        offGameBuildable: offGameBuilder
    )
}
```

<br>

주석처럼 `component`를 넣게되면 `component`가 `OffGame`의 `Depedency`를 준수하지 않기 때문에 오류가 난다.

그래서 아래처럼 수정

```swift
// 수정 전
final class RootComponent: Component<RootDependency>, LoggedOutDependency

// 수정 후
final class RootComponent: Component<RootDependency>, LoggedOutDependency, OffGameDependency

```

<br>

실행해보자

<img src="/assets/images/2022-03-03/gif.gif" style="zoom:40%;" />


<br>

드디어...!

후....... ㅠ

<br>

끝이 보인다.

데이터들을 뿌려주기 위해 `OffGameViewController`의 UI를 짜보자.

<br>


긁어가기 쉽게 코드로 짰다.

```swift
final class OffGameViewController: UIViewController, OffGamePresentable, OffGameViewControllable {

    weak var listener: OffGamePresentableListener?
    
    private let player1Name: String
    private let player2Name: String
    
    private let player1Label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 40, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let player2Label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 40, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private lazy var playButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("PLAY", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 50, weight: .bold)
        btn.backgroundColor = .systemCyan
        btn.layer.cornerRadius = 12
        btn.layer.cornerCurve = .continuous
        btn.addTarget(self, action: #selector(playAction), for: .touchUpInside)
        return btn
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .fill
        stack.spacing = 20
        return stack
    }()
    
    init(
        player1Name: String,
        player2Name: String
    ) {
        self.player1Name = player1Name
        self.player2Name = player2Name
        super.init(nibName: nil, bundle: nil)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setUI() {
        view.backgroundColor = .systemOrange
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(player1Label)
        stackView.addArrangedSubview(player2Label)
        stackView.addArrangedSubview(playButton)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            player1Label.heightAnchor.constraint(equalToConstant: 50),
            player2Label.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    func updateScore(playerScore1: String, playerScore2: String) {
        let player1Text = "\(player1Name) : \(playerScore1)"
        let player2Text = "\(player2Name) : \(playerScore2)"
        
        player1Label.text = player1Text
        player2Label.text = player2Text
    }
    
    @objc
    private func playAction() {
        print("플레이는 다음에!!")
    }
}
```

<br>

그러면 다음과 같은 화면이 나올 것이다.

<img src="/assets/images/2022-03-03/img-2.png" style="zoom:40%;" />

<br>

`LoggedOut`에서 받은 값을 이용해서 `OffGame`이라는 것을 만들었다.

글의 중점은 다시 한번 얘기히자면!

하위 리블렛을 붙이면서 `Component`를 이용하려 했다는 점을 잊지말자.

<br>
<br>

# 마무리

<br>

진짜 튜토리얼이 왜이렇게 생략을 많이 했는지 알 것 같았다...

하 중간에 생략을 나도 어느정도 할까 하다가

<br>

혹여나 튜토리얼 이해 안되는 개발자가 이 글을 읽었을 때, 

똑같이 뭐야 왜 생략됐어 ㅠ

하고 다른 글을 찾아 가는 일을 방지하고자... 길지만 써봤다....



