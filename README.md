# QuePlan - Descubre Eventos Cerca de Ti

![Flutter](https://img.shields.io/badge/Flutter-3.9+-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.9+-0175C2?logo=dart&logoColor=white)
![Supabase](https://img.shields.io/badge/Supabase-2.10+-3ECF8E?logo=supabase&logoColor=white)

QuePlan es una aplicación Flutter profesional que te ayuda a descubrir y compartir eventos locales, fiestas, mercadillos y actividades cerca de ti.

## 🎯 Características Principales

- 🔍 **Búsqueda Inteligente**: Encuentra eventos por categoría, ciudad o proximidad
- 📍 **Ubicación**: Filtra eventos por distancia usando tu ubicación
- ⭐ **Eventos Destacados**: Descubre los eventos más populares
- 💾 **Favoritos**: Guarda tus eventos favoritos para no perdértelos
- 📱 **Multiplataforma**: Disponible para Android e iOS
- 🌍 **Multiidioma**: Soporte para español, inglés, alemán y chino

## 🏗️ Arquitectura

- **Framework**: Flutter 3.9+
- **Backend**: Supabase (PostgreSQL + Auth + Storage)
- **Estado**: Provider para gestión de estado
- **Notificaciones**: Firebase Cloud Messaging
- **Analytics**: Firebase Analytics
- **Maps**: Google Maps & Flutter Map

## 🚀 Tecnologías

### Principales
- `supabase_flutter` - Backend y autenticación
- `provider` - Gestión de estado
- `firebase_core` - Firebase services
- `firebase_messaging` - Notificaciones push
- `firebase_analytics` - Analytics
- `google_maps_flutter` - Mapas de Google
- `geolocator` - Ubicación del usuario

### UI/UX
- `cached_network_image` - Caché de imágenes
- `shimmer` - Efectos de carga
- `fl_chart` - Gráficos para dashboard admin

## 📦 Instalación

1. Clona el repositorio:
```bash
git clone <repository-url>
cd fiestapp
```

2. Instala las dependencias:
```bash
flutter pub get
```

3. Configura las variables de entorno:
```bash
cp .env.example .env
# Edita .env con tus credenciales de Supabase y Firebase
```

4. Ejecuta la aplicación:
```bash
flutter run
```

## 🔧 Configuración

### Variables de Entorno Requeridas

Crea un archivo `.env` en la raíz del proyecto con:

```env
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
GOOGLE_MAPS_API_KEY=your_google_maps_api_key
# Opcional: bucket público de videos de splash (video_1.mp4 … video_12.mp4). Por defecto: splash-videos
SPLASH_VIDEO_BUCKET=splash-videos
```

### Firebase

Configura Firebase para notificaciones push y analytics:
- Agrega `google-services.json` (Android) en `android/app/`
- Configura Firebase en iOS si es necesario

## 📱 Estructura del Proyecto

```
lib/
├── config/          # Configuración
├── data/            # Repositorios de datos
├── models/          # Modelos de datos
├── providers/       # Providers para gestión de estado
├── services/        # Servicios (API, Auth, etc.)
├── ui/              # Interfaces de usuario
│   ├── admin/       # Pantallas de administración
│   ├── auth/        # Autenticación
│   ├── dashboard/   # Dashboard principal
│   └── events/      # Gestión de eventos
└── utils/           # Utilidades
```

## 🧪 Testing

```bash
flutter test
```

## 📄 Licencia

Este proyecto es privado. Todos los derechos reservados.

## 👥 Contribuir

Para contribuir, por favor contacta al equipo de desarrollo.

---

**Desarrollado con ❤️ usando Flutter**
