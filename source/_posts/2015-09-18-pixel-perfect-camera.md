---
layout: post
title: "Pixel Perfect Camera"
date: 2015-09-18 16:57:31 -0700
categories:
permalink: "pixel-perfect-camera"
published: true
---


This post is going to be a little bit different. It will mainly consist of a video with a small amount of accompanying text. Hit me up on Twitter ([@prime_31](https://twitter.com/prime_31)) to let me know if you prefer text or video posts. This particular post is very visual seeing as how it is demonstrating a pixel perfect camera.


<!-- more -->


## The Technique

Getting things setup is pretty simple. The main camera is setup like any other orthographic camera. The output of the main camera is then rendered to a RenderTexture that has a fixed height (your pixel art design-time height). The width of the RenderTexture is just set to the screen's width. We only concern ourself with the height using this technique. The output of the RenderTexture is placed on an offscreen quad. The scale of the quad is set to keep everything pixel perfect. Whenver the screen size changes the RenderTexture width is updated and the quad scale is set to match.


<div class="embed-video-container"><iframe src="//www.youtube.com/embed/yI8JrBNTwkc" allowfullscreen></iframe></div>


A couple extra enhanced features are also present in the video. The main one being 3 different behaviors for when the screen size changes: None, DisableCrop and SetNearestPerfectFitResolution. DisableCrop just ensures the entire contents of the RenderTexture are always visible no matter what. SetNearestPerfectFitResolution will update the height of the camera to be a multiple of the design-time height mentioned previously.