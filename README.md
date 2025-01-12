# Pokemon Pokédex

<b>Pokemon_Library</b>: SwiftUI와 https://pokeapi.co/의 API를 활용한 간단한 포켓몬 도감 앱
<br>
<b>노션으로 보기</b> : https://important-card-5e8.notion.site/30ae1aef49ab49ed91ea8823fad3a2ff?pvs=4


<p align="center">  
<img src="https://github.com/iOS-Ruel/Pokemon_Library/assets/67133244/5e8ad737-4d42-4d2d-9c51-f9bd19021817" align="center" width="32%">  
<img src="https://github.com/iOS-Ruel/Pokemon_Library/assets/67133244/3c743ea2-49f2-46e5-8ec6-8ed0ce5768b0" align="center" width="32%">  
<img src="https://github.com/iOS-Ruel/Pokemon_Library/assets/67133244/25cc432c-0c39-4403-8342-703c80c2a30d" align="center" width="32%">  

## 개요
- SwiftUI를 활용하여 만든 간단한 포켓몬 도감 앱입니다.
- https://pokeapi.co/의 API를 활용하였습니다.
- Clean Architecture를 적용하였습니다.

## 설명
1. https://pokeapi.co/ 에서 제공하는 포켓몬 API를 통해 포켓몬 리스트와 상세페이지 구현
    - 제공 하는 포켓몬 API는 종류가 여러가지가 있음
        1. 리스트 API
            1. [https://pokeapi.co/api/v2/pokemon?offset=\\(pokemonCnt)&limit=20](https://pokeapi.co/api/v2/pokemon?offset=%5C%5C(pokemonCnt)&limit=20)
        2. 포켓몬 번호에 해당하는 상세 데이터 제공 API
            1. https://pokeapi.co/api/v2/pokemon-species/{id or name}/
                1. 해당 API에서 Color, 한글 Name, 한글 정보를 제공 
        3. 포켓몬 종에 대한 상세 API
            1. 리스트 API에서 제공 받은 각 포켓몬의 url (https://pokeapi.co/api/v2/pokemon/1/)
                1. 해당 API에서 포켓몬 몸무게, 키, 이름(영어), 번호, 종등의 정보 제공
        4. 3에서 받은 상세 정보에서 타입 별 언어 리스트를 호출하여 한글과 영어에 대한 값 추출
2. API호출 순서를 위해 Async/await 사용
    1. API 호출시 불러온 데이터를 각각 리스트, 순서에 맞게 처리하기 위하여 사용

    <p align="center">
    <img src="https://github.com/iOS-Ruel/Pokemon_Library/assets/67133244/3fc9a403-7b33-4348-9a0c-57d7ae8d2cfa" align="center" width="49%">  
    <img src="https://github.com/iOS-Ruel/Pokemon_Library/assets/67133244/669edc00-59e6-45aa-8a7d-9403a70da608" align="center" width="49%">  
    
3. swiftUI 사용
    1. 기존 UIKit으로만 프로젝트를 진행해본 경험이 있어 SwiftUI를 사용해보고자 SwiftUI로 프로젝트 진행

4. 폴더링
    <p align="center">
    <img src="https://github.com/user-attachments/assets/d735ca44-07db-4c4d-8666-0945d56c3108   " align="left" width="25%"> 

    <div>
   &nbsp 1. Service<br>
        &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp- 외부 API와의 통신을 담당<br>
    &nbsp 2. Entites<br>
        &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp- API 응답을 받아서 필요한 모델 객체들을 정의<br>
    &nbsp 3. Domain<br>
        &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp- 데이터 호출 로직 분리<br>
    &nbsp 4. Data<br>
        &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp- API에서 가져온 데이터를 가공<br>
    &nbsp 5. Detail<br>
     &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp- 상세 화면에 대한 View, ViewModel 모음<br>
    &nbsp 6. Main <br>
     &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp- 메인 리스트 화면에 대한 View, ViewModel 모음 <br>
    &nbsp 7. Public<br>
     &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp- 모든 곳에서 사용될 코드 모음<br>
    &nbsp 8. Extension<br>
     &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp- 애니메이션에 대한 코드<br>
     &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp- ThemeColor에서 hexString을 사용하기 위해 UIColor를 확장한 코드<br>
      </div>
      






<br><br><br><br><br><br><br><br>
## 3. 트러블슈팅

1. 비동기적으로 API가 호출되어 순서를 보장하지 못해 데이터가 꼬이는 현상 발생
    1. CompletionHanlder를 이용하여 API 호출 후 데이터를 하나로 합치는 작업을 진행하였는데 비동기적으로 호출되기 때문에 원하는 데이터가 순서대로 정렬되지 않는 현상이 발생하여 async/await를 사용하여 순차 호출한 뒤 데이터를 가공
    <img width="1110" alt="ㄴㅊ" src="https://github.com/iOS-Ruel/Pokemon_Library/assets/67133244/5d6d2f3e-eb15-4c38-bf6c-a247b5eb7fcd">

2. swiftUI를 처음 프로젝트에 적용하다보니 body안에 모든 코드가 들어가다 보니 가독성에 대한 문제가 발생
    - 각 view들을 메서드를 통해 return 시켜 분리
        - 각각의 View단위로 분류하게 된다면 view를 return 하는 함수가 많아지게 되면서 가독성이 더 좋지 않은 것 같음 → 추가적인 고민 필요
    ### 개선 전
    ```swift
    struct MainLibraryListRow: View {
    var poke: Pokemon
    @ObservedObject var viewModel: MainLibraryViewModel
    var body: some View {
        VStack(spacing: 5) {
                AsyncImage(url: URL(string: poke.image)) { image in
                    image
                        .resizable()
                        .renderingMode(.original)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 150, height: 150, alignment: .center)
                .background(ThemeColor.typeColor(type: poke.type.first ?? .normal).opacity(0.7)) // 배경에 색상 적용
                .clipShape(RoundedRectangle(cornerRadius: 10)) // 배경도 원형으로 클립      
                HStack {
                    Text("No.\(poke.id)")
                        .foregroundColor(.gray)
                    Spacer()
                }
                .frame(width: 150,alignment: .center)
                HStack {
                    Text("\(poke.name)")
                        .foregroundColor(.black)
                    Spacer()
                }
                .frame(width: 150,alignment: .center)
                HStack(spacing: 5) {
                    ForEach(poke.krType.indices, id: \.self) { index in
                        let type = poke.krType[index]
                        Text(type.name)
                            .foregroundStyle(.white)
                            .frame(width: 75, height: 25, alignment: .center)
                        
                            .background(ThemeColor.typeColor(type: poke.type[index]))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        if poke.krType.count == 1 {
                            Spacer()
                        }
                    }
                }
            .frame(width: 150,alignment: .center)
            }
        }
    }
    ```

    ### 개선 후
    ```swift
    struct MainLibraryListRow: View {
        var poke: Pokemon
        @ObservedObject var viewModel: MainLibraryViewModel
        var body: some View {
            VStack(spacing: 5) {
                pokeImageView()
                pokeIdView()
                pokeNameView()
                pokeTypeView()
            }
        }
        func pokeImageView() -> some View {
            AsyncImage(url: URL(string: poke.image)) { image in
                image
                    .resizable()
                    .renderingMode(.original)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 150, height: 150, alignment: .center)
            .background(ThemeColor.typeColor(type: poke.type.first ?? .normal).opacity(0.7)) // 배경에 색상 적용
            .clipShape(RoundedRectangle(cornerRadius: 10)) // 배경도 원형으로 클립
        }
        func pokeIdView() -> some View {
            HStack {
                Text("No.\(poke.id)")
                    .foregroundColor(.gray)
                
                Spacer()
            }
            .frame(width: 150,alignment: .center)
        }
        func pokeNameView() -> some View {
            HStack {
                Text("\(poke.name)")
                    .foregroundColor(.black)
                Spacer()
            }
            .frame(width: 150,alignment: .center)
        }
        func pokeTypeView() -> some View {
            HStack(spacing: 5) {
                ForEach(poke.krType.indices, id: \.self) { index in
                    let type = poke.krType[index]
                    Text(type.name)
                        .foregroundStyle(.white)
                        .frame(width: 75, height: 25, alignment: .center)
                    
                        .background(ThemeColor.typeColor(type: poke.type[index]))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    if poke.krType.count == 1 {
                        Spacer()
                    }
                }
                
            }
            .frame(width: 150,alignment: .center)
        }
    }
    ```



3. 페이징 처리에 대한 문제 
    - 메인 리스트 뷰에서 스크롤이 최하단에 도달했을때 데이터를 추가적으로 호출하여야 하는데 ZStack가 onAppear 때 첫 데이터를 호출 하는 코드를 넣었는데 상세화면에서 되돌아왔을때도 API를 호출하는 현상 발생
    - ZStack이 onAppear되었을때 조건을 추가하여 첫데이터만 불러오도록 수정
    <img width="409" alt="onappear" src="https://github.com/iOS-Ruel/Pokemon_Library/assets/67133244/86038f9b-3906-4697-ad66-04684d5d6868">

    - 위와 같이 구현했을때 리스트가 맨마지막일때 체크를 하고 추가적인 데이터를 호출해야함 따라서 리스트의 각 셀인 MainLibraryListRow의 onAppear에 조건을 추가하여 페이징 처리
    <img width="798" alt="rowonappear" src="https://github.com/iOS-Ruel/Pokemon_Library/assets/67133244/89a160e3-ce87-4113-9980-929d41301bff">

<br><br><br><br><br><br><br><br>

## 4. 리팩토링
- Clean Architecture 적용 (~1/10)
  ### Domain:
    <b>주요 역할</b>: 비즈니스 로직과 핵심 규칙을 포함. 이 계층은 앱의 나머지 계층에 의존하지 않으며, 앱의 "핵심" 역할.<br>
    예시: Pokemon.swift, PokemonRepositoryProtocol.swift, PokemonUseCase.swift<br>
    <b>변경 사항</b>: 이 계층의 파일은 도메인 모델과 그에 해당하는 비즈니스 로직 담당. 예를 들어, PokemonRepositoryProtocol.swift는 리포지토리 인터페이스를 정의하고, PokemonUseCase.swift는 실제 서비스 계층에서 비즈니스 로직을 처리.<br>

  ### Entities:
    <b>주요 역할</b>: 앱 내에서 공유되는 데이터를 정의하는 계층. 엔티티는 순수한 모델로, 앱 로직에서 직접 사용되는 데이터 구조를 포함.<br>
    예시: PokemonInfoModel.swift, PokeListModel.swift, PokeSpeciesModel.swift<br>
    <b>변경 사항</b>: 이 계층에서 모델을 정의하고, API로부터 받은 데이터를 가공할 때 필요한 엔티티 구조를 설정. Clean Architecture에서 Entities는 Domain 계층의 핵심을 구성.<br>

  ### Service:
    <b>주요 역할</b>: 외부 API 호출 및 데이터 소스를 관리하는 계층. 서비스 계층은 데이터를 가져오고 변환하는 역할.<br>
    예시: PokeAPIService.swift, PokemonAPIRepository.swift<br>
    <b>변경 사항</b>: 외부 API와의 통신 로직을 이곳에서 처리. 예를 들어, PokeAPIService.swift는 외부 API 호출을 관리하고, PokemonAPIRepository.swift는 데이터를 처리.<br>

  ### Public:
    <b>주요 역할</b>: 앱 내에서 공통으로 사용되는 코드들이 이곳에 위치.<br>
    예시: ThemeColor.swift<br>
    <b>변경 사항</b>: 앱 전반에서 공통적으로 사용될 수 있는 코드들을 정의. 예를 들어, 색상 관련 정의나 확장 기능들이 포함.<br>

  ### Extension:
    <b>주요 역할</b>: 앱의 확장을 위한 코드가 위치. 예를 들어, UIKit 및 SwiftUI의 기본 기능에 추가 기능을 제공하는 곳.<br>
    예시: UIColor+Extensions.swift, UIViewController+Extensions.swift<br>
    <b>변경 사항</b>: 애니메이션 처리나 공통적인 뷰 스타일링을 위한 확장 메서드들을 여기에 배치.<br>

  ### Data:
    <b>주요 역할</b>: API에서 가져온 데이터를 가공하고, 각 계층으로 전달하기 위한 모델 객체 포함.<br>
    예시: PokemonDetail.swift<br>
    <b>변경 사항</b>: 데이터를 처리하는 로직을 책임지며, 데이터가 도메인 계층으로 전달되기 전에 가공.<br>

  ### Detail&Main:
    <b>주요 역할</b>: 상세 화면, 메인에 해당하는 뷰 및 뷰 모델 처리.<br>
    예시: DetailPokeInfoView.swift, DetailPokeViewModel.swift, MainLibraryView.swift, MainLibraryListRow.swift, MainLibraryViewModel.swift<br>
    <b>변경 사항</b>: 상세, 메인페이지에서 사용할 뷰 및 뷰 모델을 이곳에 배치. 상세 화면에 관련된 로직 포함<br>


## 5. 개선사항

- 상세 페이지로 화면이 이동할 때 커스텀 애니메이션
- 포켓몬 검색
- 데이터 호출 속도 개선(O)
- combine 적용(O)
- Clean Architecture 적용(O)

## 6. 개인적인 생각

- swiftUI를 처음 사용해 보았는데, 기존 UIKit에 비해 코드 작성이 쉬워지고 자유로워짐을 느꼈다.
- **@State, @Binding, @Environment** 등 프로퍼티 래퍼를 사용하게 되었는데 정리를 하여 확실하게 기억해야겠다.
    - https://github.com/iOS-Ruel/SwiftUI_DiarySample → 학습을 통해 사용해보며 프로퍼티 래퍼 정리
- 화면전환 애니메이션에 있어 제약사항이 많은 것 같다(개인적으로 찾아보았을때…) 아직 swiftUI만 사용하기 보다 UIKit과 함께 사용해야 더 많은 기능을 구현할 수 있을 것 같다
- 혼자 진행하다 보니 깃 브랜치 관리에 대해 소홀했다라고 생각이 들었음. 혼자 하더라도 기능별 브랜치를 만들어 관리하는 습관을 길러야할것 같음
- 기존 MVVM 패턴을 사용하여 프로젝트를 구성하였었고, CleanArchitecture로 리펙토링을 진행하였는데, 현재 프로젝트에서는 Clean Architecture가 과함을 느낌
  - 다만 규모가 큰 프로젝트를 진행할 경우, 협업 또는 테스트코드 작성을 할 때 많은 이점을 누릴 수 있다고 생각함.
  - 협업시에는 각각의 역할의 분리로 명확하게 구성을 파악할 수 있고 역할에 따른 분리로 한 사람이 코드를 구성한 것과 같은 장점이 있을 것 같음
  
