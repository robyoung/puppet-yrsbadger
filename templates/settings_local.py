from .settings import *

DEFAULT_FROM_EMAIL = 'Emma Mulqueeny <emma@rewiredstate.org>'
DEFAULT_REPLY_EMAIL = 'Dave Durant <dave@bowsey.co.uk>'

EMAIL_HOST = '<%= @email['host'] %>'
EMAIL_HOST_USER = '<%= @email['user'] %>'
EMAIL_HOST_PASSWORD = '<%= @email['password'] %>'
EMAIL_PORT = 587
EMAIL_USE_TLS = True

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': '<%= @mysql['yrs_database'] %>',
        'USER': '<%= @mysql['yrs_user'] %>',
        'PASSWORD': '<%= @mysql['yrs_password'] %>',
        'HOST': 'localhost',
        'PORT': '3306',
    }
}

SECRET_KEY = '<%= @django['secret_key'] %>'