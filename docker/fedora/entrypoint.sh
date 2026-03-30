#!/bin/bash
set -e

COMMAND=$1
shift # Rimuove il primo argomento (il comando) e tiene il resto

case $COMMAND in
  "deploy")
    echo "Eseguendo deploy con Kustomize..."
    ;;
  "validate")
    echo "Validando i manifesti..."
    ;;
  *)
    echo "Comando non riconosciuto: $COMMAND"
    exit 1
    ;;
esac
exit 0