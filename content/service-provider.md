---
date: 2016-08-21T02:56:50+01:00
title: Service Providers
weight: 5
---

## Twig template engine

### Install

Require composer package

```
$ composer require slim/twig-view
```

Then, uncomment the line register Twig Service Provider in `bootstrap/app.php`

### Usage

All templates is stored in `resources/views` folder

*File resource/views/email.html*
```twig
<h1>Dear {{ name|e }},</a>

Thanks for using our service :) Have a good time !
```

*Render template*

```php
$body = app('view')->render('email.html', ['name' => 'KhanhIceTea']);
// Or use $this in controller
$body = $this->view->render('email.html', ['name' => 'KhanhIceTea']);
```

## Eloquent

Eloquent is a very good query builder out there. Checkout its documentation [here](https://laravel.com/docs/master/eloquent)

### Install

Require composer package

```
$ composer require illuminate/events
$ composer require illuminate/database
```

Then, uncomment the line register Capsule Service Provider in `bootstrap/app.php`

### Usage

All application models **MUST** extend `App\Model\Base` to use the Eloquent. Because we init `capsule` service when composer autoloads the `Base` model.

*File app/Model/User.php*

```php
<?php
namespace App\Model;

class User extends Base
{
    protected $table = 'user';
}
```

*Use models*
```php
$user = App\Model\User::find(1);
```

**If you want to use [DB](https://laravel.com/docs/master/database) facade like Laravel, we already had it in App\DB**

```php
use App\DB;

/* count and group user by status */
$users = DB::table('users')
    ->select(DB::raw('count(*) as user_count, status'))
    ->where('status', '<>', 1)
    ->groupBy('status')
    ->get();
```

## Console

SlimFit used `symfony/console` to manage console application

### Install

Require composer package

```
$ composer require symfony/console
```

Then, uncomment the line register Console Service Provider in `bootstrap/app.php`

### Usage

All console commands **SHOULD** have namespace `app\Console\Command`

*File app/Console/Command/Hello.php*

```php
<?php
namespace App\Console\Command;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class Hello extends Command
{
    protected function configure()
    {
        $this
            ->setName('hello')
            ->setDescription('Hello world');
    }
    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $output->writeln('Hello World !');
    }
}
```

*Register command to console application by put it to config/console.php*

```
    'console.commands' => [
        App\Console\Command\QuoteOfDay::class,
        App\Console\Command\Hello::class,
    ],
```

### Running command

```bash
$ php console hello
```

