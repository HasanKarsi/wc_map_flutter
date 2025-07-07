<h1>Tuvalet Takip Uygulaması</h1>

<p><strong>Tuvalet Takip Uygulaması</strong>, kullanıcıların tuvalet alışkanlıklarını takip etmek amacıyla geliştirilmiş, Flutter ile yazılmış ve Firebase destekli Android uygulamasıdır. Veriler bulutta güvenli şekilde saklanır ve kolayca yönetilir.</p>

<hr />

<h2>Özellikler</h2>
<ul>
  <li><strong>Kullanıcı Onboarding:</strong> İlk açılışta kullanıcı adı ve konum seçilir ve kaydedilir.</li>
  <li><strong>Tuvalet Kayıtları:</strong> Tarih-saat, oturma süresi, tuvalete gitme sebebi, dışkı miktarı ve kıvamı gibi detaylı bilgiler girilebilir.</li>
  <li><strong>Filtreleme ve Listeleme:</strong> Kayıtlar kullanıcı adı, konum, tarih aralığı ve diğer kriterlere göre filtrelenebilir.</li>
  <li><strong>Kayıt Güncelleme ve Silme:</strong> Var olan kayıtlar kolayca güncellenebilir veya silinebilir.</li>
  <li><strong>Firebase Entegrasyonu:</strong> Veriler Firestore üzerinde gerçek zamanlı olarak yönetilir.</li>
  <li><strong>Provider Durum Yönetimi:</strong> Uygulamanın durumu Provider paketi ile yönetilir.</li>
  <li><strong>Platform:</strong> Android cihazlar için optimize edilmiştir.</li>
</ul>

<hr />

<h2>Kurulum ve Çalıştırma</h2>

<h3>Gereksinimler</h3>
<ul>
  <li>Flutter SDK (3.0.0 veya üzeri)</li>
  <li>Android Studio veya Visual Studio Code</li>
  <li>Firebase Hesabı ve Projesi</li>
</ul>

<h3>Adımlar</h3>
<ol>
  <li>Depoyu klonlayın:
    <pre><code>git clone https://github.com/HasanKarsi/flutter_wc_app.git
cd tuvalet-takip</code></pre>
  </li>
  <li>Gerekli Flutter paketlerini yükleyin:
    <pre><code>flutter pub get</code></pre>
  </li>
  <li>Firebase yapılandırmasını yapın:
    <ul>
      <li>Firebase Console'da proje oluşturun.</li>
      <li><code>flutterfire configure</code> komutunu kullanarak <code>firebase_options.dart</code> dosyasını oluşturun.</li>
    </ul>
  </li>
  <li>Uygulamayı çalıştırın:
    <pre><code>flutter run</code></pre>
  </li>
</ol>

<hr />

<h2>⚠️ Önemli: Firebase Dosyalarını Ekleyin</h2>
<p>Bu projede güvenlik nedeniyle aşağıdaki dosyalar repoda yer almamaktadır:</p>
<ul>
  <li><code>lib/firebase_options.dart</code></li>
  <li><code>android/app/google-services.json</code></li>
  <li><code>ios/Runner/GoogleService-Info.plist</code></li>
</ul>
<p>Projeyi çalıştırmak için:</p>
<ol>
  <li>Kendi Firebase projenizi oluşturun.</li>
  <li>Android ve iOS için gerekli yapılandırma dosyalarını Firebase Console’dan indirin.</li>
  <li>Terminalde aşağıdaki komutu çalıştırarak <code>firebase_options.dart</code> dosyasını oluşturun:
    <pre><code>flutterfire configure</code></pre>
  </li>
  <li>İlgili dosyaları yukarıda belirtilen yerlere ekleyin.</li>
</ol>
<p>Daha fazla bilgi için <a href="https://firebase.flutter.dev/docs/overview/" target="_blank">FlutterFire Dokümantasyonu</a>’na bakabilirsiniz.</p>

<hr />

<h2>Proje Mimarisi</h2>
<ul>
  <li><code>lib/models/</code> — Veri modelleri (örn. <code>ToiletRecord</code>, <code>User</code>)</li>
  <li><code>lib/providers/</code> — Provider ile durum yönetimi</li>
  <li><code>lib/services/</code> — Firebase ve diğer servis bağlantıları</li>
  <li><code>lib/views/</code> — UI ekranları (Onboarding, Home, Listeleme, Kayıt Ekleme vb.)</li>
</ul>

<hr />

<h2>Teknolojiler</h2>
<ul>
  <li>Flutter (Dart)</li>
  <li>Firebase Firestore</li>
  <li>Provider State Management</li>
</ul>

<hr />

<h2>İletişim</h2>
<p>Herhangi bir soru, öneri ya da katkı için <a href="mailto:karsihasanofficial@gmail.com">karsihasanofficial@gmail.com</a> adresinden bana ulaşabilirsiniz.</p>

<a href="https://github.com/HasanKarsi/flutter_wc_app" target="_blank" class="button-like">GitHub Deposu</a>

</body>
</html>
