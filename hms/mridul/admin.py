from django.contrib import admin
from django.apps import apps
from .models import *  # Import all models from your app

# Get all models in the app
app = apps.get_app_config('mridul')  # Replace 'mridul' with your app name

# Register each model in the app
for model in app.get_models():
    try:
        admin.site.register(model)
    except admin.sites.AlreadyRegistered:
        pass  # In case a model is already registered, skip it
