---
layout: post
title: "SpriteLightKit"
date: 2015-09-02 12:43:25 -0700
categories:
permalink: "SpriteLightKit"
published: false
---



SpriteLightKit brings back the old two buffered blend trick to get pseudo lighting with just sprites. It handles the setup process of getting that second buffer blended with your normal scene. This post will delve into how it works and long the way it will explain the shader techniques used to pull it off.


<!-- more -->


First off, you can find SpriteLightKit in the usual location on [GitHub](https://github.com/prime31/SpriteLightKit). The README has instructions on how to setup SpriteLightKit in your own game and the repo includes a demo scene so that you can see it in action and play around with it. This post won't touch on the setup procedures so be sure to checkout the README for that information. Due note that the ambient light of the scene is setup by just changing the SpriteLightKit Camera's background color. A dark grey is usually a good place to start for your ambient light.



### Lights that aren't actually lights

What SpriteLightKit does is really simple: it renders the output of a camera that can only see your lights and then blends it on top of your normal game view. Simple and very cheap. The performance cost of a sprite light is nowhere near what a regular light costs. You can have tons of sprite lights all over your scene with a negligible performance cost. It works a little bit like deferred lighting in that the total amount of lights in your scene doesn't really matter.


So, if a sprite light isn't a light what is it? It is just a plain old Unity Sprite with the SpriteLightMaterial applied. The SpriteLightMaterial lets you choose the blend mode of the sprite light. Where alpha is zero the light will have no effect and where alpha is 1 the light will be fully bright. Generally, a sprite light will have a simple texture with an alpha gradient of some sort that fades out to zero alpha. That will create a soft edged light but don't let that stop you from making hard edged lights or any other crazy ideas you want to try. Hard edged cookies can have a really neat effect.



### Lights that can lighten *or* darken

Sometimes you may want to use lights to both lighten and darken your scene. They key to making this work is the 2x Multiplicative toggle on the SpriteLightKitImageEffect. When true, all this does is multiply the final color (your normal scene + the sprite lights) by 2. This effectively over brightens your lights due to the doubling of the final color. Any sprite lights that you add to your scene that have a darker color than your ambient light will darken it and any lighter colors will lighten it.


SpriteLightColorCycler is a script included with SpriteLightKit that lets you animate your lights really easily. Just stick it on any sprite light and play around with the inspector properties. You can create lights that flicker on and off, cycle through different colors or just affect a single color channel (red/green/blue).



### Emissive features that aren't really emissive (more like self illuminated)

The SpriteLightEmissiveSpriteMaterial or SpriteLightEmissiveMeshMaterial


{% codeblock lang:csharp %}
Stencil
{
	Ref 2
	Comp Always
	Pass Replace
}
{% endcodeblock %}


{% codeblock lang:csharp %}
// all emissives write 2 to the stencil buffer. We want to render everything except those pixels
Stencil
{
	Ref 2
	Comp NotEqual
}
{% endcodeblock %}


### stuff





text here text here text here text here


text here text here text here text here

<iframe src="http://gfycat.com/DistortedPettyGelding" frameborder="0" scrolling="no" width="796" height="448" style="-webkit-backface-visibility: hidden;-webkit-transform: scale(1);" ></iframe>
<iframe src="http://www.gfycat.com/DenseQueasyAmurminnow" frameborder="0" scrolling="no" width="796" height="448" style="-webkit-backface-visibility: hidden;-webkit-transform: scale(1);" ></iframe>
<iframe width="700" height="400" src="https://www.youtube.com/embed/hDJQXzajiPg?list=PLb8LPjN5zpx1tauZfNE1cMIIPy15UlJNZ" frameborder="0" allowfullscreen></iframe>

text here text here text here text here









{% codeblock lang:csharp %}
{% endcodeblock %}

