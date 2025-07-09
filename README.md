# Prueba Técnica - Flutter Developer

- La primera pantalla debe ser un Login con inicio de sesión con usuario y contraseña e ingreso mediante Google y Hotmail (usar third party sign).
- Integrar la API https://mocki.io/v1/c5a90d24-be6d-480c-95cc-3d5deb95ed46 y guardar la información en BD una vez que la API responda. Si no hay conexión a internet y la información ya se encuentra almacenada en la aplicación, deberá mostrar esa información. En caso de que no exista mostrar un mensaje en pantalla indicando que no hay conexión a internet y un botón de reintentar. 
- En la pantalla principal se debe mostrar una lista de usuarios con la opción de ver la ubicación con google maps dentro de la aplicación (el cómo debe visualizarse lo dejamos a decisión del desarrollador). Adicionalmente una opción para llamar al teléfono del usuario.
- Al deslizar el card debe mostrar dos opciones: editar y borrar. Estas acciones se realizarán a nivel de BD y se deberá reflejar en la lista.
- Tendrá un botón flotante para poder agregar usuarios. Estos se guardarán de forma local y solo deberán ser eliminador una vez el usuario cierre sesión en la aplicación. Para la geolocalización utilizar la ubicación actual del usuario que está utilizando la aplicación.
- Debe enviar una notificación si el enable_alert es true. Enviar un local notificación para este caso.

**Consideraciones:**
- Manejador de Estados: BloC
- Utilizar Clean Architecture (obligatorio)
- Utilizar Injectable (obligatorio)
- Los usuarios creados deben ser almacenados por BD.
- Validar todos los campos de texto que el usuario ingrese información.
- Organizar el código en carpetas en base a la capa que pertenece.
- Mandar Repositorio y APK del proyecto.
- Diseño a inspiración del postulante.

# manantial_prueba

---

## 🚀 Instrucciones para correr la app

### Requisitos

- **Flutter SDK**: `>=3.5.0`
- **Dart SDK**: compatible con Flutter 3.5+
- **Android Studio** o **VS Code** con extensiones de Flutter y Dart
- **Firebase** configurado (verifica que tengas el archivo `google-services.json` en `android/app/` y/o `GoogleService-Info.plist` en `ios/Runner/`)

### Pasos para ejecutar el proyecto

1. **Clona el repositorio**
   ```bash
   git clone https://github.com/Piero-Vas/manantial_prueba.git
   cd manantial_prueba
   ```

2. **Instala las dependencias**
   ```bash
   flutter pub get
   ```

3. **Genera el código de inyección de dependencias**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Conecta un emulador o dispositivo físico**

5. **Ejecuta la app**
   ```bash
   flutter run
   ```

### Notas adicionales

- Si modificas clases anotadas con `@injectable`, vuelve a correr el comando de build_runner.
- Si usas FVM, asegúrate de tener la versión correcta instalada:
  ```bash
  fvm use 3.5.0
  fvm flutter pub get
  fvm flutter run
  ```
- El proyecto usa Clean Architecture, BloC, Isar, Firebase Auth, Google Maps, notificaciones locales y manejo offline.
- La inyección de dependencias es automática con Injectable y get_it.
