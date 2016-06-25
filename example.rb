


events = Events.new(:verbose => true) do
  user_is_satisfied do
    expectations_met do
      expectations_set
      enough_work_performed
      success_reached_within_timeline
    end
    goals_reached do
      goals_established
      work_performed
      work_accomplished_goals
    end
  end
end


