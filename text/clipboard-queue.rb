#!/usr/bin/env ruby

require 'fileutils'
require 'yaml'

operation = ARGV[0].to_sym
content = ARGV[1]

tmp_file = ENV['TMPDIR'] + '/.clipboard_queue'
FileUtils::touch tmp_file

queue = (YAML::load_file(tmp_file) or [])

case operation
when :push
  queue << content
when :pop
  puts queue.delete_at 0
when :clear
  queue.clear
end

File.open(tmp_file, 'w') { |f| f.write YAML::dump(queue) }
