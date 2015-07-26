require 'rubygems'
require 'active_yaml'
require 'pry'
require "tempfile"

shared_context :use_tempfile do
  attr_reader :tempfile

  around do |example|
    Tempfile.open('rspec-') do |tempfile|
      if defined?(yaml_file)
        FileUtils.copy(yaml_file, tempfile)
      end
      @tempfile = tempfile
      example.run
    end
  end
end
