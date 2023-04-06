require 'ice_cube'

class TreatRecurrenceService
    def self.to_ical_format(recurrence)
      schedule = IceCube::Schedule.new
      rule = IceCube::Rule

      case recurrence[:type]
      when 'daily'
        rule = rule.daily(recurrence[:interval] || 1) # passing interval
      when 'weekly'
        # passing interval, first day of the week and name/number of days of the week
        rule = rule.weekly(recurrence[:interval] || 1, recurrence[:first_weekday].present? && recurrence[:first_weekday].to_sym || :sunday).day(self.format_recurrence(recurrence[:days]))
      when 'monthly'
        rule = rule.monthly(recurrence[:interval] || 1) # passing interval

        if recurrence[:days].is_a?(Array)
          rule.day_of_month(self.format_recurrence(recurrence[:days])) # number of days of the month
        else
          rule.day_of_week(**recurrence[:days]) # name day with numbers of days of the weeks
        end
      when 'yearly'
        rule = rule.yearly(recurrence[:interval] || 1)  # passing interval
        rule.day_of_year(self.format_recurrence(recurrence[:days])) if recurrence[:days].present? # days of the year
        rule.month_of_year(self.format_recurrence(recurrence[:months])) if recurrence[:months].present? # months of the year
      end

      rule = rule.count(recurrence[:count]) if recurrence[:count].present?  # add count to schedule if present
      rule = rule.until(recurrence[:until].to_datetime) if recurrence[:until].present? # add until to schedule if present

      schedule.add_recurrence_rule rule

      [schedule.to_ical.match(/^RRULE.*/).to_s]
    end 

    def self.format_recurrence(days)
      days[0].is_a?(String) ? (return *days.map(&:to_sym)) : (return *days)
    end
end