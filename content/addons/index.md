---
date: 2016-08-22T00:11:02+01:00
title: Addons
weight: 6
---

## Phinx - Database Migration Tool

### Install

```
$ composer require robmorgan/phinx
```

### Usage

Read full documentation [here](http://docs.phinx.org/en/latest/)

{{< note title="Note" >}}
We already implement phinx.php configuration file, so you don't need run **init**
{{< /note >}}

## Run as HTTP Service

### Install

```
$ composer require php-pm/php-pm:dev-master
```

### Usage

Read full documentation [here](https://github.com/php-pm/php-pm). We already implement the bootstrap and http bridge, so just use current ppm.json

```
$ ./vendor/bin/ppm start
```

We benchmarked it performace on CPU Intel Core i3, 4GB RAM Laptop with PHP 7 CGI (hello world route, no database connection) : 950 requests / second.

{{< warning title="Warning" >}}
Not production ready yet ! So stay tuned or just YOLO !!!
{{< /warning >}}

