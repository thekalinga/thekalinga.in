class LastModifiedTag < Liquid::Tag
  def initialize(tag_name, input, tokens)
    super
    @input = input
  end

  def render(context)
    # path = Pathname.new("#{context.environments.first['site']['source']}/#{@input}")
    #return File.stat("#{context.environments.first['page']['dir']}/#{@input}").mtime
    # return File.absolute_path("#{context.environments.first['page']['dir']}/#{@input}").mtime.to_i
    # @cwd = Dir.getwd
    puts Dir.getwd
    #Dir.chdir(context.environments.first['site']['source']) do
    #  puts Dir.getwd
    #  return File.mtime( @input )
    #end
    # @timestamp = File.mtime( @input )
    # Dir.chdir @cwd
    # return @timestamp
    # return context.environments.first['site']['source']
    return File.mtime( @input ).to_i;
  end
end

Liquid::Template.register_tag('last_modified_generic', LastModifiedTag)
