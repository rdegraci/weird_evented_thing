class Events 
  def initialize(&block)
    @events = {}
    instance_eval(&block)
  end

  def event name, triggers=[]
    @events[name] = []
    triggers.each do |trigger|
      raise Error unless @events.has_key?(trigger)
      @events[trigger] << name
    end
  end

  def trigger name, path=[]
    path << name
    if @events[name].empty?
      puts path.join " -> "
    else
      @events[name].each { |event| trigger event, path }
    end
  end

  def method_missing(name, *args)
    event name, args
  end
end

events = Events.new do
  # Input events
  mouse_click
  control_r
  right_arrow_key

  # Distributing events
  button_click :mouse_click
  switch_page :button_click, :control_r, :right_arrow_key

  # application code
  render :switch_page
  render_page :render

  # Output events
  generate_html :render_page
end

events.trigger :mouse_click
events.trigger :control_r
events.trigger :right_arrow_key


