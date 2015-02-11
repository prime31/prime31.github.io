---
layout: post
title: "Making PlayerPrefs Sane"
date: 2015-02-11 10:24:30 -0800
categories:
permalink: "making-playerprefs-sane"
published: true
---

In past posts (mainly [this one](/constants-generator-kit)), we talked about reducing or removing all "naked strings". We do this to reduce coding errors and maintain sanity as projects grow in size. The post provided a solution for tags, layers, scenes and resources. It did not, however, help clean up the much used-and-abused PlayerPrefs.

<!--more-->

First off, let's just get this out of the way: if you are storing any large amounts of data in PlayerPrefs stop doing that immediately. PlayerPrefs is a simple key/value store. If you need to store more data then use the proper medium: files. The previous post on [Persisting Strongly Typed Data With JSON](http://blog.prime31.com/persisting-data-with-json) would be a good solution. I have seen some horrendous code where people were storing all their persistant data in PlayerPrefs and then they were surprised when certain operating systems were truncating and/or removing that data because it exceed the key/value size. The moral of the story is don't be that guy. It's a very hard bug to track down. Save yourself the pain.


## Make Them Sane!

Now that we got all that out of the way let's get down to business. Our goal here is to make safe, simple access to PlayerPrefs and to hide all the ugly strings used for the keys. By doing this, we also get to add some oddly missing features to PlayerPrefs such as support for bools. Lets start by adding a new class and putting in a property to access an int, in this case it will be the last level that was played. We want to remove all the naked strings so we make a `const string` to hold the key name and a property to access the data. Nice, simple and most importantly fool-proof.


{% codeblock lang:csharp %}
public static class SanePrefs
{
	private const string LAST_PLAYED_LEVEL = "lastPlayedLevel";


	public static int lastPlayedLevel
	{
		get { return PlayerPrefs.GetInt( LAST_PLAYED_LEVEL, -1 ); }
		set { PlayerPrefs.SetInt( LAST_PLAYED_LEVEL, value ); }
	}


	public static void save()
	{
		PlayerPrefs.Save();
	}
}
{% endcodeblock %}


Accessing our int is now a simple call to `SanePrefs.lastPlayedLevel`. Setting the last played level is equally is simple: `SanePrefs.lastPlayedLevel = 3`. Whenever we need a new pref we just add it to this class. The below example adds a string and a bool. Now PlayerPrefs doesn't have bools so we use the isFirstPlay property to handle a transition from int to bool behind the scenes. The playerName example also illustrates one additional feature we can add: it auto saves the PlayerPrefs when it is set. This is something you will only want to do for prefs that aren't set often. You can't be guaranteed that the save call is going to be performant and there is no reason to be writing to disk after every set. playerName is only ever set once so it is a good candidate to auto save.


{% codeblock lang:csharp %}
public static class SanePrefs
{
	private const string IS_FIRST_PLAY = "isFirstPlay";
	private const string LAST_PLAYED_LEVEL = "lastPlayedLevel";
	private const string PLAYER_NAME = "playerName";


	public static bool isFirstPlay
	{
		get { return PlayerPrefs.GetInt( IS_FIRST_PLAY ) == 1; }
		set { PlayerPrefs.SetInt( IS_FIRST_PLAY, value ? 1 : 0 ); }
	}


	public static int lastPlayedLevel
	{
		get { return PlayerPrefs.GetInt( LAST_PLAYED_LEVEL, -1 ); }
		set { PlayerPrefs.SetInt( LAST_PLAYED_LEVEL, value ); }
	}


	public static string playerName
	{
		get { return PlayerPrefs.GetString( PLAYER_NAME, string.Empty ); }
		set
		{
			PlayerPrefs.SetString( PLAYER_NAME, value );
			PlayerPrefs.Save();
		}
	}


	public static void save()
	{
		PlayerPrefs.Save();
	}
}
{% endcodeblock %}


That's all there is to it. Nothing magical here, just wrapping up a naked string based API and making it easier to use. One last little note to make here is that by wrapping our prefs up in a class like this if at some point in the future we no longer want to be using PlayerPrefs we only ever have to change the code in this class to make the backing store anything we want. For example, on iOS perhaps we want to persist this data to iCloud so that is available across multiple devices. All we need to do is swap out the PlayerPrefs calls for iCloud equivalents.
