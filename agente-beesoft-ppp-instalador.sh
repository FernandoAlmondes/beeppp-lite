# Desenvolvido por: Bee Solutions
# AUtor: Fernando Almondes
# Data: 10/05/2025 - 10:33

echo "---------------------------------------------------------------------------------"
echo ""
echo "--> Desenvolvido por: Bee Solutions"
echo "--> Autor: Fernando Almondes"
echo "--> Iniciando instalacao do Beeppp Lite, por favor aguarde..."
echo ""
echo "---------------------------------------------------------------------------------"

# Instalacao das dependencias do Linux para o beeppp
apt update
apt install -y default-mysql-server nginx build-essential libtool pkg-config wget net-tools git python3.11-venv python3.11 python3.11-dev default-libmysqlclient-dev sudo libpq-dev uuid

token_api=$(uuid)
senha_bd_beepppadmin=$(uuid)
senha_bd_beepppconsultor=$(uuid)

# Parte 2 - Instalacao do Beeppp #

instala_beeppp() {

cd /opt/bee/beeppp

mkdir /opt/bee/beeppp/tmp
mkdir /opt/bee/beeppp/tmp/mk
mkdir /opt/bee/beeppp/tmp/hw
mkdir /opt/bee/beeppp/tmp/cisco
mkdir /opt/bee/beeppp/logs

python3.11 -m venv venv

source venv/bin/activate

pip install -r /opt/bee/beeppp/dependencias.txt

# Partindo do principio que a instalacao seja a padrao sem senha
mysql -u root <<EOF
create database beeppp_db_01 character set utf8mb4 collate utf8mb4_bin;
create user beepppadmin@localhost identified by '${senha_bd_beepppadmin}';
grant all privileges on beeppp_db_01.* to beepppadmin@localhost;

create user beepppconsultor@localhost identified by '${senha_bd_beepppconsultor}';
grant SELECT on beeppp_db_01.* to beepppconsultor@localhost;

EOF

chave_django=$(python /opt/bee/beeppp/agente-beesoft-ppp-chave.py)

mv /opt/bee/beeppp/beesoft/settings.exemplo /opt/bee/beeppp/beesoft/settings.py

mv /opt/bee/beeppp/beesoft/.env.exemplo /opt/bee/beeppp/beesoft/.env

perl -pi -e "\$val = q{$chave_django}; s/SUA-CHAVE-DJANGO-AQUI/\$val/g" /opt/bee/beeppp/beesoft/.env

sed -i "s/TOKEN-UUID-API-AQUI/$token_api/g" /opt/bee/beeppp/beesoft/.env
sed -i "s/SENHA-BANCO-DE-DADOS-ADMIN/$senha_bd_beepppadmin/g" /opt/bee/beeppp/beesoft/.env
sed -i "s/SENHA-BANCO-DE-DADOS-GRAFANA/$senha_bd_beepppconsultor/g" /opt/bee/beeppp/beesoft/.env

python manage.py makemigrations
python manage.py migrate

# Criando index para agilizar consultas de historico
mysql -u root <<EOF
use beeppp_db_01;
CREATE INDEX idx_pppoe_historico_user_timestamp ON pppoe_historico (pppoe_id, timestamp);
EOF

export DJANGO_SUPERUSER_USERNAME=beesoft
export DJANGO_SUPERUSER_EMAIL=beesoft@example.com
export DJANGO_SUPERUSER_PASSWORD=beesoft
python manage.py createsuperuser --noinput

mv /opt/bee/beeppp/beeppp-server.service /etc/systemd/system/
mv /opt/bee/beeppp/beeppp-server.socket /etc/systemd/system/
mv /opt/bee/beeppp/beeppp-coletor.service /etc/systemd/system/

systemctl daemon-reload

systemctl start beeppp-server.service beeppp-server.socket beeppp-coletor.service
systemctl enable beeppp-server.service beeppp-server.socket beeppp-coletor.service

unlink /etc/nginx/sites-enabled/default

echo '''
server {
    listen 8888;
    server_name beeppp.seudominio.com.br;

    location = /favicon.ico { access_log off; log_not_found off; }
    location /static/ {
        root /opt/bee/beeppp;
    }

    location / {
        include proxy_params;
        proxy_pass http://unix:/run/beeppp-server.sock;
    }
}
''' > /etc/nginx/sites-enabled/beeppp.seudominio.com.br

python manage.py collectstatic

nginx -t
service nginx restart

# Ajustando permissoes
chmod +x /opt/bee/beeppp/agente-beesoft-*

# Adicionando scripts de check e limpeza no crontab
(crontab -l 2>/dev/null; echo "* * * * * /opt/bee/beeppp/agente-beesoft-ppp-recursos.sh >> /opt/bee/beeppp/logs/log_agente-beesoft-ppp-recursos.txt") | crontab -
(crontab -l 2>/dev/null; echo "0 4 * * * /opt/bee/beeppp/venv/bin/python /opt/bee/beeppp/agente-beesoft-removedor-de-duplicados.py >> /opt/bee/beeppp/logs/log_agente-beesoft-removedor-de-duplicados.txt") | crontab -
(crontab -l 2>/dev/null; echo "0 4 * * * /opt/bee/beeppp/venv/bin/python /opt/bee/beeppp/agente-beesoft-removedor-de-offlines.py >> /opt/bee/beeppp/logs/log_agente-beesoft-removedor-de-offlines.txt") | crontab -
(crontab -l 2>/dev/null; echo "0 5 * * * /opt/bee/beeppp/venv/bin/python /opt/bee/beeppp/agente-beesoft-removedor-de-historico.py >> /opt/bee/beeppp/logs/log_agente-beesoft-removedor-de-historico.txt") | crontab -
(crontab -l 2>/dev/null; echo "0 5 * * * find /opt/bee/beeppp/tmp/ -mtime 1 -type f -exec rm {} \; >> /opt/bee/beeppp/logs/log_agente-beesoft-removedor-de-arquivos.txt") | crontab -

}

instala_grafana () {

apt-get install -y adduser libfontconfig1 musl

cd /tmp

wget https://dl.grafana.com/grafana-enterprise/release/12.1.1/grafana-enterprise_12.1.1_16903967602_linux_amd64.deb

dpkg -i /tmp/grafana-enterprise_12.1.1_16903967602_linux_amd64.deb

/bin/systemctl daemon-reload
/bin/systemctl enable grafana-server

grafana-cli plugins install grafana-clock-panel
service grafana-server stop

check=$(ls -la /var/lib/grafana/grafana.db 2>/dev/null)

if [[ ! -z $check ]]; then
    mv /var/lib/grafana/grafana.db /var/lib/grafana/grafana.db.bkp
fi

mv /opt/bee/beeppp/grafana/grafana.db /var/lib/grafana/

chown -R grafana:grafana /var/lib/grafana/grafana.db

service grafana-server restart

sleep 10

/opt/bee/beeppp/venv/bin/python /opt/bee/beeppp/grafana/bee_grafana.py "$senha_bd_beepppconsultor"

service grafana-server restart

}

instala_beeppp
instala_grafana

echo ""
echo "---------------------------------------------------------------------------------"
echo ""
echo "--> Instalacao do Beeppp Finalizada..."
echo "--> Siga as demais instrucoes no Github."
echo ""
echo "---------------------------------------------------------------------------------"