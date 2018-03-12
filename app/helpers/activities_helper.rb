module ActivitiesHelper

  def assign_default_activity_number
    activity_no = rand.to_s[2..7]
    return Activity.pluck(:activity_number).include?(activity_no.to_s) ? assign_default_activity_number : activity_no
  end
end