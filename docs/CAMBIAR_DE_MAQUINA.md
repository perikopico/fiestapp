# Cambiar de máquina (Ubuntu ↔ Windows ↔ Mac)

Guía rápida de qué debes **trasladar o recrear** cuando cambias de PC. El resto del proyecto se sincroniza con Git (`git clone` / `git pull`).

---

## 1. Sobre la carpeta `assets`

**La carpeta `assets/` NO está en `.gitignore`.** Si no ves los assets en GitHub es porque esos archivos están **sin añadir** (untracked). Para subirlos:

```bash
git add assets/
git status   # revisar qué se va a subir
git commit -m "Añadir assets (logos, videos, etc.)"
git push
```

En el otro PC, con `git pull` ya tendrás `assets/`. No hace falta copiarlos a mano.

---

## 2. Archivos que SÍ debes copiar (están en .gitignore)

Estos archivos **no se suben a GitHub** por seguridad. Cópialos a mano (USB, nube privada, gestor de contraseñas, etc.) cuando cambies de máquina.

| Archivo / carpeta | Dónde | Para qué |
|-------------------|--------|----------|
| **`.env`** | Raíz del proyecto | Supabase (URL, anon key), otras variables de entorno. **Imprescindible** para que la app arranque. |
| **`android/app/google-services.json`** | Android | Configuración de Firebase (proyecto, APIs). Necesario para notificaciones y Analytics en Android. |
| **`ios/Runner/GoogleService-Info.plist`** | iOS | Misma configuración de Firebase para iOS. En el repo hay un `GoogleService-Info.plist.example` como plantilla. |

### Opcional (solo si firmas la app para publicar)

| Archivo | Dónde | Para qué |
|---------|--------|----------|
| **`android/key.properties`** | `android/` | Ruta al keystore y contraseñas de firma (release). |
| **`*.jks` o `*.keystore`** | Donde lo tengas guardado | Keystore de firma para Android. **Guárdalo en sitio seguro y haz copia de seguridad.** |

---

## 3. Qué NO hace falta copiar

- **`local.properties`** (Android): se genera en cada máquina con la ruta del SDK. Lo crea Android Studio / Flutter.
- **`build/`**, **`.dart_tool/`**, **`.gradle/`**, **`Pods/`**, etc.: se regeneran con `flutter pub get`, `flutter run`, `pod install`.
- **`venv/`** (Python): si usas scripts con venv, en el otro PC puedes crear uno nuevo y `pip install -r requirements.txt` (si tienes ese archivo).

---

## 4. Checklist al llegar al otro PC

1. **Clonar o actualizar el repo**
   ```bash
   git clone <url-del-repo>   # primera vez
   # o
   git pull                   # si ya lo tenías clonado
   ```

2. **Copiar archivos ignorados**
   - Pegar `.env` en la raíz del proyecto.
   - Copiar `google-services.json` en `android/app/`.
   - Copiar `GoogleService-Info.plist` en `ios/Runner/` (o generarlo desde Firebase y sustituir el example).

3. **Flutter**
   ```bash
   flutter pub get
   ```

4. **Solo si vas a ejecutar en iOS**
   ```bash
   cd ios && pod install && cd ..
   ```

5. **Probar**
   ```bash
   flutter run
   ```

---

## 5. Resumen mínimo

Para poder trabajar en otro Ubuntu/Windows/Mac necesitas:

- Tener el código actualizado con Git.
- Tener **`.env`** en la raíz.
- Tener **`google-services.json`** (Android) y **`GoogleService-Info.plist`** (iOS) si usas Firebase.

El resto (incluida la carpeta **assets** si la subes al repo) se obtiene con `git pull`.
