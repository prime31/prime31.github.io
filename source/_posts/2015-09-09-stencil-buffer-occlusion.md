---
layout: post
title: "Using the Stencil Buffer for Sprite Occlusion"
date: 2015-09-09 00:19:16 -0700
categories:
permalink: "stencil-buffer-occlusion"
published: false
---




<!-- more -->

Below is the full shader to be used for any occluder sprites.

{% codeblock lang:csharp %}
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
{% endcodeblock %}


Below is the full shader to be used for any occluded sprites.

{% codeblock lang:csharp %}
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
{% endcodeblock %}