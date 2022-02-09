---
layout: post

title: "(Swift) Test Double이란 (부제- Mock, Stub, SPY 이런게 뭐지?)"

categories: [Swift]

---

글 제목 방식을 조금 바꿔 보기로 했다!

글을 쓰려했던 이유를 부제로 달기로!

<br>

본론으로 가보자

<br>

점점 TDD와 아키텍쳐에 관심을 갖다 보니 

어떤 자료에서 `Stub`과 `Mock`에 대한 얘기가 나와서

혼란이 왔다.

<br>

테스트를 진행하면서 테스트 대상(SUT)를 제외하곤 여기서 실제 객체로 쓸 필요 없으니

나머지 의존성은 가짜 객체로 꽂아 두는 그런게 `Mock`으로 알고 있었다.

<br>

하지만, 그렇지 않았다.

<br>

# Test Double

위에서 말한 것이 100% 틀리진 않았다.

하지만, 그것이 `Mock`일수도 아닐 수도 있었다.

<br>

이 역할과 국내에서 잘 매칭이 되는 단어는`스턴트맨`이다.

실제로 위험한 액션이 있을 경우 이 `스턴트맨`이 대신 해준다.

마치 내가 이해한 `Mock`과 찰떡이다.

<br>

이 단어는 해외에서 `Sturnt Double`이라고 한다.

<br>

그리고 이 글의 주제는 `Test Double`. 

이때부터 감이 서서히 왔다.

<br>

(아마??)스턴트 맨들도 다양한 분야가 있을 것이다. 자동차 액션 전문, 싸움 전문 등등

<br>

`Mock` 또한 마찬가지였다.

그저 `Test Double`의 종류 중 하나였던 것이다.

<br>

그 외에 종류들은 다음과 같다.

- Dummy
- Fake
- Stub
- Mock
- Stub

<br>

## Test Double은 왜 쓰는가?

다음에 대해서  OX를 생각해보자

- (전제) `ViewModel`이 `Repository(Network)`를 프로퍼티로 가지고 있다.

- `ViewModel` 테스트 코드를 작성할때, 실제 통신하는 `Respository`가 필요할까?

<br>

내 생각은 아니다, 

그 이유는 `Repository`는 `Repository Test`를 별도로 작성해서 

거기서 통신이 잘되는지 문제가 없는지 테스트를 작성하면 되고, 

`ViewModel`에선 할 필요가 없다 생각한다.

<br>

`ViewModel`을 테스트 하는데, 

현재 통신이 잘되는지, 와이파이가 잘 되는지, 실제 서버가 장애가 있는지를 고려할 필요가 없기 때문이다.

그러한 요소는 위에 말한 `Repsotiroy Test`에서 걸러질것이다.

<br>

즉, 현재 테스트 대상에 대해서만 집중하고 싶은 것이다.

<br>

위의 예시처럼 실제 객체를 대신해서 가짜 객체 역할을 하지만, 

그것들이 하는 것은 조금씩 다르다.

<br>

하지만, 

개발자끼리 실제 정확한 의사소통이 되기 위해서 그 역할별로 명칭을 쪼개었고,

그러다 보니 위에 말한 5가지로 구분이 된게 아닐까 싶다.

<br>

## Dummy

**아무것도 하지 않고, 단순히 자리만 채워줄뿐인 그런 역할.**

<br>

예를 들자,

`X`라는 객체를 초기화 할때 `A`라는 객체가 필요하다. 근데 `A`는 `B`, `C`라는 객체가 필요하다.

또 다른 `Y`라는 객체는 테스팅 하기 위해서 `B`, `C` 기능이 모두 구현이 필요하다.

근데, `X`는 실제 `C`의 기능에 영향을 받지 않는다.

그렇다면, `X`라는 것을 테스트 할때,

`A`를 구현하기 위해 `B`는 필요하지만 `C`라는 것의 실제 객체가 필요할까?

<br>

`C`처럼, 파라미터로써 어쩔 수 없이 채워야하지만 실제론 아무 역할을 하지 않는 것에 `Dummy`를 쓴다

<br>

## Fake

**실제 객체와 핵심 로직은 동일하게 작성 되어있다. 하지만, 다른 불필요 요소는 제거 되어있다.**

<br>

예를 들자, 

계산기 메소드 중 `sum`이라는게 있다.

이 `sum`은 호출 되었을때 `(a+b)` 값을 리턴하는게 목적이다.

근데, 실제 코드에선 `sum`에 대한 로그를 서버에 남기기 위해 통신을 하는 코드가 들어 갔다거나,

다른 객체에 전달을 하는 역할을 하는 코드도 들어 갔을 수도 있다.

<br>

하지만, 이것은 현재 불필요하다.

<br>

코드로써 다시 표현해보자.


```swift
protocol Calculator {
    func sum(x: Int, y: Int) -> Int
}
```

```swift
class CalculatorImp: Calculator {
    let b: Some
    let c: Some2

    init(b: Some, c: Some2) {
        self.b = b
        self.c = c
    }

    func sum(x: Int, y: Int) -> Int {
        // 불필요
        b.callMethod()
        b.callMethod2()
        b.callMethod3()
    
        // 불필요
        if x > 0 {
            c.callLogMethod()
        }
        
        // 핵심 코드
        let result = x + y
        return result
    }
}

```

<br>

주석과 같이 핵심 코드를 제외한 나머지는 불필요하다.

그렇담, 이렇게 간소화가 가능하다.

```swift
class CalculatorFake: Calculator {
    func sum(x: Int, y: Int) -> Int {
        let result = x + y
        return return
    }
}
```

<br>

이게 `Fake`다.

<br>

## Mock, SPY, Stub 설명의 전제 

`Mock`, `SPY`, `Stub`에 들어가기전에 

다음과 같은 전제를 공통으로 사용하므로 먼저 보자


```swift
// 1. 프린터 프로토콜
protocol Printer {
    func network(handler: @escaping (String) -> Void)
}

// 2. 프린터 구현체
class PrinterImp: Printer {
    
    // 2-1. 통신(예시를 위해 임의로 작성했습니다.)
    func network(handler: @escaping (String) -> Void) {
        let url = URL(string: "naver.com")!
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { data, response, error in
            // 어떤 액션들 블라 블라...
            guard
                let data = data,
                let result = String(data: data, encoding: .utf8)
            else {
                return
            }
            // handler 사용
            handler(result)
        }
        
        task.resume()
    }
}

// 3. 회사 Class, Printer, PrintedText를 프로퍼티로 갖고 있다.
class Company {
    var printer: Printer
    var printedText: String?
    
    init(printer: Printer) {
        self.printer = printer
    }
    
    // 3-1. 해당 메소드 실행시  
    func submit(complete: @escaping ()->Void) {
    
        // 3-2. `Printer`의 `network` 통해 통신 후
        printer.network(handler: { value in
            // 3-3. 출력된 결과를 프로퍼티로 갖고 있으며,
            self.printedText = value
            // 3-4. 클로져를 실행한다.
            complete()
        })
    }
}
```

<br>

간단하다. `Company`는 `Printer`를 프로퍼티로 갖고 있다.

`Company`의 `submit()`시 `Printer`의 `network()`를 동작하게 한다.

<br>

이후의 내용은 `Company`를 테스트한다는 전제하에 작성되었다.

<br>


### Stub

**가짜 객체지만 미리 지정한 가짜 결과 값을 되돌려줌으로써 나머지 동작을 진행 할 수 있도록 해준다.**

<br>

글 초입에 예시 부분에 해당 된다. `통신`를 이용하는 부분이 `Company` 테스트에 영향을 줄 필요는 없다.

단지 통신 코드처럼 어떠한 값을 콜백으로 돌려주면 된다.

<br>

그것을 코드로 구현하면 `Print Stub`은 다음과 같다.

```swift
class PrinterStub: Printer {
    
    // 1. 미리 돌려줄 값을 정해둔다.
    var handlerValue = "안녕 Stub?"
    
    func network(handler: @escaping (String) -> Void) {
        // 2. 실제 통신처럼 비동기로 클로저를 실행하도록 한다.
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            // 3. 미리 만들어둔 값을 돌려준다.
            handler(self.handlerValue)
        }
    }
}
```

`Printer` 프로토콜을 받고 있기 때문에, 구현을 해줘야한다.

<br>

그렇지만 주석처럼 실제 통신이 아닌 `GCD`를 이용하여, 

연기를 해준뒤 1초 뒤에 값을 돌려준다.

<br>

이것을 테스트 코드를 작성하면 다음과 같다.

<br>

```swift
class StubTests: XCTestCase {

    private var sut: TestDouble.Company!
    private var printerStub: TestDouble.PrinterStub!
    
    override func setUp() {
        // 1. PrintImp 대신 Stub을 이용한다
        printerStub = TestDouble.PrinterStub()
        sut = TestDouble.Company(printer: printerStub)
    }
    
    func test_submit() {
        // given
        let exp = expectation(description: "exp")
        
        // when
        sut.submit(complete: {
            exp.fulfill()
        })
        
        wait(for: [exp], timeout: 2)
        
        // then
        XCTAssertEqual(sut.printedText, "안녕 Stub?")
    }
}
```

<br>

테스트 하고자 한것은 `submit()`을 했을 때, 

통신 후 `String`을 `printedText`(프로퍼티)로 잘 가지고 있는지를 보고 싶었다.

<br>

여기서 실제로 통신은 될 필요 없기에 `Stub`을 이용하였고, 

거기서 미리 정해둔 값`"안녕 Stub?"`이 잘 들어 왔는지를 확인하는 코드를 작성했다.

<br>

더 이상 실제 통신이 잘 되는지, 서버가 멀쩡한지 영향을 받지 않는다.

<br>

## Mock

**리턴값, 콜백은 중요하지 않다. 해당 메소드가 잘, 얼마나 실행 되었는지가 중요하다.**

<br>

만약의 테스트 요소가 결과값 테스트가 아닌 

Company의 `submit`을 통해 

Printer의 `network`가 잘 호출 되었는지가 중요하다면 다음과 같이 `Mock`을 생성한다. 

<br>

```swift
class PrinterMock: Printer {
    
    var networkCallCount = 0
    
    func network(handler: @escaping (Void) -> Void) {
        var networkCallCount += 1
    }
}
```

`networkCallCount`라는 변수를 만들고 `network`메소드가 실행 되면 `+1`을 해주는 게 끝이다.

<br>

이제 테스트 코드를 보자.

```swift
class MockTests: XCTestCase {
    private var sut: Company!
    private var printerMock: PrinterMock!
    
    override func setUp() {
        printerMock = PrinterMock()
        // 1. PrintImp 대신 Mock을 넣어준다.
        sut = Company(printer: printerMock)
    }
    
    func test_call_network() {
        // given
        // when
        sut.submit()
        
        // then
        // 2. printerMock에 메소드가 잘 호출되었는지 테스트 한다.
        XCTAssertEqual(printerMock.networkCallCount, 1)
    }
}
```

<br>

간단하다! `submit`은 한번 호출했으니 `callCount`는 `1`이여야한다. 

`2`라면 뭔가 많이 잘못된 것이다.

<br>

## SPY

**`Mock` + `Stub`이다. 상태도 확인하고 행위도 테스트한다.**

이게 내가 잘못 이해했던 `Mock`이다...

<br>

```swift
class PrinterSPY: Printer {
    
    var handlerValue = "안녕 SPY?"
    
    var networkCallCount = 0
    func network(handler: @escaping (String) -> Void) {
        networkCallCount += 1

        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            handler(self.handlerValue)
        }
    }
}
```


<br>

주석도 필요 없을 듯하다. 간단하다. 

`Stub`처럼 미리 돌려줄 값 `handlerValue`도 만들어 줬고

메소드가 호출 되었는지 확인할 `networkCallCount`도 넣었다.

<br>

테스트 코드를 보자

```swift
class SPYTests: XCTestCase {

    private var sut: TestDouble.Company!
    private var printerSPY: TestDouble.PrinterSPY!
    
    override func setUp() {
        printerSPY = TestDouble.PrinterSPY()
        sut = TestDouble.Company(printer: printerSPY)
    }
    func test_call_network() {
        // given
        let exp = expectation(description: "exp")
        
        // when
        sut.submit(complete: {
            exp.fulfill()
        })
        
        wait(for: [exp], timeout: 2)
        
        // then
        XCTAssertEqual(sut.printedText, "안녕 SPY?")
        XCTAssertEqual(printerSPY.networkCallCount, 1)
    }
}
```

마지막 `then`을 보자.

두가지를 확인한다. 

1. `printedText` 상태 체크
2. `networkCallCount` 행위 체크

<br>

## 상태 검증과 행위 검증

이젠 누군가 `Mock`과 `Stub`의 차이는 뭐에요? 라고 하면

이렇게 대답할 수 있을 것 같다.

<br>

> `Mock`은 행위 검증이고, `Stub`은 상태 검증이에요

<br>

하지만, 부연 설명을 더 하겠지. 저렇게 말하면 의아해 할 확률이 있다.

나도 그랬으니.. 나 같은 사람은 있을 것이다...

<br>

 - `Mock`은 해당 메소드가 잘 호출되었는지, 얼마나 호출되었는지가 중요할때 쓰는 것이고,
 
 - `Stub`은 실제 객체 대신 가짜 객체를 넣어야하는데, 실제 로직은 필요없고 
 
<br>
 
 리턴 값 또는 콜백을 통해 데이터를 반환하는 가짜 객체가 필요할때 쓰인다. 

<br>

## 마무리

`TDD`로 시작해서 `Unit Test`, `BDD` 등을 알게 되었고,

이제는 `Test Double`도 알게 되었다.

<br>

알게 되면 될수록 재미를 느끼고 있다.

<br>

이번 글을 통해 다른 개발자와 의사소통시

`Test Double` 종류에 맞는 것을 얘기하면,

사소하지만 조금이라도 명확한 의사소통을 할 수 있는 한걸음을 내딘 것 같다.

<br>

끝!
