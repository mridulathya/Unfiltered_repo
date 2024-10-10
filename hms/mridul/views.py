from django.shortcuts import render
from django.http import HttpResponse as hr
from .forms import RegisterForm
from django.utils import timezone
from django.http import HttpResponseRedirect
# Create your views here.
# def home(request):
#     return render(request, 'mridul/index.html')
def testing(request):
    return render(request,'mridul/mridul.html')
def patient_login(request):
    return render(request,'mridul/patient_login.html')
def doctor_login(request):
    return render(request,'mridul/doctor_login.html')
def receptionist_login(request):
    return render(request,'mridul/receptionist_login.html')

def register(request):
    if request.method == 'POST':
        role = request.POST.get('role') 
        form = RegisterForm(request.POST)
        
        if form.is_valid():
            user = form.save()
            user.role_as_a = role 
            user.created_at = timezone.now()
            user.save() 
            print('\n******ohk! form suceesfully submitted*****\n')

            if role == 'Patient':
                return HttpResponseRedirect('/home/login/patient/') 
            elif role == 'Doctor':
                return HttpResponseRedirect('/home/login/doctor/')
            elif role == 'Receptionist':
                return HttpResponseRedirect('/home/login/receptionist/')
        else:
            return render(request, 'mridul/index.html', {'form': form, 'active_tab': role}) 
            
    else:
        form = RegisterForm()
    
    return render(request, 'mridul/index.html', {'form': form, 'active_tab': 'Patient'})