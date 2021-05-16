---
layout: post                       
title: (Tool) Fastlane 기본 설치 방법과 1달 사용후기
categories: [Tool]
---

설치는 글내용이 별로 없을듯 하니 짧게 나마 사용 후기를 같이 써보고자 한다.

지난 글에는 Fastlane의 개념을 간략히 알아 보았다.  [지난글: Fastlane을 알아보자](https://jiseobkim.github.io/tool/2019/03/30/Tool-Fastlane을-알아보자.html)


# 1달 사용 후기
설치 방법을 알아보기전, 회사에서 사용해본 장단점을 먼저 얘기하자면,

<br>

## 장점

1. IPA 추출할때, 셋팅을 걱정할 필요가 없다.
2. IPA 추출을 하는 동안 맥북 앞에 앉아있을 필요가 없다.

<br>

## 단점?
1. 생각보다 사용할 일이 적어서 익숙해지기 힘들다.
2. 아직 기능의 반의 반의 반도 못쓰는 기분이다.

<br> 

먼저 장점 부분을 얘기하자면, 
> 장점 1. IPA 추출할때, 셋팅을 걱정할 필요가 없다.

<br>
실제 IPA를 추출하다보면 과정들이 은근 신경 써야한다. 
- 빌드 클린은 했나?
- 빌드 타겟은 잘맞췄나?
- 아카이브 하는 동안 인증서 선택은 잘했나?

위와 같이 사소하지만 은근~히 신경이 쓰이는 것들이 필요한데, 이미 모든 작업을 어떻게 진행 할지 셋팅을 했기 때문에
IPA로 추출을 할때 터미널에 명령어 `fastlane IPA_Adhoc` (IPA_Adhoc은 미리 작성한 Lane)만 입력해주면, 손쉽게 파일 추출이 끝난다. 신경 쓸것은 Adhoc, Development, Distribution 등등 미리 작성해둔 `Lane` 이름만 생각 해내면 된다.

<br> 
> 장점 2. IPA 추출을 하는 동안 맥북 앞에 앉아있을 필요가 없다.

2의 경우는 1의 연장선이라고도 볼수있다. 아카이브 하고 추출까지 프로젝트 사이즈에 따라 다르지만, 3분~5분 정도였던것 같다. 그렇지만, 1에서 본것과 같이 중간 중간 버튼을 누른다던가 인증서를 선택 등등 할일이 있다, 그래서 짧다면 짧지만, 길다고 볼수도 있는 시간동안 맥북 앞에서 기다리고 있어야 한다.
그치만 이 귀찮은 행동은 `Fastlane`을 사용함으로써 해결이 되었다. 명령어 치고 화장실도 다녀오고, 물도 마시고 돌아오면 추출이 끝나있다.

<br> 
<br>

단점이라 하기엔 애매하지만! 
> 단점 1. 생각보다 사용할 일이 적어서 익숙해지기 힘들다.

`Fastlane`은 배포, 추출, 인증서 관리 등등 도와주는 편리한 도구이다, 하지만 그것들을 할일이 자주 있는편이 아니다.
자주 써야 익숙해지던가 할텐데, 한 3번 정도 썼나,,,? 그러다보니 한달가량 썼지만 아직도 친숙함이 안느껴진다.

> 단점 2. 아직 기능의 반의 반의 반도 못쓰는 기분이다.

이건 단점이라 적긴 했지만, 나의 귀차니즘이 크긴 했지만 1에서 말한바와 같이 잘 쓸일이 없었기에 순간 아쉬운점이 있어도 자주 안쓰니 까먹고 기능을 추가 안했다.. (쓰고보니 변명)
써봐야겠다 생각드는 기능은 아래와 같았다.
1. 슬랙으로 작업 완료 알리기
2. 인증서 Git Hub로 관리 
3. 자동 심사 제출

<br> 
좀더 쓰게 되면 더 적어봐야지 

<br>

# 설치 방법
가장 좋은건 아무래도 공식 사이트 문서라 생각하므로 첨부! [공식 설치 문서](https://docs.fastlane.tools/getting-started/ios/setup/)

문서가 잘나와 있으니, 문서에 없는 세세한거라도 설명 추가!

## 기본 단계

**순서 1 커맨드 라인 툴 설치**
- 이것을 안하면 터미널에 `fastlane` 명령어 사용시 오류 발생할 수도 있다.

```
xcode-select --install
```

<br> 
**순서 2 Ruby Gem을 이용해 `Fastlane` 설치**
- sudo : 높은 권한으로 설치하기 위해! 

```
sudo gem install fastlane -NV
```


<br> 
**순서 3 프로젝트에 `fastlane` 적용(초기화)하기**
- Cocoapod을 사용해보았다면 `pod init`이랑 같은 개념
- 꼭 적용하려는 폴더로 이동후 명령어 입력하기

```
fastlane init
```
<br><br>

## init 과정
`init`하게 되면 몇가지 셋팅을 과정이 있다. 아래 과정은 대부분 비슷하겠지만 프로젝트 셋팅 상태에 따라 뜰수도, 안뜰수도 있는 부분도 있다.

**순서 1. 폴더내의 project 혹은 workspace가 여러개 존재한다면?**
![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2019-04-21/image1.png)

해당 폴더 내에 여러 프로젝트가 존재한다면 어떤 프로젝트에 적용할건지 물어보는 화면이다,
이런것도 판단 해주고 참 좋은 툴이네!

선택지에서 골라서 해당 숫자 입력후 엔터!

<br>
<br>

**순서 2. 사용 목적 셋팅**
![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2019-04-21/image2.png)

여기서 나오는 화면은 예전엔 없었나보다, 다른 블로그들에선 없었던 화면이라 당황스러웠었다.
"주 사용 목적이 스크린샷, 테스트플라이트, 배포용 어느거야?" 라고 묻는다고 보면 되고
지금 하기 싫다면 4번을 선택하면 된다, (4로 진행)


<br> 
<br>

**순서 3. 완료**
![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2019-04-21/image3.png)

위와 같이 하면 명령어들의 간단한 설명과 함께 `init`의 과정은 끝이난다.

그치만 위에 말했듯이 위와 다른 설명을 보았다면, 그곳엔 저 화면들이 아닌 애플 개발자 계정 셋팅 화면이 나왔을것이다. 하지만 바뀐후 달라진건지 애플 개발자 계정 넣는 부분이 안보였다.

그렇기에 그냥 진행할 경우 오류도 발생할 수 있다.

<br>
<br>
## 계정 셋팅

위에 말했듯 계정을 따로 설정을 해줘야 한다.

Xcode 내에서 해야할 일을 외부에서 처리해야하니 계정에 대한 정보는 필수다.

<br>

 위에 `init` 과정이 끝난후 설치된 폴더내에 fastlane이란 폴더가 생겼을 것이다.
 위2번 상황에서 4번을 택했으면 `Fastfile`과 `AppFile` 항목이 생겼을 것이다. (다른것을 선택했다면 더 있을 수 있다.)
 
 <br> 
 - Appfile : 개발자 계정 설정하는 파일
 - Fastlane : Lane을 셋팅하는 파일
 
 위와 같은 역할들을 하며, Fastlane은 다음 포스팅때 하고 여기선 Appfile만!
 
 `Appfile` 폴더의 내용은 다음과 같다.
 
 ```
 # app_identifier("[[APP_IDENTIFIER]]") # The bundle identifier of your app
 # apple_id("[[APPLE_ID]]") # Your Apple email address
 
 
 # For more information about the Appfile, see:
 #     https://docs.fastlane.tools/advanced/#appfile
```

여기서 설정해야할 부분은 처음 두줄.

- 1,2번줄 `#` 제거
- `[[APP_IDENTIFIER]]`에는 해당 프로젝트 BundleID 넣기.
- `[[APPLE_ID]]` 에는 개발자 계정 넣기.

<br><br>
그리고나서 인증서 받기(sign), 혹은 itunesConnect에 앱생성(produce) 명령어를 실행한다.
```
fastlane produce
```
그럼 `Appflie` 에 설정한 애플 계정의 패스워드를 요구한다.
> 애플 이중인증 사용중일시 appleid.apple.com 사이트에서 이중인증 비밀번호를 발급 받아서 입력!

위의 작업을 통한다면 계정 연결은 끝난것이고, 입력한 명령어를 수행하게 된다.
- 위의 연결 없이 IPA추출했다가 오류가 발생했었다.

중요한건 **애플 계정 연결**이다.

<br><br> 
여기까지 했다면 `Fastlane`의 기본적 사용을 위한 준비는 끝이나게 되고 다음 포스팅에선 `lane` 사용법에 대해서 포스팅할 예정이다. 


