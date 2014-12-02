---
layout: post
title: "ConstantsGeneratorKit: Killing Naked Strings so You Don't Have To"
date: 2014-12-01 19:12:12 -0800
categories:
permalink: "constants-generator-kit"
published: false
---


Killing naked strings? What the heck does that even mean? If you have ever worked on a large project with a medium-to-large sized team you will know exactly what I am talking about. How many times have you seen brittle code like this `GameObject.FindWithTag( "SpawnPoint" )` or this `someGameObject.tag == "Enemy"`? Those strings are naked and afraid and they will come back to haunt you later.

<!-- more -->

### The Problem(s) Defined
For the purposes of this discussion we will define a *naked string* as any string that is not declared as a constant. That means anytime you start typing a quote (") in your code you are making a naked string and causing problems for future you or the rest of your team. Lets say, for example, you are doing GameObject.tag compares to naked strings like in the first paragraph. What happens if you want to change the tag from "Enemy" to "Tank"? You then have


[available here](https://github.com/prime31/ConstantsGeneratorKit)