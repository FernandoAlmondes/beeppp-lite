import os
import django
from datetime import datetime, timedelta
from django.utils import timezone

print()
print('--> Desenvolvido por: Bee Solutions')
print('--> Autor: Fernando Almondes')
print()

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "beesoft.settings")
django.setup()

from pppoe.models import Pppoe

# Definir o intervalo de datas (offline ha mais de 30 dias)
data_limite = timezone.now() - timedelta(days=30)

# Filtrando por pppoe offlines ha mais de 30 dias
registros = Pppoe.objects.filter(timestamp__lt=data_limite).filter(status='offline')

# Debug quais pppoes serao deletados
print(registros)

# Removendo pppoes offlines ha mais de 30 dias
registros.delete()

print('--> Script de limpeza finalizado!')

print()