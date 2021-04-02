---
layout: post
title: "Using the Stencil Buffer for Sprite Occlusion"
date: 2015-10-13 00:19:16 -0700
categories:
permalink: "stencil-buffer-occlusion"
published: true
---


Back in <a href="/SpriteLightKit/">the post</a> on SpriteLightKit, we talked about the stencil buffer and we left things off with a homework assignment. I also did the homework assignment and will be sharing the result that I came up with.

<!-- more -->

First, let's have a look at what the resulting shaders look like in action. We have one shader for the trees (occluders) and one for the player (occluded).

<iframe src="https://gfycat.com/ifr/AdoredIndolentAmphiuma" frameborder="0" scrolling="no" width="790" height="405" style="-webkit-backface-visibility: hidden;-webkit-transform: scale(1);" ></iframe>


The full shaders are available below. At first glance they might seem really daunting but in reality they are super, duper simple. For some reason, Unity makes us use shaders for accessing the stencil buffer so because of that we have a lot more code than is really required (in "real life" stencil buffer access has nothing to do with a shader). Basically, all there is in these shaders below is a near copy of the standard sprite shader once for the occluder and twice for the occluded sprites and then our tiny stencil section on each. Lets ignore the sprite shader portion (since its so similar to the Unity default sprite shader) and have a look at the actual stencil portions.

First, the occluder sprites. Below is all of the code that actually matters for the stencil buffer. All it is doing is saying for every pixel we write to the color buffer lets replace the stencil buffer value with 4. So, in essence, anywhere there is an occluder pixel it will write 4 to the stencil buffer. Important side note: in the example the tree is not a solid sprite. It has lots of alpha = 0 portions (like most non-rectangle/square sprites) so in the shader we discard any pixels that are less than alpha 0.1. If you have a solid sprite that is not necessary.

{% highlight csharp %}
Stencil
{
	Ref 4
	Comp Always
	Pass Replace
}
{% endhighlight %}


Occluded sprites need two passes (once for rendering the silhouette and one for rendering the non-occluded portation) so we will have two different stencil sections for them. The first pass is going to render wherever the stencil buffer value is *not equal* to 4. So, anywhere that there is not an occluder the first pass will render. The second pass is exactly the opposite: wherever the stencil buffer value *is equal* to 4 it will render. When it renders it multiplies the output by a dark color to make a silhouette. That's all there is to it.

{% highlight csharp %}
// first pass
Stencil
{
	Ref 4
	Comp NotEqual
}

// second pass
Stencil
{
	Ref 4
	Comp Equal
}
{% endhighlight %}


Below is the full shader to be used for any occluder sprites.

{% highlight csharp %}
Shader "Sprites/Occluder"
{
	Properties
	{
		[PerRendererData] _MainTex ( "Sprite Texture", 2D ) = "white" {}
		_Color ( "Tint", Color ) = ( 1, 1, 1, 1 )
		[MaterialToggle] PixelSnap ( "Pixel snap", Float ) = 0
		_AlphaCutoff ( "Alpha Cutoff", Range( 0.01, 1.0 ) ) = 0.1
	}


	SubShader
	{
		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "TransparentCutout"
			"PreviewType" = "Plane"
			"CanUseSpriteAtlas" = "True"
		}

		Cull Off
		Lighting Off
		ZWrite Off
		Blend One OneMinusSrcAlpha

		Pass
		{
			Stencil
			{
				Ref 4
				Comp Always
				Pass Replace
			}

		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile _ PIXELSNAP_ON
			#include "UnityCG.cginc"

			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				half2 texcoord  : TEXCOORD0;
			};

			fixed4 _Color;
			fixed _AlphaCutoff;

			v2f vert( appdata_t IN )
			{
				v2f OUT;
				OUT.vertex = mul( UNITY_MATRIX_MVP, IN.vertex );
				OUT.texcoord = IN.texcoord;
				OUT.color = IN.color * _Color;
				#ifdef PIXELSNAP_ON
				OUT.vertex = UnityPixelSnap( OUT.vertex );
				#endif

				return OUT;
			}

			sampler2D _MainTex;
			sampler2D _AlphaTex;


			fixed4 frag( v2f IN ) : SV_Target
			{
				fixed4 c = tex2D( _MainTex, IN.texcoord ) * IN.color;
				c.rgb *= c.a;

				// here we discard pixels below our _AlphaCutoff so the stencil buffer only gets written to
				// where there are actual pixels returned. If the occluders are all tight meshes (such as solid rectangles)
				// this is not necessary and a non-transparent shader would be a better fit.
				clip( c.a - _AlphaCutoff );

				return c;
			}
		ENDCG
		}
	}
}
{% endhighlight %}


Below is the full shader to be used for any occluded sprites.

{% highlight csharp %}
Shader "Sprites/Occluded"
{
	Properties
	{
		[PerRendererData] _MainTex ( "Sprite Texture", 2D ) = "white" {}
		_Color ( "Tint", Color ) = ( 1, 1, 1, 1 )
		[MaterialToggle] PixelSnap ( "Pixel snap", Float ) = 0
		_OccludedColor ( "Occluded Tint", Color ) = ( 0, 0, 0, 0.5 )
	}


CGINCLUDE

// shared structs and vert program used in both the vert and frag programs
struct appdata_t
{
	float4 vertex   : POSITION;
	float4 color    : COLOR;
	float2 texcoord : TEXCOORD0;
};

struct v2f
{
	float4 vertex   : SV_POSITION;
	fixed4 color    : COLOR;
	half2 texcoord  : TEXCOORD0;
};


fixed4 _Color;
sampler2D _MainTex;


v2f vert( appdata_t IN )
{
	v2f OUT;
	OUT.vertex = mul( UNITY_MATRIX_MVP, IN.vertex );
	OUT.texcoord = IN.texcoord;
	OUT.color = IN.color * _Color;
	#ifdef PIXELSNAP_ON
	OUT.vertex = UnityPixelSnap( OUT.vertex );
	#endif

	return OUT;
}

ENDCG



	SubShader
	{
		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
			"PreviewType" = "Plane"
			"CanUseSpriteAtlas" = "True"
		}

		Cull Off
		Lighting Off
		ZWrite Off
		Blend One OneMinusSrcAlpha

		Pass
		{
			Stencil
			{
				Ref 4
				Comp NotEqual
			}


		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile _ PIXELSNAP_ON
			#include "UnityCG.cginc"


			fixed4 frag( v2f IN ) : SV_Target
			{
				fixed4 c = tex2D( _MainTex, IN.texcoord ) * IN.color;
				c.rgb *= c.a;
				return c;
			}
		ENDCG
		}


		// occluded pixel pass. Anything rendered here is behind an occluder
		Pass
		{
			Stencil
			{
				Ref 4
				Comp Equal
			}

		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile _ PIXELSNAP_ON
			#include "UnityCG.cginc"

			fixed4 _OccludedColor;


			fixed4 frag( v2f IN ) : SV_Target
			{
				fixed4 c = tex2D( _MainTex, IN.texcoord );
				return _OccludedColor * c.a;
			}
		ENDCG
		}
	}
}
{% endhighlight %}
