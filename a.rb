require "sourcify"
require "yaml"
require "./events"

events = Events.new(:verbose => true) do
  # Input events
  init
  textbox_a_click
  textbox_b_click
  button_click

  state_changed(:init) { @a = @b = 0 }

  a_given :textbox_a_click
  b_given :textbox_b_click

  a_modified :a_given
  b_modified :b_given

  a_incremented :button_click

  a_displayed :a_given, :b_given, :a_incremented


  conditions do
    a_is_greater_than_2 :a_is_incremented { @a > 2 }
  end

  state_changes do
    a_given { @a=1 }
    b_given { @b=1 }
    a_incremented { @a+=1 }
    a_displayed { puts "\n\na == #{@a.inspect}\n\n" }
  end
end


# I/O
%w(init button_click button_click button_click).each do |t|
  puts "--------------"
  events.trigger t.to_sym
end
