---
layout: post

title: "Swift - JSON 데이터 쉽게 모델 만들기(feat. QuickType)"

categories: [Swift]

---


오늘도 LOL API와 관련이 있다.

<br>

그리고 툴을 하나 소개하려한다.

`QuickType`이라는 것인데,

[앱스토어](https://apps.apple.com/kr/app/paste-json-as-code-quicktype/id1330801220?mt=12)에서 받아도 되고, 다운받기 싫다면 [웹사이트](https://quicktype.io)에서 진행해도 된다.

## 언제 쓸까

<br>

`Codable` 관련해서 글을 많이 쓰다보니

글을 게제하기 위해서 다음과 같은 순서로 진행 했었다.

1. `JSON`파일을 만들거나 `String`을 `JSON`형태로 만든뒤 `Data`로 변경
2. `JSON` 형태 기준으로 구조체 또는 클래스를 만든다.
3. `Codable`을 이용하여 `JSON` 데이터로 인스턴스를 생성한다.


여기서 3번! 3번이 은근히 귀찮았다.

그치만 짧기 때문에 해볼만한 귀찮음이었다.

<br>

회사에서는 데이터 파악할겸 프로퍼티  하나하나 복붙하느라

`QuickType`을 적용해볼 생각 조차 안했다.

> 복붙한 이유는,,, 타이핑 치다가 오타나면 귀찮음이 x3

<br>


그러다가 `LOL API` 관련 포스팅하다가 아주 아주 소름 돋는 경험을 했다.


<br>

제공하는 정보중에 `챔피언 리스트` 라는 것이 있다.

이는 `JSON` 형태로 주는데,  아래 링크를 들어가보면

[링크](http://ddragon.leagueoflegends.com/cdn/11.16.1/data/en_US/champion.json)

<br>

다음과 같이 거부감이 팍드는 `JSON`이 나온다.

<img src="/assets/images/2021-08-21/img.png" style="zoom:40%;" />

<br>

이것을 파악하고 하나하나 타이핑 친다는것은

블로그 주제를 포기해야하나 할만큼 내적 갈등을 일으켰다.

<br>

그러다가 `QuickType`이 생각 났고 적용 해보았다.

그랬더니 놀랍게도 다음과 같은 처리가 되었다.

<img src="/assets/images/2021-08-21/img-1.png" style="zoom:40%;" />

오.. 뭔
