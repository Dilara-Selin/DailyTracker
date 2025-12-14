# DailyTracker

DailyTracker, kullanıcıların yeni alışkanlıklar kazanmasına ve "Zinciri Kırma" (Don't Break the Chain) metoduyla süreklilik sağlamasına yardımcı olan modern bir iOS uygulamasıdır.

SwiftUI ve Core Data teknolojileri kullanılarak, MVVM mimarisine sadık kalınarak geliştirilmiştir.

✨ Özellikler

⚡️ Alışkanlık Yönetimi: Kolayca yeni alışkanlık ekleyin, silin ve düzenleyin.

🔥 Streak (Seri) Sistemi: Alışkanlıklarınızı üst üste kaç gün sürdürdüğünüzü takip edin.

📊 Gelişmiş Grafikler: Apple Swift Charts ile son 7 günlük performansınızı görselleştirin.

🏆 Oyunlaştırma : Tamamlanan görev sayısına göre "Acemi", "Usta", "Efsane" gibi seviye rozetleri kazanın.

🔔 Akıllı Bildirimler: Her alışkanlık için özel saatte hatırlatıcı kurun.

📌 Sabitleme & Sıralama: Önemli alışkanlıkları en başa sabitleyin veya seriye göre sıralayın.

🎨 Tema & İkonlar: Her alışkanlık için farklı renk ve ikon seçeneği.

👤 Profil Özelleştirme: Profil fotoğrafı ve isim düzenleme.

🌙 Karanlık Mod: Tam uyumlu Dark Mode desteği.

🛠 Kullanılan Teknolojiler
Bu proje aşağıdaki teknolojiler ve kütüphaneler kullanılarak geliştirilmiştir:

Dil: Swift 5

UI Framework: SwiftUI

Veritabanı: Core Data (Yerel Kalıcı Depolama)

Mimari: MVVM (Model-View-ViewModel)

Grafik: Swift Charts

Bildirimler: UserNotifications Framework

Depolama: @AppStorage & UserDefaults

📂 Proje Mimarisi
Proje, okunabilirlik ve sürdürülebilirlik açısından modüler bir yapıda tasarlanmıştır:

Model: Habit (Core Data Entity), HabitTheme

View: HabitListView, HabitDetailView, ProfileView, SettingsView

ViewModel: HabitListViewModel (İş mantığı ve UI durumu yönetimi)

Services: CoreDataManager (Singleton yapısında veritabanı yönetimi)

🚀 Kurulum
Projeyi yerel makinenizde çalıştırmak için adımları takip edin:

Repoyu klonlayın:

Bash
git clone (https://github.com/Dilara-Selin/DailyTracker/git)

DailyTracker.xcodeproj dosyasını Xcode ile açın.

Projenin derlenmesi için paketlerin yüklenmesini bekleyin.

Bir Simülatör (iPhone 15/16 Pro önerilir) seçin ve CMD+R ile çalıştırın.

🤝 Katkıda Bulunma
Katkıda bulunmak isterseniz lütfen önce bir Issue açarak neyi değiştirmek istediğinizi belirtin. Pull request'ler memnuniyetle karşılanır.

Bu repoyu Fork'layın.

Yeni bir Branch oluşturun (git checkout -b ozellik/YeniOzellik).

Değişikliklerinizi Commit'leyin (git commit -m 'Yeni özellik eklendi').

Branch'i Push'layın (git push origin ozellik/YeniOzellik).

Bir Pull Request oluşturun.



<p align="center"> <sub>Developed with ❤️ by <a href="https://github.com/Dilara-Selin">Dilara Selin</a></sub> </p>
