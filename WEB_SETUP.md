# 🚀 Como Rodar o Heal+ na Web

## Passos Rápidos

1. **Instalar dependências** (se ainda não fez):
   ```bash
   flutter pub get
   ```

2. **Rodar na web**:
   ```bash
   flutter run -d chrome
   ```
   
   Ou para Edge:
   ```bash
   flutter run -d edge
   ```

3. **Build para produção** (opcional):
   ```bash
   flutter build web
   ```
   
   Os arquivos serão gerados em `build/web/`

## Acessar Localmente

Após executar `flutter run -d chrome`, o aplicativo abrirá automaticamente no navegador.

A URL padrão será: `http://localhost:xxxxx` (porta aleatória)

## Notas Importantes

- ✅ O aplicativo agora suporta web com SQLite via `sqflite_common_ffi_web`
- ✅ Todas as funcionalidades estão disponíveis na web
- ✅ Os dados são armazenados localmente no navegador
- ⚠️ Para produção, considere usar um servidor web para servir os arquivos

## Solução de Problemas

### Erro: "No devices found"
Execute:
```bash
flutter devices
```

### Erro: "Chrome not found"
Instale o Google Chrome ou use:
```bash
flutter run -d edge
```

### Erro de SQLite na web
O `sqflite_common_ffi_web` deve resolver automaticamente. Se houver problemas, verifique o console do navegador.

