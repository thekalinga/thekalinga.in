---
layout: post
title: Schedulers in Project Reactor
description: Why does not project reactor use java's native executors for scheduling instead of its own Scheduler abstraction
author: thekalinga
category: Reactor
tags: [Reactor, Project Reactor, WebFlux, Spring WebFlux]
image: merging-streams.jpg
featured: false
hidden: false
type: article
# Make sure to the issue # is present at https://github.com/thekalinga/thekalinga.in-comments/issues
github_comments_issueid: 6
---

![{{page.title}}](merging-streams.jpg){:.featured-image.img-fluid.margin-auto}

This article addresses why reactor uses its own abstraction called `Scheduler` instead of java's native `Executor` API by using various usecases. We will discuss various types of builtin `Scheduler`s, how to create your own scheduler using `Executor` & `ExecutorService` & finally conclude with code examples of various usecases that addresses each aspect of `Scheduler`s

## Whats available out of the box

### Execute a task immediately in java
### Execute a task asynchronously in java
### Execute a task at a fixed time in the future in java

## Usecases that we encounter everyday

* Offload work from eventloop to another thread/threadpool
* Need to test code that only gets executed sometime in the future 

## Reactor `Scheduler`: Free from system time limitations

## Various types of Schedulers

* `single`
* `parallel`
* `elastic`
* `newSingle`
* `newParallel`
* `newElastic`
* `fromExecutor`
* `fromExecutorService`
* `immediate`

## Conclusion
