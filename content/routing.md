---
date: 2016-08-21T01:56:50+01:00
title: Routing - Controller
weight: 4
---

## Routing

In SlimFit, you can define routing in `app/Http/routes.php` file in the same way as Slim 3.

```
<?php

$app = app();

// Use basic closure, setName is method to name to route, it is optional
$app->get('/', function ($req, $res) {
    return $res->withJson(['hello' => 'world']);
})->setName('home');

// Use controller class, which Home is controller in namespace App\Http\Controller and hello is method name
$app->get('/', 'Home:hello')->setName('home');

// Add a middleware, mw_token is middleware named 'token' which defined in app/Http/Kernel.php
$app->get('/me', 'User:aboutMe')->setName('about_me')->add('mw_token');

// Group route
$app->group('/api/me', function() {
    $this->get('/info', 'User:info')->setName('api_me_info');
    $this->put('/info', 'User:updateInfo')->setName('api_me_update_info');
})->add('mw_token');
```

## Controller

You **SHOULD** define application controller in namespace `App\Htpp\Controller` and **extends** `App\Http\Controller\Base`

### Passing request, response directly to method

```
<?php
namespace App\Http\Controller;

class User extends Base
{
    // use public scope if you want it receive request, reponse directly
    public function info($req, $res, $args) {
        return $res->withJson(['data' => $args]);
    }
}
```

### Proxy request and respone through Controller

```
<?php
namespace App\Http\Controller;

class User extends Base
{
    // use protected scope if you want it receive request, reponse directly
    protected function info($args) {
        // $this->req will be request instance
        // $this->res will be response instance
        return $this->res->withJson(['data' => $args]);
    }
}
```
