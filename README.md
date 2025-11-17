<div align="center">

# 🏥 Heal+ - Plataforma de Gestão e Análise de Feridas

![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![License](https://img.shields.io/badge/License-Private-red?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)

**A plataforma inteligente para gestão e análise de feridas com tecnologia de ponta**

[🚀 Funcionalidades](#-funcionalidades) • [📱 Instalação](#-instalação) • [🔧 Tecnologias](#-tecnologias) • [📂 Estrutura](#-estrutura-do-projeto)

</div>

---

## 📋 Sobre o Projeto

O **Heal+** é um aplicativo mobile desenvolvido em Flutter que oferece uma solução completa para profissionais de saúde gerenciarem e analisarem feridas de pacientes. Com interface moderna, persistência de dados local e sistema de avaliação TIMERS completo, o aplicativo facilita o acompanhamento detalhado do processo de cicatrização.

---

## ✨ Funcionalidades

### 🎯 Principais Recursos

| Funcionalidade | Descrição |
|--------------|-----------|
| 🤖 **Análise com IA** | Tecnologia de ponta para análise inteligente de feridas |
| 📊 **Relatórios Automáticos** | Geração automática de relatórios detalhados |
| 👨‍⚕️ **Acompanhamento Médico** | Sistema completo para acompanhamento profissional |
| 📚 **Histórico Completo** | Registro completo e histórico de todas as avaliações |

### 📝 Sistema de Avaliação TIMERS

- **T - Tecido**: Dimensões, localização (mapa corporal), avaliação do leito da ferida
- **I - Infecção**: Intensidade da dor (0-10), sinais de inflamação/infecção
- **M - Umidade**: Quantidade, tipo, consistência, pele perilesional
- **E - Bordas**: Características, fixação, velocidade de cicatrização
- **R - Reparo**: Observações, plano de tratamento, dados da consulta, timers
- **S - Social**: Fatores sociais, histórico clínico, comorbidades, medicamentos

### 🗺️ Recursos Adicionais

- ✅ Mapa corporal interativo para localização precisa
- ✅ Sistema de timers múltiplos por avaliação
- ✅ Persistência de dados local (SQLite)
- ✅ Configurações de perfil e preferências
- ✅ Upload e gerenciamento de imagens
- ✅ Interface acessível e responsiva

---

## 🚀 Instalação

### Pré-requisitos

- [Flutter SDK](https://flutter.dev/docs/get-started/install) >= 3.0.0
- [Dart SDK](https://dart.dev/get-dart) >= 3.0.0
- Android Studio ou VS Code com extensões Flutter
- Android SDK (para desenvolvimento Android)

### Passos para Instalação

1. **Clone o repositório**
   ```bash
   git clone <url-do-repositorio>
   cd healplusFlutter
   ```

2. **Instale as dependências**
   ```bash
   flutter pub get
   ```

3. **Execute o aplicativo**
   ```bash
   flutter run
   ```

---

## 📦 Geração de APK

### APK de Release

Para gerar o APK otimizado para produção:

```bash
flutter build apk --release
```

📁 O APK será gerado em: `build/app/outputs/flutter-apk/app-release.apk`

### APK Dividido por Arquitetura

Para gerar APKs menores por arquitetura:

```bash
flutter build apk --split-per-abi --release
```

Isso gerará APKs separados para:
- `app-armeabi-v7a-release.apk` (32-bit)
- `app-arm64-v8a-release.apk` (64-bit)
- `app-x86_64-release.apk` (x86_64)

### App Bundle (AAB) para Google Play

```bash
flutter build appbundle --release
```

📁 O arquivo será gerado em: `build/app/outputs/bundle/release/app-release.aab`

> 📖 Para mais detalhes, consulte o arquivo [BUILD_INSTRUCTIONS.md](BUILD_INSTRUCTIONS.md)

---

## 🛠️ Tecnologias

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat-square&logo=dart&logoColor=white)
![SQLite](https://img.shields.io/badge/SQLite-003B57?style=flat-square&logo=sqlite&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=flat-square&logo=android&logoColor=white)

</div>

### Principais Dependências

| Pacote | Versão | Uso |
|--------|--------|-----|
| `sqflite` | ^2.3.0 | Persistência de dados local |
| `go_router` | ^13.0.0 | Navegação entre telas |
| `image_picker` | ^1.0.5 | Seleção de imagens |
| `intl` | ^0.18.1 | Formatação de datas |
| `uuid` | ^4.2.1 | Geração de IDs únicos |
| `shared_preferences` | ^2.2.2 | Armazenamento de preferências |

---

## 📂 Estrutura do Projeto

```
healplusFlutter/
│
├── 📱 lib/
│   ├── main.dart                    # Ponto de entrada da aplicação
│   │
│   ├── 🎨 theme/
│   │   └── app_theme.dart          # Tema e cores do aplicativo
│   │
│   ├── 📦 models/
│   │   ├── wound_assessment.dart   # Modelo de avaliação de ferida
│   │   └── user_profile.dart        # Modelo de perfil do usuário
│   │
│   ├── 💾 database/
│   │   └── database_helper.dart     # Helper do banco de dados SQLite
│   │
│   ├── 📺 screens/
│   │   ├── welcome_screen.dart     # Tela de boas-vindas
│   │   ├── home_screen.dart         # Tela inicial
│   │   ├── wound_assessment_screen.dart  # Tela de avaliação TIMERS
│   │   ├── wound_list_screen.dart   # Lista de avaliações
│   │   └── settings_screen.dart     # Configurações
│   │
│   └── 🧩 widgets/
│       ├── body_map_widget.dart     # Mapa corporal interativo
│       └── timer_widget.dart        # Widget de timers
│
├── 🤖 android/                      # Configurações Android
├── 📄 pubspec.yaml                  # Dependências do projeto
├── 📖 README.md                     # Este arquivo
└── 🔧 BUILD_INSTRUCTIONS.md         # Instruções de build

```

---

## 🎨 Design

O aplicativo utiliza um **design moderno e acessível** com:

- 🎨 **Cores**: Tema azul e azul escuro profissional
- ♿ **Acessibilidade**: Seguindo as melhores práticas de UX/UI
- 📱 **Responsivo**: Adaptável a diferentes tamanhos de tela
- 🌓 **Modo Escuro**: Suporte a tema claro e escuro
- 🔤 **Tipografia**: Fonte legível e tamanhos configuráveis

---

## 📸 Capturas de Tela

> 💡 *Adicione capturas de tela do aplicativo aqui*

---

## 🤝 Contribuindo

Este é um projeto privado e de uso interno. Para contribuições, entre em contato com a equipe de desenvolvimento.

---

## 📄 Licença

Este projeto é **privado** e de uso interno. Todos os direitos reservados.

---

## 👥 Equipe

Desenvolvido com ❤️ pela equipe Heal+

---

<div align="center">

**⭐ Se este projeto foi útil, considere dar uma estrela! ⭐**

Made with Flutter 💙

</div>

