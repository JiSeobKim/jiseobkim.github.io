---
layout: post

title: "Project - LOL API (문서 살펴보기)"

categories: [Project]

---

노마드코더 영상에서 그런말이 나오더라

> 공부할 리스트만 만들면 쉽게 지치기 쉽다, 
> 만들고 싶은 목록을 만들어라, 
> 그럼 거기에 필요한 것들을 공부하게 될 것이다

크, 그래서 가끔 즐기는 롤에서 전적 관련 APP을 간단하게 만들어보려고한다.

카피 앱이 아니기 때문에 UI 다루는 스킬보단

라이엇은 API 응답값 형태가 이렇구나 저렇구나 하면서 다른 회사의 API를 체험해보는 경험이 될 듯하다.

깃헙에 저장소를 만들면서 공개용으로 만들고 싶었지만,,, Key 부분이 조금 걸려서
프라이빗으로 만들게 된 점은 다소 아쉽다.

<br>

[개발자 사이트](https://developer.riotgames.com)에 들어가서 가입하고 나오는 화면은 다음과 같다.

<img src="/assets/images/2021-08-14/img.png" style="zoom:40%;" />

저기 중간에 나오는 `API Key` 는 필요한거니 잘 가지고 있자.

<br>

그리고 상단에 `API 탭`에 들어가보면 수많은 API들이 기다리고 있다.

처음에 너무 많아서 정신도 없고 문서 양식 파악이 안되어서 무슨말인지 한참 봤다.

처음엔 어려웠지만 읽는 방법을 알고 나니 술술 읽히는 부분이 마음에 들었다.

<br> 

아무래도 게임내의 정보다 보니 모든 API 들이 URL Path 부분에 값을 채워줘야했다.

그 중 제일 기본이 사용자 정보였다. 

사용자 정보를 알아야 그 사람의 전적이라던가 게임 정보라던가 알 수 있으니 당연한 것이었다.

<br>

# 사용자 정보 문서 확인

문서 보는 방식을 사용자 정보 보는것으로 알아보자.

`API 탭`으로 이동한뒤 `Summoner`을 찾자

> Summoner는 소환사라는 의미다

<br>

<img src="/assets/images/2021-08-14/img-1.png" style="zoom:40%;" />

상단엔 페이지 이름 `SUMMONER_V4`가 적혀있고,

오른쪽엔 `모두 접기`, `모두 펼치기`가 있다.

아래 API들을 접고 펴기 하겠다는 것이다.

<br>

그아래는 왼쪽부터

`Method` - `URL Path` - `Description`

메소드는 `Get`이 압도적으로 많겠지? 라이엇은 정보를 제공만 할테니.

그리고 `path`에 보면 괄호`{}` 안에 것이 필요한 정보인데,

현재는 다른 값들은 알지 못하고 두번째 `{summonerName}`을 이용해서 할 수 있다.

<br>

그리고 오른쪽에는 간단하게 설명이 되어있고 클릭이 가능해서 파란색으로 되어있다.

눌러보면 펼쳐지게 되니 눌러보자.

<br>

<img src="/assets/images/2021-08-14/img-2.png" style="zoom:40%;" />

그럼 해당 API에 대한 정보가 나오는데,

처음 나오는건 `Response Data Type`에 대한 것이다.

응답값을 `SummonerDTO`라는 형태로 돌려주고 바로 아래에
이 `SummonerDTO`라는 것에 대한 자료형을 설명해준다.

단순히 `Dictionary`로 뿌려주는게 아니라 데이터 형태의 이름을 붙여주니
이 부분이 아주 좋았다.

서버도 클라이언트도 모두 자료형에 대해 네이밍을 통일할 수 있겠다 싶었다.

<br>

왜냐면 응답값이 형태가 정의가 제대로 안되어있으면 

비슷하지만 미묘하게 달라서다른게 자료형이 많아지는 현상이...

<br>

다른 API들을 보면 알겠지만 설명해주는 부분에 또 다른게 있으면

그 아래에 또 다른 것에 대한 설명을 해주기 때문에 여기 저기 찾아볼 필요가 없었다.

<br>

그 다음은 `ErrorCode`에 대해 정의가 되어있다

<img src="/assets/images/2021-08-14/img-3.png" style="zoom:40%;" />

<br>

그 아래 부분엔 편리한것이 있는데, API를 바로 테스트해 볼 수 있다.

<br>

<img src="/assets/images/2021-08-14/img-4.png" style="zoom:40%;" />


path에 필요했던 값인 `summonerName`이란 필드 값을 채우고

아래에 빨간 버튼을 눌러주면 실행값이 나온다.

보여주는 항목들은 다음과 같다

- Request URL
- Request Headers
- Response Status Code
- Response HEADERS
- Response Body

정말 친절하다! 따로 `PostMan`이나 `Paw` 같은 프로그램들을 켜서 

테스트를 해볼 필요가 없었다. 크 역시 큰 곳은 다르다 이건가...

<br>

그 중 `Response Body`를 보자

```json
{
    "id": "waVzd7W1xB47_2P650Jn67EO8iijoAoX6fOEdWqDQVvs0io",
    "accountId": "8VOqFMdQDXwTKPsbSBg5wo08GjcaZlpUmjBs9aSHUn0ap8Y",
    "puuid": "ywGOQDCvN_7PsLZChEIyW-4c535T2w5Hi2WfB8E-uIeVpCuQZHT3LuuGIUQ9g7XX-dysavsFfHFtnA",
    "name": "2세트짬뽕2탕슉1",
    "profileIconId": 4569,
    "revisionDate": 1628400316000,
    "summonerLevel": 274
}
```

위 같은 형태로 내려준다.

다른 `puuid`, `id`, `accountId` 이런 것 들을 이용해서 다른 API를 통해
이런 저런 값들을 얻을 수 있다.

<br>

다음 편을 통해서 실제로 호출해보자.

끝.

<br>
