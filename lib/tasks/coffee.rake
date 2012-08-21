require 'find'
namespace :coffee do
  src_dir = "#{Rails.root}/../../spec/coffeescripts"
  dist_dir = "#{Rails.root}/../../spec/javascripts"

  task :compile_spec => :clean do
    Dir["#{src_dir}/*.coffee"].each do |f|
      src_file = File.open(f)
      dist = File.open("#{dist_dir}/#{File.basename(src_file, '.coffee')}", 'a+')
      dist.write CoffeeScript.compile(src_file)
      dist.close
    end
  end

  task :clean do
    `rm #{dist_dir}/*.js`
  end
end