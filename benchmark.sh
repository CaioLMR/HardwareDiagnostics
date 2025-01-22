#!/bin/bash
PATH_LOG="/var/log/log_tstcpu.log"

# ------------------------------------ TESTE STRESS CPU ----------------------------------------

echo "=========================== INICIO =============================" | tee -a $PATH_LOG > /dev/null

echo "Verificando sysbench instalado" | tee -a $PATH_LOG > /dev/null

# Função para verificar a instalação do sysbench
check_sysbench() {
    if command -v sysbench >/dev/null 2>&1; then
        echo "sysbench já está instalado." | tee -a $PATH_LOG > /dev/null
        return 0
    else
        echo "sysbench não está instalado." | tee -a $PATH_LOG > /dev/null
        return 1
    fi
}

# Função para instalar o sysbench
install_sysbench() {
    echo "Instalando sysbench..." | tee -a $PATH_LOG > /dev/null
    sudo yum install -y epel-release
    sudo yum install -y sysbench
    if [ $? -ne 0 ]; then
        echo "Erro ao instalar sysbench." | tee -a $PATH_LOG > /dev/null
        exit 1
    fi
    echo "sysbench instalado com sucesso." | tee -a $PATH_LOG > /dev/null
}

# Verifica e instala o sysbench se necessário
if ! check_sysbench; then
    install_sysbench
fi


# Inicializa a variável para armazenar a temperatura máxima
max_temp=0

# Obtém a data e hora atual
start_time=$(date "+%d-%m-%Y %H:%M:%S")

# número de sockets
sockets=$(lscpu | grep socket | grep -o '[0-9]\+')

# número de cores por socket
cores_per_socket=$(lscpu | grep core | grep -o '[0-9]\+')

# Multiplicar o número de sockets pelo número de cores por socket
resultadothreads=$((sockets * cores_per_socket))

# Inicia o comando sysbench em segundo plano
sysbench --test=cpu --num-threads=$resultadothreads --max-time=900 run > /dev/null 2>&1 &

# Obtém o PID do processo sysbench
sysbench_pid=$!

# Loop enquanto o sysbench estiver em execução
while ps -p $sysbench_pid > /dev/null; do
    # Coleta dados do uso da CPU usando o comando top
    cpu_usage=$(top -b -n 1 | grep "Cpu(s)" | awk '{print $2}' | cut -d '%' -f 1)

    # Coleta dados da temperatura dos cores usando o comando sensors
    core_temperatures=$(sensors | grep "Core" | awk '{print $3}')

    # Processa as temperaturas para encontrar a máxima
    while IFS= read -r temp; do
        temp_val=$(echo "$temp" | sed 's/[^0-9.]//g')  # Remove todos os caracteres exceto números e ponto
        if (( $(echo "$temp_val > $max_temp" | bc -l) )); then
            max_temp=$temp_val
        fi
    done <<< "$core_temperatures"

    # Espera 5 segundos antes de coletar os dados novamente
    sleep 5
done

# Obtém a data e hora de término
end_time=$(date "+%d-%m-%Y %H:%M:%S")

# Registra no arquivo de log apenas a temperatura máxima
echo "===================== TESTE STRESS CPU ========================" | tee -a $PATH_LOG > /dev/null
echo -e "Teste CPU: Temperatura máxima: $max_temp°C | Data de início: $start_time | Data de término: $end_time" >>  $PATH_LOG
echo "============================ FIM ==============================" | tee -a $PATH_LOG > /dev/null

	
# Pergunta ao usuário se deseja executar o script de memória
read -p "Deseja executar o script de memória? (s/n): " resposta

if [ "$resposta" == "s" ] || [ "$resposta" == "S" ]; then
    /tmp/scripts/memoria.sh
else
    echo "Finalizando sem executar o script de memória." | tee -a $PATH_LOG > /dev/null
fi
