# Pokemon Pokédex

<b>Pokemon_Library</b>: SwiftUI와 https://pokeapi.co/의 API를 활용한 간단한 포켓몬 도감 앱


<p align="center">  
<img src="https://github.com/iOS-Ruel/Pokemon_Library/assets/67133244/5e8ad737-4d42-4d2d-9c51-f9bd19021817" align="center" width="32%">  
<img src="https://github.com/iOS-Ruel/Pokemon_Library/assets/67133244/3c743ea2-49f2-46e5-8ec6-8ed0ce5768b0" align="center" width="32%">  
<img src="https://github.com/iOS-Ruel/Pokemon_Library/assets/67133244/25cc432c-0c39-4403-8342-703c80c2a30d" align="center" width="32%">  

## 개요
- SwiftUI를 활용하여 만든 간단한 포켓몬 도감 앱입니다.
- https://pokeapi.co/의 API를 활용하였습니다.

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
    <p align="center>
    <img src="https://github.com/iOS-Ruel/Pokemon_Library/assets/67133244/ae7aec26-5563-45f8-961c-800ca46c025e" align="center" width="32%">  
    <img src="https://github.com/iOS-Ruel/Pokemon_Library/assets/67133244/87bbd1ab-6261-4919-bd37-805dfde8fea3" align="center" width="32%">  
    