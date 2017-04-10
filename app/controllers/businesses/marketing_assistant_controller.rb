class Businesses::MarketingAssistantController < Businesses::BaseController
  def index
    @to_do_lists = ToDoList.for_business(@business).page(params[:page]).per(12)
    @instances = @business.mission_instances.group_by(&:mission_id)
    @grouped_missions = Mission.assigned_to_lists(@business, @to_do_lists).group_by do |mission|
       if @instances[mission.id] && @instances[mission.id].first.to_do_list_id
         @instances[mission.id].first.to_do_list_id
       else
         mission.to_do_list_id
       end
    end
  end
end
