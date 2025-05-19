from django.contrib import admin

from pppoe.models import Pppoe, Bng, Historico

# Register your models here.

class PppoeAdmin(admin.ModelAdmin):
    list_display = ['username','status','ipv4','mac','interface','bng','acct_start_time','timestamp']
    list_filter = ['bng','status']
    search_fields = ['username','ipv4','mac','interface']
admin.site.register(Pppoe, PppoeAdmin)

class BngAdmin(admin.ModelAdmin):
    list_display = ['nome', 'ip', 'usuario', 'senha', 'porta_ssh', 'porta_telnet', 'porta_api', 'modo', 'vendor']
admin.site.register(Bng, BngAdmin)

class HistoricoAdmin(admin.ModelAdmin):
    list_display = ['pppoe', 'bps_in', 'bps_out', 'bng', 'timestamp']
    list_filter = ['bng']
    search_fields = ['pppoe__username']
admin.site.register(Historico, HistoricoAdmin)