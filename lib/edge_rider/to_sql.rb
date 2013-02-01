module EdgeRider
  module ToSql

    def to_sql
      construct_finder_sql({})
    end

    if Rails.version < '3'
      ActiveRecord::Base.extend(self)
    end

  end
end
