##js-discourseBestOf##

**js-discourseBestOf** is a jQuery based wrapper for the  [wp-discourse](https://github.com/discourse/wp-discourse "wp-discourse") plugin for [discourse](https://github.com/discourse/discourse). 

Read about it! [at it's place on meta.discourse.org](http://meta.discourse.org/t/discourse-plugin-for-static-site-generators-like-jekyll-or-octopress/7965/16)

This is just the javascript part, for developers who don't need the jekyll intergration. Create a div tag with ID of comments, and a topic ID and it'll do the rest.

### Javascript Guide ###

* Edit your ```/source/_includes/custom/head.html```  file to include this script. jQuery is included with Octopress. As long as it's placed on your posts page it should work, but it'd be best to put it in the header. Here's an example, assuming you placed the files in the source folder. 

```diff
+<script src="//code.jquery.com/jquery-2.0.0.js"></script> *if you need jQuery*
+<script src="/javascripts/js/js-discourse.js"></script>
```

* Edit your posts.html to include the below somewhere. Feel free to re-write the noscript tag.

```diff
+  <section>
+    <h1>Comments</h1>
+    <div id="comments" style="padding-left:35px; padding-right:35px" {% discourse_comments %}></div>
+    <noscript>Javascript is off, so comments don't load.</noscript>
+  </section>
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

When the pages are created, this will add an attribute to the div tag called "tid", which holds the related topic ID. 


<h3> Extra Notes </h3>
I've detailed some of the implementation in the posts above, but if you use some other kind of site generator all you need to create is a div/span with an ID of comments, and an attritube called "tid." Then, you can just load the javascript and comments will render in that space. The topic ID is the number that follows after `/t/<post-slug>/` and is not the last number. 

And if you're really looking to build it out in some other kind of framework I'd recommend looking at the original [wp-discourse][6]. Or, just load up `/t/<topicID>/wordpress.json?best=number` and parse it from there.


  [1]: https://github.com/trident523/js-discourseBestOf
  [2]: https://github.com/discourse/wp-discourse
  [3]: http://meta.discourse.org/users/sam
  [4]: http://benalman.com/code/projects/php-simple-proxy/docs/files/ba-simple-proxy-php.html
  [5]: http://temp.trid.in:8080/
  [6]: https://github.com/discourse/wp-discourse



### Let me see it in action! ###
Okay! [Check it out.](http://temp.trid.in:8080/blog/2013/07/01/title/) I don't actually have any content, but why not go for it. 
I'm sure there's more that can be added, like avatars. However, I wanted to keep the concept fairly simple so it can be expanded by other users. Please contribute any suggestions you have to me, either here or on [meta.discourse.org](http://meta.discourse.org/users/trident). Or, make a pull request!
