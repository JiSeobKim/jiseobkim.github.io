---
layout: post
title: Xcode_Carthage (설치)
published: true
author: Kim Ji Seob
category: articles
tags:
- Carthage
- Xcode
---



Hello! 2019!

이전편에서 `Carthage`이란 무엇인지 그리고 Cocoapods보다 장점은 무엇인지 글을 써봤다.

이전글: [Carthage-서론][https://jiseobkim.github.io/articles/2018/12/26/Xcode-Cartage.html]

오늘도 짧게! 설치법만 적어야겠다.

---



### 요약

- Homebrew 설치
- Homebrew를 이용한 Carthage 설치
- Carthage를 통한 라이브러리 설치( Alamofire 로 설치 예정! )



---



### Homebrew 설치

*Homebrew*란? 쉽게 생각하자면 Cocoapods과 Carthage 처럼 Package Manager 같은 것이라 생각하면 될 것 같다!

그럼 우린 무엇을 할것인가!

Carthage 란것을 설치해야 하므로 일단 *Homebrew*가 설치되어 있다면 Pass

[Homebrew 사이트][https://brew.sh]가 공식 사이트다. 자세히 보고 싶다면 한번쯤 보면 좋을듯하다.

하지만 귀찮다면, `Terminal`을 실행하고  아래 명령어 입력 후 Enter!

```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

기다리면 끝.



### Carthage 설치

[Carthage 공식 Github 사이트][https://github.com/Carthage/Carthage]에 굉장히 자세히 나와있다.

`Terminal`을 열고

```
sudo chown -R $(whoami) /usr/local
```

입력하고

> chown 은 소유자나 소유 그룹을 변경하는것이고, 
>
> 옵션 -R은 해당 경로와 하위 파일들 다 바꾼다는것,
>
> $(whoami)는 말그대로 내가 누군지를 나타낸다. 아마 Terminal 명령어 입력하는 곳 앞부분이랑 같을 것이다!
>
> 뒤에 /usr/local 설정하고자 하는 파일이다.
>
> 즉, /usr/local 경로와 그하위 목록들의 소유자를 나로 바꿔라! 라는 의미로 해석할 수 있다.
>
> 안해도 되는 경우가 있지만 iTerm2를 쓰면서 oh-my-zip을 써서 그런가? 안해주면 안되었다.

<br>

```
brew install carthage
```

입력하면 끝.



<br>

<br>

### Carthage를 통한 라이브러리 설치

Cocoapods 사용자라면 `pod init`을 해서 Podfile을 만들었을 것이다. 

> Podfile은 설치할 라이브러리 이름을 적는곳 (추가 정보도 입력가능)

Carthage 사용자라면 Cartfile이란것을 만들어 줘야한다. (Terminal 입력)

```
vi Cartfile
```

편집기가 열리면 설치하고자 하는 라이브러리 주소 정보 및 버젼 정보를 적으면 된다. (Terminal 입력)

```
github "Alamofire/Alamofire" ~> 4.7.2
```

> `-> 4.7.2` 는 생략 가능

Podfile에 비해 Cartfile은 파일 내용이 심플해서 좋다.



<br>

pod install 같이 설치가 필요하다. (Terminal 입력)

```
carthage update
```

<br>

하지만, 심플한만큼 후자업이 조금 있다...



1. Framework 수동 추가
2. Run Script 생성
3. shell script 작성 (이 표현이 맞는지 모르겠.....)
4. Input Files에 루트 추가





# 졸리므로 나머진 내일 작성.





