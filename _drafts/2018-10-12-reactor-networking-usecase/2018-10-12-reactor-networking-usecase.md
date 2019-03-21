---
layout: post
title: Handling network packet buffer using Reactor
description: Dealing with the usecase where the network buffer needs to flushed when buffer is full (or) timeout reaches
author: thekalinga
category: Programming
tags: [Reactor, Rx Java2, Networking, Real world usecase, Java, Multi Threading]
image: cpu-with-cables.png
featured: false
hidden: false
type: article
# Make sure to the issue # is present at https://github.com/thekalinga/thekalinga.in-comments/issues
github_comments_issueid: 3
---

From post

```java
public static Flux<String> create(final Flux<String> source, final String delimiter, final int maxByteArraySize, final long maxMillisecondsBetweenEmits, final Scheduler scheduler) {
    return Flux.defer(() -> {
        final int delimiterSize = delimiter.getBytes().length;
        final AtomicInteger byteSize = new AtomicInteger(0);
        final AtomicLong lastTime = new AtomicLong(0);

        return source
            .bufferUntil(line -> {
                final int bytesLength = line.getBytes().length;
                final long now = scheduler.now(TimeUnit.MILLISECONDS);
                final long last = lastTime.getAndSet(now);
                long diff;
                if (last != 0L) {
                    diff = now - last;
                    if (diff > maxMillisecondsBetweenEmits) {
                        // This creates a buffer, reset size
                        byteSize.set(bytesLength);
                        return true;
                    }
                }

                int additionalBytes = bytesLength;
                if (additionalBytes > 0 && byteSize.get() > 0) {
                    additionalBytes += delimiterSize;  // Make up for the delimiter that's added when joining the strings
                }

                final int projectedBytes = byteSize.addAndGet(additionalBytes);

                if (projectedBytes > maxByteArraySize) {
                    // This creates a buffer, reset size
                    byteSize.set(bytesLength);
                    return true;
                }

                return false;
            }, true)
            .map(lines -> String.join(delimiter, lines));
    });
}
```

```java
Flux.merge(source, Flux.interval(Duration.ofMillis(maxMillisecondsBetweenEmits)).takeUntilOther(source).map(l -> "ping"))
```

Problem, testing and cancelling infinite stream

Can this be resolved by a `TestPublisher` and `StepVerifier.thenCancel()`?

```java
Flux.merge(
   source,
   Flux.interval(Duration.ofMillis(maxMillisecondsBetweenEmits))
       .takeUntilOther(source.then(Mono.just("ignored")))
       .map(l -> "ping"))
```

```java
Flux<T> source;
Flux<T> sharedSource = source.share();
return Flux.merge(
    sharedSource,
    Flux.interval(Duration.ofMillis(maxMillisecondsBetweenEmits))
       .takeUntilOther(sharedSource.then(Mono.just("ignored")))
       .map(l -> "ping"));
```

```java
final Flux<String> sourceWithEmptyStringKeepAlive = source.publish(flux -> Flux.merge(
    flux
    Flux.interval(Duration.ofMillis(maxMillisecondsBetweenEmits))
        .takeUntilOther(flux.then(Mono.just("ignored")))
        .map(l -> "ping")
));
```

# 23) Get an upstream event (or) a ping at regular interval & terminate the whole stream as soon as upstream terminates

One way to achieve this is by using a simple `merge`

```java
final int bufferSize;
final int maxFlushInternal;
DateTime lastReceived;
Flux<T> upstream = ...;
T ping // initialize dummy T that represents ping
upstream
  .mergeWith(Flux.interval(ofSeconds(pingInterval)).map(ping))
  .map(v -> {
    if (v != ping && v) {
    }
  })
```

## Usecase

Network programming

1. If upstream send data that fits (or) overflows the network buffer, send the data over network as buffer sized packets one after another till you are left with a buffer that's only partially filled
2. If buffer is partially filled, wait till (1) (or) flush timeout
3. If flush times out, flush the buffer
4. Rinse & repeat till the upstream completes

Courtesy of [@breun](https://github.com/breun), [@OlegDokuka](https://github.com/OlegDokuka) & [@simonbasle](https://github.com/simonbasle) from [reactor gitter discussion](https://gitter.im/reactor/reactor)
