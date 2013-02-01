require 'spec_helper'

describe EdgeRider::ToSql do

  it "should return the SQL the scope would produce" do
    scope = EdgeRider::Util.append_scope_conditions(Forum, :name => 'Name')
    scope.to_sql.should =~ /\ASELECT (`forums`\.)?\* FROM `forums`\s+WHERE \(?`forums`.`name` = 'Name'\)?\s*\z/
  end

end
