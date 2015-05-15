# Shogun

Add Shogun to your Gemfile:

```
gem 'shogun', github: 'getshogun/shogun_rails'
```

Run `bundle install`

[Sign up](https://getshogun.com/sign_up) and find your environment variables in settings. Add these to your env:

```
SHOGUN_SITE_ID={your site id}
SHOGUN_SECRET_TOKEN={your secret token}
```

If you are using Unicorn, you also need to add this line in your `after_fork` configuration block:

```
Shogun.daemon.call
```

---

## Advanced configuration options

### automount

Shogun will automatically mount itself in your `routes`. You can disable this functionality and manually mount shogun by creating an initializer:

```ruby
Shogun.automount = false
```

You will then need to mount Shogun manually in your `config/routes.rb` file:

```ruby
mount Shogun::Engine => '/'
```

This project rocks and uses MIT-LICENSE.
