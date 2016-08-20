---
date: 2016-08-20T00:11:02+01:00
title: Getting started
weight: 10
---

## Installation

### Installing SlimFit

Let's make sure Composer is set up as expected. You should use a latest stable version of Composer

```sh
composer create-project khanhicetea/slimfit your-folder-project
```

### Setup webserver 

Next, assuming you have a popular webserver like Apache2 or Nginx

- Apache 2 : just point the document root of virtualhost to **public** folder and enable **rewrite** mod if you want to use rewrite url feature.
- Nginx : use this sample site config, (replace the **fastcgi_pass** if you use UNIX sock)

```nginx
server {
    listen 80;
    server_name slimfit.dev; 

    root /www/slimfit/public;
    index index.php;

    location / {
        try_files $uri $uri/ /index.php$is_args$args;
    }

    location ~ \.php$ {
        fastcgi_pass localhost:9000;
        fastcgi_split_path_info ^(.+\.php)(/.*)$;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }
}
```

## Config environment

Copy at the **.env.example** to **.env** in the root directory of your website. Overwrite the existing config file if necessary.

Let me explain detail of environments

```env
# Your app name
APP_NAME=SlimFit
# Your app secret key, use for encrypt data or JWT token
APP_KEY=hard_to_guess

# Enable debug error mode
DEBUG=true

# Default timezone
TIMEZONE="UTC"

# Database config
DB_DRIVER=mysql
DB_HOST=localhost
DB_DATABASE=slimfit
DB_USERNAME=root
DB_PASSWORD=secret
DB_CHARSET=utf8
DB_COLLATION=utf8_unicode_ci
DB_PREFIX=
DB_LOG=true
```

Now you can go to home page of application to see the **hello world** message :)

## Project folder struture

- **app** : Application classes (included Console Commands, Http Stack, Database Models and Service Providers)
- **bootstrap** : bootstrap files (first run before running the app)
- **config** : configuration files (app, database and console, etc ...)
- **db** : database files (migration and seeder files)
- **public** : your public folder - document root (index.php, assets and public files)
- **resources** : resources files (templates or language files)
- **storage** : application storage (cache, log)
- **tests** : PHPUnit testcase files

