#!/bin/bash

# Desenvolvido por: Bee Solutions
# Autor: Fernando Almondes
# Data: 04/04/2025 - 00:36

agora=$(date "+%Y-%m-%d_%Hh_%Mmin")

echo ""
echo "----------------------------------------------------"
echo ""
echo "--> Desenvolvido por: Bee Solutions"
echo "--> Autor: Fernando Almondes"
echo "--> Script: Verificando recursos do servidor e servicos do Beeppp"
echo "--> Agora: $agora"
echo ""

# Verificando se o servico do Beeppp Server esta rodando
beeppp_server=$(/usr/bin/systemctl status beeppp-server | grep 'active (running)')

if [[ -z "$beeppp_server" ]]; then
echo ""
echo "--> Servico do Beeppp Server parado, tentando reiniciar..."
echo ""
/usr/bin/systemctl restart beeppp-server

else

echo "--> Servico do Beeppp Server Ok..."

fi

beeppp_coletor=$(/usr/bin/systemctl status beeppp-coletor | grep 'active (running)')

if [[ -z "$beeppp_coletor" ]]; then
echo ""
echo "--> Servico do Beeppp Coletor parado, tentando reiniciar..."
echo ""
/usr/bin/systemctl restart beeppp-coletor

else

echo "--> Servico do Beeppp Coletor Ok..."

fi

# Verificando status da memoria do servidor
m=$(free | grep Mem. | awk '{printf("%.0f\n", ($3/$2) * 100)}')

if [[ $m -ge 90 ]]; then

echo ""
echo "--> Uso de memoria muito alto reiniciando servicos do Beeppp ($m%)!"
echo ""

# Reiniciando Beeapp Server
/usr/bin/systemctl restart beeppp-server

# Reiniciando Beeppp Coletor
/usr/bin/systemctl restart beeppp-coletor

# Reiniciando o Grafana
service grafana-server restart

else

echo "--> Recursos em ($m%) Ok..."

fi

echo ""