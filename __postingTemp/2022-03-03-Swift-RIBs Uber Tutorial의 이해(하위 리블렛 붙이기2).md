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
