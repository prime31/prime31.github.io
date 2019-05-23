---
layout: post
title: "Making a Sprite Blink"
date: 2015-04-19 14:48:41 -0700
categories: ["reader question", "shaders"]
permalink: "sprite-blink-shader"
published: true
---


This is the first post in response to a reader-suggested topic and probably not the last. If there is a specific topic that you would like to see covered feel free to send over a question/request. Quite often when dealing with sprites you may want to have the sprite blink in a solid color to indicate various different states such as taking damage, build up before attack, etc. Unity's default sprite shader has only a tint color property so out of the box it isn't possible to do.


<!-- more -->


We aren't going to go into great detail on the basics of writing a shader in this post but only a rudimentary understanding is required. For an in-depth beginners guide to shaders you can checkout our tutorial series on <a href="https://www.youtube.com/playlist?list=PLb8LPjN5zpx1tauZfNE1cMIIPy15UlJNZ">YouTube.</a> First things first: visit <a href="http://unity3d.com/get-unity/download/archive">Unity's website</a> and fetch the built in shader source. We are going to just add a few lines to the Sprites-Default shader to add the blink effect.


### The Shader

The first thing we are going to need to do is add a property to the shader so that we can specify the blink color. Just add the following line in the Properties section to do so:

{% highlight csharp %}
_BlinkColor ("Blink Color", Color) = (1,1,1,1)
{% endhighlight %}


Next up, we need to add the declaration in the shader for the new _BlinkColor property that we just added. This can be done by adding the following line directly under (or above) the `fixed4 _Color;` declaration already present in the shader:

{% highlight csharp %}
fixed4 _BlinkColor;
{% endhighlight %}


There are a few different ways we can handle the blinking. A nice, flexible approach for this particular case would be to provide the ability to immediately flash to the blink color but also provide a way to smoothly interpolate from the current color to the blink color. Doing it this way should provide the most flexibility. Locate the line in the shader that looks like this:
`fixed4 c = tex2D(_MainTex, IN.texcoord) * IN.color;`
Directly underneath that add the line below which will handle the blinking.


{% highlight csharp %}
c.rgb = lerp( c.rgb, _BlinkColor.rgb, _BlinkColor.a );
{% endhighlight %}


What we are doing in that line is using the alpha value of the blink color to interpolate the final color from the original sprite color to our blink color. If the blink color has an alpha of 0 then the standard sprite color will be displayed. When the blink color has an alpha of 1 only the blink color will be shown. Any value in between 0 and 1 will interpolate between the two colors.


### Code to Control the Shader

Now that we have the shader code all wrapped up we need to make a quick script to manage the blink color. The code block below will do a hard blink (jump from the sprite color directly to the blink color). To see it in action check out <a href="http://cl.ly/ai7N">this short video.</a>


{% highlight csharp %}
IEnumerator blink( float delayBetweenBlinks, int numberOfBlinks, Color blinkColor )
{
	var material = GetComponent<SpriteRenderer>().material;
	var counter = 0;
	while( counter <= numberOfBlinks )
	{
		material.SetColor( "_BlinkColor", blinkColor );
		counter++;
		blinkColor.a = blinkColor.a == 1f ? 0f : 1f;
		yield return new WaitForSeconds( delayBetweenBlinks );
	}

	// revert to our standard sprite color
	blinkColor.a = 0f;
	material.SetColor( "_BlinkColor", blinkColor );
}
{% endhighlight %}


This final code block shows how to use the interpolation we built into the shader. It just does a simple ping-pong of the alpha value so that you can see how the shader works. <a href="http://cl.ly/ai82">Here it is</a> in action. You can get a lot fancier with the final outcome of the blink by varying the alpha value in a non-linear way (using AnimationCurves, a <a href="/anatomy-of-a-tween-lib/">tween library</a>, easing equations, etc).


{% highlight csharp %}
IEnumerator blinkSmooth( float timeScale, float duration, Color blinkColor )
{
	var material = GetComponent<SpriteRenderer>().material;
	var elapsedTime = 0f;
	while( elapsedTime <= duration )
	{
		material.SetColor( "_BlinkColor", blinkColor );

		blinkColor.a = Mathf.PingPong( elapsedTime * timeScale, 1f );
		elapsedTime += Time.deltaTime;
		yield return null;
	}

	// revert to our standard sprite color
	blinkColor.a = 0f;
	material.SetColor( "_BlinkColor", blinkColor );
}
{% endhighlight %}
