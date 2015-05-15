# Shogun

Add Shogun to your Gemfile:

```
# Gemfile
gem 'shogun', github: 'getshogun/shogun_rails'
```

Run `bundle install`

[Sign up](https://getshogun.com/sign_up) and find your environment variables in settings. Add these to your env:

```
SHOGUN_SITE_ID={your site id}
SHOGUN_SECRET_TOKEN={your secret token}
```

If you are using Unicorn, you also need to add this line in your `after_fork` configuration block:

```ruby
Shogun.daemon.call
```

Full example:

```ruby
# config/unicorn.rb
after_fork do
  ...
  Shogun.daemon.call
  ...
end
```

---

## Advanced configuration options

### automount

Shogun will automatically mount itself in your `routes`. You can disable this functionality and manually mount shogun by creating an initializer:

```ruby
# config/initializers/shogun.rb
Shogun.automount = false
```

You will then need to mount Shogun manually in your `config/routes.rb` file:

```ruby
# config/routes.rb
mount Shogun::Engine => '/'
```

### layout

Shogun will use your `application` layout by default. You can override this with the name of another layout:

```ruby
# config/initializers/shogun.rb
Shogun.layout = "my_special_layout"
```

### Manually setting site_id and secret_token

If you name your environment variables appropriately, these are picked up automatically by Shogun. These can also be set manually:

```ruby
# config/initializers/shogun.rb
Shogun.site_id = "the_site_id"
Shogun.secret_token = "the_secret_token"
```

This project rocks and uses MIT-LICENSE.
