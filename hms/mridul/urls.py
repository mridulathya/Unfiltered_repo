from django.urls import path
from . import views
urlpatterns = [
    path('mri/', views.register,name='register'),
    path('test/',views.testing),
    path('login/patient/', views.patient_login, name='patient_login'),
    path('login/doctor/', views.doctor_login, name='doctor_login'),
    path('login/receptionist/', views.receptionist_login, name='receptionist_login'),
]
