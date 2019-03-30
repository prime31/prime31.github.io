---
layout: post
title: The Great 2D Framework Evaluation, Part 3
date: 2018-10-04 07:00:00 +0000
permalink: the-great-2d-framework-evaluation-part-3

---
### Making the Cut

Now that the trash bin is overflowing with plenty of capable game engines that just aren't for me what's left? At this point in my evaluation something really odd kept coming up over and over again. A few of the engines that made it this far (and some that didn't such as Stencyl and Kha) seemed to share a commonality: they use the Haxe programming language. This was a big red flag for me initially. Let's take a quick aside here to explain a few things that I learned about Haxe before moving forward.

<!--preview-->

### Haxe: Hipster Toy or Useful Language?

_The Cross-platform Toolkit_. That's what the Haxe web page tells us. Up until this point my only experience with Haxe was several years ago. It was a toy. A cute little language that cross-compiles to other languages (mostly JavaScript back then). How many cross compilers to JavaScript do we really need? I brushed it aside as I do with any hipster web tech (I'm looking at you Ruby, Node.js, CoffeeScript, TypeScript, Dart, Cappuccino/Objective-J LOL at that one). I mean, holy crap! The web dev community is the most fickle group ever. So, Haxe was tossed in the bin as hipster crapware back then. But it kept coming up in the game dev world. At first I was thinking it was all there just to make WebGL/Canvas games for people afraid to use JavaScript. Then I learned that it was being used to make real, native games on every platform imaginable. Evoland, Papers, Please, Rymdkapsel are just a few of the games made with Haxe. It turns out Tivo was built with Haxe as well. They have a proper foundation (The Haxe Foundation) and Haxe is used by Nickelodeon, Disney, Mattel, Hasbro, Coca Cola and Toyota just to name a few. Suffice to say, I promoted Haxe from a made-up language to a real one and officially allowed Haxe-based frameworks into the evaluation.

<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr">Actually, I think haXe is great in general. I dunno why it took me so long to try it out properly. Flash devs should give it a serious look. <br>— Terry (@terrycavanagh) <a href="[https://twitter.com/terrycavanagh/status/552890362214481922](https://twitter.com/terrycavanagh/status/552890362214481922 "https://twitter.com/terrycavanagh/status/552890362214481922")">January 7, 2015</a></p></blockquote>

That ends our aside. I felt it was important to explain a bit about Haxe since there are probably others out there who threw it in the trash bin for being a toy much like I did. If Haxe is new to you and you have any questions feel free to hit me up on \[Twitter\]([https://twitter.com/prime_31](https://twitter.com/prime_31 "https://twitter.com/prime_31")). I'm no pro with it but I _just_ learned it so all the newbie stuff is fresh in my head. ### The Final Four Every framework previously listed is perfectly capable of making most 2D games (except for Defold due to it crashing on launch). All the frameworks below are as well. Narrowing it down to four was a herculean act. Let's give them a look in a bit more detail.

### MonoGame

A C# framework that is basically an open source port of Microsoft's now defunct XNA. It has a pretty good API, an easily extensible asset pipeline and quite a lot of people using it. Most of them seem to be XNA refugees with a few Unity castoffs thrown in for good measure. If you are a Unity developer looking for a 2D framework and have a fear of using anything other than C# MonoGame is your baby.

### Pros

\- open source port of XNA

\- modern C# via the Mono runtime

\- tons of games made with it so it has a solid user base

\- quite a few open source libs out there in the wild to use in lieu of the lack of documentation and official samples (see Cons)

#### Cons

\- open source port of XNA. Yes, it's also a con. There comes a time when you have to stop riding on the coattails of ex-XNA devs and forge your own path.

\- requires Xamarin for iOS and Android export - very infrequent updates (April was the last release)

\- documentation? What documentation?

\- sample code? What sample code?

\- not the most performant choice for mobile In an LOL moment I found this gem in the MonoGame news section from 2014. The post was titled: New Breed of Samples for MonoGame.

> The core MonoGame team set out with a purpose to being (sic) a new samples repository for the project. Its goals were simple:

\- The samples had to be of high quality

\- They had to work on ALL platforms not just one

\- Best practices had to be used where possible

\- They had to be testable and re-usable to test the latest builds (builds may not pass if samples tests failed)

99% of the samples repository mentioned hasn't been updated in over 2 years. Oops.

### OpenFL

An open source Haxe port of the Flash API. I suppose that is a pro for some people but I am not one of them. Like our friend MonoGame above, OpenFL gained it's popularity by being identical to some other API that was heaving on the floor dying (Flash in this case, XNA for MonoGame). The Flash API is terrible in my opinion. Awful. Why can't Flash just die already? I'd rather write a game using the \[Monkey language\]([http://www.monkey-x.com/Monkey/language.php](http://www.monkey-x.com/Monkey/language.php "http://www.monkey-x.com/Monkey/language.php")) than to ever have to use the Flash API again. So, what the heck is OpenFL doing in the final four? OpenFL (which is just the Flash API layer) sits on top of a lower level base call Lime. As it turns out, if you aren't afraid to live at a slightly lower level (completely undocumented) then Lime is super nice. It basically gives you access to OpenGL along with an asset loading system, font/text rendering system and a few other minor goodies. Write some code, click a button and you get a WebGL game, Windows game, Mac game and a slew of other platforms. The downside to using Lime directly is that you're flying solo. Seeing as how a _huge_ portion of OpenFL users are Flash converts they mostly don't even know Lime exists because they just want their precious Flash API.

#### Pros

\- large community with lots of open source libs to play with

\- exports to just about every platform around - excellent performance when dropping down to Lime. Not such good performance if staying in the OpenFL layer (curse you inefficient Flash API!)

#### Cons

\- open source port of the Flash API. This one is similar to MonoGame in that they are stuck being "that framework Flash developers can move to". The Flash API isn't winning any awards and this makes OpenFL useless to me unfortunately.

\- samples kind of work and kind of don't

\- documentation is sparse at best with a lot of it (95% or so) deferring to some third-party website that hasn't been updated in ages. But really, this is just Flash so you can use the Adobe docs.

### LibGDX

Java framework. Yup, Java. And somehow it's really fast. The library does a great job of keeping allocations to a minimum so it avoids the garbage collector better than most. LibGDX's SpriteBatch is very reminiscent of the Kha API which is a good thing.

#### Pros

\- LibGDX is fast. Really fast. Who'd have thunk Java could do that?

\- great community. Tons of open source code out there.

\- solid API with lots of pleasant surprises

\- good documentation with plenty of tutorials out there

\- handy particle system editor

\- works out of the box with Overlap2D

#### Cons

\- Java. Not my favorite language. In fact, it's one of my least favorite. Too rigid for my taste. It brings me back to my days of bus-dev. Yuck. 

\- requires RoboVM for iOS which can be slow. Also of note, Xamarin purchased RoboVM a few days ago. Uh oh.

### Luxe

Very young Haxe framework that is still in alpha. I almost feel like I shouldn't mention it because of its alpha status but it's too late now. Luxe sits on top of Snow (much like OpenFL sits on top of Lime). Snow is a fairly thin layer separating and abstracting away the low level hardware access. This two-part separation seems to be common in most of the Haxe frameworks (Kha had Kore as its lower level).

#### Pros

\- the sample code. Oh yes. TONS of samples that are all bite-sized making it very easy to pick up Luxe and run with it. Sample code for Luxe beats out every other framework here and it's still alpha. - well documented already

\- clean, well structured code with just the right amount of comments 

\- flexible build system (Flow) that is actually easy to use unlike most build systems

#### Cons

\- allocations, allocations, allocations

\- strings, strings and more strings. If you've read any of my past blog posts you will know of my great disdain of strings all over the place.

\- performance in general can use some love but again, it's still alpha so I imagine an optimization pass hasn't happened yet with the API still in flux

That wraps it up. If you read this far someone should give you a cookie. This framework evaluation has been really difficult to slim down to this size. I could have written multiple blog posts on each of the frameworks (perhaps some of the final four should get that treatment with some code examples). Choose any of these frameworks and you can't go wrong.