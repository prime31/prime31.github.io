## Garbage Collection and How to Avoid It

Managed languages (like C#) have often been touted as the panacea of programming. We no longer need to be concerned with memory management. Memory leaks are a thing of the past. Retain/release/delete is banashed to the bowels of hell. The garbage collector (GC from here on out) will take care of all the ugly details of memory management for us.

<!--more-->

The reality of the situtation is that we almost need to be _even more careful_ in a managed environment. All control of memory management is now out of our hands and we have no choice but to deal with the GC and it's madness. To make matters even worse, Unity ships with an **absolutely ancient** GC. If you are making a mobile game it will undoubtedly end up being a battle with the GC.


## So, What Actually Happens at Runtime?

In simplified terms, as you allocate more and more memory eventually the GC gets to it's limit and it kicks in a collection. While the GC is collecting everything freezes until it is complete. On desktop platforms it isn't terrible as long as you have a couple milliseconds per frame to spare. On mobile and most consoles it is a guaranteed frame rate stutter. If you continue to allocate every frame you end up with endless stutters.


## What Causes Allocations?

From all of the code I have seen, the main culprits are calling Instantiate at runtime and senseless string usage. There are plenty of other sources but these are the two biggest offenders. Conveniently, these happen to also be completely under our own control. We already touched on strings with the [ConstantsGeneratorKit post](/constants-generator-kit/) so give that a look if you haven't seen it yet. Abolishing Instantiate calls requires a bit more foresight and some discipline. It is just too easy to stick calls to Instantiate in our code sometimes. What we need is a solution that is just as simple as Instantiate/Destroy.


## Enter Object Pools

What is an object pool (as defined by [duffymo](http://stackoverflow.com/users/37213/duffymo))?
> "An object pool is a collection of a particular object that an application will create and keep on hand for those situations where creating each instance is expensive."
What this boils down to for a Unity game is that we do all of our Instantiate calls at level load time. Object pools are the tool that we use to do this. There are plenty of tutorials and sample code including a great video right on the [Unity Learn website](http://unity3d.com/learn/tutorials/modules/beginner/live-training-archive/object-pooling). As is the case with all of the core feature tools we also have an open source object pool available in our *Kit family.


## RecyclerKit

[RecyclerKit](https://github.com/prime31/RecyclerKit) aims to take the pain out of using a object pool. INSERT_IMAGE_HERE It includes a simple inspector that lets you simply drag-and-drop any prefab or GameObject in your scene to create an object pool. From there, you just replace your Instantiate calls with `TrashMan.spawn` and replace your Destroy calls with `TrashMan.despawn/despawnAfterDelay`. Of course, not everyone wants to use the inspector and sometimes you don't know what you want to stick in an object pool until runtime so you can create your recycle bins anytime. Here is a snipping showing how to create and use a recycle bin at runtime:

{% codeblock lang:csharp %}
// create a new recycle bin
var recycleBin = new TrashManRecycleBin()
{
    prefab = somePrefabOrGameObjectReference
    // any other options can be placed here
};
TrashMan.manageRecycleBin( recycleBin );

// usage is the same as with a recycle bin created with the inspector
var newObj = TrashMan.spawn( somePrefabOrGameObjectReference );
TrashMan.despawnAfterDelay( newObj, 5f );
{% endcodeblock %}


All the options we have ever needed over the last couple years have been added so RecyclerKit should cover just about all use cases. Options include the total number of objects to preallocate, total objects to create if we hit the recycle bin limit, automatically recycle ParticleSystems (based on system.duration + system.startLifetime), use a hard limit (do not allocate any objects once the recycle bin is empty) and automatic culling (destroy instances above a certain amount). Go grab a copy and avoid the GC monster in your games!