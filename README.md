##js-discourseBestOf##

**js-discourseBestOf** is a jQuery based wrapper for the  [wp-discourse](https://github.com/discourse/wp-discourse "wp-discourse") plugin for [discourse](https://github.com/discourse/discourse). Knowing a little javascript, and nothing about ruby yet, this was made. Please fork it and improve... hopefully someone will write a plugin that creates a thread and saves the thread ID on the page!

Read about it! [at it's place on meta.discourse.org](http://meta.discourse.org/t/discourse-plugin-for-static-site-generators-like-jekyll-or-octopress/7965/16)
### Javascript Guide (old) ###

* Add the javascript file in /javascripts/ to your source folder.
* Edit your ```/source/_includes/custom/head.html```  file to include this script. jQuery is included with Octopress. As long as it's placed on your posts page it should work, but it'd be best to put it in the header. Here's an example, assuming you placed the files in the source folder. 

```diff
+<script src="//code.jquery.com/jquery-2.0.0.js"></script> *if you need jQuery*
+<script src="/javascripts/js-discourse.js"></script>
```

* Edit your posts.html to include the below somewhere. Feel free to re-write the noscript tag.

```diff
+<h1>Comments</h1>
+<div id="comments" style="padding-left:35px; padding-right:35px"></div>
+<noscript>Javascript is off, so comments don't load.</noscript>
```

In octopress, you can remove:

```diff
-{% if site.disqus_short_name and page.comments == true %}
-  <section>
-    <h1>Comments</h1>
-    <div id="disqus_thread" aria-live="polite">{% include post/disqus_thread.html %}</div>
-  </section>
-{% endif %}
```
 and include the above code.

* Edit /javascripts/js-discourse.js and examine the variables at the top.

* Style the output. The quick way is to add an inline style, and I wrote a super quick one. Every post has an id of post#, so you can make some cool styles. I include a hr for just basic styling. 

* Enjoy! Hope it works out.


### Let me see it in action! ###
Okay! [Check it out.](http://temp.trid.in:8080/blog/2013/07/01/title/) I don't actually have any content, but why not go for it. 
I'm sure there's more that can be added, like avatars. However, I wanted to keep the concept fairly simple so it can be expanded by other users. Please contribute any suggestions you have to me, either here or on [meta.discourse.org](http://meta.discourse.org/users/trident). Or, make a pull request!
