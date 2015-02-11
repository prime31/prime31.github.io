
In past posts (mainly [this one](http://blog.prime31.com/constants-generator-kit/)), we talked about reducing or removing all "naked string" use in an effort to reduce coding errors and maintain sanity as projects grow in size. The post provided a solution for tags, layers, scenes and resources. It did not, however, help clean up the much used-and-abused PlayerPrefs.

<!--more-->

First off, let's just get this out of the way: if you are storing any large amounts of data in PlayerPrefs stop doing that immediately. PlayerPrefs is for simple key/value storage. If you need to store more data then use the proper medium: files. The previous post on [Persisting Strongly Typed Data With JSON](http://blog.prime31.com/persisting-data-with-json) would be a good solution. I have seen some horrendous code where people were storing all their persistant data in PlayerPrefs and then they were surprised when certain operating systems were truncating and/or removing that data because it exceed the key/value size. The moral of the store is don't be that guy. It's a very hard bug to track down. Save yourself the pain.

