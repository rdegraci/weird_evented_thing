require "sourcify"
require "yaml"

class Events 
  def initialize(&block)
    @events = {}
    @state_changers = {}
    @current_state_changer = 0
    instance_eval(&block)
  end

  def event name, triggers=[], &block
    if name == :state_changed
      name = "state_changed_#{@current_state_changer}"
      raise Exception if @events.has_key? name
      @current_state_changer += 1
      @state_changers[name] = block
    else
      @events[name] = []
    end
    triggers.each do |trigger|
      raise Exception unless @events.has_key? trigger
      @events[trigger] << name
    end
  end

  def trigger name, path=[]
    path << name
    if @events[name].nil? or @events[name].empty?
      puts path.join " -> "
    else
      @events[name].each { |event| trigger event, path }
    end
    return unless name =~ /^state_changed_/

    raise Exception unless @state_changers[name].is_a? Proc
    begin
      puts "==> #{name} #{@state_changers[name].to_source}"
    rescue
      puts "==> #{name} ???"
    end
    instance_eval &@state_changers[name]
  end

  def method_missing(name, *args, &block)
    event name, args, &block
  end
end

events = Events.new do
  # Input events
  init
  textbox_a_click
  textbox_b_click
  button_click

  state_changed(:init) { @a = @b = 0 }

  a_given :textbox_a_click
  b_given :textbox_b_click
  a_incremented :button_click

  a_displayed :a_given, :b_given, :a_incremented

  # Output events
  state_changed(:a_given) { @a=1 }
  state_changed(:b_given) { @b=1 }
  state_changed(:a_incremented) { @a+=1 }
  state_changed(:a_displayed) { puts "\n\na == #{@a.inspect}\n\n" }
end


# I/O
events.trigger :init
print "> "
while trigger = gets.chomp.to_sym
  events.trigger trigger
  puts
  print "> "
end
