module EdgeRider
  module ToIdQuery

    def to_id_query
      ids = collect_ids
      EdgeRider::Util.exclusive_query(self, :id => ids)
    end

    ActiveRecord::Base.send(:extend, self)

  end
end
