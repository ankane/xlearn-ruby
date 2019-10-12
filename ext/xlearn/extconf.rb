require "mkmf"

def run(command)
  puts ">> #{command}"
  unless system(command)
    raise "Command failed"
  end
end

dir = File.expand_path("../../vendor/xlearn", __dir__)

build_dir = "#{dir}/build"
Dir.mkdir(build_dir)
Dir.chdir(build_dir) do
  run "cmake .."
  run "make -j4"
end

create_makefile("xlearn")
