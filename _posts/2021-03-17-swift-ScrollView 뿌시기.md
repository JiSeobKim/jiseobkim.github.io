---

layout: post

title: (swift) ScrollView 뿌시기

categories: [Swift, UI]


---

하 DragAnimation Final을 진행중이었는데,

스크롤뷰 생성중에 새로 바뀐 Content Layout Guides을 또 아 이거뭐가 뭐였지? 해버려서



이거부터 진행.

<br>

---

여기보면 `Content Layout Guides` 라는 것이 어느새 새로운것이 추가 되었다.

![](/assets/images/2021-03-17/img.png)

<br>

이거 전에도 스크롤뷰 생성은 공부가 필요했다. 자체 사이즈도 잡아줘야하고, 내용물의 사이즈는 얼마일지도 잡아줘야했다.

위의 옵션을 체크해주면, 스크롤뷰 하위에 다음과 같은 2개가 있는 것을 볼 수 있다.

![](/assets/images/2021-03-17/img-1.png)

<br>

새롭게 추가된 이것은 위에 말한것과 같이 기존에 필요했던 자체 사이즈, 내용물 사이즈를 명시한 느낌이다.

<br><br>

# AutoLayout 적용하기

<br>

**1. 스크롤뷰 추가하기**

<img src="/assets/images/2021-03-17/img-2.png" style="zoom:40%;" />

<br>

**2. AutoLayout 상하좌우 걸기**

<img src="/assets/images/2021-03-17/img-3.png" style="zoom:60%;" />

<br>

**3. 오류 구경하기(컨텐츠 값을 모르겠다! 라는 대충 그런 의미)**

<img src="/assets/images/2021-03-17/img-4.png" style="zoom:40%;" />

<br>

**4. 스크롤뷰 안에 내용물(UIView) 추가하기 - 모호 하다니깐 해주기, 여전히 스크롤뷰 누르면 4같은 에러가 보인다.**

<img src="/assets/images/2021-03-17/img-5.png" style="zoom:40%;" />

<br>

**5. 추가한 `View`의 상하좌우 AutoLayout을 `Content Layout Guide` 의 상하좌우에 걸어준다.** 

(이 부분 귀찮은데 ㅜ 쉽게 하는 방법이 궁금하다.)

<img src="/assets/images/2021-03-17/img-6.png" style="zoom:100%;" />

<br>

**6. 뷰의 Size Inspector에서 Autolayout 값들을 보자, 이상한 값으로 들어가있다**

<img src="/assets/images/2021-03-17/img-7.png" style="zoom:40%;" />

<br>

이는 5와 같은 방식으로 잡아줄 경우 현재의 비율에 비례해서 걸리게 된다.

<br>

**7. 6의 값들을 전부 1 으로 수정**

<img src="/assets/images/2021-03-17/img-8.png" style="zoom:40%;" />

<br>

**8. ScrollView 에러를 다시 보자 - 새로운 에러가 나타난다.**

<img src="/assets/images/2021-03-17/img-9.png" style="zoom:40%;" />

컨텐츠의 사이즈가 모호해! 는 사라졌다. 대신에 위와 같이 X,Width 값 잡고 Y, Height도 필요하다고 나온다. 

<br>

**9. 컨텐츠의 사이즈를 잡아준다.**

가장 일반적으로 세로 스크롤이 되는것이 많다. 이때 Width는 스크롤뷰와 동일하게, 높이는 커스텀하게.

<br>

이때, 우리는 생각을 해야한다. 컨텐츠 레이아웃을 잡았고 필요한건 프레임의 사이즈다. 

따라서, 높이는 수동으로 잡아주고 폭은 스크롤뷰의 `프레임`과 같게! 걸어주며, 이때 초반에 나온 Frame Layout Guide를 사용한다.

<br><br>

폭은 Frame Layout Guide와 동일하게, Height는 400으로 잡아주면 다음과 같이 되며 에러가 사라진다.

<img src="/assets/images/2021-03-17/img-16.png" style="zoom:40%;" />



<br><br>

여기까지만 해도 충분히 스크롤뷰 사용하는데는 문제가 없다. 

다음편은 조금 실험을 하려한다. 

<br>

왜 이전 스크롤뷰 사이즈 잡는 것과 같이 프레임 자체는 ScrollView의 Width나 다른 Width를 안잡고 Frame Layout Guide를 썼을까? 라는 생각을 시작으로 다른것과도 AutoLayout을 잡아볼 예정이다.

<br>

다음 편의 결론을 얘기하면, 다 가능하다 이전과 같이 다른것과 AutoLayout을 걸어도 된다.

초반에 얘기한것처럼 컨텐츠 사이즈와 자체 사이즈를 명시한다는 느낌을 주기위해 Frame Layout Guide를 추가한 것 같다.

<br><br>

애플의 의도는 아마 이것 같다.

>  사이즈를 잡을때 스크롤뷰를 안벗어나고  Content Layout Guide와 Frame Layout Guide만으로 잡아!



