##js-discourseBestOf##

**js-discourseBestOf** is a jQuery based wrapper for the  [wp-discourse](https://github.com/discourse/wp-discourse "wp-discourse") plugin for [discourse](https://github.com/discourse/discourse). Knowing a little javascript, and nothing about ruby yet, this was made. Please fork it and improve... hopefully someone will write a plugin that creates a thread and saves the thread ID on the page!

### Wow, cool! Sign me up!###

Hold on there just a second. There's a couple of huge flaws with this plugin that I'd like to explain. 

* You must set Access-Control-Allow-Origin for whatever domain your blog is on to allow this script access. This applies to subdomains as well. If you know a way around this, let me know! 
* This does not yet create threads on your discourse server. You'll have to make them by hand for now.
* This creates non-static content on a static site. However, most forms of comments in jekyll do.
* Finally, it use the page title to determine what comments to load. If your page titles are fairly generic it's possible the comments will load from a more popular thread. By default, octopress uses your post title and your blog name, which is discarded. If you forget to create a thread, and someone else does it will still load the best of that conversation.


### Setting Access-Control-Allow-Origin for Nginx ###

Add ```add_header Access-Control-Allow-Origin "your blog url";``` to either your server block, or a location block. Your blog url includes http://, and does not include a traling slash or /blog/. Restart nginx. 

### Install Guide for Octopress/Jekyll ###

* Add the javascript file in /javascripts/ to your source folder.
* Edit your ```/source/_includes/custom/head.html```  file to include this script. jQuery is included with Octopress. As long as it's placed on your posts page it should work, but it'd be best to put it in the header. Here's an example, assuming you placed the files in the source folder. 

```diff
+ <script src="//code.jquery.com/jquery-2.0.0.js"></script> *if you need jQuery*
+ <script src="/javascripts/js-discourse.js"></script>
```

* Edit your posts.html to include:

```diff
+<h1>Comments</h1>
+<div id="#comments" style="padding-left:35px; padding-right:35px"></div>
```

somewhere. In octopress, you can remove:

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
I'm sure there's more that can be added, like avatars. However, I wanted to keep the concept fairly simple so it can be expanded by other users. Please contribute any suggestions you have to me, either here or on (meta.discourse.org)[http://meta.discourse.org/users/trident]
