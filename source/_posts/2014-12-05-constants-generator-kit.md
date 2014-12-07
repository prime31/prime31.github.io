---
layout: post
title: "ConstantsGeneratorKit: Killing Naked Strings so You Don't Have To"
date: 2014-12-05 19:12:12 -0800
categories:
permalink: "constants-generator-kit"
published: true
---


Killing naked strings? What the heck does that even mean? If you have ever worked on a large project with a medium-to-large sized team you will know exactly what I am talking about. How many times have you seen brittle code like this `GameObject.FindWithTag( "SpawnPoint" )` or this `someGameObject.tag == "Enemy"`? Those strings are naked and afraid and they will come back to haunt you later.

<!-- more -->

### The Problem(s) Defined
For the purposes of this discussion we will define a *naked string* as any string that is not declared as a constant. That means anytime you start typing a quote (") in your code you are making a naked string and causing problems for future you or the rest of your team. Let's say, for example, you are comparing GameObject.tag to naked strings as in the first paragraph. What happens if you want to change the tag from "Enemy" to "Tank"? You then have to search your project and hope that you find all the places where you used the "Enemy" string. The worst part is that bugs like this are **very** hard to track down.



### The (Dead Simple) Solution
There are various ways to solve this problem. The most common is constant string properties/fields in classes. As long as you are diligent and make sure that you always remember to update the strings when you change your tags, all will be well. We all know that isn't happening though. Either you or somebody else will change something and forget to update the string. Good luck tracking that bug down.


Enter ConstantsGeneratorKit: the solution to naked strings. As an added benefit, it will also solve your naked layer ints, naked scene names and the worst offender of them all: naked resource paths. You can find ConstantsGeneratorKit on [GitHub](https://github.com/prime31/ConstantsGeneratorKit). It's a single script. Stick it in a folder named Editor somewhere in your project. That's it. ConstantsGeneratorKit will wait for changes in scenes, layers, tags and resources then generate classes with all the strings and ints setup as *const*. Yup. That means you get autocomplete for all of them. Just type `k.` and bask in the glory (by default ConstantsGeneratorKit stick everything in the "k" namespace for easy access but you can configure that and other options right in the file.) Below are examples of the 4 classes that ConstantsGeneratorKit generates automatically.



### Tags.cs
{% codeblock lang:csharp %}
namespace k
{
	public static class Tags
	{
		public const string EDITOR_ONLY = "EditorOnly";
		public const string MAIN_CAMERA = "MainCamera";
		public const string PLAYER = "Player";
	}
}
{% endcodeblock %}


### Layers.cs
{% codeblock lang:csharp %}
namespace k
{
	public static class Layers
	{
		public const int DEFAULT = 0;
		public const int TRANSPARENT_FX = 1;
		public const int IGNORE_RAYCAST = 2;
		public const int WATER = 4;
		public const int UI = 5;
		public const int PLAYER = 8;


		public static int onlyIncluding( params int[] layers )
		{
			int mask = 0;
			for( var i = 0; i < layers.Length; i++ )
				mask |= ( 1 << layers[i] );

			return mask;
		}


		public static int everythingBut( params int[] layers )
		{
			return ~onlyIncluding( layers );
		}
	}
}
{% endcodeblock %}


### Scenes.cs
{% codeblock lang:csharp %}
namespace k
{
	public static class Scenes
	{
		public const string LEVEL_ONE = "LevelOne";
		public const string LEVEL_TWO = "LevelTwo";
		public const string LEVEL_THREE = "LevelThree";

		public const int TOTAL_SCENES = 3;


		public static int nextSceneIndex()
		{
			if( UnityEngine.Application.loadedLevel + 1 == TOTAL_SCENES )
				return 0;
			return UnityEngine.Application.loadedLevel + 1;
		}
	}
}
{% endcodeblock %}


### Resources.cs
{% codeblock lang:csharp %}
namespace k
{
	public static class Resources
	{
		public const string LAND_POOF = "LandPoof";
		public const string BLOOD_BIT = "SubFolder/BloodBit";
		public const string EXCLAMATION = "SubFolder/Exclamation";
	}
}
{% endcodeblock %}