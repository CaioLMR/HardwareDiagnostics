#!/bin/bash
PATH_LOG="/var/log/log_tstmemoria.log"

echo "=========================== INICIO =============================" | tee -a $PATH_LOG > /dev/null
start_time=$(date "+%d-%m-%Y %H:%M:%S")

echo "Verificando memtester instalado" | tee -a $PATH_LOG > /dev/null

# Função para verificar a instalação do memtester
check_memtester() {
    if command -v memtester >/dev/null 2>&1; then
        echo "memtester já está instalado." | tee -a $PATH_LOG > /dev/null
        return 0
    else
        echo "memtester não está instalado." | tee -a $PATH_LOG > /dev/null
        return 1
    fi
}

# Função para instalar o sysbench
install_memtester() {
    echo "Instalando memtester..." | tee -a $PATH_LOG > /dev/null
    sudo yum install -y epel-release
    sudo yum install -y memtester
    if [ $? -ne 0 ]; then
        echo "Erro ao instalar memtester." | tee -a $PATH_LOG > /dev/null
        exit 1
    fi
    echo "memtester instalado com sucesso." | tee -a $PATH_LOG > /dev/null
}

# Verifica e instala o sysbench se necessário
if ! check_memtester; then
    install_memtester
fi

# Obter a quantidade de memória livre
mem_free=$(free -m | awk '/^Mem:/ {print $4}')

# Subtrai 200 da quantidade de memória livre
mem_to_test=$(($mem_free - 200))
echo "Memoria Livre: $mem_free MB" | tee -a $PATH_LOG > /dev/null
echo "Memoria Para teste: $mem_to_test MB" | tee -a $PATH_LOG > /dev/null

# Executa o memtester
resultado=$(sudo memtester ${mem_to_test}M 1)
echo "$resultado" | tee -a $PATH_LOG > /dev/null

# Obtém a data e hora de término
end_time=$(date "+%d-%m-%Y %H:%M:%S")

echo -e "Teste MEMORIA | Data de início: $start_time | Data de término: $end_time" >> $PATH_LOG
echo "============================ FIM ==============================" | tee -a $PATH_LOG > /dev/null

