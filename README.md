# HardwareDiagnostics

Este repositório contém três scripts desenvolvidos para auxiliar no diagnóstico de hardware e desempenho em sistemas Linux, especificamente testados no **CentOS 6.10**.

## Scripts Disponíveis

### 1. `benchmark.sh`
Executa testes de desempenho para CPU e disco, utilizando ferramentas disponíveis no sistema.

**Funcionalidades:**
- Mede o desempenho da CPU.
- Avalia a velocidade de leitura/escrita do disco.

### 2. `memory.sh`
Fornece informações detalhadas sobre o uso da memória RAM do sistema.

**Funcionalidades:**
- Exibe a quantidade total, utilizada e livre de memória.
- Lista processos que mais consomem memória.

### 3. `network.sh`
Realiza diagnósticos de conexão de rede, verificando conectividade e desempenho.

**Funcionalidades:**
- Testa a conectividade com hosts remotos.
- Mede a latência e a velocidade da conexão.

## Requisitos
- Sistema operacional: **CentOS 6.10** (pode funcionar em outras versões, mas não testado).
- Permissões de execução nos scripts (`chmod +x script.sh`).

## Como Usar
1. Clone o repositório:
   ```bash
   git clone https://github.com/seu-usuario/HardwareDiagnostics.git
   cd HardwareDiagnostics
   ```
2. Dê permissão de execução aos scripts:
   ```bash
   chmod +x *.sh
   ```
3. Execute o script desejado:
   ```bash
   ./benchmark.sh
   ./memory.sh
   ./network.sh
   ```

---
Criado e testado em **CentOS 6.10**.


