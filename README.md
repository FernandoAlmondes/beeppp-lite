### --> Beesoft (By: Bee Solutions) <-- ###
### Módulo Beeppp Lite v1.0 ✅ ###

--- ---
# Projeto destinado a análise de pppoes em concentradores Mikrotik, Cisco e Huawei
- Python, Django e Shellscript
--- ---
- Sobre o projeto:
> - Desenvolvido por: Bee Solutions
> - Autor: Fernando Almondes
> - Principais ferramentas: Python, Django e Shellscript
--- ---

- Distribuições homologados (Sistemas Operacionais Linux Server)
> - Debian 12 ou Superior (Puro sem interface gráfica)
> - MySQL 8.x ou superior ou MariaDB 10.x ou superior
> - Python 3.11 ou superior
> - Django 5.x ou superior
> - Grafana 12.x ou superior

--- ---

# 1# Dashboard de exemplo | Inicial

![Painel](https://beesolutions.com.br/static/beeppp/public/img/beesolutions-dashboard-analise-pppoe-menu-v1.png)
--- ---

# 2# Dashboard de exemplo | Geral

![Painel](https://beesolutions.com.br/static/beeppp/public/img/beesolutions-dashboard-analise-pppoe-beeppp-v1.png)
--- ---

### Parte 0 - Mais informações e Requisitos de Hardware do Beeppp

- Antes de iniciar leia com atenção o nosso [Contrato de Licença de Uso (EULA) para o Beeppp Lite](https://github.com/FernandoAlmondes/beeppp-lite/blob/main/EULA.txt).

--- ---

- Para aqueles que buscam monitorar os usuários pppoes na rede e tiveram problema para realizar isso via SNMP, desenvolvemos um método diferenciado que faz o acesso ao concentrador via SSH ou API, coleta as informações e armazena em um banco de dados;
- O Beeppp pode monitorar listas completas de pppoes para os principais fabricantes de BNG do Mercado (Mikrotik, Cisco e Huawei).

- Comparativo de versões do Beeppp:

| Funcionalidade    | Beeppp Lite  | Beeppp Pro  |
| :---:             | :---:        | :---:        |
| Status PPPoE      | ✅           | ✅          |
| Documentação      | ✅           | ✅          |
| Concentradores    | 1 BNG         | Sob demanda |
| Histórico Tráfego | ❌           | ✅          |
| Duplicados        | ❌           | ✅          |
| Suporte           | ❌           | ✅          |

--- ---

- Tabela de requisitos recomendados:

| Usuários   | CPU          | Memoria      | Disco         | Armazenamento (Recomendado) |
| :---:     | :---:        | :---:        | :---:         | :---:                       | 
| `~1K`    | 4vCPUs       | 4GB          | 100GB         | SSD (Leitura > 400MB/s)     |
| `~2K`    | 8vCPUs      | 8GB         | 152GB         | SSD (Leitura > 400MB/s)     |
| `~5K`   | 16vCPUs      | 16GB         | 252GB         | SSD (Leitura > 400MB/s)     |
| `>10K`   | A Consultar  | A Consultar  | A Consultar   | A Consultar                 |

- Essa tabela foi montada a partir de testes realizados em cenários reais, mas é claro que os requisitos podem variar a depender do ambiente;
- Discos SSD de alta performance com velocidade minima de leitura de 400Mb/s são recomendados para melhor eficiência no processamento das consultas.

--- ---

- Compatibilidade (Vendors e opções de conexão)

| Vendor   | API   | SSH   | Telnet |
| :---:    | :---: | :---: | :---:  |
| Mikrotik | ✅   |  ❌   | ❌     |
| Cisco    | ❌   | ✅    | ✅     |
| Huawei   | ❌   | ✅    | ✅     |

--- ---

### Parte 1 - Instalação do Beeppp

- Para instalação do beeppp use um servidor com Debian 12 puro (Limpo e sem interface gráfica).

--- ---
- Crie o diretório base para o projeto (beeppp).
```shell
mkdir /opt/bee/
```

- Navegue até o diretório base do projeto.
```shell
cd /opt/bee/
```

- Baixando o beeppp
```shell
apt-get update
apt install -y git
git clone https://github.com/fernandoalmondes/beeppp-lite
```

- Ajustando diretorios e entrando
```shell
mv /opt/bee/beeppp-lite /opt/bee/beeppp
```

- Ajuste as permissões do script de instalação
```shell
chmod +x /opt/bee/beeppp/agente-beesoft-ppp-instalador.sh
```

- Instalação com um comando ;)
```shell
/opt/bee/beeppp/agente-beesoft-ppp-instalador.sh
```

- Volte ao diretorio base
```shell
cd /opt/bee/beeppp
```

--- ---

### Parte 3 - Liberando o acesso ao Admin e para o seu IP, libere o seu ip normalmente o que aparece em meuip.com.br, ou seja, o IP de origem a partir de onde você acessará o Beeppp Admin

- Libere os ips que poderam acessar e o Admin seguindo o exemplo no seu arquivo settings.py
```shell
nano /opt/bee/beeppp/beesoft/settings.py

IPS_PERMITIDOS = [
    '127.0.0.1',
    '192.168.0.10'
]
```

--- ---

### Parte 4 - Adicione os seus concentradores no Admin
- Adicione os concentradores que o Beeppp vai coletar (Tabela BNG, beesoft/beesoft são as credenciais padrões).
- Django Admin: http://IP-DO-SEU-SERVIDOR:8888

- A versão Lite é limitada para somente um roteador, você até pode cadastrar mais de um na base, mas somente o router mais antigo será considerado.
- Para multiplos concentradores entre em contato e contrate uma licença válida.

--- ---

### Parte 5 - Acessando o Grafana já com tudo pronto ;)
- Acesse o Grafana via IP do seu servidor na porta 3000 (admin/beesolutions são as credenciais padrões)
- Grafana: http://IP-DO-SEU-SERVIDOR:3000

- * Recomendamos que altere essa senha do Grafana após finalizar a instalação.

--- ---

### Parte 6 - Informações extras
- O Histórico de tráfego dos pppoes é limitado a 30 min na versão Lite, caso precise de um intervalo maior contrate uma licença Pro.
- Homologado com roteadores Cisco da linha ASR1000, Mikrotik com RouterOS e Huawei da linha NE.
- Por padrão as coletas são realizadas a cada 5 minutos (300 segundos), ajuste no arquivo agente-beesoft-ppp-coletor.py se achar necessário.
- Nos deixe saber se funcionou bem pra você, em caso de dúvidas ou sugestões entre em contato ;)

--- ---

### Parte 7 - Finalizando

- Após validação, lembre-se de desativar o modo debug no arquivo settings e reiniciar a aplicação.
```shell
nano /opt/bee/beeppp/beesoft/settings.py
```
```shell
DEBUG = False
```

- Reiniciando serviços após desativar o modo debug.
```shell
systemctl restart beeppp-server.socket beeppp-server.service beeppp-coletor.service

service nginx restart
```

### Parte 8 - Precisa de suporte adicional ou uma licença Pro? ###
- [Contato Comercial](https://t.me/fernandoalmondes)

--- ---

### Parte 9 - Comunidade no Telegram e canal do YouTube ###

- [Comunidade no Telegram](https://t.me/beesolutions)
- [Canal no Youtuve](https://www.youtube.com/beesolutions)

> Participe e colabore com nossos projetos (Bee Solutions 2025).

--- ---