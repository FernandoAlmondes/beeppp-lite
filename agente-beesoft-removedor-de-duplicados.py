import os
import sys
import django
from django.db.models import Count

print()
print('--> Desenvolvido por: Bee Solutions')
print('--> Autor: Fernando Almondes')
print()

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "beesoft.settings")
django.setup()

from pppoe.models import Pppoe

# Consulta para filtrar por nome e contar ocorrencias | +1 de registro
registros = Pppoe.objects.values('username').annotate(ocorrencias=Count('username')).filter(ocorrencias__gte=2)

if len(registros) < 1:
    print('--> Nada a fazer...')
    print()
    sys.exit(1)

for i in registros:
    print(i)

for i in registros:
    teste = Pppoe.objects.filter(username=i['username']).filter(status='offline')
    teste.delete()

print()