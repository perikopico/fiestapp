# Análisis del Flujo de Creación de Eventos

## Flujo Actual

### Estructura
El formulario actual es un **formulario largo con scroll vertical** que contiene todas las secciones en una sola pantalla:

1. **Información básica** (título, descripción)
2. **Fecha y horario** (fecha inicio, fecha fin, hora, programación diaria)
3. **Imagen del evento** (selector, preview, alineación)
4. **Lugar** (búsqueda de venues, campo de texto libre)
5. **Categoría** (dropdown con descripciones)
6. **Tipo de evento** (gratuito/pago)
7. **Ubicación en el mapa** (selector de coordenadas)
8. **Envío** (captcha, botón de enviar)

### Problemas Identificados

1. **Sobrecarga cognitiva**: Demasiada información en una sola pantalla
2. **Navegación confusa**: El usuario debe hacer scroll para ver todas las opciones
3. **Validación tardía**: Solo se valida al final, cuando el usuario intenta enviar
4. **No hay resumen**: El usuario no puede revisar todo antes de enviar
5. **Móvil no optimizado**: En pantallas pequeñas es difícil ver el contexto completo
6. **No hay progreso visible**: El usuario no sabe cuánto falta por completar

## Propuesta: Wizard Paso a Paso

### Ventajas

✅ **Mejor UX**: Guía al usuario paso a paso, reduciendo la carga cognitiva
✅ **Validación progresiva**: Se valida cada paso antes de continuar
✅ **Progreso visible**: Indicador de pasos completados
✅ **Navegación clara**: Botones "Siguiente" y "Atrás" para moverse entre pasos
✅ **Resumen final**: Pantalla de revisión antes de enviar
✅ **Edición fácil**: Desde el resumen se puede editar cualquier campo
✅ **Móvil optimizado**: Cada paso ocupa toda la pantalla
✅ **Menos errores**: Validación por pasos reduce errores de usuario

### Estructura Propuesta del Wizard

#### **Paso 1: Información Básica**
- Título del evento (obligatorio)
- Descripción (obligatorio, mínimo 20 caracteres)
- **Validación**: Título no vacío, descripción >= 20 caracteres

#### **Paso 2: Fecha y Horario**
- Fecha de inicio (obligatorio)
- Fecha de fin (opcional)
- Hora (opcional)
- Programación diaria (switch, solo si hay fecha fin)
- **Validación**: Fecha inicio seleccionada

#### **Paso 3: Lugar y Ubicación**
- Búsqueda de ciudad (obligatorio)
- Búsqueda de lugar/venue (opcional)
- Campo de texto libre para lugar (si no hay venue)
- Selector de ubicación en el mapa (opcional)
- **Validación**: Ciudad seleccionada

#### **Paso 4: Categoría y Tipo**
- Selección de categoría (obligatorio)
- Tipo de evento (gratuito/pago)
- **Validación**: Categoría seleccionada

#### **Paso 5: Imagen**
- Selector de imagen (opcional)
- Preview de imagen
- Selector de alineación (top/center/bottom)
- **Validación**: Ninguna (opcional)

#### **Paso 6: Resumen y Confirmación**
- Resumen de todos los datos ingresados
- Botones para editar cada sección
- Captcha
- Botón final "Crear Evento"

### Diseño Visual

```
┌─────────────────────────────────┐
│  ← Crear Evento         1/6    │ ← Header con progreso
├─────────────────────────────────┤
│                                  │
│  [Contenido del paso actual]    │
│                                  │
│                                  │
├─────────────────────────────────┤
│  [Atrás]        [Siguiente →]   │ ← Navegación
└─────────────────────────────────┘
```

### Indicador de Progreso

```
○──○──○──○──○──○  (pasos no completados)
●──●──○──○──○──○  (pasos 1 y 2 completados)
```

### Pantalla de Resumen

```
┌─────────────────────────────────┐
│  ← Resumen del Evento     6/6    │
├─────────────────────────────────┤
│  📝 Información Básica      [✏️] │
│  Título: Festival de Verano     │
│  Descripción: ...               │
│                                  │
│  📅 Fecha y Horario        [✏️] │
│  Inicio: 15/07/2024 20:00       │
│                                  │
│  📍 Lugar                  [✏️]  │
│  Ciudad: Barbate                 │
│  Lugar: Discoteca Éxito          │
│                                  │
│  🏷️ Categoría             [✏️]  │
│  Música                          │
│                                  │
│  🖼️ Imagen                 [✏️]  │
│  [Preview de imagen]             │
│                                  │
│  ☑️ No soy un robot              │
│                                  │
│  [Crear Evento]                  │
└─────────────────────────────────┘
```

## Implementación Técnica

### Componentes Necesarios

1. **EventWizardScreen**: Pantalla principal del wizard
2. **WizardStepIndicator**: Indicador de progreso
3. **Step1BasicInfo**: Paso 1 - Información básica
4. **Step2DateTime**: Paso 2 - Fecha y horario
5. **Step3Location**: Paso 3 - Lugar y ubicación
6. **Step4Category**: Paso 4 - Categoría y tipo
7. **Step5Image**: Paso 5 - Imagen
8. **Step6Summary**: Paso 6 - Resumen y confirmación

### Estado del Wizard

```dart
class EventWizardState {
  int currentStep = 0;
  Map<int, bool> stepValidated = {};
  
  // Datos del evento
  String? title;
  String? description;
  DateTime? startDate;
  DateTime? endDate;
  TimeOfDay? time;
  City? city;
  Venue? venue;
  Category? category;
  bool isFree = true;
  File? image;
  String? imageAlignment;
  double? lat;
  double? lng;
  bool captchaValidated = false;
}
```

### Navegación

- **Siguiente**: Valida el paso actual, si es válido avanza
- **Atrás**: Vuelve al paso anterior sin validar
- **Editar desde resumen**: Navega directamente al paso correspondiente

## Conclusión

**SÍ, un wizard paso a paso es mucho más profesional y mejora significativamente la UX**, especialmente en móviles. El flujo actual funciona pero es abrumador para el usuario. El wizard:

- ✅ Reduce la carga cognitiva
- ✅ Guía mejor al usuario
- ✅ Permite validación progresiva
- ✅ Ofrece un resumen antes de enviar
- ✅ Es más profesional y moderno
- ✅ Mejora la tasa de completación del formulario

