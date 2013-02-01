module EdgeRider
  module TraverseAssociation

    class UnsupportedAssociation < StandardError; end
    class UnknownAssociation < StandardError; end

    def traverse_association(*associations)

      scope = scoped({})

      associations.each_with_index do |association, index|

        reflection = scope.reflect_on_association(association) or raise UnknownAssociation, "Could not find association: #{self.name}##{association}"
        foreign_key = reflection.respond_to?(:foreign_key) ? reflection.foreign_key : reflection.primary_key_name

        if reflection.macro == :belongs_to
          ids = scope.collect_column(foreign_key, :distinct => true)
          scope = EdgeRider::Util.exclusive_query(reflection.klass, :id => ids)
        elsif reflection.macro == :has_many || reflection.macro == :has_one
          if reflection.through_reflection
            scope = scope.traverse_association(reflection.through_reflection.name, reflection.source_reflection.name)
          else
            ids = scope.collect_ids
            scope = EdgeRider::Util.exclusive_query(reflection.klass, foreign_key => ids)
          end
        else
          raise UnsupportedAssociation, "Unsupport association type: #{reflection.macro}"
        end
      end

      scope

    end

    ActiveRecord::Base.extend(self)

  end
end
