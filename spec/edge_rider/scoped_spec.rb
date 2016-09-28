require 'spec_helper'

describe EdgeRider::Scoped do
  describe 'scoped' do
    
    it 'returns a scope when called without parameters' do
      unless EdgeRider::Util.activerecord2? # Rails 2 cannot do this
        EdgeRider::Util.scope?( Forum.scoped ).should == true
      end
    end
    
    it 'returns a scope when called with an empty hash' do
      EdgeRider::Util.scope?( Forum.scoped({}) ).should == true
    end
    
    it 'respects conditions' do
      trashed = Forum.create! :trashed => true
      active = Forum.create! :trashed => false
      
      Forum.scoped(:conditions => { :trashed => true }).to_a.should == [ trashed ]
    end
    
    it 'respects order' do
      c = Forum.create! :name => 'Chemikalien'
      a = Forum.create! :name => 'Allegorie'
      b = Forum.create! :name => 'Botanisch'
      
      Forum.scoped(:order => 'name ASC').to_a.should == [ a, b, c ]
    end
    
    it 'can be used to add conditions to an existing scope chain' do
      bulldog = Forum.create! :name => 'bulldog', :trashed => false
      trashed = Forum.create! :name => 'maneuver', :trashed => true
      trashed_bulldog = Forum.create! :name => 'bulldog', :trashed => true
      
      Forum.
        scoped(:conditions => { :trashed => true }).
        scoped(:conditions => { :name => 'bulldog' }).to_a.should == [ trashed_bulldog ]
    end
    
    it 'can be used to add conditions to a has_many association' do
      forum = Forum.create!
      thema = Topic.create! :subject => 'Thema', :trashed => false, :forum => forum
      other_topic = Topic.create! :subject => 'Other', :trashed => false, :forum => forum
      trashed_thema = Topic.create! :subject => 'Thema', :trashed => true, :forum => forum
      
      has_many_scope = forum.active_topics
      # In Rails 3, #scoped on associations does not take parameters but turns
      # an association into a real scope.
      has_many_scope = has_many_scope.scoped if ActiveRecord::VERSION::MAJOR == 3
      has_many_scope.scoped(:conditions => { :subject => 'Thema' }).to_a.should =~ [ thema ]
    end
    
  end
end
