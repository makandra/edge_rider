Gemika::Database.new.rewrite_schema! do

  create_table :forums do |t|
    t.string :name
    t.boolean :trashed
  end

  create_table :topics do |t|
    t.string :subject
    t.references :forum
    t.references :author
    t.boolean :trashed
  end

  create_table :posts do |t|
    t.text :body
    t.references :topic
    t.references :author
    t.boolean :trashed
    t.timestamps null: true
  end

  create_table :users do |t|
    t.string :email
    t.boolean :trashed
  end

  create_table :profiles do |t|
    t.references :user
    t.text :hobbies
    t.boolean :trashed
  end

end
