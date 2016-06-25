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

  condition_met :a_is_greater_than_2, :a_incremented

  # Output events
  state_changed(:a_given) { @a=1 }
  state_changed(:b_given) { @b=1 }
  state_changed(:a_incremented) { @a+=1 }
  state_changed(:a_displayed) { puts "\n\na == #{@a.inspect}\n\n" }
end


# I/O
%w(init button_click button_click button_click).each do |t|
  puts "--------------"
  events.trigger t.to_sym
end
