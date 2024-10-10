from django import forms
from .models import Users

class RegisterForm(forms.ModelForm):
    
    password = forms.CharField(widget=forms.PasswordInput())  
    confirm_password = forms.CharField(widget=forms.PasswordInput()) 
    class Meta:
        model = Users
        fields = ['first_name', 'last_name', 'email_id', 'phone_no','gender','password'] 

    gender = forms.ChoiceField(choices=[('Male', 'Male'), ('Female', 'Female'), ('Others', 'Others')]) 
    def clean(self):
        cleaned_data = super().clean()
        password = cleaned_data.get('password')
        confirm_password = cleaned_data.get('confirm_password')

        if password and confirm_password and password != confirm_password:
            raise forms.ValidationError("Passwords do not match.")
        
        return cleaned_data
