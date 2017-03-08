class MissionActioner
  attr_reader :mission_instance, :actor, :note

  def initialize(mission, business, current_user, note = nil)
    @actor = current_user
    @note = note
    @mission_instance = MissionInstance.find_or_initialize_by(mission_id: mission.id, business_id: business.id)

    if @mission_instance.repetition.nil? && mission.repetition
      @mission_instance.assign_attributes(repetition: mission.repetition)
    end

    if @mission_instance.start_date.nil?
      @mission_instance.assign_attributes(start_date: Time.now)
    end
  end

  def complete
    mission_instance.mark_complete.tap do
      track 'completed'
      mission_instance.mission_instance_events.oldest&.first&.update(status: 'completed')
    end
  end

  def skip
    mission_instance.mark_skipped.tap do
      track 'skipped'
      mission_instance.mission_instance_events.oldest&.first&.update(status: 'skipped')
    end
  end

  def snooze
    mission_instance.mark_snoozed.tap do
      track 'snoozed'
      mission_instance.mission_instance_events.oldest&.first&.update(status: 'snoozed')
    end
  end

  def deactivate
    mission_instance.deactivate.tap do
      track 'deactivated'
    end
  end

  def activate
    mission_instance.activate.tap do
      track 'activated'

      if mission_instance.scheduled?
        mission_instance.reschedule_events!
      end
    end
  end

  private

  def track(verb)
    mission_instance.save!
    history = mission_instance.mission_histories.create!(
      action: verb,
      actor: actor,
      happened_at: Time.zone.now,
      description: "Mission #{verb} by #{actor.name}"
    )

    history.build_note(note: note, author: actor).save
  end
end
