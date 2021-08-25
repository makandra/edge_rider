describe EdgeRider::CollectIds do

  describe '#collect_ids' do

    context 'when called on an ActiveRecord class' do

      it 'should return the ids for all records of that class' do
        Forum.create!(id: 1)
        Forum.create!(id: 2)
        Forum.collect_ids.should =~ [1, 2]
      end

    end

    context 'when called on a scope' do

      it 'should return the ids for all records matching that scope' do
        Forum.create!(id: 1, name: 'Name 1')
        Forum.create!(id: 2, name: 'Name 2')
        Forum.create!(id: 3, name: 'Name 2')
        scope = Forum.scoped(conditions: { name: 'Name 2' })
        scope.collect_ids.should =~ [2, 3]
      end

    end

    context 'when called on an Integer' do

      it 'should return the number as an array with a single element' do
        5.collect_ids.should == [5]
      end

    end

    context 'when called on another scalar value' do

      it 'should not be defined' do
        expect { "foo".collect_ids }.to raise_error(NoMethodError)
      end

    end

    context 'when called on an array of Integers' do

      it 'should return the list itself' do
        [1, 3].collect_ids.should == [1, 3]
      end

    end

    context 'when called on an array of ActiveRecords' do

      it 'should return the ids collected from that list' do
        forum_1 = Forum.create!(id: 1)
        forum_2 = Forum.create!(id: 2)
        [forum_1, forum_2].collect_ids.should =~ [1, 2]
      end

    end

    context 'when called on an array of other values' do

      it 'should raise an error' do
        expect { [1, 'foo', 3].collect_ids }.to raise_error(EdgeRider::CollectIds::Uncollectable)
      end

    end

    context 'when called on a has many association' do

      it 'should return the ids' do
        topic = Topic.create!
        post = Post.create!(topic: topic, id: 1)
        post = Post.create!(topic: topic, id: 2)
        topic.reload
        topic.posts.to_a
        topic.posts.collect_ids.should =~ [1,2]
      end

      it 'should return ids when further restricted with an anonymous scope' do
        topic = Topic.create!
        post = Post.create!(topic: topic, id: 1)
        post = Post.create!(topic: topic, id: 2)
        topic.reload
        topic.posts.to_a
        if topic.posts.respond_to?(:where)
          topic.posts.where(id: [1]).collect_ids.should =~ [1]
        else
          topic.posts.scoped(conditions: {id: [1]}).collect_ids.should =~ [1]
        end
      end

      it 'should return ids when further restricted with a named scope' do
        topic = Topic.create!
        post = Post.create!(topic: topic, id: 1)
        post = Post.create!(topic: topic, id: 2)
        topic.reload
        topic.posts.to_a
        topic.posts.these([1]).collect_ids.should =~ [1]
      end

    end

  end

end
