module EdgeRider
  module ToIdQuery

    def to_id_query
      ids = collect_ids
      EdgeRider::Util.exclusive_query(self, id: ids)
    end
  end
end

ActiveSupport.on_load :active_record do
  extend(EdgeRider::ToIdQuery)
end
