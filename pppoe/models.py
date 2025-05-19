from django.db import models

# Create your models here.

class Bng(models.Model):
    nome = models.CharField(max_length=200, unique=True, default='BNG-BEE-01')
    ip = models.CharField(max_length=200, unique=True, null=True, blank=True)
    usuario = models.CharField(max_length=200, null=True, blank=True)
    senha = models.CharField(max_length=200, null=True, blank=True)
    porta_ssh = models.IntegerField(null=True, blank=True, default='22')
    porta_telnet = models.IntegerField(null=True, blank=True, default='23')
    porta_api = models.IntegerField(null=True, blank=True, default='8728')
    modo = models.CharField(max_length=200, choices=[('ssh', 'SSH'), ('telnet', 'Telnet'), ('api', 'Api')])
    vendor = models.CharField(max_length=200, null=True, blank=True, choices=[('cisco', 'Cisco'), ('huawei', 'Huawei'), ('mikrotik', 'Mikrotik')])
    
    class Meta:
        verbose_name_plural = "Concentradores"
    
    def __str__(self):
        return str(self.nome)

class Pppoe(models.Model):
    username = models.CharField(max_length=200, null=True, blank=True)
    status = models.CharField(max_length=200, null=True, blank=True)
    interface = models.CharField(max_length=200, null=True, blank=True)
    mac = models.CharField(max_length=200, null=True, blank=True)
    ipv4 = models.CharField(max_length=200, null=True, blank=True)
    acct_start_time = models.CharField(max_length=200, null=True, blank=True)
    bng = models.ForeignKey(Bng, on_delete=models.CASCADE)
    timestamp = models.DateTimeField(auto_now_add=True, null=True, blank=True)

    class Meta:
        verbose_name_plural = "Pppoes"

    def __str__(self):
        return str(self.username)

class Historico(models.Model):
    pppoe = models.ForeignKey(Pppoe, on_delete=models.CASCADE)
    bps_in = models.IntegerField(null=True, blank=True)
    bps_out = models.IntegerField(null=True, blank=True)
    bng = models.ForeignKey(Bng, on_delete=models.CASCADE)
    timestamp = models.DateTimeField(auto_now_add=True, null=True, blank=True)

    class Meta:
        verbose_name_plural = "Historico"
    
    def __str__(self):
        return str(self.pppoe)