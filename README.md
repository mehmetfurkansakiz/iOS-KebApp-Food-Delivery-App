<h1 align="center">
    KebApp Food Delivery App
</h1>

[TR]🇹🇷
KebApp eğitim amaçlı geliştirilmiş basit bir yemek siparişi uygulamasıdır. Başlangıçta 'Swift ile iOS Geliştirici Eğitim Kampı' için mezuniyet projesi olarak sunmuştum ve mezuniyet sonrası geliştirmeye devam ediyorum. Bu proje, Firebase kullanarak kullanıcı kaydı, oturum açma, kullanıcı veri depolama, profil görüntüleme ve beğenilen öğeleri kaydetme gibi işlevleri kapsıyor. Ek olarak, ürünleri almak, görüntülemek ve sepete eklemek ve sepette görüntülemek için Alamofire paketi kullandım. Ayrıca kodlarımı MVVM mimarisine ve artısı olarak RxSwift'e göre yazdım. Genel olarak bu projem, bootcamp boyunca öğrenilen çeşitli özellikleri, sonrasında araştırarak öğrendiğim şeyleri ve öğrenmeye devam ettikçe neler yapabildiğimi göstermek için tasarlanmış temel bir proje görevi görüyor.

[EN]🇬🇧
KebApp is a simple food ordering application developed for educational purposes. I originally submitted it as a graduation project for the 'iOS Developer Bootcamp with Swift' and I continue to develop it after graduation. This project includes functions such as user registration, login, user data storage, profile viewing and saving liked items using Firebase. In addition, I used the Alamofire package to get, display, and add products to the cart and display them in the cart. I also wrote my code based on the MVVM architecture and RxSwift as a plus. Overall, this project serves as a basic project designed to show the various features learned during the bootcamp, what I learned by researching after, and what I can do as I continue to learn.

## Uygulamadan Ekran Görüntüleri / SS from the app 🏞

| **Login Screen**       | **Register Screen** | **Register Complete Screen** | **Home Screen**       |
|------------------------|---------------------|------------------------------|-----------------------|
|<img src="https://github.com/mehmetfurkansakiz/iOS-KebApp-Food-Delivery-App/assets/62005335/fd09694c-1c35-4a9c-8cad-9014af2702d9"/>|<img src="https://github.com/mehmetfurkansakiz/iOS-KebApp-Food-Delivery-App/assets/62005335/e02d12bb-cf60-40c6-88f0-2b7fd41133ad"/>|<img src="https://github.com/mehmetfurkansakiz/iOS-KebApp-Food-Delivery-App/assets/62005335/7bdcdc34-146a-4e8f-89bb-4ffbc6ae235a"/>|<img src="https://github.com/mehmetfurkansakiz/iOS-KebApp-Food-Delivery-App/assets/62005335/3f1cfc71-199e-4f16-8c81-179787e04c0e"/>|
| **Food Detail Screen** | **Likes Screen**    | **Food Cart Screen**         | **My Profile Screen** |
|<img src="https://github.com/mehmetfurkansakiz/iOS-KebApp-Food-Delivery-App/assets/62005335/9e303da7-5387-45d6-af9b-bfdebf650113"/>|<img src="https://github.com/mehmetfurkansakiz/iOS-KebApp-Food-Delivery-App/assets/62005335/d89a3f81-262e-4830-b1d7-5e512dd0a31b"/>|<img src="https://github.com/mehmetfurkansakiz/iOS-KebApp-Food-Delivery-App/assets/62005335/36f2ca00-d779-44cb-bf8e-8d22cb41534a"/>|<img src="https://github.com/mehmetfurkansakiz/iOS-KebApp-Food-Delivery-App/assets/62005335/5f7606fd-600e-4f73-a4d3-f8f7e51ef37b"/>|

## Uygulamadan Video / Video from the app 📱
<div> 
  <video src='https://github.com/mehmetfurkansakiz/iOS-KebApp-Food-Delivery-App/assets/62005335/c28f7b85-2cb3-4894-94a2-958a893a56d1'/>
</div>

## Teknoloji Paketleri / Tech Stack 📚

* [Firebase Authentication](https://firebase.google.com/docs/auth)
* [Firebase Firestore](https://firebase.google.com/docs/firestore)
* [Firebase Storage](https://firebase.google.com/docs/storage)
* [Kingfisher](https://github.com/onevcat/Kingfisher)
* [Alamofire](https://github.com/Alamofire/Alamofire)
* [SkeletonView](https://github.com/Juanpe/SkeletonView)
* [RxSwift](https://github.com/ReactiveX/RxSwift)

## Mimari / Architecture 📐
<div>
  <img src="https://github.com/mehmetfurkansakiz/iOS-KebApp-Food-Delivery-App/assets/62005335/ad25f86b-99de-44a4-a590-b02b73760752" width="1400" height="360"/>
</div>

[TR]🇹🇷
Uygulama, MVVM mimarisi ile birlikte RxSwift kütüphanesini kullanmaktadır. MVVM, kodu Model, View ve ViewModel olarak üç temel bileşene bölerken, RxSwift reaktif programlama prensiplerini ekleyerek olay odaklı ve tepki veren bir programlama modelini destekler. Bu tasarım deseni ve reaktif programlama, temiz, modüler ve etkileşimli bir kod yapısı oluşturmamıza olanak tanır. Bu yaklaşım, kodun daha anlaşılır ve bakımı daha kolay olmasının yanı sıra test edilebilirlik, reaktivite ve asenkron programlama avantajlarını da beraberinde getirir.

---
[EN]🇬🇧
The app utilizes the MVVM architecture along with the RxSwift library. MVVM divides our code into three essential components: Model, View, and ViewModel, while RxSwift introduces reactive programming principles, supporting an event-driven and responsive programming model. This design pattern, combined with reactive programming, enables us to create a clean, modular, and interactive code structure. This approach not only enhances code clarity and maintainability but also brings advantages such as testability, reactivity, and asynchronous programming.
