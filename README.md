# Rubydotool

A small Ruby wrapper for `ydotool`.

```bash
gem install rubydotool
```

Install `ydotool` with your system package manager, then add the gem:

```ruby
gem "rubydotool"
```

```ruby
require "rubydotool"

Rubydotool.type("Hello from Ruby")
Rubydotool.key(28)
Rubydotool.click
Rubydotool.right_click
Rubydotool.move(50, -20)
Rubydotool.move_to(800, 450)
```

The daemon starts on the first command and stops when the Ruby process exits. `Rubydotool.start` and `Rubydotool.stop` are also available.

Keys use Linux input keycodes. Mouse buttons use ydotool button codes. The process needs permission to access `/dev/uinput`.
