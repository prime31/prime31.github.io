---
layout: post
title: "PropEnumEvents (wtf?)"
date: 2015-03-27 21:05:54 -0700
categories:
permalink: "prop-enum-events"
published: true
---


I often use [StateKit](https://github.com/prime31/StateKit) (a simple, object-based finite state machine implementation) for all kinds of state management. It gets used for enemy AI, player controllers, menus and just about everywhere else. In a recent project that was not very well defined (to be honest, it was made almsot completely on the fly) I needed a super flexible way to deal with a hierarchial state machine. The solution presented in this post is what I ended up using and it has been dubbed the PropEnumEvent system.

<!-- more -->


## Defining the Problem

Let's say you have a game with a main menu and some submenus. Maybe you have no idea how many menus and you need a nice, flexible way to deal with them. We'll start things off by creating an enum that has a value for each menu/state in the game.


{% codeblock lang:csharp %}
public enum GameState
{
	MainMenu,
	LevelSelectMenu,
	MultiPlayerMenu,
	Map
}
{% endcodeblock %}


To add a bit of spice to the discussion, lets add some substates for the GameState.Map value:


{% codeblock lang:csharp %}
public enum MapState
{
	Editing,
	PrePlay,
	Playing,
	Paused,
	PlayerWon,
	PlayerDied
}
{% endcodeblock %}


If we were to whip up a quick diagram for what we have so far it might look something like this:


![](/images/posts/propEnumEvents/state-flow.png)


We can only be on one screen at any given time and the Map screen has several different sub states. Nothing groundbreaking here so far. We want to use these enums to drive the entire state of the game from launch until completion. We are going to need to show/hide UI, HUD elements, control enemy AI state etc. There is no limit to how far you can take it.


## Decouple the Pieces!

I personally hate tightly coupled code. It makes changing things, adding features and refactoring a huge PITA. [MessageKit](https://github.com/prime31/MessageKit) solves a lot of the tight coupling problems and it will be used for the PropEnumEvent system since I always already have it in whatever project I am working on. The meat of the solution is incredibly simple but quite powerful (and quite similar to [INotifyPropertyChanged](https://msdn.microsoft.com/en-us/library/system.componentmodel.inotifypropertychanged%28v=vs.110%29.aspx?f=255&MSPPError=-2147217396) or [KVO](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/KeyValueObserving/KeyValueObserving.html)). All we are going to do is wire up a property that when changed uses MessageKit to post a message with the new enum value (note that plain old .NET events would work fine as well for this if you don't use MessageKit). You'll see in the code below the message is posted *before* the value is set. The reason for that is that sometimes the system listening for the message needs to know the previous state (UI for example so that it can do proper transitions). When the message is received the receiver will get the new state and they can access the old state via the *state* property.


{% codeblock lang:csharp %}
static GameState _state;
public static GameState state
{
	get
	{
		return _state;
	}
	set
	{
		if( _state == value )
			return;

		MessageKit<GameState>.post( Messages.gameStateChanged, value );
		_state = value;
	}
}


static MapState _state;
public static MapState state
{
	get
	{
		return _state;
	}
	set
	{
		if( _state == value )
			return;

		MessageKit<GameState>.post( Messages.mapStateChanged, value );
		_state = value;
	}
}
{% endcodeblock %}


That's it. Nothing more to it. In that little snippet of code we end up with a powerful, decoupled system to control our games. Adding new enum values as the game grows in complexity is no problem. Code can set the enum and trigger the message at any time easily. Some example message listeners from the project this was used in are HUD (activates/deactivates features based on state), canvas (hides/shows menus with animations based on state), player (enables/disables self, jumps to spawn point, increments death count).

