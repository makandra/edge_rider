module EdgeRider
  module Scoped
    
    VALID_FIND_OPTIONS = [ :conditions, :include, :joins, :limit, :offset,
                           :order, :select, :readonly, :group, :having, :from, :lock ]

    def scoped(options = nil)
      options ||= {}
      relation = all
  
      options.assert_valid_keys(VALID_FIND_OPTIONS)
      finders = options.dup
      finders.delete_if { |key, value| value.nil? && key != :limit }
  
      ((VALID_FIND_OPTIONS - [:conditions, :include]) & finders.keys).each do |finder|
        relation = relation.send(finder, finders[finder])
      end
  
      relation = relation.where(finders[:conditions]) if options.has_key?(:conditions)
      relation = relation.includes(finders[:include]) if options.has_key?(:include)
  
      relation
    end

    if ActiveRecord::VERSION::MAJOR >= 4
      ActiveRecord::Base.extend(self)
    end

  end
end
