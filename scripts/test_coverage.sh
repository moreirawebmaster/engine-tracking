#!/bin/bash

# Test Coverage Script para Engine Tracking
# Executar testes com cobertura e gerar relatórios

set -e

echo "🧪 Executando testes com cobertura..."

# Limpar cobertura anterior
rm -rf coverage/

# Executar testes com cobertura
flutter test --coverage

# Verificar se o arquivo de cobertura foi gerado
if [ ! -f coverage/lcov.info ]; then
    echo "❌ Erro: Arquivo de cobertura não foi gerado"
    exit 1
fi

# Instalar lcov se não estiver disponível
if ! command -v lcov &> /dev/null; then
    echo "📦 Instalando lcov..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt-get update
        sudo apt-get install lcov
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install lcov
    fi
fi

# Gerar relatório HTML
echo "📊 Gerando relatório HTML..."
genhtml coverage/lcov.info -o coverage/html

# Calcular cobertura total
COVERAGE=$(lcov --summary coverage/lcov.info 2>&1 | grep -E "lines\.*:" | sed 's/.*lines.*: \([0-9.]*\)%.*/\1/')

echo "✅ Cobertura de testes: ${COVERAGE}%"

# Verificar se a cobertura atende ao mínimo
MIN_COVERAGE=45
if (( $(echo "$COVERAGE >= $MIN_COVERAGE" | bc -l) )); then
    echo "✅ Cobertura acima do mínimo exigido (${MIN_COVERAGE}%)"
else
    echo "❌ Cobertura abaixo do mínimo exigido (${MIN_COVERAGE}%)"
    exit 1
fi

echo "📁 Relatório gerado em: coverage/html/index.html"

# Abrir relatório se estivermos em desenvolvimento local
if [[ -z "${CI}" ]]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        open coverage/html/index.html
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        xdg-open coverage/html/index.html
    fi
fi 