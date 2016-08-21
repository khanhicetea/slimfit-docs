---
date: 2016-08-21T00:56:50+01:00
title: HTTP Stack
weight: 2
---

## HTTP Stack

In SlimFit, we have a HTTP Kernel handles request and return a response. That is how a webservice works.

HTTP Kernel is a middlewares stack, where each middleware receive a request, process the request or pass it to next middleware, and finally return a response.


{{< note title="Note" >}}
Below part of document has been copied from [Slim Framework docs](http://www.slimframework.com/docs/concepts/middleware.html), and I changed some place to fit with SlimFit.
{{< /note >}}

## What is middleware?

Technically speaking, a middleware is a _callable_ that accepts three arguments:

1. `\Psr\Http\Message\ServerRequestInterface` - The PSR7 request object
2. `\Psr\Http\Message\ResponseInterface` - The PSR7 response object
3. `callable` - The next middleware callable

It can do whatever is appropriate with these objects. The only hard requirement
is that a middleware **MUST** return an instance of `\Psr\Http\Message\ResponseInterface`.
Each middleware **SHOULD** invoke the next middleware and pass it Request and
Response objects as arguments.

## How does middleware work?

Different frameworks use middleware differently. Slim adds middleware as concentric
layers surrounding your core application. Each new middleware layer surrounds
any existing middleware layers. The concentric structure expands outwardly as
additional middleware layers are added.

**The last middleware layer added is the first to be executed.**

When you run the Slim application, the Request and Response objects traverse the
middleware structure from the outside in. They first enter the outer-most middleware,
then the next outer-most middleware, (and so on), until they ultimately arrive
at the Slim application itself. After the Slim application dispatches the
appropriate route, the resultant Response object exits the Slim application and
traverses the middleware structure from the inside out. Ultimately, a final
Response object exits the outer-most middleware, is serialized into a raw HTTP
response, and is returned to the HTTP client. Here's a diagram that illustrates
the middleware process flow:

![Middleware Stack](/images/middleware_stack.png)

## How do I write middleware?

Middleware is a callable that accepts three arguments: a Request object, a Response object, and the next middleware. Each middleware **MUST** return an instance of `\Psr\Http\Message\ResponseInterface`.

### Closure middleware example.

This example middleware is a Closure.

```
<?php
/**
 * Example middleware closure
 *
 * @param  \Psr\Http\Message\ServerRequestInterface $request  PSR7 request
 * @param  \Psr\Http\Message\ResponseInterface      $response PSR7 response
 * @param  callable                                 $next     Next middleware
 *
 * @return \Psr\Http\Message\ResponseInterface
 */
function ($request, $response, $next) {
    $response->getBody()->write('BEFORE');
    $response = $next($request, $response);
    $response->getBody()->write('AFTER');

    return $response;
};
```

### Invokable class middleware example

This example middleware is an invokable class that implements the magic `__invoke()` method.

```
<?php
class ExampleMiddleware
{
    /**
     * Example middleware invokable class
     *
     * @param  \Psr\Http\Message\ServerRequestInterface $request  PSR7 request
     * @param  \Psr\Http\Message\ResponseInterface      $response PSR7 response
     * @param  callable                                 $next     Next middleware
     *
     * @return \Psr\Http\Message\ResponseInterface
     */
    public function __invoke($request, $response, $next)
    {
        $response->getBody()->write('BEFORE');
        $response = $next($request, $response);
        $response->getBody()->write('AFTER');

        return $response;
    }
}
```

To use this class as a middleware, you can use `->add( new ExampleMiddleware() );` function chain after the `$app`, `Route`,  or `group()`, which in the code below, any one of these, could represent $subject.

```
$subject->add( new ExampleMiddleware() );
```

## How do I add middleware?

You may add middleware to a Slim application, to an individual Slim application route or to a route group. All scenarios accept the same middleware and implement the same middleware interface.

### Application middleware

Application middleware is invoked for every *incoming* HTTP request. Add application middleware with the Slim application instance's `add()` method. We recommend use class as a middleware, you can define new one in `app/Http/Middleware` folder with namespace `App\Http\Middleware`

*File : app/Http/Middleware/Example.php*
```
<?php
namespace App\Http\Middleware;

class Example
{
    public function __invoke($request, $response, $next)
    {
        $response->getBody()->write('SLIM');
        $response = $next($request, $response);
        $response->getBody()->write('FIT');

        return $response;
    }
}
```

Then add it in `defaultAppMiddlewares` method of `app/Http/Kernel.php` class
```
    public function defaultAppMiddlewares()
    {
        /* Other middlewares */
        $this->appendAppMiddleware(new \App\Http\Middleware\Example());
        /* Other middlewares */
    }
```

This would output this HTTP response body:

    SLIM [controller response content] FIT

### Route middleware

Route middleware is invoked _only if_ its route matches the current HTTP request method and URI. Route middleware is specified immediately after you invoke any of the Slim application's routing methods (e.g., `get()` or `post()`). Each routing method returns an instance of `\Slim\Route`, and this class provides the same middleware interface as the Slim application instance. Add middleware to a Route with the Route instance's `add()` method. This example adds the Closure middleware example above:

```
<?php
$mw = function ($request, $response, $next) {
    $token = $request->getHeaderLine('Authorization');
    if ($token && verify_token($token)) {
        return $next($request, $response);
    }
    return $response->withStatus(401);
};

$app->get('/secret', function ($request, $response, $args) {
	$response->getBody()->write(' This is secret zone ');
	return $response;
})->add($mw);
```

This would add a token authentication layer to your secret route.

### Group Middleware

In addition to the overall application, and standard routes being able to accept middleware, the `group()` multi-route definition functionality, also allows individual routes internally. Route group middleware is invoked _only if_ its route matches one of the defined HTTP request methods and URIs from the group. To add middleware within the callback, and entire-group middleware to be set by chaining `add()` after the `group()` method.

Sample Application, making use of callback middleware on a group of url-handlers

```
<?php
$mw = function ($request, $response, $next) {
    $token = $request->getHeaderLine('Authorization');
    if ($token && verify_token($token)) {
        return $next($request, $response);
    }
    return $response->withStatus(401);
};

$app->group('/api/me', function() {
    $this->get('/info', 'User:info')->setName('api_me_info');
    $this->put('/info', 'User:updateInfo')->setName('api_me_update_info');
})->add($mw);
```

This would add a token authentication layer to `/api/me` group of routes.

### Reusing middleware by injecting it to Dependency Injection Container (works only in SlimFit)

*File app/Http/Middleware/Token.php*
```php
<?php
namespace App\Htpp\Middleware;

class Token
{
    public function __invoke($request, $response, $next)
    {
        $token = $request->getHeaderLine('Authorization');
        if ($token && verify_token($token)) {
            return $next($request, $response);
        }
        return $response->withStatus(401);
    }
}
```

*File app/Http/Kernel.php*
```php
    public function defaultRouteMiddlewares()
    {
        $this->setRouteMiddleware('token', new \App\Http\Middleware\Token());
    }
```

When you want to use this middleware, just add prefix `mw_` to there middleware alias named.

```php
$group_or_route->add('mw_token');
```

### Passing variables from middleware
The easiest way to pass attributes from middleware is to use the request's
attributes.

Setting the variable in the middleware:

```
$request = $request->withAttribute('foo', 'bar');
```

Getting the variable in the route callback:

```
$foo = $request->getAttribute('foo');
```

