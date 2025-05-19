import sys
import os
import django
import subprocess
import time

# Desenvolvido por: Bee Solutions
# Autor: Fernando Almondes
# Data: 17/05/2025 - 13:27

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "beesoft.settings")
django.setup()

from pppoe.models import Bng

# Todos
#bngs = Bng.objects.all()

# Limitando somente a um concentrador - Limitacao Beeppp Lite
bngs = Bng.objects.order_by('id').first()

bngs = [bngs]

for i in bngs:
    if i.vendor == 'mikrotik':
        subprocess.check_output(f'/opt/bee/beeppp/agente-beesoft-ppp-mikrotik-atualizador.bin {i.ip}', text=True, shell=True)
    elif i.vendor == 'cisco':
        subprocess.check_output(f'/opt/bee/beeppp/agente-beesoft-ppp-cisco-atualizador.bin {i.ip}', text=True, shell=True)
    elif i.vendor == 'huawei':
        subprocess.check_output(f'/opt/bee/beeppp/agente-beesoft-ppp-huawei-atualizador.bin {i.ip}', text=True, shell=True)
    else:
        print()
        print('--> Fabricante invalido ou nenhum BNG cadastrado!')
        print()

# Aguardar proxima coleta
print()
print('--> Coletor Beeppp finalizado, aguardando nova coleta (5m)!')
print()
time.sleep(300)


