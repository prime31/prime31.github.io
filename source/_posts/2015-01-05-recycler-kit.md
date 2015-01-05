## Garbage Collection and How to Avoid It

Managed languages (like C#) have often been touted as the panacea of programming. We no longer need to be concerned with memory management. Memory leaks are a thing of the past. Retain/release/delete is banashed to the bowels of hell. The garbage collector (GC from here on out) will take care of all the ugly details of memory management for us.

<!--more-->

The reality of the situtation is that we almost need to be _even more careful_ in a managed environment. All control of memory management is now out of our hands and we have no choice but to deal with the GC and it's madness. To make matters even worse, Unity ships with an **absolutely ancient** GC. If you are making a mobile game it will undoubtedly end up being a battle with the GC.

## So, What Actually Happens at Runtime?

In simplified terms, as you allocate more and more memory eventually the GC gets to it's limit and it kicks in a collection. While the GC is collecting everything freezes until it is complete. On desktop platforms it isn't terrible as long as you have a couple milliseconds per frame to spare. On mobile and most consoles it is a guaranteed frame rate stutter. If you continue to allocate every frame you end up with endless stutters.

- object pools in general

- RecyclerKit specifics


