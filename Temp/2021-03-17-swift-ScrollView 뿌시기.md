---

layout: post

title: (swift) ScrollView 뿌시기

categories: [Swift, UI]


---




# 실험



위의 8부터 다시보고 차근차근 봐보자, 이것 저것 실험하기

컨텐츠의 사이즈가 모호해! 는 사라졌다. 대신에 위와 같이 X,Width 값 잡고 Y, Height도 필요하다고 나온다. 

하나씩 다잡아보자 X 또는 Width, Y 또는 Height.



**X값 설정**

센터로 설정을 해보자

<img src="/Users/jiseob/Desktop/스크린샷/img-10.png" style="zoom:80%;" />

<img src="/Users/jiseob/Desktop/스크린샷/img-11.png" style="zoom:40%;" />

x 값을 잡아줬더니 x또는 Width 잡으라는 경고는 사라졌다. 그리곤 ScrollView의 폭만큼 늘어났다





**Y값 설정**

X는 다시 지워주고 Y만 센터로 해보자

<img src="/Users/jiseob/Desktop/스크린샷/img-12.png" style="zoom:80%;" />

<img src="/Users/jiseob/Desktop/스크린샷/img-13.png" style="zoom:40%;" />

마찬가지로 y|height 잡으라는 경고는 사라졌다. 그리곤 ScrollView의 높이만큼 늘어났다.



**X,Y값 설정**

둘다 센터 0으로 잡아보자

<img src="/Users/jiseob/Desktop/스크린샷/img-14.png" style="zoom:40%;" />



모든 에러가 사라졌다. 그리고 ScrollView와 같은 사이즈가 되었다.

Content Layout Guide와의 상하좌우를 0으로 맞추고 센터를 0,0잡아준 결과이다.



Content Layout Guide와의 좌,우 를 100 잡아보자

<img src="/Users/jiseob/Desktop/스크린샷/img-15.png" style="zoom:40%;" />





**Height, Width값 설정**

(Y는 마찬가지로 초기화) 이건 한꺼번에 설정 해도 생각한대로 그려지므로 한꺼번에 설정.

100, 100 으로 잡아보자











