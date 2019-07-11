---
layout: post                       
title: (swift) FileManager
categories: [swift]
---

오늘의 주제는 `FileManager`

쓰게된 이유는 다음과 같다,

사이드 프로젝트를 하고 있는데, Photo kit 관련 해본 경험이 없어서, 이 부분을 직접 써볼려고 앨범 라이브러리를 안쓰는데, 

영상, 이미지, 라이브포토를 앱내에 저장하는 방법이 필요했다. 

NSData로 캐스팅해서 Core Data에 넣으려했는데, 이건 좀 아닌거 같아서 여기저기 물어본 결과

**바이너리 파일(이미지, 영상 등등)**은 **파일**에 저장하고,

**메타데이터(사진 정보, 관련 정보)**만 **Core data**에 저장시키는 방식이 가장 많이 쓰인다고 해서 써보게 됐다. 


# 순서

- `File Manager`란?
- 폴더 추가 방법은?
- 파일 추가 방법은?
- 파일 불러오는 방법은?
- 파일 삭제하는 방법은?

<br>
<br>



# `File Manager`란?

아이폰 앱마다 자기만의 공간을 가지고 있는데, 이 공간을 관리하는 매니저라 생각하면 될 것 같다.

이 공간은 일반 맥, 윈도우처럼 Document 폴더, Download폴더 등등 다양한 종류의 폴더가 있다! 

이 글에선 Document폴더를 사용하여 이것 저것 해보려한다.



# 경로 접근

다른 작업들 하기전 공통 사항인 해당 폴더로 접근 하는 방법을 먼저 알아보자

```
let fileManager = FileManager.default
```
`fileManager`라는 인스턴스를 만들어준다. (default를 해줌으로써 싱글톤 인스턴스!)

<br>
<br>

```
let documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
```

`for`는 폴더를 정해주는 요소입니다. Download 폴더 혹은 Document 폴더 등등

`in`은 제한을 걸어주는 요소입니다. 그 이상은 못가게 하는! 
> **About - Mask**  
> view.layer.masksToBounds = true 많이 보셨을 겁니다.    
> 그렇게 하면 Bound 밖의 UI들은 안보이는!!  
> `in`의 인자들 이름에 붙은 **Mask**는 이런 의미라 생각하면 좋을 것 같다.

<br>
애플이 주석을 굉장히 잘써놨으므로 좀더 디테일하게 보자,

### `for` enum 값들 (Objective C Enum)
```
documentDirectory   // documents (Documents)
developerDirectory  // (Developer) DEPRECATED - there is no one single Developer directory.
desktopDirectory    // location of user's desktop
downloadsDirectory  // location of the user's "Downloads" directory
musicDirectory      // location of user's Music directory (~/Music)
...
```
굉장히 설명을 잘해놨고, 굉장히 많다.  그 중  친숙해 보이는 몇개만 가져왔다. 이런식으로 접근 폴더를 지정해준다.

<br>

### `in` enum 값들 (Swift Enum)
```
public static var userDomainMask: FileManager.SearchPathDomainMask { get } 
// user's home directory --- place to install user's personal items (~)

public static var localDomainMask: FileManager.SearchPathDomainMask { get } 
// local to the current machine --- place to install items available to everyone on this machine (/Library)

public static var networkDomainMask: FileManager.SearchPathDomainMask { get } 
// publically available location in the local area network --- place to install items available on the network (/Network)

public static var systemDomainMask: FileManager.SearchPathDomainMask { get } 
// provided by Apple, unmodifiable (/System)

public static var allDomainsMask: FileManager.SearchPathDomainMask { get } 
// all domains: all of the above and future items
```

터미널을 조금이라도 써봤다면 뒤에 괄호만 봐도 쉽게 이해할 수 있을 것 같다. 

센스있게 저렇게 표현해주니 좋다.


<br>
<br>

# 경로 추가

키워드:  `appendingPathComponent`

아주 간단하다.

```
let newURL = documentsURL.appendingPathComponent("App Photos")
```

간단한 예를 써보면

```
let oldURL = URL(string: "~/Document")
let newURL = documentsURL.appendingPathComponent("Hello")
print(newURL) // ~/Document/Hello
```

아주 간단!





# 폴더 추가 방법은?

키워드: `createDirectory`

```
// 1. 인스턴스 생성
let fileManager = FileManager.default
// 2. 도큐먼트 URL 가져오기
let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
// 3. 생성할 폴더 이름 추가해주기
let directoryURL = documentsURL.appendingPathComponent("NewDirectory")
// 4. 생성하기
do {
    try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: false, attributes: nil)
} catch let e {
    print(e.localizedDescription)
}
```

이것도 아주 간단!

- `at` : 경로 및 폴더명, 위에서 만든 `URL` 사용
- `withIntermediateDirectories` : "중간 디렉토리들도 만들꺼야?" 이런 의미.
- `attributes` : 파일 접근 권한, 그룹 등등 폴더 속성 정의


<br>

다시 말해, 현재 존재하는 폴더가 `~/Document`만 있는 상태에서 `appendingPathComponent`를 여러번해서 `~/Document/path1/path2/path3`로 만들었다고 가정하면, 각 `Bool`값에 따라 성공, 실패가 나뉜다.

- `withIntermediateDirectories: true` - 중간 디렉토리인 `path1/path2`도 만들고 `path3`까지 만든다.
- `withIntermediateDirectories: false` - 중간 디렉토리가 존재하지 않으면 `catch`로 빠진다.



# 파일 추가 방법은?

키워드: `write(to:_, atomically:_, encoding:_)`

```
// 1. 인스턴스 생성 - 동일
let fileManager = FileManager.default

// 2. 도큐먼트 URL 가져오기 - 동일
let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]

// 3. 파일 저장할 Directory 설정
let directoryURL = documentsURL.appendingPathComponent("NewDirectory")

// 4. File 이름 설정
let fileURL = directoryURL.appendingPathComponent("test.txt")

// 5. File 내용
let text = NSString(string: "Hello world")

do {
    // 6-1. 파일 생성
    try text.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8.rawValue)
} catch let e {
    // 6-2. 오류 처리
    print(e.localizedDescription)
}
```

`NSString`에 내부 함수로 `write`가 존재하며, 이를 이용해서 **쓰기**를 한다. 

- `to`: 위에 만든 `URL`을 써주면 그대로 생성.
- `atomically`: 이거 뭔지 모르겠,,, 읽어도 모르겠,,, 다만, `true`면 URL이 존재 안해도 시스템상 손상이 없단 뉘앙스를 풍기므로 `true`만,,
- `encoding`: 인코딩 종류!


여기서 에러가 났던게 파일 경로가 미존재시 "The file “test.txt” doesn’t exist." 라고 catch로 간다.

test.txt는 파일을 이제 만들라는건데 왜 없다고 그래,,? 라고 한참 생각했는데, 다른 테스트하느라 경로를 잘못 셋팅했었다.

허허,, 중간에 다른 경로가 없는건데, 저렇게 설명을 하다니... 그래도 보면 간단하게 이루어진단걸 알 수 있다. 

여기서 또 `write` 할 경우엔, 덮어 씌웠었다.



// TODO: - 이어서 작성하기, 내용 달리해서 다시 쓰기 해보기