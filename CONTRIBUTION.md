# How to Add article

1. Clone on of the existing posts from `_posts` directory
2. Create an issue at [https://github.com/thekalinga/thekalinga.in-comments/issues](https://github.com/thekalinga/thekalinga.in-comments/issues)
3. Replace existing issue number in this new post with the above created issue number
4. Update title, categories & everything else from the new post markdown
5. Commit & Push
6. Wait for travis to push the built github pages to

# Local testing steps

* Install [rvm](https://rvm.io/)
* Create a copy of an existing post & paste it in `_drafts` folder
* Run `bundle exec jekyll serve --verbose --drafts` from the cloned directory which starts jekyll server with drafts enabled
* Access local server at [http://localhost:4000](http://localhost:4000)

# Going to production

* Once development is done, move the draft from `_drafts` to `_posts`
* Run `bundle exec jekyll serve`
