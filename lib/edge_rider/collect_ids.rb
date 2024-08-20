module EdgeRider
  module CollectIds

    class Uncollectable < StandardError; end

    module Array

      def collect_ids
        collect do |obj|
          case obj
          when Integer
            obj
          when ActiveRecord::Base
            obj.id
          when String
            if obj.match(/\A\d+\z/)
              obj.to_i
            else
              raise Uncollectable, "Cannot collect an id from #{obj.inspect}"
            end
          else
            raise Uncollectable, "Cannot collect an id from #{obj.inspect}"
          end
        end
      end

    end

    ::Array.send(:include, Array)

    module ActiveRecordValue

      def collect_ids
        [id]
      end

    end

    module ActiveRecordScope

      def collect_ids
        collect_column(:id)
      end

    end

    module Integer

      def collect_ids
        [self]
      end

    end

    ::Integer.send(:include, Integer)

  end
end

ActiveSupport.on_load :active_record do
  extend(EdgeRider::CollectIds::ActiveRecordScope)
  include(EdgeRider::CollectIds::ActiveRecordValue)
  ActiveRecord::Associations::HasManyAssociation.send(:include, EdgeRider::CollectIds::ActiveRecordScope)
  ActiveRecord::Associations::HasManyThroughAssociation.send(:include, EdgeRider::CollectIds::ActiveRecordScope)
end
