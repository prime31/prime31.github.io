---
layout: post
title: "Zombie Ninjas Attack: A survivor's retrospective"
date: 2014-11-22 17:12:03 -0800
comments: false
categories: [CSS3, Sass, Media Queries]
---





{% titlecard %}
This is the EXCERPT. This is the EXCERPT. This is the EXCERPT. This is the EXCERPT. This is the EXCERPT. This is the EXCERPT. This is the EXCERPT. This is the EXCERPT. This is the EXCERPT. 
{% endtitlecard %}

<!-- more -->


{% card %}
Second paragraph. Testing an embed.
<iframe src="//www.youtube.com/embed/iWxIM9U5gHo" allowfullscreen></iframe>
{% endcard %}


{% card What the Fuck are You Doing %}
Hi. Im a card. This card happens to have a title. How does it look?
{% endcard %}



{% card %}
This is the fucking post. This is the fucking post. This is the fucking post. This is the fucking post. This is the fucking post. This is the fucking post. This is the fucking post. This is the <b>fucking</b> post. This is the fucking post. This is the fucking post. This is the fucking post. This is the fucking post. This is the fucking post. This is the fucking post. This is the fucking post. This is the fucking post. This is the fucking post. This is the fucking post. This is the fucking post. This is the fucking post. This is the fucking post. 
{% endcard %}



{% card %}
{% codeblock lang:csharp %}
public class Foliage : MonoBehaviour
{
	// the offset from the player when they entered the trigger
	private float _enterOffset;
	// the offset from the player when the exited the trigger
	private float _exitOffset;
	// bending is when the player is still in the trigger and has moved past the midway point
	private bool _isBending;
	// rebounding is when the player as existed the trigger
	private bool _isRebounding;

	public bool isWindEnabled = true;
	[Range( 0f, 3f )]
	public float windForceMultiplier = 1f;
	[Tooltip( "Higher numbers increase the period of the sin wave" )]
	public float windPeriod = 3f;
	[Tooltip( "When the sin wave reaches a valley this will be the lowest point that it will reach" )]
	[Range( 0f, 0.1f)]
	public float baseWindForce = 0.05f;


	/// <summary>
	/// how far shall we bend the foliage
	/// </summary>
	const float BEND_FACTOR = 0.1f;
	const float BEND_FORCE_ON_EXIT = 0.2f;
	private MeshFilter _meshFilter;
	private Spring _spring = new Spring();
	private float _colliderHalfWidth;
}
{% endcodeblock %}
{% endcard %}


{% card %}
var t = "sthi";
t.EndsWith( "st" );
{% endcard %}