#!/usr/bin/ruby

class Execution
  def initialize(args)
    @args = args
  end
  
  def error(msg)
    return { 'verdict' => msg }
  end
  
  def run()
    # Arguments for the problem
    time_limit = @args['time_limit']
    input_dir = @args['input_dir']
    output_dir = @args['output_dir']
    test_files = @args['test_files']
    
    # Arguments for the submission
    source_file = @args['source_file']
    language = @args['language']
    
    # TODO
    daemon = 'daemon'
    user_name = 'user_name'
    test_dir = 'for_daemon/test_dir'
    output_file = 'output'
    
    # Make the working directory
    return error('System Error 1') if !system("sudo useradd #{user_name}")
    return error('System Error 2') if !system("mkdir -p #{test_dir}")
    
    # Compilation
    case language
    when "C++"
      res = !system("g++ -O2 #{source_file} -o #{test_dir}/a")
      if res
        return error("Compile Error")
      end
      execution_cmd = "#{test_dir}/a"
    when "Ruby"
      return error('System error 3') if !system("cp #{source_file} #{test_dir}/a.rb")
      execution_cmd = "ruby #{test_dir}/a.rb"
    else
      return error('System error 4')
    end
    
    # Run test
    verdict = 'Accepted'
    test_files.each do |test|
      return error('System error 5') if !system("sudo chown -R #{user_name}:#{user_name} #{test_dir}")
      res = !system("sudo -u #{user_name} sh -c \"timeout #{time_limit} #{execution_cmd} < #{input_dir}/#{test} > #{test_dir}/#{output_file}\"")
      return error('System error 6') if !system("sudo chown -R #{daemon}:#{daemon} #{test_dir}")
      if res
        verdict = 'Runtime Error'
        break
      end
      res = !system("diff -q #{test_dir}/#{output_file} #{output_dir}/#{test} > /dev/null")
      if res
        verdict = 'Wrong Answer'
        break
      end
    end
    
    # Remove the working directory
    return error('System error 7') if !system("rm -rf #{test_dir}")
    return error('System error 8') if !system("sudo userdel #{user_name}")
    
    return { 'verdict' => verdict }
  end
end

