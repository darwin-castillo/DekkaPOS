# DekkaPOS

Sistema de Punto de Venta (POS) desarrollado en Flutter.

## Características

- Gestión de productos con precios y peso
- Carrito de compras interactivo
- Registro de clientes y proveedores
- Control de ventas
- Reportes de ventas
- Interfaz adaptativa para tablets

## Requisitos

- Flutter 3.11.0+
- Dart 3.11.0+

## Instalación

```bash
flutter pub get
flutter run
```

## Estructura del Proyecto

```
lib/
├── core/           # Configuración global y theme
├── data/           # Implementación de datos (datasources, repositories impl)
├── domain/         # Entidades y repositorios abstractos
└── presentation/   # UI (screens, widgets, providers)
```

## Dependencias

- `provider` - Gestión de estado
- `cupertino_icons` - Iconos iOS

## Build

```bash
# Android
flutter build apk

# iOS
flutter build ios
```

## License

MIT