---
date: 2016-08-21T00:11:02+01:00
title: Concepts
weight: 2
---

## SlimFit Application

SlimFit has a application object that extends Slim Application, it used Singleton to make sure only 1 application running.

### Get application instance

```php
$app = \App\SlimFit::getInstance()
// or use helper function
$app = app();
```

## Dependency Container

SlimFit uses [Pimple](http://pimple.sensiolabs.org/) as Dependency Container because it's very lightweight and flexible. You can read its documentation in Homepage.

### Get service, factory by key

```php
$container = app()->getContainer();
$value = $container->get($key);
$value2 = $container[$key2]
// or use helper function
$value3 = app($key3);
```

### Get application config

SlimFit application autoload all PHP files in `config` folder to retrieve array of config then put in DI Container via a namespace key `config.[filename_without_extension]`.

*File : config/console.php*

```php
return [
    'console.name' => 'SlimFit console',
] 
```

*Getting that config*

```php
$console_name = $container['config.console']['console.name'];
// or short way
$console_name = app('config.console')['console.name'];
```

## Service provider

Service provider **MUST** implements `\Pimple\ServiceProviderInterface`
We have some common service providers in `app\ServiceProvider` : Monolog, Console, Capsule and Twig

You **SHOULD** register service provider in bootstraping of Application at `bootstrap/app.php`, you can see we had 2 core service providers : Monolog and HttpKernel

```php
$service_providers = [
    App\ServiceProvider\Monolog::class => [], 
    App\ServiceProvider\HttpKernel::class => [], 

    // Your service providers below
    App\ServiceProvider\Example::class => $config_replace_in_container, 
];
```

which `$config_replace_in_container` is an array of key-value config will be replaced in DI Container.
