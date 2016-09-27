module EdgeRider
  module Development
    extend self

    def selects_star_with_conditions_pattern(table, conditions)
      table = Regexp.quote(table)
      conditions = Regexp.quote(conditions) unless conditions.is_a?(Regexp)
      quote = '[`"]?'
      /\ASELECT (#{quote}#{table}#{quote}\.)?\* FROM #{quote}#{table}#{quote}\s+WHERE \(?#{conditions}\)?\s*\z/
    end

  end
end

