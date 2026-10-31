# Astroapp

Astroapp es una aplicación Flutter de divulgación astronómica con noticias, juegos de preguntas y datos del cielo. Tiene dos tipos de cuenta, usuario y administrador. El administrador publica noticias y crea el contenido de los juegos.

## Qué incluye

- Noticias por categoría, con vista completa.
- Cuatro juegos: quiz, verdadero o falso, términos pareados y memorice, con ranking. Quiz y verdadero o falso tienen tres niveles.
- Imagen astronómica del día de la API APOD de la NASA.
- Posición de la Estación Espacial Internacional en un mapa.
- Fase lunar y calendario lunar.
- Registro, login con correo o Google, recuperación de contraseña y edición de perfil.
- Tema claro y oscuro.
- Panel de administración para noticias, categorías y juegos.

## Stack

- Flutter y Dart (SDK `>=3.3.2 <4.0.0`)
- Firebase: Auth, Cloud Firestore y Storage
- `go_router` para la navegación
- `provider`, `flutter_map`, `lottie`, `table_calendar`

## Cómo correrlo

Requiere Flutter instalado. El archivo `lib/firebase_options.dart` ya viene en el repo.

```bash
flutter pub get
flutter run
```

La clave de la API de NASA no va en el código. Sin ella la app usa `DEMO_KEY`, que tiene límite bajo. Para usar la tuya: `flutter run --dart-define=NASA_API_KEY=tu_clave`.

Para elegir plataforma, usa `flutter run -d chrome`, `-d macos` o el id de un dispositivo Android.

## Estructura

```
lib/
  main.dart           inicio y tema
  router/             rutas con go_router
  Login/              registro, login y contraseña
  api/                APOD de la NASA y posición de la ISS
  pagina/             home y perfil
  vistausuario2/      vistas de usuario, juegos y panel admin
assets/               imágenes y animaciones
```

## Estado

Desarrollo principal entre junio y diciembre de 2024. Último commit en mayo de 2025.
