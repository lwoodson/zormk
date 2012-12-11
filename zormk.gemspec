Gem::Specification.new do |s|
  s.name  = 'zormk'
  s.version  = '0.0.1'
  s.date  = '2012-12-09'
  s.summary  = 'Navigate the twisting labyrinth of ruby ORM code MUD-style'
  s.description  = s.summary
  s.authors     = ['Lance Woodson']
  s.email  = 'lance@webmaneuvers.com'
  s.files  = [
    "lib/zormk.rb",
    "lib/zormk/commands.rb",
    "lib/zormk/lambdas.rb",
    "lib/zormk/active_record/initializer.rb",
    "lib/zormk/active_record/renderer.rb"
  ] 
  s.homepage  = 'https://github.com/lwoodson/zormk/'
  s.add_runtime_dependency "obj_mud", ">= 0.0.1"
end

