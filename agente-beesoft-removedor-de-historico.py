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

from pppoe.models import Pppoe, Historico

# Definir o intervalo de datas (historico maior que 30 dias)
data_limite = timezone.now() - timedelta(days=31)

# Filtrando historico de pppoes com mais de 30 dias
registros = Historico.objects.filter(timestamp__lt=data_limite)

# Removendo historico de pppoes com mais de 30 dias
registros.delete()

print('--> Script de limpeza finalizado!')

print()