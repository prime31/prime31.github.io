---
layout: post
title: "Simple Value Mapping"
date: 2015-01-16 11:53:46 -0800
categories:
permalink: "simple-value-mapping"
published: true
---


This post is a quick one that covers a technique that I use all over the place: mapping a value from one range to a completely different range. Uses include everything from a simple health bar to mesh deformation to UI layout to shader vertex mods and tons more.

<!-- more -->

Lets say you want to show health bars for all the enemies or players in your game. The health of each varies from 10 for weaker enemies up to 200 for bosses. Whenever the health changes you want to update the health bar in the UI. This is where value mapping comes in handy. Most UI elements (and many other value-based scenarios) map from 0 to 1. The max health of your entities varies so you need a simple way to map that back to the 0 to 1 range.



## Mapping Health Value to UI Value

![](/images/posts/valueMapping/health-map.png)


Mapping to the 0 to 1 range is pretty simple. The map01 method below shows how to do it. For the case presented in the screenshot the entity health is approximately 70. Running that through the `map01` method (code is below) like so `map01( 70f, 0f, 250f )` results in a value of 0.28f.


{% codeblock lang:csharp %}
// Maps a value from some arbitrary range to the 0 to 1 range
public static float map01( float value, float min, float max )
{
	return ( value - min ) * 1f / ( max - min );
}
{% endcodeblock %}


The `map01` method is just a reduction of a full value mapping method. The `map` method below allows you to not only map to the 0 to 1 range but expands the idea to allow mapping to any arbitrary range.


{% codeblock lang:csharp %}
// Maps a value from ome arbitrary range to another arbitrary range
public static float map( float value, float leftMin, float leftMax, float rightMin, float rightMax )
{
	return rightMin + ( value - leftMin ) * ( rightMax - rightMin ) / ( leftMax - leftMin );
}
{% endcodeblock %}


With the ability to map from one range to any other range you can start to do some interesting things. If you read the [Interactive 2D Foliage post](/grass2d/), you may have noticed it actually used the `map` method to handle bending the foliage. In this particular use case we want to know how far our player moved into a trigger collider and then map that to a range of -1 to 1. We use the mapped -1 to 1 value to decide how far we will bend the foliage verts. Here is the relevant code snippet:

{% codeblock lang:csharp %}
// figure out how far we have moved into the trigger and then map the offset to -1 to 1.
// 0 would be neutral, -1 to the left and +1 to the right.
var offset = col.transform.position.x - transform.position.x;
var radius = _colliderHalfWidth + col.bounds.size.x * 0.5f;
var mappedOffset = map( offset, -radius, radius, -1f, 1f );
setVertHorizontalOffset( mappedOffset );
{% endcodeblock %}
