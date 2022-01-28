---
layout: post

title: "Xcode - Cocoapods Podfile, Podfile.lock 파일에 대해서"

categories: [Xcode]

---

이직 준비하느라 블로그에 소홀에 졌었지만,

성공적인 이직을 했으니 다시 블로그에 관심 주기!

<br>

`cocoapods`에 대해서 혼자서 일할때는 사실 크게 관심을 갖지 않았다. 

컴퓨터가 바뀔일이 거의 없었으므로 단순히 라이브러리 설치 용도로만 쓰이고 

`podfile`내의 연산기호, `podfile.lock`에 대해서는 잘 몰랐기에 이참에 정리해보기.

<br>

# Podfile

```swift
pod 'Alamofire', '~>5.0'
```

간단한 사용법은 패스, 여기서 내 관심사는 뒤에 `~>5.0`에 관해서다.

기타 연산 기호인 `>`, `=`, `>=`, `<`, `<=` 등에 대해서는 패스하고 `~`에 대해서만!

<br>

여기서 중요한 점은 소수점의 위치이다. 

- `~>4.8.1` : 4.8.1 ~< 4.9
- `~>4.8`: 4.8 ~< 5
- `~>4`: 4 ~< 5 (`~>4.0`과 동일로 보임)

<br>

세번째 자리까지 기입한다면 두번째 자리까진 고정.

두번째 자리까지 기입한다면 첫번째 자리까진 고정.

한자리만 입력한다면 두번째자리에 0을 넣은 것(4.0)과 동일.

<br>

그리고 최초 설치시엔 해당 버전에 범위내에 최고 버전이 설치가 된다.

<br>

# Podfile.lock

이것과 관련지으면 좋을 키워드는 `pod update`와 `pod install`이다.

두 명령어를 입력했을시 차이는 다음과 같다.

<br>

**Podfile.lock이 없다면?**

- `pod install`: `Podfile` 파일 조건에 따른 설치, `podfile.lock` 생성

- `pod update`: `Podfile` 파일 조건에 따른 설치, `podfile.lock` 생성

동일하다

<br>
**Podfile.lock이 있다면?**

여기선 조금 나눠서 설명을 나눠보자.

- `pod update`: `Podfile` 파일 조건에 따른 설치, `podfile.lock` 재생성
 
`lock`을 무시하며 해당 파일이 없을때와 동일하게 동작한다.

<br>
문제는 `pod install`이다.

- `podfile`의 조건이 `podfile.lock` 조건을 만족한다면 미설치.
- `podfile`의 조건이 `podfile.lock` 조건을 만족하지 않는다면 새 조건으로 설치 및 `podfile.lock` 수정.

이 부분은 예시를 통해 이해를 돕는게 좋을듯 싶다.

<br>

### 예시

`Alamofire`를 이용할 것이고, 글을 작성하는 시점에서 최신 버전은 `5.5.0`이 최신이다.

<br>

**실험 1. `~>4.8.1`, `pod install`**
- 4.8 버전 중 최신 버전인 4.8.2가 설치됨
- `podfile.lock`에 `Alamofire (~> 4.8.1)` 생성

<br>

**실험 2-1. `~> 4.8`로 수정, `pod install`**
- 변화 x 4.8.2 유지

> why: `podfile.lock`이 존재하며 현재 설치된 버전이 `4.8.2` 이기에
> `DEPENDENCIES`에 `Alamofire (~> 4.8.1)` 조건 만족하므로 변화 x

<br>

**실험 2-2. `~> 4.8`로 수정, `pod update`**
- 4.9.1로 변경

> why: `podfile.lock` 무시, `podfile.lock` 미변경

- `Terminal`에 "Installing Alamofire 4.9.1 (was 4.8.2)" 문구 표출

<br>

**실험 2-3 `~>5.0`, `pod install`**
- 5버전대 최신인 `5.5.0`으로 변경

> why: `podfile.lock`이 존재하지만 새 조건 `~>5.0`이 
> 기존 조건문인 `~> 4.8.1`를 만족하지 않으므로 새로 적용.

- `podfile.lock` `DEPENDENCY`변경됨. `Alamofire (~> 5.0)`

- `Terminal`에 "Installing Alamofire 5.5.0 (was 4.9.1)" 문구 표출

<br> 

이렇게 실험적으로 해보고나니 확실하게 이해가 되었다.

해당 연산자는 마이너업데이트 또는 패치 정도는 허용하겠다! 라는

용도로 사용을 하면 좋을것 같다.

<br>

끝!
