---
date: 2016-08-20T21:07:13+01:00
title: SlimFit - Good Enough RESTful API Framework
type: index
weight: 0
---

## Beautiful API design

SlimFit is a framework for only purpose - RESTful API webservice, it's fast and GOOD enough. It is built on top Slim 3 framework but its design is learnt from Silex 2, Laravel 5.

SlimFit is very lightweight – it is built from scratch using Pimple as DI Container, Slim 3 as HttpKernel, Eloquent as query builder and Phinx as migration tool. And specially, its core is a PSR7-middleware stack so you can customize the whole struture as you want.

{{< note title="Rasmus Lerdorf" >}}
All general purpose PHP frameworks suck!
{{< /note >}}

![meme](/images/solve-any-problem-meme.jpg)

## Quick start

Install with `composer`:

```sh
composer create-project khanhicetea/slimfit your-folder-project
```

## Features

- Beautiful, readable and very user-friendly design based on PSR-7
- Well-tested and optimized
- Extra configuration, easy to customize the stack
- Have I said "GOOD ENOUGH" ? Sure, it's good enough for a RESTful API webservice
- Compatible with React PHP to boosting the application speed to new level via [PHP PPM](https://github.com/php-pm/php-pm)

See the [getting started guide]({{< relref "getting-started/index.md" >}}) for instructions how to get
it up and running.

## Acknowledgements

Last but not least a big thank you to [Slim contributors](https://github.com/slimphp/Slim#credits). They created the good base framework to build this stack.

