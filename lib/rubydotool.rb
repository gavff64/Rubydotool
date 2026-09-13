require_relative "rubydotool/version"

module Rubydotool
  SOCKET = "/tmp/rubydotool-#{Process.pid}.sock"

  @pid = nil

  def self.start
    return if @pid

    @pid = Process.spawn(
      "ydotoold",
      "-p",
      SOCKET,
      out: File::NULL,
      err: File::NULL
    )

    sleep 0.5
  end

  def self.stop
    return unless @pid

    Process.kill("TERM", @pid)
    Process.wait(@pid)
    @pid = nil

    if File.exist?(SOCKET)
      File.delete(SOCKET)
    end
  rescue Errno::ESRCH, Errno::ECHILD
    @pid = nil
  end

  def self.run(*arguments)
    start

    environment = {"YDOTOOL_SOCKET" => SOCKET}

    text_arguments = []

    arguments.each do |argument|
      text_arguments << argument.to_s
    end

    system(environment, "ydotool", *text_arguments)
  end

  def self.type(text)
    run("type", text)
  end

  def self.key(*keycodes)
    events = []

    keycodes.each do |keycode|
      events << "#{keycode}:1"
    end

    keycodes.reverse.each do |keycode|
      events << "#{keycode}:0"
    end

    run("key", *events)
  end

  def self.hotkey(*keycodes)
    key(*keycodes)
  end

  def self.click(button = "0xC0")
    run("click", button)
  end

  def self.right_click
    run("click", "0xC1")
  end

  def self.move(x, y)
    run("mousemove", x, y)
  end

  def self.move_to(x, y)
    run("mousemove", "--absolute", x, y)
  end
end

at_exit do
  Rubydotool.stop
end
