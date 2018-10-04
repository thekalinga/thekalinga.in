Jekyll::Hooks.register :posts, :pre_render do |post|
  # inject last modified time in post's datas.
  post.data['last-modified-date'] = File.mtime( post.path )
end
