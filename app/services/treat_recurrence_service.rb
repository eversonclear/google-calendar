require 'json'
require 'net/http'
require 'ice_cube'

class TreatRecurrenceService
    TYPES = {:yearly => 'year', :monthly => 'month', :weekly => 'week', :daily => 'day'}

    def self.to_ical_format(recurrence, starts_at, finishes_at=nil)
      schedule = IceCube::Schedule.new
      rule = IceCube::Rule
            
      case recurrence[:type]
      when 'daily'
        rule = rule.daily(recurrence[:interval] || 1)
      when 'weekly'
        puts recurrence
        rule = rule.weekly(recurrence[:interval] || 1, recurrence[:first_weekday] || :sunday).day(*recurrence[:days])
      when 'monthly'
        rule = rule.monthly(recurrence[:interval] || 1)

        if recurrence[:days].is_a?(Array)
          rule.day_of_month(*recurrence[:days])
        else
          rule.day_of_week(**recurrence[:days])
        end
      when 'yearly'
        rule = rule.yearly(recurrence[:interval] || 1)
        rule.day_of_year(*recurrence[:days]) if recurrence[:days].present?
        rule.month_of_year(*recurrence[:months]) if recurrence[:months].present?
      end

      # add count to schedule
      rule = rule.count(recurrence[:count]) if recurrence[:count].present?

      # add until to schedule
      rule = rule.until(recurrence[:until]) if recurrence[:until].present?

      schedule.add_recurrence_rule rule
      schedule.to_ical.match(/^RRULE.*/).to_s
    end 
end