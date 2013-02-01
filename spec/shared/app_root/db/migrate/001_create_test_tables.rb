class CreateTestTables < ActiveRecord::Migration

  def self.up

    create_table :forums do |t|
      t.string :name
    end

    create_table :topics do |t|
      t.string :subject
      t.references :forum
      t.references :author
    end

    create_table :posts do |t|
      t.text :body
      t.references :topic
      t.references :author
    end

    create_table :users do |t|
      t.string :email
    end

    create_table :profiles do |t|
      t.references :user
      t.text :hobbies
    end

  end

  def self.down
    drop_table :forums
    drop_table :topics
    drop_table :posts
    drop_table :users
  end

end
