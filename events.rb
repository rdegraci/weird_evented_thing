require "sourcify"
require "yaml"

class Events 
  def initialize(opts={}, &block)
    @verbose = opts[:verbose]
    @events = {}
    @state_changers = {}
    @current_state_changer = 0
    instance_eval(&block)
  end

  def event name, triggers=[], &block
    if name == :state_changed or name == :condition_met
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
    end

    type = :regular
    type = :state if name =~ /^state_changed_/
    type = :condition if name =~ /^condition_met_/

    if type == :state or type == :condition
      raise Exception unless @state_changers[name].is_a? Proc
      begin;puts "==> #{name} #{@state_changers[name].to_source}" if @verbose;rescue;end
      ret = instance_eval &@state_changers[name]
    end

    if type == :regular or (type == :conditoin and ret)
      @events[name].each { |event| trigger event, path.dup }
    end
  end

  def method_missing(name, *args, &block)
    event name, args, &block
  end
end

