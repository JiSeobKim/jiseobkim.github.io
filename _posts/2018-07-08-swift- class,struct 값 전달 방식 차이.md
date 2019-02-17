---
layout: post                       
title: "(Swift) Class, Struct 값 전달 방식이 다른건 알지만 언제쓰지?"
categories: [Swift]
---

차이가 있다는건 나도 안다! 그치만 쓰임새가 어떻게 다를지 모르겠다!

<br>

마치 고등학교때 배운 미적분 마냥, 배우긴 했지만 어떻게 써먹어야할지 애매했다.

많은 책에서 중요하게 다루는 구조체와 클래스,

다르다는 설명은 많다. 전달 방식에 따라 다른 것 외에도 차이점은 많지만

개발 경력이 얼마 안되서 그런지 실제로 다르게 써야한다고 느낀적이 없었다...

둘이 비슷한정도로만 사용했던 것 같다.

그런데! 개발하다가 **아!! 이때 필요하겠는데?** 라고 최근에 느꼈다.

비스무리한 예를 들어서 포스팅을 해야겠다.

중점은 값을 전달 하는것과 주소 값를 전달 하는것에 맞춰서!

<br><br>

## 예시 구조
학교라는 틀에서 설명을 해보려고한다.

> 학교 : ( 학교 이름 / 학년 리스트 )
<br>
학년 : ( 학년 이름 / 반 리스트 )
<br>
반 : ( 반 이름 / 학생 리스트 )
<br>
학생 정보 : ( 이름 / 번호 )

이런식으로 상위 개념이 하위 개념들을 포함하고 있다고 가정을 하자.

이를 코드로 표현을 해보자.

<br><br>

## Struct

```swift
// 학생 정보
struct StudentInfo {
    var name: String // 학생 이름
    var number: Int  // 학생 번호
}
// 반 정보
struct ClassInfo {
    var className: String           // 반 이름
    var studentList: [StudentInfo]  // 반내의 학생들 리스트(배열)
}
// 학년 정보
struct GradeInfo {
    var gradeName: String      // 학년 이름
    var classList: [ClassInfo] // 학년내의 반 리스트
}
// 학교 정보
struct SchoolInfo {
    var schoolName: String      // 학교 이름
    var gradeList: [GradeInfo]  // 학교내의 학년 리스트
}
```
우선, 여기서 포인트는 모두 **Struct(구조체)** 로 만들었다는 점이다!

간단하니 바로 이어서 선언과 초기화로!

<br><br>

## 선언 및 초기화
구조상 학교/학년/반/학생이 너무 많으면 헷갈릴테니 아래처럼 심플하게 구성
- 학교.학년,반: 1개
- 학생 : 2명

```swift
// 학생 2명!
var student1 = StudentInfo(name: "student 1", number: 0)
var student2 = StudentInfo(name: "student 2", number: 1)

// 반 1개! (2명의 학생을 가지고 있다.)
var class1 = ClassInfo(className: "class 1", studentList: [student1,student2])

// 학년 1개! (1개의 반만 가지고 있고)
var grade1 = GradeInfo(gradeName: "grade 1", classList: [class1])

// 학교 1개! (역시 1개의 학년만 가지고 있다.)
var school1 = SchoolInfo(schoolName: "school 1", gradeList: [grade1])

```

첫번째 상황은 간단하게 내부 구조를 파헤치는 것을 시도해보는 정도로 삼아 간단하게 해보자.

<br><br>

# 상황 1:
## JS씨 모든 학생의 이름을 <br> 따로 배열로 만들어주세요!

내부를 순회하는 방법 중 무난한 2개로 가보자.
1. for문
2. forEach문 (closer 사용)

1은 많은 사람들이 기본적으로 사용하겠지만 2의 경우 이해하면 쉽지만 다소 낯설은 감이 있다.

하지만 익숙해지고 forEach를 종종 쓰게 되었다.

익숙한것부터!
```swift
var nameList: [String] = []
for row1 in school1.gradeList {
    for row2 in row1.classList {
        for row3 in row2.studentList {
            nameList.append(row3.name)
        }
    }
}
```

2중에 3중까지,,, 심플해서 다행이다.
일단 결과값을 보자.
![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-08/image 1.png)

학생1과 학생2가 잘들어갔다.

그럼, 필자가 좋아하는 forEach 를 사용해보자.

```swift
school1.gradeList.forEach {
    $0.classList.forEach {
        $0.studentList.forEach {
            nameList.append($0.name)
        }
    }
}
```
아 좋다. 훨씬 심플하다. 필요한것만 있는 느낌, 마음이 편해진다. (개인취향)

하지만 이건 스위프트 언어 특징인 `타입 추론` 이라는 것 덕분에 심플해보인다.

타입추론을 이용하여 ‘어차피 너는 정해져있어’ 하는 애들을 생략한 것이다.

그렇다면 타입 추론 사용을 안한다면?
```swift
// 생략 x
school1.gradeList.forEach( { (row1) in
    row1.classList.forEach({ (row2) in
        row2.studentList.forEach({ (row3) in
            nameList.append(row3.name)
        })
    })
})
```

별로다. 괄호가 너무 많아서 별로다.

여기선 row에 관해서만 생략이 되었다.

뭘 어떻게 생략했는지, 아니면 관심이 더간다면 **클로저** 검색!

얘기가 잠시 딴길로 샜다. (그치만 클로저란 좋은것)

이 포스팅의 목적이었던, struct와 class 로 돌아가자

이번엔 구조체와 클래스의 차이점을 확실히 보게 될 상황으로 가보자.

책에서 많이 봤을 내용이다.
- 클래스: 주소 정보를 전달
- 구조체: 값을 전달

많이 봤다, 분명히 봤다, 그치만 몰랐다, 언제 써야해?

상황으로 가보자

<br><br>

# 상황 2.
## JS씨 학생들 번호가 0부터 시작했어요, <br>전부 1씩 더해야해요

음 말이 안되는 상황이지만? 이해가 쉽게 개발자가 배열 0번부터 시작해서 나온 귀여운 실수로 가정 해보자.

위에서 이름 추가하는 부분을 살짝 바꾸자
익숙한 for문으로 한다면?
``` swift
for row1 in school1.gradeList {
    for row2 in row1.classList {
        for row3 in row2.studentList {
            row3.number = row3.number + 1
        }
    }
}
```

row3에서 해당을 순서에서 row3.number 값을 +1만 해주면 될까?

결과를 보자

![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-08/image 2.png)

세상에나.. Play Grounds에선 친절하게 한글로 나온다.

근데, 중요한건 에러가 난다는 것이다.  $0은 변경할 수 없다고 한다.

그렇다면 값을 바꾸고 싶다면 어떻게 해야할까?

위에 문법에선 몇번째인지 모른다. row1,2,3의순서가 필요하다

그렇담 이렇게?
```swift
for row1 in 0...school1.gradeList.count - 1 {
    for row2 in 0...school1.gradeList[row1].classList.count - 1 {
        for row3 in 0...school1.gradeList[row2].classList[row2].studentList.count - 1 {
            school1.gradeList[row1].classList[row2].studentList[row3].number = school1.gradeList[row1].classList[row2].studentList[row3].number + 1
        }
    }
}
```

아아아... 끔찍하다. 최악이다. 너무 싫다.
결과는 제대로 나왔나???
![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-08/image 3.png)
제대로 나왔다.
위의 사진에서 프린트 문을 실행한 결과 박스를 보자
값이 다르다

1번 학생에 대해 보자
```swift
// 1. 값 0
student1.number

// 2. 값 1  
school1.gradeList[0].classList[0].studentList[0].number
```
분명 학생 리스트에 0번 학생 정보는 student1이었다. 근데 왜 값이 다를까?

이는 위에 말했듯이 **구조체** 이기 때문이다.

구조체는 값에 의한 전달이기 때문에 값을 카피를 한다.

따라서, 주석 번호 1과 2는 별개의 존재이다

코드상 school1에 값을 더했기 때문에
첫번째 줄은 0이고, 두번째 줄은 1이다

근데 위에 for문은 너무 최악이다. 너무 싫다
배열의 enumerate()라는 메소드가 딱이다.
일단 코드를 보자
```swift
for (x1, row1) in school1.gradeList.enumerated() {
    for (x2, row2) in row1.classList.enumerated() {
        for (x3, row3) in row2.studentList.enumerated(){           
 school1.gradeList[x1].classList[x2].studentList[x3].number = row3.number + 1
        }
    }
}
```

오.. 좋다.. 마음에 평화가 오기  시작한다

> 간단하게 enumerate()에 대해 설명하자면,
<br>- x :현재 카운트 번호
<br>- row : 현재 데이터
<br>라고 생각하자.  그래서 값을 넣을때 각 자리에 x1,x2,x3를 넣어주는 것이다.
<br>그리고 +1 row3.number에 +1을 하는것이고!
<br>but. value += 1 이런 방식이면 더 깔끔
<br>( 이해가 안된다면 천천이 읽어보자.)  


row -> 현재 데이터  
라고 생각하자.  그래서 값을 넣을때 각 자리에 x1,x2,x3를 넣어주는 것이다.  
그리고 +1 row3.number에 +1을 하는것이고!
but. value += 1 이런 방식이면 더 깔끔
( 이해가 안된다면 천천이 읽어보자.)  

그치만 역시나 아쉽다. 값 넣는 부분이 맘에 들지 않는다.

값에 의한 전달이기 때문에 아쉽다. struct라서 아쉽다.


<br><br>

### 그렇다면, 주소값을 전달하는 class라면?

데이터 변경 예정인 `학생 정보`  구조체만 클래스로 바꾸자
```swift
// 학교 정보
class SchoolInfo {
    var schoolName: String      // 학교 이름
    var gradeList: [GradeInfo]  // 학교내의 학년 리스트

    // 초기화 구문
    init (name: String, number: Int){
        self.name = name
        self.number = number
    }
}
```

클래스에선 구조체와 달리 초기값이 필요하다! 그래서 `init` 부분을 넣고!

아까 오류 났던 문법을 다시 보자.
``` swift
for row1 in school1.gradeList {
    for row2 in row1.classList {
        for row3 in row2.studentList {
            row3.number = row3.number + 1
        }
    }
}
```

이 문법의 결과는???

![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-08/image 4.png)

짜잔~ 오른쪽에 2x가 보인다. 학생은 2명이니깐 2번 돌았다는 것이다.

코드 실행이 성공했다!  깔끔해!

그럼 결과를 보자

![](https://raw.githubusercontent.com/JiSeobKim/jiseobkim.github.io/master/static/img/_posts/2018-07-08/image 5.png)

차이점이 보인다.
아까의 결과는 1,2번줄 결과는 분명 초기 값인 0과 1이었다.

그런데, 지금은 school1에 +1 씩 한값으로 변경이 되었다.

클래스는 참조에 의한 전달이니깐 주소로 찾아가서 원본 값을 바꿔준것이다!

<br><br>
### ps.
말로만 듣던
클래스는 참조에 의한 전달
구조체는 값에 의한 전달

언제 다르게 써먹을 수 있을지 생각하고 사용할 수 있는 케이스였다.

어디선간 그런말을 들었다. 뭐 여러 가지 이유는 있었지만
참조에 의한 전달이 아닐땐 구조체를 쓰자~라는?  

이번 케이스를 통해 나눌 필요성을 느꼈다.
하지만 아직 부족하다 좀더 여러케이스가 필요하다.

아참 나는 forEach문 클로저 사용 하는게 더 좋으니깐 이것도 첨부
```swift
// number에 1씩 더하기
school1.gradeList.forEach {
    $0.classList.forEach {
        $0.studentList.forEach {
            $0.number += 1
        }
    }
}
```
Peace!







[jekyll]: http://jekyllrb.com
[jekyll-gh]: https://github.com/jekyll/jekyll
[jekyll-help]: https://github.com/jekyll/jekyll-help