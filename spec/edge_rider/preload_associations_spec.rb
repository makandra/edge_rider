describe EdgeRider::PreloadAssociations do

  describe '.preload_associations' do
    it 'should preload the given named associations so they are no longer fetched lazily' do
      forum = Forum.create!
      topic = Topic.create!(forum: forum)
      post = Post.create!(topic: topic)

      Forum.preload_associations([forum], topics: :posts)
      expect { forum.topics.collect(&:posts) }.to_not make_database_queries
    end
  end

  describe '#preload_associations' do
    it 'should preload the given named associations so they are no longer fetched lazily' do
      forum = Forum.create!
      topic = Topic.create!(forum: forum)
      post = Post.create!(topic: topic)

      forum.preload_associations(topics: :posts)
      expect { forum.topics.collect(&:posts) }.to_not make_database_queries
    end
  end

end
