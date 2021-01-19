Edge Rider [![Tests](https://github.com/makandra/edge_rider/workflows/Tests/badge.svg)](https://github.com/makandra/edge_rider/actions)
====================================

Power tools for ActiveRecord relations (scopes)
-------------------------------------------------

In ActiveRecord, relations (or scopes) allow you to construct complex queries piece-by-piece
and then trigger a query or update at a precisely defined moment. If you write any kind
of scalable code with ActiveRecord, you are probably using relations (or scopes) to do it.

Edge Rider was created with two intents:

1. Provide a number of utility methods to facilitate hardcore work with relations.
2. Provide a stable API for working with relations across multiple versions of Rails (since
Rails has a tradition of breaking details of its relation API every other release).


Usage
-----

### Traversing a relation along an association

Edge Rider gives your relations a method `#traverse_association` which
returns a new relation by "pivoting" around a named association.

Say we have a `Post` model and each `Post` belongs to an author:

```ruby
class Post < ActiveRecord::Base
  belongs_to :author
end
```

To turn a relation of posts into a relation of its authors:

```ruby
posts = Post.where(archived: false)
authors = posts.traverse_association(:author)
```

You can traverse multiple associations in a single call.
E.g. to turn a relation of posts into a relation of all posts of their authors:

```ruby
posts = Post.where(archived: false)
posts_by_same_authors = posts.traverse_association(:author, :posts)
```

*Implementation note:* The traversal is achieved internally by collecting all foreign keys in the current relation
and return a new relation with an `IN(...)` query (which is very efficient even for many thousand keys).
This means every association that you pivot around will trigger one SQL query.


### Efficiently collect all record IDs in a relation

You often want to retrieve an array of all record IDs in a relation.

You should **not** use `relation.collect(&:id)` for this because a call like that
will instantiate a potentially large number of ActiveRecord objects only to collect
its ID.

Edge Rider has a better way. Your relations gain a method `#collect_ids` that will
fetch all IDs in a single query without instantiating a single ActiveRecord object:

```ruby
posts = Post.where(archived: false)
post_ids = posts.collect_ids
```

*Implementation note:* `#collect_ids` delegates to [`#pluck`](https://apidock.com/rails/ActiveRecord/Calculations/pluck),
which can be used for the same purpose.


### Collect record IDs from any kind of object

When writing a method that filters by record IDs, you can make it more useful by accepting
any kind of argument that can be turned into a list of IDs:

```ruby
Post.by_author(1)
Post.by_author([1, 2, 3])
Post.by_author(Author.find(1))
Post.by_author([Author.find(1), Author.find(2)])
Post.by_author(Author.active)
```

For this use case Edge Rider defines `#collect_ids` on many different types:

```ruby
Post.where(id: [1, 2]).collect_ids    # => [1, 2]
[Post.find(1), Post.find(2)].collect_ids # => [1, 2]
Post.find(1).collect_ids                 # => [1]
[1, 2, 3].collect_ids                    # => [1, 2, 3]
1.collect_ids                            # => [1]
```

You can now write `Post.by_author` from the example above without a single `if` or `case`:

```ruby
class Post < ActiveRecord::Base

  belongs_to :author

  def self.for_author(author_or_authors)
    where(author_id: author_or_authors.collect_ids)
  end

end
```


### Efficiently collect all values in a relation's column

You often want to ask a relation for an array of all values ofin a given column.

You should **not** use `relation.collect(&:column)` for this because a call like that
will instantiate a potentially large number of ActiveRecord objects only to collect
its column value.

Edge Rider has a better way. Your relations gain a method `#collect_column` that will
fetch all column values in a single query without instantiating a single ActiveRecord object:

```ruby
posts = Post.where(archived: false)
subjects = posts.collect_column(:subject)
```

*Implementation note:* `#collect_column` delegates to [`#pluck`](https://apidock.com/rails/ActiveRecord/Calculations/pluck),
which can be used for the same effect.

#### Collect unique values in a relation's column

If you only care about *unique* values, use the `distinct: true` option:

```ruby
posts = Post.where(archived: false)
distinct_subjects = posts.collect_column(:subject, distinct: true)
```

With this options duplicates are discarded by the database before making their way into Ruby.

*Implementation note:* The `:distinct` option is implemented with [`#uniq`](https://apidock.com/rails/ActiveRecord/QueryMethods/uniq)
 or [`#distinct`](https://apidock.com/rails/ActiveRecord/QueryMethods/distinct) which can be used for the same effect.

### Simplify a complex relation for better chainability

In theory you can take any relation and extend it with additional joins or conditions.
We call this *chaining** relations.

In practice chaining becomes problematic as relation chains grow more complex.
In particular having JOINs in your relation will reduce the relations's ability to be chained with additional JOINs
without crashes or side effects. This is because ActiveRecord doesn't really "understand" your relation chain, it only
mashes together strings that mostly happen to look like a MySQL query in the end.

Edge Rider gives your relations a new method `#to_id_query`:

```ruby
Site.joins(user).where(:users: { name: 'Bruce' }).to_id_query
```

`#to_id_query` will immediately run an SQL query where it collects all the IDs that match your relation:

```sql
SELECT sites.id FROM sites INNER JOIN users WHERE sites.user_id = sites.id AND users.name = 'Bruce'
```

It now uses these IDs to return a new relation that has **no joins** and a single condition on the `id` column:

```sql
SELECT * FROM sites WHERE sites.user_id IN (3, 17, 103)
```


### Preload associations for loaded ActiveRecords

Sometimes you want to fetch associations for records that you already instantiated, e.g. when it has deeply nested associations.

Edge Rider gives your model classes and instances a method `preload_associations`. The method can be used to preload associations for loaded objects like this:

```ruby
@user = User.find(params[:id])
User.preload_associations [@user], { threads: { posts: :author }, messages: :sender }
# or
user.preload_associations { threads: { posts: :author }, messages: :sender }
```

*Implementation note*: Rails 3.0 already has a method [`.preload_associations`](https://apidock.com/rails/ActiveRecord/AssociationPreload/ClassMethods/preload_associations)
which Edge Rider merely makes public. Edge Rider ports this method forward to Rails 3.1+.



### Retrieve the class a relation is based on

Edge Rider gives your relations a method `#origin_class` that returns the class the relation is based on.
This is useful e.g. to perform unscoped record look-up.

```ruby
Post.recent.origin_class
# => Post
```

Note that `#origin_class` it roughly equivalent to the blockless form of [`unscoped`](https://apidock.com/rails/ActiveRecord/Scoping/Default/ClassMethods/unscoped) from Rails 3.2+,
but it works consistently across all Rails versions.


### Turn a model into a scope or narrow down an existing scope

Edge Rider ports `Model.scoped` forward to Rails 4+ (taken from
[activerecord-deprecated_finders](https://github.com/rails/activerecord-deprecated_finders/blob/master/lib/active_record/deprecated_finders/base.rb#L61)). This
enables you to consistently turn models into scopes or narrow down scopes
across all versions of Rails.

```ruby
User.scoped # just calls User.all in Rails 4
User.active.scoped(conditions: { admin: true })
```

*Implementation note*: Rails 3 already have a method
[`.scoped`](https://apidock.com/rails/ActiveRecord/Scoping/Named/ClassMethods/scoped) which Edge Rider does not touch. Rails 4 has removed this method and
splits its functionality into the query methods known from Rails 3 (`.where`,
`.order` etc.) and an `.all` method that just returns a scope.

Note that associations and scopes also have a `.scoped` method that behaves
slightly different in all versions of Rails (see
[`scoped_spec.rb`](/spec/shared/spec/edge_rider/scoped_spec.rb#L49)). These
methods are not modified.


Installation
------------

In your `Gemfile` say:

    gem 'edge_rider'

Now run `bundle install` and restart your server.


Development
-----------

- There are tests in `spec`. We only accept PRs with tests.
- We currently develop using the Ruby version in `.ruby-version`. It is required to change the Ruby Version to cover all Rails version or just use Travis CI.
- Put your database credentials into `spec/support/database.yml`. There's a `database.sample.yml` you can use as a template.
- Create a database `edge_rider_test` in both MySQL and PostgreSQL.
- There are gem bundles in the project root for each combination of ActiveRecord version and database type that we support.
- You can bundle all test applications by saying `bundle exec rake matrix:install`
- You can run specs from the project root by saying `bundle exec rake matrix:spec`. This will run all gemfiles compatible with your current Ruby.

If you would like to contribute:

- Fork the repository.
- Push your changes **with passing specs**.
- Send me a pull request.


Credits
-------

Henning Koch from [makandra](http://makandra.com/)
