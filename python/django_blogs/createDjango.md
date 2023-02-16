> - [Quickstart - Django REST framework (django-rest-framework.org)](https://www.django-rest-framework.org/tutorial/quickstart/)
> - [Writing your first Django app, part 1 | Django documentation | Django (djangoproject.com)](https://docs.djangoproject.com/en/4.0/intro/tutorial01/)
> - [django-admin and manage.py | Django documentation | Django (djangoproject.com)](https://docs.djangoproject.com/en/4.0/ref/django-admin/#startproject)



> - `django-admin startproject name [directory]`[¶](https://docs.djangoproject.com/en/4.0/ref/django-admin/#django-admin-startproject)
>
>   
>
> - Creates a Django project directory structure for the given project name in the current directory or the given destination.
>
> - By default, [the new directory](https://github.com/django/django/blob/main/django/conf/project_template) contains `manage.py` and a project package (containing a `settings.py` and other files).
>
> - If only the project name is given, both the project directory and project package will be named `<projectname>` and the project directory will be created in the current working directory.
>
> - If the optional destination is provided, Django will use that existing directory as the project directory, and create `manage.py` and the project package within it. Use ‘.’ to denote the current working directory.
>
> For example:
>
> ```
> django-admin startproject myproject /Users/jezdez/Code/myproject_repo
> ```







