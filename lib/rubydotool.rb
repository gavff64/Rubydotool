require "json"
require_relative "rubydotool/version"

module Rubydotool
  SOCKET = "/tmp/rubydotool-#{Process.pid}.sock"
  KEYCODES_FILE = File.join(__dir__, "rubydotool", "keycodes.json")
  KEYCODES = JSON.parse(File.read(KEYCODES_FILE))

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

    sleep 2
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

    worked = system(
      environment,
      "ydotool",
      *text_arguments,
      out: File::NULL
    )

    sleep 0.1

    if !worked
      raise "ydotool command failed"
    end
  end

  def self.type(text)
    run("type", text)
  end

  def self.key(*keycodes)
    events = []

    keycodes.each do |key|
      keycode = find_keycode(key)
      events << "#{keycode}:1"
    end

    keycodes.reverse.each do |key|
      keycode = find_keycode(key)
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

  def self.find_keycode(key)
    if key.is_a?(Integer)
      return key
    end

    keycode = KEYCODES[key.to_s]

    if keycode.nil?
      raise "unknown key: #{key}"
    end

    keycode
  end
end

at_exit do
  Rubydotool.stop
end
