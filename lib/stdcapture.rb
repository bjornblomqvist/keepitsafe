require 'stringio'

class STDCapture < StringIO
  
  def initialize io1,io2
    @io1 = io1
    @io2 = io2
    super ""
  end

  def write text
    @io1.write text
    @io2.write text
  end

  def self.capture buffer = nil
    
    buffer ||= StringIO.new

    stdout_old = $stdout
    stderr_old = $stderr

    $stdout = STDCapture.new(stdout_old,buffer)
    $stderr = STDCapture.new(stderr_old,buffer)

    yield
    
    buffer.string
  ensure
    $stdout = stdout_old
    $stderr = stderr_old
  end
end

