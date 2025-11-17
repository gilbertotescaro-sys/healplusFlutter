# Instruções para Gerar o APK

## Pré-requisitos

1. Flutter SDK instalado (versão 3.0.0 ou superior)
2. Android SDK configurado
3. Java JDK instalado

## Passos para Gerar o APK

### 1. Instalar Dependências

```bash
flutter pub get
```

### 2. Verificar Configuração do Android

Certifique-se de que o Android SDK está configurado corretamente:

```bash
flutter doctor
```

### 3. Gerar APK de Release

Para gerar um APK otimizado para produção:

```bash
flutter build apk --release
```

O APK será gerado em:
```
build/app/outputs/flutter-apk/app-release.apk
```

### 4. Gerar APK Dividido (Split APK)

Para gerar APKs divididos por ABI (arquitetura):

```bash
flutter build apk --split-per-abi --release
```

Isso gerará APKs separados para:
- `app-armeabi-v7a-release.apk` (32-bit)
- `app-arm64-v8a-release.apk` (64-bit)
- `app-x86_64-release.apk` (x86_64)

### 5. Gerar App Bundle (AAB) para Google Play

Para publicar na Google Play Store:

```bash
flutter build appbundle --release
```

O arquivo será gerado em:
```
build/app/outputs/bundle/release/app-release.aab
```

## Testando o APK

### Instalar no Dispositivo

```bash
flutter install
```

Ou manualmente:

```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

## Assinatura do APK (Opcional)

Para assinar o APK para distribuição:

1. Gerar uma chave de assinatura:
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. Configurar o arquivo `android/key.properties`:
```
storePassword=<password>
keyPassword=<password>
keyAlias=upload
storeFile=<caminho para o keystore>
```

3. Atualizar `android/app/build.gradle` para usar a assinatura.

## Solução de Problemas

### Erro: "Gradle build failed"
- Verifique se o Android SDK está instalado corretamente
- Execute `flutter clean` e tente novamente

### Erro: "SDK location not found"
- Configure o `ANDROID_HOME` no ambiente
- Ou crie `android/local.properties` com:
```
sdk.dir=C:\\Users\\SEU_USUARIO\\AppData\\Local\\Android\\Sdk
```

### APK muito grande
- Use `--split-per-abi` para gerar APKs menores
- Ou use App Bundle (AAB) que é otimizado pela Google Play

