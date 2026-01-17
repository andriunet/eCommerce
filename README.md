# 📱 eCommerce iOS App - Walmart Search Challenge

![Swift](https://img.shields.io/badge/Swift-6.0-orange?style=flat-square&logo=swift)
![Platform](https://img.shields.io/badge/iOS-16.0%2B-blue?style=flat-square&logo=apple)
![Architecture](https://img.shields.io/badge/Architecture-MVVM-green?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-lightgrey?style=flat-square)

Una aplicación nativa de iOS desarrollada en **SwiftUI** que permite buscar productos del catálogo de Walmart mediante la integración con la API de Axesso. El proyecto se centra en la **arquitectura limpia**, **concurrencia moderna** y **rendimiento de UI**.

---

## 📸 Capturas de Pantalla

| Búsqueda | Productos | 
|:---:|:---:|
| <img src="https://github.com/andriunet/eCommerce/blob/main/IMG_0493.png?raw=true" alt="Search" width="200"/> | <img src="https://github.com/andriunet/eCommerce/blob/main/IMG_0494.png?raw=true" alt="Scroll" width="200"/>

---

## 🚀 Características Principales

* **Búsqueda en Tiempo Real:** Consulta de productos por palabra clave utilizando la API de Axesso.
* **Paginación Infinita:** Carga automática de más resultados al llegar al final de la lista (Infinite Scroll) sin bloquear la UI.
* **Historial de Búsqueda:** Persistencia de las últimas búsquedas utilizando `UserDefaults` con codificación JSON.
* **Gestión de Estados:** Manejo robusto de estados de vista (`idle`, `loading`, `loadingMore`, `loaded`, `error`).
* **Resiliencia:** Algoritmo de deduplicación de IDs para evitar duplicados en la UI y crashes en `ForEach`.
* **Interfaz Adaptativa:** Feedback visual claro para el usuario (Spinners, Alertas de Error, Empty States).

---

## 🛠 Tech Stack & Arquitectura

El proyecto sigue el patrón **MVVM (Model-View-ViewModel)** con una separación estricta de responsabilidades y principios de **Clean Architecture** simplificada.

### 🏗 Arquitectura
* **Views:** Componentes SwiftUI solo reaccionan al estado del ViewModel.
* **ViewModels:** `ObservableObject` que gestiona la lógica de negocio, transforma datos y mantiene el estado de la UI.
* **Services:** Capa de red de la vista, encargada de la comunicación con la API.
* **Models:** Estructuras de datos inmutables (`struct`) conformadas a `Codable` e `Identifiable`.

### ⚡️ Tecnologías Clave
* **Swift Concurrency (`async/await`):** Para manejo de hilos y operaciones asíncronas seguras, evitando el "Callback".
* **Actors:** Uso de `actor` en el `NetworkManager` para garantizar *Thread Safety* y evitar *Data Races* en Swift 6.
* **Combine:** Uso de `@Published` para el binding reactivo con la UI.
* **Protocol Oriented Programming:** Definición de contratos claros para los servicios.

---

## 📂 Estructura del Proyecto

```text
ECommerceApp
├── Core
│   └── AppConfig.swift          # Configuración global (API Keys, URLs, Constantes)
├── Models
│   ├── Product.swift            # Modelo de dominio (Identifiable & Hashable)
│   ├── SearchResponse.swift     # Mapeo de respuesta JSON compleja (Codable)
│   └── ErrorWrapper.swift       # Helper para manejo de alertas en SwiftUI
├── Services
│   ├── NetworkManager.swift     # Cliente HTTP Genérico (Singleton Actor)
│   └── APIEndpoint.swift        # Constructor de rutas, queries y requests
├── ViewModels
│   └── SearchViewModel.swift    # Lógica de negocio, paginación y gestión de estado
└── Views
    ├── eCommerceView.swift      # Vista Principal (Screen)
    └── Components
        ├── ProductRow.swift     # Celda de producto optimizada y extraída
        ├── ProductListView.swift# Lista con lógica de paginación integrada
        └── HistoryView.swift    # Vista de historial reciente

```

## 🔧 Instalación y Ejecución

Este proyecto no utiliza dependencias externas (sin CocoaPods ni SPM), por lo que la configuración es inmediata.

### Prerrequisitos
* Xcode 15.0 o superior.
* iOS 16.0 o superior (Simulador o Dispositivo).

### Pasos

1.  **Clonar el repositorio:**
    Abre tu terminal y ejecuta:
    ```bash
    git clone https://github.com/andriunet/eCommerce/
    ```

2.  **Abrir el Proyecto:**
    Abre el archivo del proyecto en Xcode:
    ```bash
    open eCommerce.xcodeproj
    ```

3.  **Verificar Configuración de API:**
    El proyecto ya incluye la configuración necesaria para conectar con la API de Axesso/Walmart.
    
    Puedes verificar el archivo en: `Core/AppConfig.swift`

4.  **Ejecutar:**
    * Selecciona un simulador (ej. **iPhone 16 Pro**).
    * Presiona `Cmd + R` o el botón de **Run** en Xcode.
  
   
