#!/bin/bash

# Pana Analysis Script para Engine Tracking
# Executar análise de qualidade do pacote

set -e

echo "🔍 Executando análise Pana..."

# Instalar Pana se não estiver disponível
if ! command -v pana &> /dev/null; then
    echo "📦 Instalando Pana..."
    dart pub global activate pana
fi

# Verificar se todas as dependências estão instaladas
echo "📦 Verificando dependências..."
flutter pub get

# Executar análise Pana
echo "🔍 Executando análise de qualidade..."
pana_output=$(dart pub global run pana --no-warning 2>&1)
echo "$pana_output"

# Extrair pontuação
score=$(echo "$pana_output" | grep -E "Points: [0-9]+/160" | tail -1 | sed 's/Points: \([0-9]*\)\/160\./\1/')

if [ -z "$score" ]; then
    echo "❌ Erro: Não foi possível extrair a pontuação do Pana"
    exit 1
fi

echo "📊 Pontuação Pana: $score/160"

# Verificar se a pontuação atende ao mínimo
MIN_SCORE=140
if [ "$score" -ge "$MIN_SCORE" ]; then
    echo "✅ Pontuação acima do mínimo exigido ($MIN_SCORE/160)"
else
    echo "❌ Pontuação abaixo do mínimo exigido ($MIN_SCORE/160)"
    echo "💡 Verifique os problemas relatados acima"
    exit 1
fi

# Verificar se há sugestões de melhoria
if echo "$pana_output" | grep -q "SUGGESTION"; then
    echo "💡 Existem sugestões de melhoria - verifique o output acima"
fi

echo "✅ Análise Pana concluída com sucesso!" 