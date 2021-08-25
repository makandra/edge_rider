describe EdgeRider::TraverseAssociation do

  describe '#traverse_association' do

    it 'should traverse a belongs_to associations' do
      forum_1 = Forum.create!
      forum_2 = Forum.create!
      forum_3 = Forum.create!
      topic_1 = Topic.create!(forum: forum_1)
      topic_2 = Topic.create!(forum: forum_1)
      topic_3 = Topic.create!(forum: forum_2)
      topic_4 = Topic.create!(forum: forum_3)
      scope = Topic.scoped(conditions: { id: [ topic_2.id, topic_4.id ] })
      traversed_scope = scope.traverse_association(:forum)
      EdgeRider::Util.scope?(traversed_scope).should == true
      traversed_scope.to_a.should =~ [forum_1, forum_3]
    end

    it 'should raise an error when traversing a belongs_to association with conditions, until this is implemented' do
      forum = Forum.create!(trashed: true)
      topic = Topic.create(forum: forum)

      scope = Topic.scoped(conditions: { id: topic.id })
      expect { scope.traverse_association(:active_forum) }.to raise_error(NotImplementedError)
    end

    it 'should traverse multiple belongs_to associations in different model classes' do
      forum_1 = Forum.create!
      forum_2 = Forum.create!
      forum_3 = Forum.create!
      topic_1 = Topic.create!(forum: forum_1)
      topic_2 = Topic.create!(forum: forum_2)
      topic_3 = Topic.create!(forum: forum_3)
      post_1 = Post.create!(topic: topic_1)
      post_2 = Post.create!(topic: topic_2)
      post_3 = Post.create!(topic: topic_3)
      scope = Post.scoped(conditions: { id: [post_1.id, post_3.id] })
      traversed_scope = scope.traverse_association(:topic, :forum)
      EdgeRider::Util.scope?(traversed_scope).should == true
      traversed_scope.to_a.should =~ [forum_1, forum_3]
    end

    it 'should traverse one or more has_many associations' do
      forum_1 = Forum.create!
      forum_2 = Forum.create!
      forum_3 = Forum.create!
      topic_1 = Topic.create!(forum: forum_1)
      topic_2 = Topic.create!(forum: forum_2)
      topic_3 = Topic.create!(forum: forum_3)
      post_1 = Post.create!(topic: topic_1)
      post_2 = Post.create!(topic: topic_2)
      post_3a = Post.create!(topic: topic_3)
      post_3b = Post.create!(topic: topic_3)
      scope = Forum.scoped(conditions: { id: [forum_1.id, forum_3.id] })
      traversed_scope = scope.traverse_association(:topics, :posts)
      EdgeRider::Util.scope?(traversed_scope).should == true
      traversed_scope.to_a.should =~ [post_1, post_3a, post_3b]
    end

    # in Rails 4, conditions on a scope are expressed as a lambda parameter
    it 'should raise an error when traversing a has_many association with conditions, until this is implemented' do
      forum = Forum.create!
      topic = Topic.create(forum: forum, trashed: true)

      scope = Forum.scoped(conditions: { id: forum.id })
      expect { scope.traverse_association(:active_topics) }.to raise_error(NotImplementedError)
    end

    it 'should traverse a has_many :through association' do
      forum_1 = Forum.create!
      forum_2 = Forum.create!
      forum_3 = Forum.create!
      topic_1 = Topic.create!(forum: forum_1)
      topic_2 = Topic.create!(forum: forum_2)
      topic_3 = Topic.create!(forum: forum_3)
      post_1 = Post.create!(topic: topic_1)
      post_2 = Post.create!(topic: topic_2)
      post_3a = Post.create!(topic: topic_3)
      post_3b = Post.create!(topic: topic_3)
      scope = Forum.scoped(conditions: { id: [forum_1.id, forum_3.id] })
      traversed_scope = scope.traverse_association(:posts)
      EdgeRider::Util.scope?(traversed_scope).should == true
      traversed_scope.to_a.should =~ [post_1, post_3a, post_3b]
    end

    it 'should traverse a has_one association' do
      user_1 = User.create!
      user_2 = User.create!
      user_3 = User.create!
      profile_1 = Profile.create!(user: user_1)
      profile_2 = Profile.create!(user: user_2)
      profile_3 = Profile.create!(user: user_3)
      scope = User.scoped(conditions: { id: [user_2.id, user_3.id] })
      traversed_scope = scope.traverse_association(:profile)
      EdgeRider::Util.scope?(traversed_scope).should == true
      traversed_scope.to_a.should =~ [profile_2, profile_3]
    end

    it 'should raise an error when traversing a has_many association with conditions, until this is implemented' do
      user = User.create!
      profile = Profile.create(user: user, trashed: true)

      scope = User.scoped(conditions: { id: user.id })
      expect { scope.traverse_association(:active_profile) }.to raise_error(NotImplementedError)
    end

    it 'should traverse up and down the same edges' do
      forum_1 = Forum.create!
      forum_2 = Forum.create!
      forum_3 = Forum.create!
      topic_1 = Topic.create!(forum: forum_1)
      topic_2 = Topic.create!(forum: forum_2)
      topic_3 = Topic.create!(forum: forum_3)
      post_1 = Post.create!(topic: topic_1)
      post_2 = Post.create!(topic: topic_2)
      post_3a = Post.create!(topic: topic_3)
      post_3b = Post.create!(topic: topic_3)
      scope = Post.scoped(conditions: { id: [post_3a.id] })
      traversed_scope = scope.traverse_association(:topic, :forum, :topics, :posts)
      EdgeRider::Util.scope?(traversed_scope).should == true
      traversed_scope.to_a.should =~ [post_3a, post_3b]
    end

    it 'should traverse to a polymorphic has one association' do
      profile = Profile.create!
      profile_attachment = Attachment.create!(record: profile)

      # Sanity check that the condition includes both record id and record type
      Attachment.create!(record_id: profile_attachment.id, record_type: 'NonExisting')

      scope = Profile.scoped(conditions: { id: [profile.id] })
      scope.traverse_association(:attachment).to_a.should =~ [profile_attachment]
    end

    it 'should traverse to a polymorphic has many association' do
      topic = Topic.create!
      topic_attachment_1 = Attachment.create!(record: topic)
      topic_attachment_2 = Attachment.create!(record: topic)

      # Sanity check that the condition includes both record id and record type
      Attachment.create!(record_id: topic_attachment_1.id, record_type: 'NonExisting')

      scope = Topic.scoped(conditions: { id: [topic_attachment_1.id, topic_attachment_2.id] })
      scope.traverse_association(:attachments).to_a.should =~ [topic_attachment_1, topic_attachment_2]
    end

    it 'should raise an error if you want to traverse from a polymorphic association' do
      profile = Profile.create!
      profile_attachment = Attachment.create!(record: profile)

      scope = Attachment.scoped(conditions: { id: [profile_attachment.id] })

      if [4, 3].include?(EdgeRider::Util.active_record_version)
        expect { scope.traverse_association(:record) }.to raise_error(
          NameError,
          'uninitialized constant Attachment::Record'
        )
      elsif EdgeRider::Util.active_record_version == 5
        expect { scope.traverse_association(:record) }.to raise_error(
          ArgumentError,
          'Polymorphic association does not support to compute class.'
        )
      else
        expect { scope.traverse_association(:record) }.to raise_error(
          ArgumentError,
          'Polymorphic associations do not support computing the class.'
        )
      end
    end

  end

end
