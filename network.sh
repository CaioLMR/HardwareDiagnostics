#!/bin/bash

# Redirecionar toda a saída para o arquivo de log
exec &> /var/log/log_testeinterfaces.log

REMOTE_SERVER="10.42.0.157"
REMOTE_USER="root"
REMOTE_PASSWORD='testescript'
TEST_DURATION=600
INTERFACE=$(ip route show | grep '^default' | awk '{print $5}')
start_time=$(date "+%d-%m-%Y %H:%M:%S")

echo "=============================================== [INICIO - $start_time] =============================================="
echo ""
# 1. Instalar iperf3 na máquina local, se não estiver instalado
echo "Verificando se iperf3 está instalado na máquina local..."
        if ! command -v iperf3 &> /dev/null
        then
# Se não estiver instalado, instala usando yum
        echo "iperf3 Não instalado, instalando."
        sudo yum -y install iperf3
else
         echo "iperf3 já está instalado."
fi

# Alguns segundos para garantir que o iperf3 seja iniciado.
sleep 15

# 3. Executar iperf3 no modo cliente na máquina local e gerar resultado de largura de banda máxima
echo "Iniciando teste de largura de banda..."
iperf3 -c $REMOTE_SERVER -t $TEST_DURATION > temp_iperf_output.txt

# Filtra as linhas do arquivo temporário com 'sender' ou 'receiver'
grep -E 'sender|receiver' temp_iperf_output.txt

# Limpa o arquivo temporário
rm temp_iperf_output.txt

echo "=============================================== [TESTE DE BANDA FINALIZADO] ================================================="

echo ""
# 4. Fazer um teste de mtr para o outro destino
echo "Iniciando teste MTR..."
mtr -rwc 600 $REMOTE_SERVER
echo "=============================================== [TESTE DE MTR FINALIZADO]  =================================================="

# Obtém a data e hora de término
end_time=$(date "+%d-%m-%Y %H:%M:%S")
echo ""
echo -e "Teste na Interface $INTERFACE | Data de início: $start_time | Data de término: $end_time"
echo ""
echo "=============================================== [FIM - $end_time] =============================================="
