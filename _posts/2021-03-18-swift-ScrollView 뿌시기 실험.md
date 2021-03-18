---

layout: post

title: (swift) ScrollView 뿌시기 실험

categories: [Swift, UI]


---



이전편 8번에서부터 이어지므로 보고 오는것을 추천 - [이전글](https://jiseobkim.github.io/swift/ui/2021/03/17/swift-ScrollView-뿌시기.html)



이 에러부터!

<img src="/assets/images/2021-03-17/img-9.png" style="zoom:80%;" />



<br><br>

# 실험



위의 8부터 다시보고 차근차근 봐보자, 이것 저것 실험하기!

컨텐츠의 사이즈가 모호해! 는 사라졌다. 대신에 위와 같이 X,Width 값 잡고 Y, Height도 필요하다고 나온다. 

하나씩 다잡아보자 X 또는 Width, Y 또는 Height.

<br>

**X값 설정**

센터로 설정을 해보자

<img src="/assets/images/2021-03-18/img-10.png" style="zoom:80%;" />

<img src="/assets/images/2021-03-18/img-11.png" style="zoom:40%;" />

x 값을 잡아줬더니 x또는 Width 잡으라는 경고는 사라졌다. 그리곤 ScrollView의 폭만큼 늘어났다

<br><br>

**Y값 설정**

X는 다시 지워주고 Y만 센터로 해보자

<img src="/assets/images/2021-03-18/img-12.png" style="zoom:80%;" />

<img src="/assets/images/2021-03-18/img-13.png" style="zoom:40%;" />

마찬가지로 y, height 잡으라는 경고는 사라졌다. 그리곤 ScrollView의 높이만큼 늘어났다.

<br><br>

**X,Y값 설정**

둘다 센터 0으로 잡아보자

<img src="/assets/images/2021-03-18/img-14.png" style="zoom:40%;" />



모든 에러가 사라졌다. 그리고 ScrollView와 같은 사이즈가 되었다.

Content Layout Guide와의 상하좌우를 0으로 맞추고 센터를 0,0잡아준 결과이다.

스크롤뷰 사이즈 = 컨텐츠 사이즈인 상태이다. 그러므로 **스크롤은 되지 않는다.**

<br>

이번엔 Content Layout Guide와의 좌,우 를 100 잡아보자( Leading만 잡아도 Trailing은 줄어드는 이유는 잘 모르겠다. )

<img src="/assets/images/2021-03-18/img-15.png" style="zoom:40%;" />

<img src="/assets/images/2021-03-18/img-17.png" style="zoom:40%;" />

가득 차있다가 좌우 여백 100 만큼을 갖는 사이즈로 형성이 된다.

그렇다는건 반대로 여백을 반대 방향으로 잡는다면 그만큼 스크롤이 가능하게 된다는것이다.



<br>



반대로 하기전 스크롤 됨을 확인하기가 어려우므로 다음과 같이 이쁘게 꾸며주자 (핑크와 오렌지의 폭은 100)

<img src="/assets/images/2021-03-18/img-18.png" style="zoom:40%;" />



<br>

Leading만 -100을 줘보자

<img src="/assets/images/2021-03-18/img-19.png" style="zoom:40%;" />



자세히 보면 왼쪽은 두줄이다. 오른쪽은 한줄이고!

이상태에서 왼쪽->오른쪽 드래그를 해보면 더이상 갈 수 없다. 빨간색이 bounce 동안은 볼수 있지만 해당 영역으로 스크롤을 갈 수 없다.

반대로 오른쪽 -> 왼쪽 드래그를 해보면 주황색영역을 볼 수 있다. 

이때부터, 뭔가 내 생각대로 안됨을 인식하기 시작했다.

Leading과 Trailing에 대해 내가 모른단 생각이 들었다.



<br><br>

Trailing에 -100을 줘보자

<img src="/assets/images/2021-03-18/img-20.png" style="zoom:40%;" />

오 오른쪽으로 갈 수 있는 영역이 100 만큼 생겼다. 그치만 Leading과 다르게 좌로는 늘어나지 않고 우로만 늘어났다.

오.. 혼란이 온다... 

Leading과 Trailing은 다르다.

이 얘긴 나중에 하자 길어질듯하다.

공부해서오자.

<br><br>

Leading과 Trailing을 복구 시키고 세로로만 스크롤 되게 해보자

y축을 -100 줘보자.

<img src="/assets/images/2021-03-18/img-23.png" style="zoom:40%;" />



<br><br>

축 자체가 -100이 되기 위해선 x2만큼 늘어나야해서 200이 늘어나게 된다.

어찌 됐든 스크롤은 되지만 영역잡기엔 굉장히 별로 안좋은 방법이다.

그냥 상하좌우와 X,Y축 AutoLayout만으로도 스크롤을 가능하게 할 수 있다! 정도만 알게 되었다.

<br><br>

**Height, Width값 설정**

(Y는 마찬가지로 초기화) 이건 한꺼번에 설정 해도 생각한대로 그려지므로 한꺼번에 설정.

100, 100 으로 잡아보자

<img src="/assets/images/2021-03-18/img-21.png" style="zoom:40%;" />

아주 귀엽게 됐다, 아직은 컨텐츠 양이 작아서 드래그가 안되니 조금 많이 키워보자



<br>

<img src="/assets/images/2021-03-18/img-22.png" style="zoom:40%;" />

오 이것도 된다.

자체적인 Width, Height로도 스크롤은 가능하게 할 수 있다.

<br><br>

하지만, 보통은 X방향 또는 Y방향으로만 스크롤이 되게 하므로 위에 방법들은 보통의 경우에 쓰긴 추천하지 않는다.

 그럼 Y축 스크롤만 예를 들었을때, 좌우 폭을 잡는 방법은 다음과 같은 방식이 있다.

1. Frame Layout Guide와 Width를 동일시한다.
2. ScrollView와 Width를 동일시한다.

<br><br>

둘의 차이점은 없다고 생각한다.

다만, 구조적으로 봤을때 Frame Layout Guide를 사용한다면 스크롤뷰 내의 뷰의 사이즈를 `Guide`들을 이용해서 사이즈를 잡을 수 있다.

<img src="/assets/images/2021-03-18/img-24.png" style="zoom:100%;" />

<br><br>

스크롤뷰 내의 컨텐츠 사이즈를 정의할때, 괜히 엄한것이랑 AutoLayout 잡지 말고 Guide들로 잡아! 라는 뜻이 아닐까?

