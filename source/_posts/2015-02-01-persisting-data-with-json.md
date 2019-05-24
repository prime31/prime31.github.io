---
layout: post
title: "Persisting Strongly Typed Data With JSON"
date: 2015-02-02 10:24:30 -0800
categories:
permalink: "persisting-data-with-json"
published: true
---


JSON is often thought of as a data transport format for hipsters who use Node.js or Ruby or whatever the new language/platform for cool kids is this week. JSON also happens to be a fantastic way for us nerds to store data in a human-readable format that is well suited for game dev.

<!-- more -->

Let us start by saying you do not need to wear tight-fitting jeans or buy your entire wardrobe from Urban Outfitters to be able to use JSON. It is assumed that you have some idea what JSON is. If you do not, now is a good time to reference the [JSON page](http://www.json.org/) or [Wikipedia](http://en.wikipedia.org/wiki/JSON). We will be using the JSON library that comes with every prime31 plugin (in the P31RestKit.dll) for the examples in this post. Feel free to substitue your own favorite JSON library if it supports serializing classes.


## The Problem

Every game has to persist data at some point whether it be player stats, high scores, continue points or just player's chosen name. Unity provides the PlayerPrefs class for simple data. Many people abuse PlayerPrefs and try to store all of their game data in it which is a poor idea. PlayerPrefs are backed by platform specific, simple key-value stores on some platforms. They were designed to store only a small amount of data that often remains in memory at all times. Some platforms have an upper limit on how large any key/value pair can be as well. Be smart and use PlayerPrefs for what it was intended for: simple key/value pairs.


## The Solution

There are many, many ways to persist data. Some of the most popular include XML, SQL/SQLite, Protocol Buffers, web-based data stores, BinaryFormatter, etc. You have to choose the right tool for the job. As you can imagine, in this post we will be using JSON as our data format which is well suited for small to moderate amounts of data. If you have a massive amount of data you should consider using a database. If you need the data available on multiple devices a web-based data store is a good idea (which you can store JSON in as well).


In the example that follows, we are going to take a mock GameData class (which would represent all the data that you may want to store for your game) and persist it to disk. In an effort to not make this example to simple or too complex the GameData class will contain a single List of LevelStats as well. The LevelStats class represents the score and grade that a player got on that particular level. It uses an Enum for the grade. This hierarchy of classes is complex enough to be real world but easy enough to follow along with. Without further ado here are the two classes:


{% highlight csharp %}
public class GameData
{
	public string playerName;
	public float totalScore;
	public List<LevelStats> levelStats;
}

public class LevelStats
{
	public enum LevelStatsGrade
	{
		A,
		B,
		C,
		D,
		F
	}

	public int levelNumber;
	public float levelScore;
	public LevelStats.LevelStatsGrade levelGrade;
}
{% endhighlight %}


In this scenario, GameData is the main point of entry for the persistant data. We want to keep things organinized, logical and simple to use so we will add two new methods to the GameData class to handle saving and loading data from disk. Each method will take in a filename so that we can store multiple GameData classes to disk. This is useful for games with more than one "save slot". If your game is single player with no notion of save slots feel free to hardcode the filename. The code is pretty basic but there is one bit that I want to draw your attention to. When calling `Json.decode<>` you have to tell the JSON library which class you want to deserialize the data back into. In this case it is the GameData class.


{% highlight csharp %}
public void saveToFile( string filename )
{
	var json = Json.encode( this );
	File.WriteAllText( Path.Combine( Application.persistentDataPath, filename ), json );
}

public static GameData createGameDataFromFile( string filename )
{
	var json = File.ReadAllText( Path.Combine( Application.persistentDataPath, filename ) );
	return Json.decode<GameData>( json );
}
{% endhighlight %}


That's all there is to it. Now all you have to do is call `gameData.saveToFile( "game-data.json" )` where appropriate to persist the data (perhaps after each level and in OnApplicationPause/Quit). When you want to fetch the data at startup you just call `gameData = GameData.createGameDataFromFile( "game-data.json" )`. An example of what the data in the game-data.json file looks like after saving is below. You can see that it is easily readable and you can hand-edit it as well if needed. Tip: to pretty-print the JSON (like the example below) or any other object you can use the `Prime31.Utils.logObject` method.

{% highlight javascript %}
{
	"playerName": "Hello Kitty",
	"totalScore": 12.4,
	"levelStats": [
		{
			"levelNumber": 1,
			"levelScore": 100,
			"levelGrade": 0
		},
		{
			"levelNumber": 2,
			"levelScore": 75,
			"levelGrade": 2
		},
		{
			"levelNumber": 3,
			"levelScore": 13,
			"levelGrade": 4
		}]
}
{% endhighlight %}
