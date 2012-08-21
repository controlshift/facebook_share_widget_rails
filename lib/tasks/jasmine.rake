require 'fileutils'

def copy_files
  dist_dir =  "#{Rails.root}/../../public/javascripts/"
  ['backbone.js', 'handlebars-runtime.js', 'underscore.js'].each do |file|
    fullpath =  "#{Rails.root}/../../app/assets/javascripts/#{file}"
    FileUtils.copy_file fullpath, "#{dist_dir}/#{file}"
  end
  FileUtils.copy_file "#{Rails.root}/lib/assets/jquery.js", "#{Rails.root}/../../public/javascripts/jquery.js"
end

begin
  require 'jasmine'
  copy_files
  load 'jasmine/tasks/jasmine.rake'
rescue LoadError
  task :jasmine do
    abort "Jasmine is not available. In order to run jasmine, you must: (sudo) gem install jasmine"
  end
end

