module EdgeRider
  module TraverseAssociation

    class UnsupportedAssociation < StandardError; end
    class UnknownAssociation < StandardError; end

    def traverse_association(*associations)

      scope = scoped({})

      associations.each do |association|

        reflection = scope.reflect_on_association(association) or raise UnknownAssociation, "Could not find association: #{self.name}##{association}"
        foreign_key = reflection.respond_to?(:foreign_key) ? reflection.foreign_key : reflection.primary_key_name

        # In Rails 4, conditions on a scope are expressed as a lambda parameter
        # that is called `scope`.
        raise NotImplementedError if reflection.options[:conditions] or (reflection.respond_to?(:scope) && reflection.scope)

        if reflection.macro == :belongs_to # belongs_to
          ids = scope.collect_column(foreign_key, distinct: true)
          scope = EdgeRider::Util.exclusive_query(reflection.klass, id: ids)
        elsif reflection.macro == :has_many || reflection.macro == :has_one
          if reflection.through_reflection # has_many :through
            scope = scope.traverse_association(reflection.through_reflection.name, reflection.source_reflection.name)
          else # has_many or has_one
            conditions = {}
            # A polymorphic association has a type attribute, e.g. record_type, that needs to be added to condition.
            conditions[reflection.type] = self.name if reflection.type.present?
            conditions[foreign_key] = scope.collect_ids

            scope = EdgeRider::Util.exclusive_query(reflection.klass, conditions)
          end
        else
          raise UnsupportedAssociation, "Unsupport association type: #{reflection.macro}"
        end
      end

      scope

    end

  end
end

ActiveSupport.on_load :active_record do
  extend(EdgeRider::TraverseAssociation)
end
