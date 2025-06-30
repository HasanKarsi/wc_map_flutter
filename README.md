<!DOCTYPE html>
<html lang="tr">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Tuvalet Takip Uygulaması - README</title>
<style>
  body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    max-width: 900px;
    margin: 2rem auto;
    padding: 1rem 2rem;
    background: #f9f9f9;
    color: #333;
    line-height: 1.6;
  }
  h1, h2, h3 {
    color: #5a3e1b;
  }
  code {
    background-color: #eaeaea;
    padding: 0.2em 0.4em;
    border-radius: 3px;
    font-family: Consolas, monospace;
  }
  pre {
    background: #272822;
    color: #f8f8f2;
    padding: 1em;
    border-radius: 6px;
    overflow-x: auto;
  }
  a {
    color: #bc6c25;
    text-decoration: none;
  }
  a:hover {
    text-decoration: underline;
  }
  ul {
    margin-top: 0;
  }
  hr {
    border: none;
    border-top: 1px solid #ddd;
    margin: 2rem 0;
  }
  .button-like {
    display: inline-block;
    padding: 0.4em 1em;
    margin: 0.5em 0;
    background-color: #bc6c25;
    color: white;
    border-radius: 4px;
    text-decoration: none;
    font-weight: 600;
  }
  .button-like:hover {
    background-color: #a05a1f;
  }
</style>
</head>
<body>

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
