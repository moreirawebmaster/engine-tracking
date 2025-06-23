# GitHub Workflows e Templates - Engine Tracking

Este diretório contém toda a configuração de CI/CD, templates e automações para o projeto Engine Tracking.

## 📋 Workflows Configurados

### 🔄 CI Pipeline (`.github/workflows/ci.yml`)
Pipeline principal de integração contínua que executa:
- **Análise de código** com `flutter analyze`
- **Verificação de formatação** com `dart format`
- **Execução de testes** com cobertura
- **Upload para Codecov** automático
- **Análise Pana** para qualidade do pacote
- **Build do exemplo** para verificar compatibilidade

### 📦 Publicação Automática (`.github/workflows/publish.yml`)
Workflow de publicação automática no pub.dev que:
- É disparado por tags `v*.*.*`
- Executa todos os testes e verificações
- Faz análise Pana
- Publica automaticamente no pub.dev (requer secrets configurados)

### 🔍 Verificações de Qualidade (`.github/workflows/quality.yml`)
Workflow semanal de qualidade que:
- Executa auditoria de segurança
- Verifica dependências desatualizadas
- Analisa complexidade do código
- Executa toda segunda-feira às 9h

## ⚙️ Configurações

### 📊 Codecov (`codecov.yml`)
Configuração de cobertura de código:
- Meta de cobertura: 45% (ajustada para dependências externas)
- Ignora arquivos gerados automaticamente
- Configuração de comentários em PRs
- Análise de branches e patches

### 🔍 Pana (`pana_config.yaml`)
Configuração de análise de qualidade:
- Pontuação mínima: 140/160
- Verificações habilitadas (README, CHANGELOG, exemplo, licença)
- Ignora diretórios de teste e build
- Configurações de severidade

## 🛠️ Scripts de Desenvolvimento

### 📊 Test Coverage (`scripts/test_coverage.sh`)
Script automatizado que:
- Executa testes com cobertura
- Gera relatório HTML
- Verifica meta mínima (45%)
- Abre relatório automaticamente em desenvolvimento

### 🔍 Pana Analysis (`scripts/pana_analysis.sh`)
Script de análise de qualidade que:
- Instala Pana se necessário
- Executa análise completa
- Verifica pontuação mínima (140/160)
- Reporta sugestões de melhoria

## 🚀 Como Usar

### Para Desenvolvedores

```bash
# Executar testes com cobertura
./scripts/test_coverage.sh

# Executar análise de qualidade
./scripts/pana_analysis.sh

# Verificar formatação
dart format --output=none --set-exit-if-changed .

# Análise estática
flutter analyze
```

### Para CI/CD

Os workflows são executados automaticamente em:
- **Push/PR** para `main` e `develop` → CI completo
- **Tags** `v*.*.*` → Publicação automática
- **Segundas-feiras 9h** → Verificações de qualidade

### Secrets Necessários

Para publicação automática, configure no GitHub:
- `PUB_CREDENTIALS` - Credenciais do pub.dev

## 📈 Métricas Atuais

- ✅ **Pana Score**: 160/160 (Perfeito!)
- ✅ **Testes**: 83 passando (100% de sucesso)
- ✅ **Cobertura**: 49.5% (acima da meta de 45%)
- ✅ **Análise**: 0 warnings, 0 errors

## 🔗 Links Úteis

- [Documentação do Codecov](https://docs.codecov.com/)
- [Pana Package Analysis](https://pub.dev/packages/pana)
- [GitHub Actions](https://docs.github.com/en/actions)
- [Pub.dev Publishing](https://dart.dev/tools/pub/publishing)
- [engine-security](https://github.com/moreirawebmaster/engine-security)
---

---

## ❤️ Feito com Amor

**Desenvolvido por:** [Thiago Moreira](https://github.com/moreirawebmaster)  
**Organização:** [STMR](https://stmr.tech)  
**Domínio:** tech.stmr

---

**⭐ Se este projeto te ajudou, considere dar uma estrela no repositório!**

[![GitHub stars](https://img.shields.io/github/stars/moreirawebmaster/engine-tracking?style=social)](https://github.com/moreirawebmaster/engine-tracking/stargazers)

**🤝 Contribuições são sempre bem-vindas!**

[![GitHub issues](https://img.shields.io/github/issues/moreirawebmaster/engine-tracking)](https://github.com/moreirawebmaster/engine-tracking/issues)
[![GitHub pull requests](https://img.shields.io/github/issues-pr/moreirawebmaster/engine-tracking)](https://github.com/moreirawebmaster/engine-tracking/pulls)

---

**📧 Contato:** [Email](mailto:moreirawebmaster@gmail.com)  
**🌐 Website:** [stmr.tech](https://stmr.tech)  
**🐦 Twitter:** [@moreirawebmaster](https://twitter.com/parabastech)
