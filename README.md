<h1 align="center">
    KebApp Food Delivery App
</h1>

[TR]🇹🇷
KebApp eğitim amaçlı geliştirilmiş basit bir yemek siparişi uygulamasıdır. Başlangıçta 'Swift ile iOS Geliştirici Eğitim Kampı' için mezuniyet projesi olarak sunmuştum ve mezuniyet sonrası geliştirmeye devam ediyorum. Bu proje, Firebase kullanarak kullanıcı kaydı, oturum açma, kullanıcı veri depolama, profil görüntüleme ve beğenilen öğeleri kaydetme gibi işlevleri kapsıyor. Ek olarak ürün bilgilerini görüntülemek, sepete eklemek, sepetten silmek ve sepette görüntülemek için Alamofire paketi kullandım. Ayrıca kodlarımı MVVM mimarisine ve artısı olarak RxSwift'e göre yazdım. Genel olarak bu projem, bootcamp boyunca öğrenilen çeşitli özellikleri, sonrasında araştırarak öğrendiğim şeyleri ve öğrenmeye devam ettikçe neler yapabildiğimi göstermek için tasarlanmış temel bir proje görevi görüyor.

[EN]🇬🇧
KebApp is a simple food ordering application developed for educational purposes. I originally submitted it as a graduation project for the 'iOS Developer Bootcamp with Swift' and I continue to develop it after graduation. This project includes functions such as user registration, login, user data storage, profile viewing and saving liked items using Firebase. In addition, I used the Alamofire package to get, display, and add products to the cart or delete and display them in the cart. I also wrote my code based on the MVVM architecture and RxSwift as a plus. Overall, this project serves as a basic project designed to show the various features learned during the bootcamp, what I learned by researching after, and what I can do as I continue to learn.

## SS from the app 🏞

| Loading Screen                                                                                                                                   | Login Screen                                                                                                                                    | Register Screen                                                                                                                                  | Register Complete Screen                                                                                                                         |
|:------------------------------------------------------------------------------------------------------------------------------------------------:|:-----------------------------------------------------------------------------------------------------------------------------------------------:|:------------------------------------------------------------------------------------------------------------------------------------------------:|:------------------------------------------------------------------------------------------------------------------------------------------------:|
| <img src="https://github.com/mehmetfurkansakiz/iOS-KebApp-Food-Delivery-App/assets/62005335/642c2d94-59bc-4c3c-83cb-333d84bb3ef7" width="480" /> | <img src="https://github.com/mehmetfurkansakiz/iOS-KebApp-Food-Delivery-App/assets/62005335/78081fe0-23b6-4a38-8a83-87a6b87a8c3a" width="480"/> | <img src="https://github.com/mehmetfurkansakiz/iOS-KebApp-Food-Delivery-App/assets/62005335/8995eca3-7ef6-41a1-bc3a-0215b7d5bab1" width="480" /> | <img src="https://github.com/mehmetfurkansakiz/iOS-KebApp-Food-Delivery-App/assets/62005335/7bdcdc34-146a-4e8f-89bb-4ffbc6ae235a" width="480" /> |

| Home Screen                                                                                                                                      | Food Detail Screen                                                                                                                              | Likes Screen                                                                                                                                     | Food Cart Screen                                                                                                                                 |
|:------------------------------------------------------------------------------------------------------------------------------------------------:|:-----------------------------------------------------------------------------------------------------------------------------------------------:|:------------------------------------------------------------------------------------------------------------------------------------------------:|:------------------------------------------------------------------------------------------------------------------------------------------------:|
| <img src="https://github.com/mehmetfurkansakiz/iOS-KebApp-Food-Delivery-App/assets/62005335/14d10ca7-8633-46ce-819b-2b804924666f" width="480" /> | <img src="https://github.com/mehmetfurkansakiz/iOS-KebApp-Food-Delivery-App/assets/62005335/c76007d3-4367-40f1-a83c-dc331369d43b" width="480"/> | <img src="https://github.com/mehmetfurkansakiz/iOS-KebApp-Food-Delivery-App/assets/62005335/7a2bedec-7c33-4bc4-9ed1-f31ef290586e" width="480" /> | <img src="https://github.com/mehmetfurkansakiz/iOS-KebApp-Food-Delivery-App/assets/62005335/bb20a100-45fa-4f9c-b010-b51ce90efe47" width="480" /> |

| My Profile Screen                                                                                                                           | Addresses Screen                                                                                                                                | Address(Add) Screen                                                                                                                              | Address(Edit) Screen                                                                                                                             |
|:-------------------------------------------------------------------------------------------------------------------------------------------:|:-----------------------------------------------------------------------------------------------------------------------------------------------:|:------------------------------------------------------------------------------------------------------------------------------------------------:|:------------------------------------------------------------------------------------------------------------------------------------------------:|
| <img src="https://github.com/mehmetfurkansakiz/iOS-KebApp-Food-Delivery-App/assets/62005335/aa8dce0e-d419-4fbc-a1fe-6fd351863517" width="480" /> | <img src="https://github.com/mehmetfurkansakiz/iOS-KebApp-Food-Delivery-App/assets/62005335/5b3286e3-de0c-4759-ad9a-22a4591c2ae4" width="480"/> | <img src="https://github.com/mehmetfurkansakiz/iOS-KebApp-Food-Delivery-App/assets/62005335/55065623-d6fa-4c27-980a-0b1e728f8577" width="480" /> | <img src="https://github.com/mehmetfurkansakiz/iOS-KebApp-Food-Delivery-App/assets/62005335/8639e575-15f1-4c9c-ac2a-9dc98f35a641" width="480" /> |

| Payment Methods Screen                                                                                                                           | Card(Add) Screen                                                                                                                                 | Card(Edit) Screen                                                                                                                                |
|:------------------------------------------------------------------------------------------------------------------------------------------------:|:------------------------------------------------------------------------------------------------------------------------------------------------:|:------------------------------------------------------------------------------------------------------------------------------------------------:|
| <img src="https://github.com/mehmetfurkansakiz/iOS-KebApp-Food-Delivery-App/assets/62005335/9c97474c-c6f6-46ac-a757-601b59f776cc" width="480" /> | <img src="https://github.com/mehmetfurkansakiz/iOS-KebApp-Food-Delivery-App/assets/62005335/abcf0ff5-6043-4335-9b3b-803b5be24ec8" width="480" /> | <img src="https://github.com/mehmetfurkansakiz/iOS-KebApp-Food-Delivery-App/assets/62005335/92d3d828-1eef-4309-85e2-66cf4e51d264" width="480" /> |

| Checkout(1) Screen                                                                                                                               | Checkout(2) Screen                                                                                                                               | Order Confirm Screen                                                                                                                             |
|:------------------------------------------------------------------------------------------------------------------------------------------------:|:------------------------------------------------------------------------------------------------------------------------------------------------:|:------------------------------------------------------------------------------------------------------------------------------------------------:|
| <img src="https://github.com/mehmetfurkansakiz/iOS-KebApp-Food-Delivery-App/assets/62005335/a9dfb487-fd94-46e9-a9ba-4131f8bc5080" width="480" /> | <img src="https://github.com/mehmetfurkansakiz/iOS-KebApp-Food-Delivery-App/assets/62005335/72e91c91-264e-4292-8cd1-1507707bf046" width="480" /> | <img src="https://github.com/mehmetfurkansakiz/iOS-KebApp-Food-Delivery-App/assets/62005335/ae1763a4-410c-46b7-91ae-1cf0ff3680eb" width="480" /> |

## Video from the app (OLD)📱
<div> 
  <video src='https://github.com/mehmetfurkansakiz/iOS-KebApp-Food-Delivery-App/assets/62005335/c28f7b85-2cb3-4894-94a2-958a893a56d1'/>
</div>

## Tech Stack 📚

* [Firebase Authentication](https://firebase.google.com/docs/auth)
* [Firebase Firestore](https://firebase.google.com/docs/firestore)
* [Firebase Storage](https://firebase.google.com/docs/storage)
* [Kingfisher](https://github.com/onevcat/Kingfisher)
* [Alamofire](https://github.com/Alamofire/Alamofire)
* [SkeletonView](https://github.com/Juanpe/SkeletonView)
* [RxSwift](https://github.com/ReactiveX/RxSwift)

## Architecture 📐
<div>
  <img src="https://github.com/mehmetfurkansakiz/iOS-KebApp-Food-Delivery-App/assets/62005335/ad25f86b-99de-44a4-a590-b02b73760752"/>
</div>

[TR]🇹🇷
Uygulama, MVVM mimarisi ile birlikte RxSwift kütüphanesini kullanmaktadır. MVVM, kodu Model, View ve ViewModel olarak üç temel bileşene bölerken, RxSwift reaktif programlama prensiplerini ekleyerek olay odaklı ve tepki veren bir programlama modelini destekler. Bu tasarım deseni ve reaktif programlama, temiz, modüler ve etkileşimli bir kod yapısı oluşturmamıza olanak tanır. Bu yaklaşım, kodun daha anlaşılır ve bakımı daha kolay olmasının yanı sıra test edilebilirlik, reaktivite ve asenkron programlama avantajlarını da beraberinde getirir.

---
[EN]🇬🇧
The app utilizes the MVVM architecture along with the RxSwift library. MVVM divides our code into three essential components: Model, View, and ViewModel, while RxSwift introduces reactive programming principles, supporting an event-driven and responsive programming model. This design pattern, combined with reactive programming, enables us to create a clean, modular, and interactive code structure. This approach not only enhances code clarity and maintainability but also brings advantages such as testability, reactivity, and asynchronous programming.
