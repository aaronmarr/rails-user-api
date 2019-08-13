# README

Created a rails api app:

```
rails new user-api --api
```

Created the User model:

```
rails generate model User username:string email:uniq:index password_digest:string
```

This generates a bunch of stuff, including the new User model, migration and model test.

We'll be using bcrypt so add that as gem

```
gem 'bcrypt'
```

Then:

```
bundle
```

Add another migration for setting up the digest

```
rails generate migration add_password_digest_to_users password_digest:string
```

We can migrate now:

```
rails db:migrate
```

This runs the initial migration, and also created the file-based database in the db folder.

Start adding some tests

  def setup
    @user = User.new(name: "Example User", email: "user@example.com")
  end

  test "should be valid" do
    assert @user.valid?
  end