from django.shortcuts import render

# Create your views here.
def beeppp(request):
    return render(request, 'pppoe/beeppp.html')