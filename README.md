![](https://badge.fury.io/rb/rspec_controller_helpers.svg)
![](http://ruby-gem-downloads-badge.herokuapp.com/rspec_controller_helpers)
![](https://img.shields.io/badge/license-MIT-blue.svg)

# Installation

Add the following to your Gemfile, under the `test` group

````ruby
gem 'rspec_controller_helpers', require: false
````

And add the following in the top of your `spec_helper.rb`:

````ruby
require 'rspec_controller_helpers'
````

# Usage

## Resourceful Controller
**Pre-requisite: You must have a factory set up with the right attributes**

This shared example can be used to test the default resourceful rails endpoints.

````ruby
it_behaves_like 'a resourceful controller', User
````

By default, it will test all of the following:

| Controller Method | request      | Tests |
|-------------------|-----------|-------|
| `index`  | `GET /<resource>`          | The page returns a 200 http status, and it rendering the index template |
| `new`    | `GET /<resource>/new`      | The page returns a 200 http status, and it renders the new template |
| `create` | `POST /<resource>`         | The model count changes by 1 |
| `show`   | `GET /<resource>/:id`      | The page returns a 200 http status, and it renders the show template |
| `edit`   | `GET /<resource>/:id/edit` | The page returns a 200 http status, and it renders the edit template |
| `update` | `PATCH /<resource>/:id`    | All attributes on the object are updated |
| `delete` | `DELETE /<resource>/:id`   | The model count changes by -1 |

You can disable endpoint tests the same way you would in `routes.rb`:

````ruby
# Tests new, create, show, edit, update, and delete
it_behaves_like 'a resourceful controller', User, except: [:index]
# Tests new, create
it_behaves_like 'a resourceful controller', User, only: [:new, :create]
````

This shared example will also infer your factory name from your model, so if your model is `User`, it will try `create(:user)`. You can override that with the `factory` option

````ruby
it_behaves_like 'a resourceful controller', User, factory: :admin
````

### JSON

By default, the shared example assumes html format for all views, but you can override that for each view, to test json endpoints:

````ruby
it_behaves_like 'a resourceful controller', User, formats: { index: [:html, :json] }
````

That will test the following:

| Controller Method | request      | Tests |
|-------------------|-----------|-------|
| `index`           | `GET /<resource>` | The right number of objects is returned |
| `show`            | `GET /<resource>/:id` | The correct attributes are returned |
