---
layout: post
title: "SpriteLightKit and Stencil Buffer Introduction"
date: 2015-09-04 12:43:25 -0700
categories:
permalink: "SpriteLightKit"
published: true
---



SpriteLightKit brings back the old two buffered blend trick to get pseudo lighting with just sprites. It handles the setup process of getting that second buffer blended with your normal scene. This post will delve into how it works and along the way it will explain the shader techniques used to pull it off.


<!-- more -->


First off, you can find SpriteLightKit in the usual location on [GitHub](https://github.com/prime31/SpriteLightKit). The README has instructions on how to setup SpriteLightKit in your own game and the repo includes a demo scene so that you can see it in action and play around with it. This post won't touch on the setup procedures so be sure to checkout the README for that information. Do note that the ambient light of the scene is setup by just changing the SpriteLightKit camera's background color. A dark grey is usually a good place to start for your ambient light.


Below is what the demo scene included with SpriteLightKit looks like. There are six sprite lights in the scene with 2 of them animated. You can see that the clock tower and the street light are always fully bright. Take note of this for now and we will come back to it later.


<iframe src="http://gfycat.com/DecisiveGregariousAlbacoretuna" frameborder="0" scrolling="no" width="796" height="448" style="-webkit-backface-visibility: hidden;-webkit-transform: scale(1);" ></iframe>


This next gif shows what the scene looks like when taking the ambient light (the camera background color) from yellow to full black.


<iframe src="http://gfycat.com/DaringTallCrane" frameborder="0" scrolling="no" width="640" height="360" style="-webkit-backface-visibility: hidden;-webkit-transform: scale(1);" ></iframe>


### Lights that aren't actually lights

What SpriteLightKit does is really simple: it renders the output of a camera that can only see your lights and then blends it on top of your normal game view. Simple and very cheap. The performance cost of a sprite light is nowhere near what a regular light costs. You can have tons of sprite lights all over your scene with a negligible performance cost. It works a little bit like deferred lighting in that the total amount of lights in your scene doesn't really matter.


So, if a sprite light isn't a light what is it? It is just a plain old Unity Sprite with the SpriteLightMaterial applied. The SpriteLightMaterial lets you choose the blend mode of the sprite light. Where alpha is zero the light will have no effect and where alpha is 1 the light will be fully bright. Besides that it is identical to the default Unity sprite shader. Generally, a sprite light will have a simple texture with an alpha gradient of some sort that fades out to zero alpha. That will create a soft edged light but don't let that stop you from making hard edged lights or any other crazy ideas you want to try. Hard edged cookies can have a really neat effect.


SpriteLightColorCycler is a script included with SpriteLightKit that lets you animate your lights really easily. Just stick it on any sprite light and play around with the inspector properties. You can create lights that flicker on and off, cycle through different colors or just affect a single color channel (red/green/blue).



### So, how does it work?

At it's core it is a pretty simple kit but it is an interesting one due to all the different Unity and shader features it employs. All the sprite lights are rendered using a 2nd camera that outputs to a RenderTexture. An image effect on the main camera then blends the RenderTexture with the normal camera's output. If you are new to RenderTextures and image effects, SprightLightKit's code is a great way to get your feet wet due to it being about as simple as you will ever see.



## Introducing, the big scary stencil buffer

Unity describes the stencil buffer in the following way: *The stencil buffer can be used as a general purpose per pixel mask for saving or discarding pixels.* That is really all there is to it. The stencil buffer is basically an integer that a shader can write to or read from. It can be incremented or decremented as well. All this doesn't sound too interesting at first glance but it is very useful in action.


### Emissive features that aren't really emissive (more like self illuminated)

SpriteLightKit uses the stencil buffer to provide a way to specify parts of your scene that you don't want to take part in the mock lighting system. For any piece of your main scene to be able to be self illuminated (like the aforementioned clock tower and street light) you just have to apply the SpriteLightEmissiveSpriteMaterial or SpriteLightEmissiveMeshMaterial to the object that should be self illuminated. Lets take a look at the stencil section of the shader used in both materials.


{% highlight csharp %}
Stencil
{
	Ref 2
	Comp Always
	Pass Replace
}
{% endhighlight %}


We are only going to touch on a few of the stencil operations. For full list of all the available stencil operations be sure to check the [Unity docs](http://docs.unity3d.com/Manual/SL-Stencil.html). Lets talk through the stencil block above in English. Hopefully it will be pretty clear what each line does after it is explained. The value 2 will *always* *replace* the current value in the stencil buffer. *Ref* is the value, *Comp* is the comparison function and *Pass* is what should be done if the comparison function passes (it is *Always* so it always passes).

Below we have the stencil block from the image effect that SpriteLightKit uses. In English, it checks to see if the current value in the stencil buffer is *NotEqual* to 2. If the test fails (as it will if our self illuminated material wrote 2 to the stencil buffer) then it will do nothing for that pixel. If it succeeds (everywhere there is not a self illuminated pixel) it will continue to render and blend the RenderTexture with the main camera output.

{% highlight csharp %}
// all emissives write 2 to the stencil buffer. We want to render everything except those pixels
Stencil
{
	Ref 2
	Comp NotEqual
}
{% endhighlight %}


![](//f.cl.ly/items/2N43273s1b1w3r2M1W2b/fez.png) The stencil buffer can be used for all kinds of trickery such as portals (as popularized by the game Portal), masks, shadows and anything else you can come up with. They are super efficient and since they occur _before_ pixel shading they can be used to discard pixels that don't need to be processed. As a homework assignment, see if you can use the stencil buffer to replicate the screenshot from Fez. Hint: your sprite will need a 2 pass shader to pull this off. In a future blog post we will go over how to pull off the effect and provide the shaders to do so.
