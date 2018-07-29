---
layout: post
title: Alamofire와 Escaping
tags: [swift, Alamofire, Escaping]
excerpt_separator: <!--more-->

---
자주 반복되는 Alamofire를 함수로 만들자. feat.Escaping
<!--more-->

Alamofire라는 좋은 라이브러리를 쓰다가 보면 새로운 swift파일을 만들때마다 반복적으로 쓴다는 생각이 든다.

그래서 함수로 만들면 좋겠다! 라고 생각했다가, 졸업작품 당시 포기했다. 



포기한 과정을 보기전에 오늘의 구조 먼저, 첨부



![]({{ site.baseurl }}/assets/img/post/2018-07-29/img1.png)



스토리보드도 심플, 코드도 심플, 화면도 심플한 상태이다

<br>

### 코드 구성

1. Alamofire를 사용하기 위해 import
2. 사용될 함수
3. url을 선언과 초기화
4. 통신 성공시 obj 라는 이름의 Any타입을 가진 데이터를 가져오고 출력
   - 출력 값: 오른쪽 하단
5. Any 타입 데이터를 딕셔너리로 캐스팅
6. 해당 딕셔너리중 'text'라는 키의 데이터를 String형으로 캐스팅
   - 값: "Server Text"라는 문자열
7. Label에 적용



저번편에 간단하게 설명을 참고하면 아주 간단한 코드.

[참고: Alamofire와 Codable](https://jiseobkim.github.io/2018/07/21/swift-Alamofire와-Codable.html)



그런데, 만약 다른 통신을 한다고 하면 2번 부분에서 굉장히 중복이 많이 일어난다.

```swift
// 요청
let request = Alamofire.request(url)
// 응답
request.responseJSON { (response) in
// Switch문 사용
switch response.result {                      
    case .success(let obj):
        print(obj)
    case .failure(let e):
        print(e.localizedDescription)
    }
}
```

위의 코드를 보자, 



1. 요청
2. 응답
3. 분기문



이것들은 분명 반복이 된다. 



 앱정보, 사용자 정보, 기타등등  통신할때마다 똑같은 코드를 쳐야한다. 그래서 나는 졸업작품 당시 간소화 시키고 싶었다.

내가 필요한건 **nsDic** 였었다. 그래서 아래와 같은 코드를 사용했었다. 

(**주의: 안되는 코드임**)



![]({{ site.baseurl }}/assets/img/post/2018-07-29/img2.png)



1번을 보면 어떤 클래스라도 접근할수 있는 전역함수가 있다.



여기서 중요한건 return 값이 존재하며 타입은 **NSDictionary?** 이다. 위에 쓴바와 같이 원하던 nsDic의 타입이다.



```swift
// 1-1. 필요한 nsDic이 될값
var returnValue: NSDictionary?
```

돌려줄 값의 타입을 옵셔널로 지정해주고

```swift
// 5. returnValue에 지정
returnValue = nsDic
```

통신을 통해 받아서 캐스팅한 nsDic 값을 returnValue의 값으로 넣어주고

```swift
// 6. 돌려주기
return returnValue
```

6번에서 return 해준다!

<br>

이게 과연 될까? **결론은 안된다**



위 이미지 하단의 콘솔창을 보면 **nil** 임을 알 수 있다.



<br>

### 왜 nil일까?

그 당시 참 멘붕이었는데, 정답은 간단하다. 통신은 얼마나 걸릴지 모른다. 따라서,**비동기**로 진행되야한다.



<br>

### 만약 비동기가 아니라면??

앱자체가 멈춰 버릴것이다. 왜냐면 통신이 될때까지 기다렸다가 순차적으로 진행되어야 하기 때문이다.

시간이 좀 지연된다면 사용자는 앱이 죽었나? 라고 생각 할것이다.  

> **너는 통신하고 끝나면 할거 하고와 나는 하던일 계속할게** 이런 느낌이랄까?

그래서 **nil**이 발생한것이다.

사용자가 느끼기엔 충분히 빠른시간안에 표현되었지만 아래코드가 진행될때쯤이면

return은 이미 끝난 후이다.

```swift
// 5. returnValue에 지정
returnValue = nsDic // 이때, 이미 return은 진행된 상태. 즉, 넣어봤자 소용이 없다.
```



그렇다면 nsDic을 return 값으로 정해주는게 아니라 nsDic을 return 해준다면?



![]({{ site.baseurl }}/assets/img/post/2018-07-29/img3.png)



안된다. 다른 방식이 필요하다.

<br>

## Escaping

처음엔 이 문법에 대해 도무지 이해가 안갔다. 졸업작품할당시에도 찾았었지만, 시간이 급해서 조금 시도해보다 포기했다.



하지만, 알면 정말 도움이 많이 된다. 혹여나 읽는 분이 계시다면 이리 저리 시도해서 꼭 성공하시길.



일단 코드를 보자.



![]({{ site.baseurl }}/assets/img/post/2018-07-29/img4.png)



특별히 0번이라 썼다. 책으로만 공부했다면, 정말 정말 생소할 모습일것이다.



```swift
func useEscaping(url: String, handler: (NSDictionary) -> Void) {}
```



혹시, 이런 모습이면 조금이나마 익숙하다. 스위프트는 함수형 언어라고도 가능한데, 그 이유는 스위프트에서 함수는 일급함수에 속하기 때문이다. 여러가지 조건이 있지만 복잡하니, 나중에 더 알아보는걸로 하고. 여기서 관련된 조건들만 말해보면

1. 인자 값으로 함수를 전달할 수 있다.
2. 반환 값으로 함수를 전달할 수 있다.

두가지 정도? 저기서 **handler** 라는 인자는 타입이 **NSDictionary**만 받는게 아니라 **return**이 있다. 이건 누가봐도 함수다. 이런식으로 인자값으로 함수를 받았다. 반환값으로도 가능하고! 일급함수란 표현도 중요하지만 그 내용인 함수를 받았다는게 중요하다. 그렇다면 **`@escaping`** 이 의미하는것은 무엇일까

> handler 라는 표현은 보통 '다루다'로 사용되고 stackOverFlow 같은 곳에서 보면
>
> 관련 자료에서 종종 인자값에 **`completionHandler`** , **`completion`**라는 단어를 많이 쓰는데, 
>
> 이는 완료후 처리할 작업, 완료후 다룰것 이라고 생각하면 좀더 편했던것 같다.



<br>

### @escaping

이름부터가 탈출이다. 나는 이렇게 이해하고 있다. 현재 함수로부터 도망쳐 나온다. 하지만, 그때 NSDictionary를 가지고 도망친다. 이게 포인트다, 다르지만 비슷하게 생각할 수 있는건, **NSDictionary** 값을 리턴해준다고도 볼 수 있다.

쓰는 방식은 이미 많이들 접했을 것이다. 비슷한 문법을 보자



![]({{ site.baseurl }}/assets/img/post/2018-07-29/img5.png)



1번의 경우는 애니메이션 효과를 사용할때 자주 사용하는 문법이다. 

2번의 경우 포스팅에 자주 나온 Alamofire에서 응답 값을 받았을때 처리하는 부분에서 나온것이다.

저런 문법을 만들려면 필요한것은 @escaping을 쓰는 것이라는 결론이 나왔다!

각각의 차이점을 보자

```swift
// 1. Animation ( 인자: o , 반환: x)
((Bool)-> Void)?
// 2. Alamofire Response ( 인자: o , 반환: x)
(DataResponse<Any>) -> Void)
// 3. Use Escaping ( 인자: o , 반환: x)
(NSDictionary -> Void)
```



<br>

쉬운 순서대로 정리했다.  공통점은 반환 값이 전부 없다는것.

### UIView Animation

1번의 경우 애니메이션 사용할때 생각을 해보자,

```swift
UIView.animate(withDuration: 2, animations: {
    self.view.alpha = 0
}) { (value) in
    if value == true {
        print("success")
    }
}
```



자신이 정한 시간(여기선 2초)동안 **animations** 의 내용을 수행하게 된다, 그리고 그 작업이 끝난뒤에 할일은 **completion내용이** 된다. 저기서 뒤에 물음표가 붙어있는데, **nil이** 될수 있다는 것이다. 즉 효과만 주고 그뒤에 다른 작업은 안해도 된다는것! 그렇기에 **animation에** 더 들어가보면 default값으로 **nil이** 들어가있다.

![]({{ site.baseurl }}/assets/img/post/2018-07-29/img6.png)



<br>

### Alamofire Response

다시 본론으로 들어가서 2번째 경우, 데이터 타입이 DataResponse라는 것이고 뒤에 꺽쇠로 된건 **Generic**을 의미한다.

Generic도 나중에 다루기로하고, 함수나 클래스 구조체 등등 하나 선언해서 여러 타입(String, Int 등등)을 대응 한다 생각하고 넘어가자. 



여기서 중요한건, 통신 후 **DataResponse라는 타입을 가진 데이터를 받아와서 내가 사용**했다는 것이다.



이게 바로 우리가 필요한것이다. **nsDictionary로 된 데이터를 받아와서 표현**하고 싶은 것이다.



<br>

### Escaping

사용법은 위의 Alamofire보다 훨씬 간단하다.



![]({{ site.baseurl }}/assets/img/post/2018-07-29/img7.png)



2-2 부분이 전부이다. 받아온 **NSDictionary** 타입을 가진 데이터 이름을 **``nsDic``** 이라 이름을 붙여주고 정말 딕셔너리 사용하듯 사용하면 끝이다.



그 아래에 쓴것은 위에서 실패했던 방식인 NSDictionary를 return 해주는 방식의 함수를 다시 사용 한것이다.



근데 아래 콘솔창을 보면 당연하지만 재미난 출력물이 보인다.



사용한건 **escaping** 방식이 먼저지만, 출력된건  **return** 방식을 사용 한것이 먼저이다. 이제는 당연하다고 생각이 들것이다.

네트워크가 아무리 빠르다 한들 통신보다 빠를리가... 그리고 비동기방식이기 때문에 가능한일!



<br>

## 번외: 공통으로 사용하는건 좋다! 그렇지만, 통신 실패시엔 다르게 대응하고 싶은데? 할 경우

위에 잠시 언급한 일급 함수의 특징을 사용하면 간단하게 해결! 내가 하고 싶은 함수를 만들고, 실패시에 작동하게 하면 그만



```swift
func useEscaping(url: String, whenIfFailed: (), handler: @escaping (NSDictionary) -> Void) {
    
    let request = Alamofire.request(url)
    
    request.responseJSON { (response) in
        switch response.result {
        case .success(let obj):
            guard let nsDic = obj as? NSDictionary else { return }
            handler(nsDic)
            
        case .failure(let e):
            // 통신 실패시
            print(e.localizedDescription)
            whenIfFailed
        }
    }
}
```



위와 같이 적어 주자. 하나가 추가 되었다. **``whenIfFailed``**  라는 함수 타입의 인자이다. 그리고 주석 부분에 보면 통신 실패시 작동하게 되어 있다.



하지만, 항상 실패에 대응 할필요가 없을 수도 있다. 위 함수안에 동일하게 대응되게 짜둔다면 굳이 그럴 필요 없다. 그러나! 필요한 경우도 있다! 그렇다면 어떻하면 좋을까?  **``whenIfFailed``** 를 옵셔널로 해주고 기본값을 **nil**로 해주자



```swift
func useEscaping(url: String, whenIfFailed: (() -> Void)? = nil, handler: @escaping (NSDictionary) -> Void) {
    
    let request = Alamofire.request(url)
    
    request.responseJSON { (response) in
        switch response.result {
        case .success(let obj):
            
            guard let nsDic = obj as? NSDictionary else { return }
            handler(nsDic)
            
        case .failure(let e):
            
            // 통신 실패시
            print(e.localizedDescription)
            whenIfFailed?()
        }
    }
}
```



**``whenIfFailed``** 부분이 좀 달라졌다. **(() -> Void)** 는 같은것이다. 하지만 뒤에 물음표가 붙어 있고, 기본 값이 **nil** 로 되어있다.

즉, 필요 없으면 안써두 된다는 것이다. 그 결과 아래쪽에 보면 **``whenIfFailed``** 에 물음표가 붙어있고, 이는 nil이면 자동으로 실행 않고 지나가게 된다!



사용은 아래와 같다

```swift
func ifFailed() {
    print("실패했어요")
}

// 함수 사용
useEscaping(url: url, whenIfFailed: ifFailed) { (nsDic) in
    guard let text = nsDic["text"] as? String else { return }
    print("(Escaping 사용)text: \(text)")
}
```



그런데, 나는 각각에 다르게 반응할거야!! 라고 하면, 각 함수 만드는것도 일이다. 그럴 경우엔 이렇게 해보는건 어떨까



```swift
func useEscaping(url: String, whenIfFailed: @escaping () -> Void, handler: @escaping (NSDictionary) -> Void) {
    
    let request = Alamofire.request(url)
    
    request.responseJSON { (response) in
        switch response.result {
        case .success(let obj):
            
            guard let nsDic = obj as? NSDictionary else { return }
            handler(nsDic)
            
        case .failure(let e):
            
            // 통신 실패시
            print(e.localizedDescription)
            whenIfFailed()
        }
    }
}
```



여기서도 **escaping**을 사용했다. 그럼 사용 코드에선?



![]({{ site.baseurl }}/assets/img/post/2018-07-29/img8.png)



마치 UIView Animation 같다.



값을 채워 넣으면 이렇게

```swift
useEscaping(url: url, whenIfFailed: {
    print("실패했어요")
}) { (nsDic) in
    guard let text = nsDic["text"] as? String else { return }
    print("(Escaping 사용)text: \(text)")
}
```





escaping은  알면 알수록 유용하게 쓰이는 것 같다. 좀 더 활용할 곳을 찾아봐야겠다.

