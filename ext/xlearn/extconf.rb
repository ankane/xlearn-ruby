require "mkmf"

def run(command)
  puts ">> #{command}"
  unless system(command)
    raise "Command failed"
  end
end

dir = File.expand_path("../../vendor/xlearn", __dir__)

arch = RbConfig::CONFIG["arch"]
puts "Arch: #{arch}"
case arch
when /mingw/
  build_dir = "#{dir}/build"
  Dir.mkdir(build_dir)
  Dir.chdir(build_dir) do
    # https://xlearn-doc.readthedocs.io/en/latest/install/install_windows.html
    run "cmake -G \"Visual Studio 15 Win64\" .."
    run '"C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" x64'
    run "MSBuild xLearn.sln"
  end
else
  build_dir = "#{dir}/build"
  Dir.mkdir(build_dir)
  Dir.chdir(build_dir) do
    run "cmake .."
    run "make -j4"
  end
end

create_makefile("xlearn")
