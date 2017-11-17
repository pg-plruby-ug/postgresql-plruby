#!/usr/bin/ruby
require 'rbconfig'
include RbConfig
pwd = Dir.pwd
pwd.sub!(%r{[^/]+/[^/]+$}, "")

language, extension = 'C', '_new_trigger'
opaque = 'language_handler'

version = ARGV[0].to_s
suffix = ARGV[1].to_s

begin
  if File.exists?("test_setup.sql.in")

    open("test_setup.sql", "w") do |f|
      IO.foreach("test_setup.sql.in") do |x|
        x.gsub!(/language\s+'plruby'/i, "language 'plruby#{suffix}'")
        f.print x
      end
    end

  else
    puts "There is no test_setup.sql.in file"
  end

  f = File.new("test_queries.sql", "w")
  IO.foreach("test_queries.sql.in") do |x|
    x.gsub!(/language\s+'plruby'/i, "language 'plruby#{suffix}'")
    f.print x
  end
  f.close

  f = File.new("test.expected." + version, "w")
  IO.foreach("test.expected." + version + ".in") do |x|
    x.gsub!(/language\s+'plruby'/i, "language 'plruby#{suffix}'")
    f.print x
  end
  f.close

  open("test_mklang.sql", "w") do |f|
    f.print <<EOF

   create function plruby#{suffix}_call_handler() returns #{opaque}
    as '#{pwd}src/plruby#{suffix}.#{CONFIG["DLEXT"]}'
   language #{language};

   create trusted procedural language 'plruby#{suffix}'
        handler plruby#{suffix}_call_handler;
EOF
  end
rescue
  raise "Why I can't write #$!"
end
