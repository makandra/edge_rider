require 'spec_helper'

describe EdgeRider::OriginClass do

  describe '#origin_class' do

    it "should return the class a scope is based on" do
      Forum.create!(id: 1)
      Forum.create!(id: 2)
      scope = Forum.scoped(conditions: { id: [1] })
      scope.origin_class.should == Forum
      scope.origin_class.collect_ids.should == [1, 2]
    end

    it "should return the class a scope chain is based on" do
      Forum.create!(id: 1, name: 'A')
      Forum.create!(id: 2, name: 'B')
      Forum.create!(id: 3, name: 'C')
      scope_chain = Forum.scoped(conditions: { id: [1, 2] }).scoped(conditions: { name: ['A', 'B'] })
      scope_chain.origin_class.should == Forum
      scope_chain.origin_class.collect_ids.should == [1, 2, 3]
    end

    it "should return itself when called on an ActiveRecord class" do
      Forum.create!(id: 1)
      Forum.create!(id: 2)
      Forum.origin_class.should == Forum
      Forum.origin_class.collect_ids.should == [1, 2]
    end
  end

end
