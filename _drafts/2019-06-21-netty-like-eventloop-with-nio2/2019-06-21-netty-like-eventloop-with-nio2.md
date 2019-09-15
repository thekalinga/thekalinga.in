---
layout: post
title: Netty like eventloop processing using NIO2 in Java
description: Nonblocking processing of netty like eventloops using NIO2 in Java 
author: thekalinga
category: NIO2
tags: [NIO2, NIO, Netty, Eventloop, WebFlux, Spring WebFlux]
image: assembly-line.jpg
featured: false
hidden: false
type: article
# Make sure to the issue # is present at https://github.com/thekalinga/thekalinga.in-comments/issues
github_comments_issueid: 7
---

![{{page.title}}](assembly-line.jpg){:.featured-image.img-fluid.margin-auto}

This article helps you understand various aspects of how to use NIO2 with eventloop based non-blocking request & response handling. This mechanism is similar to how netty's eventloops. We will build an server that can handle thousands of concurrent requests using java's non blocking IO (NIO2)

Since we know the maximum amount of concurrency we can achieve on any machine is proportional to the number of cores on the machine, our server will be using one eventloop/core (eventloop is defined lil later)

The toy example we create would generate fibonacci number for any input number. I will be using an inefficient implementation of fibonacci generator to show an important usecase when dealing with limited number of threads to process requests & some of these request are IO/CPU bound

This is our deliberately inefficient fibonacci generator

```java
private int fibonacci(int number) {
  if (number <= 1) {
    return 1;
  }
  return fibonacci(number - 1) + fibonacci(number - 2);
}
```

Our application will allow clients to connect (say telnet) & ask our server to generate a fibonacci number for any given number. Our application also supports disconnection using telnet client using `Ctrl+C` key combination

If you are building application using [Spring WebFlux](https://docs.spring.io/spring/docs/current/spring-framework-reference/web-reactive.html) with [Reactor Netty](https://github.com/reactor/reactor-netty), the mechanism (not the implementation) this article describes is internally used by netty (which reactor netty is based on). Please note that netty provides far more useful abstractions & is far more performance than java NIO2

The whole intent behind this article is to understand the underlying mechanics of how the foundations are netty are built & we will never in real world want to build application using NIO2 directly, rather its always better to use netty (as it performs far better than builtin NIO2)/some other high level abstractions provided by servers like Tomcat/Jetty

Here is the final version of the application we build by the end of this article

![Diagram: Overall flow](svg-optimized/overall-interaction.svg){:.featured-image.img-fluid.margin-auto}

Before we proceed with the actual implementation details, here is a summary of the terms we would be using

## Terminology

### Executor (and its siblings)

`java.util.concurrent.Executor` is java's abstraction over task execution. We can submit a task to be executed by excutor using `Executor#execute`

There are various implementations of this interface. There are many implementations of this interface such as `ThreadPoolExecutor`, `ScheduledThreadPoolExecutor` & more

Java comes with a factory for creating common implementations thru `java.util.concurrent.Executors`

For e.g, if we want an executor backed by fixed thread pool thread pool we can use `Executors#newFixedThreadPool(int)`. Similarly if we want an executor that's backed by just a single thread, we can use `Executors#newSingleThreadExecutor`

### Eventloop

An eventloop is a fancy name for the following loop

```java
while(true) {
  Event event = eventQueue.deque();
  processEvent(event);
}
```

As you can see, the loop is an infinite loop & we are processing events inside this loop by dequeing messages from a queue

All events in an eventloop is processed by one thread. If the task is quick to execute, executor itself might execute the task. If any task is known to stall eventloop thread, usually, this task is delegated to another task pool whose job is to finish the work & then the response 

### CPU vs IO bound
### SocketChannel
### ServerSocketChannel
### Selector
### SelectionKey
### ByteBuffer

## 

## Conclusion
