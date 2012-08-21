require 'find'
require 'fileutils'
namespace :coffee do
  
  def compile_coffee src_dir, dist_dir
    FileUtils.mkdir_p(dist_dir)
    Dir["#{src_dir}/*.coffee"].each do |f|
      src_file = File.open(f)
      dist = File.open("#{dist_dir}/#{File.basename(src_file, '.coffee')}", 'a+')
      dist.write CoffeeScript.compile(src_file)
      dist.close
    end
  end
    

  task :compile_spec => :clean_spec do
    src_dir = "#{Rails.root}/../../spec/coffeescripts"
    dist_dir = "#{Rails.root}/../../spec/javascripts"
    compile_coffee src_dir, dist_dir 
  end

  task :compile do
    src_dir = "#{Rails.root}/../../app/assets/javascripts/facebook_share_widget"
    dist_dir = "#{Rails.root}/../../public/javascripts/compiled"
    compile_coffee src_dir, dist_dir
  end
  
  task :clean do
    `rm #{Rails.root}/../../public/javascripts/compiled/*.js`
  end  
  
  task :clean_spec do
    `rm #{Rails.root}/../../spec/javascripts/*.js`
  end
  
end