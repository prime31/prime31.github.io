---
layout: post
title: "A Method for Working with Shared Code with Unity and Git"
date: 2015-05-19 12:45:51 -0700
categories:
permalink: "A-Method-for-Working-with-Shared-Code-with-Unity-and-Git"
published: true
---


Out of the box Unity doesn't provide any good way to have a shared codebase that is used amongst multiple Unity projects. Any code that you drag into a Unity project is automatically copied into it. If you make changes to your shared code you have to remember to change it in every project that uses it. This is obviously not a sustainable approach.


<!-- more -->


### Enter Git Submodules

Submodules allow you to keep a Git repository as a subdirectory of another Git repository. On it's own this isn't quite enough. Often times, Git repositories have unit tests, demo scenes and full Unity projects in them. Of course you can just make your shared code repositories a naked subdirectory with just code and use submodules directly. Sometimes you don't have control over the repository (open source projects for example) and frankely I prefer to keep Git repos with full Unity projects in tow. This makes isolating the code super easy and lets you just fire up the project and make changes directly.


To illustrate the process that I have been using we'll use the [StateKit](https://github.com/prime31/StateKit) repository which is one of the first things I import into any new projects. We'll assume you have the Git repo for your Unity project initialized and ready to go. If you aren't using Git (or some other version control system) it's time for you to start. With the advent of the [GitHub.app](https://mac.github.com/) (which works with or without a github.com account) using Git is something anyone can and should be doing even for simple throwaway projects. Simply drag a folder into the GitHub.app and it magically sets up a repo for you. Couldn't be much easier.


### Step-by-Step Guide

Now that we are all on the same page and we have a Git repo rolling lets get to adding StateKit to our project in a sustainable fashion. You can use the Git application of your choice but for this kind of thing it's actually easier to just use the scary command line. First things first, open a terminal and cd into your Unity project's root folder and make a subdirectory to hold our shared code submodules.

{% codeblock lang:javascript %}
// get ourselves to the root folder of the Unity project
cd folder/otherfolder/Unity Project Root
// make a folder to organize our shared code submodules
mkdir submodules
// move into the subfolder
cd submodules
{% endcodeblock %}


Your Unity project folder should look something like this:

![](/images/posts/submodules/initialFolder.png)


Now we are going to add the submodule. We should already be in the `submodules` directory so the command to add the StateKit repo as a submodule is the following:


{% codeblock lang:scala %}
// tell git we want to add a submodule into the StateKit folder
git submodule add https://github.com/prime31/StateKit StateKit
{% endcodeblock %}


I personally like to have all my shared code in the Plugins folder in Unity but you can add it wherever you want in your project. The main reasons I stick it in the Plugins folder are for organizational purposes and because everything in the Plugins folder gets compiled into it's own DLL by Unity. That means the only time Unity needs to recompile the code in the Plugins folder is when you specifically change something in it. Less work for Unity since we will be doing a large amount of our work in our project's code as opposed to with the shared code.


The final step in the process is to make a symlink from the Plugins folder (or wherever you choose to have the shared code reside) to the folder in the submodule that we want in our project. The StateKit repo folder structure looks like this:

![](/images/posts/submodules/stateKitFolder.png)


The folder we are interested in is the `StateKit/Assets/StateKit` folder so that is what we are going to symlink into our project. We want the symlink to originate at the Plugins folder so we will first `cd` back to that folder then create the symlink.


{% codeblock lang:javascript %}
// move ourselves back to the folder in our Unity project that we want the shared code to end up
cd ../Assets/Plugins
// make a symlink from the current folder to the folder in the shared code submodule that we want in our project
ln -s ../../submodules/StateKit/Assets/StateKit StateKit
{% endcodeblock %}


Looking at our Unity project you can see we now have our shared code in place right where we want it:

![](/images/posts/submodules/unityProject.png)


It should be noted that Unity will get angry at you for creating the symlink. It will display a warning in the console just once to let you know of its anger that looks like this:

```
Assets/Plugins/StateKit is a symbolic link. Using symlinks in Unity projects may cause your project
to become corrupted if you create multiple references to the same asset, use recursive symlinks or
use symlinks to share assets between projects used with different versions of Unity. Make sure you
know what you are doing.
```


Luckily, we know what we are doing here so clear the console and ignore it just like you do when your significant other tells you to clean the bathroom.


### Wrapping Up

We now have a workable solution to share code between multiple Unity projects. By doing things this way, when we change the shared code it will be propogated to every project that uses it. We even still retain the ability to open up and modify any Unity projects in the submodules. In this particular example we can still open the `submodules/StateKit` Unity project and go to town making changes. Those changes can then be pushed to the Git remote repo and shared throughout all of your projects easily.


### One More Thing

If you are an Alfred user you can find a handy workflow that automates everything in this post [here](https://mega.co.nz/#!JV1QWKbJ!HmLBN7efh_5_bd4TXC7hx2QNgL3DzHO0QEvInBzYUDo). Usage is simple and works in two different ways: 1. using the `unitysubmoduleadder` keyword which will then provide a folder filter for you to choose your Unity project. 2. Place a single folder in the folder buffer (option + up) then use the Unity Git Submodule Adder action (option + right arrow).