# Plans

[![Code Climate](https://codeclimate.com/github/andela-ooranagwa/bucketlist/badges/gpa.svg)](https://codeclimate.com/github/andela-ooranagwa/bucketlist) [![Test Coverage](https://codeclimate.com/github/andela-ooranagwa/bucketlist/badges/coverage.svg)](https://codeclimate.com/github/andela-ooranagwa/bucketlist/coverage)

Plans provides an API service that allows user create and manage bucketlists (and bucketlist items).

Users of the service can have many bucketlists and a bucketlist can have many items. Items can be marked as done or pending. A possible flow of the use of the API service is outlined below.

### Register user

The service requires users to register with a *name* (between 2 and 50 characters in length), a valid *email* and a *password*. A successful registration will return the user database information including the `user id`.

[Create user documentation](http://pl-an.herokuapp.com/docs/1.0/users/create.html)


### login user

After successfully creating an account, users can login using a validly registered *email* and *password* . A successful login will return an `auth_token` to be used for authenticating subsequent requests to the service. [*See the section on authentication for more information*](#)

[Login documentation](http://pl-an.herokuapp.com/docs/1.0/users/login.html)

### List bucketlists
If you've followed this readme sequentially up until now, this query will (probably) return an empty result with a **200** status. _This should be because you are yet to create a bucketlist_. A query to `v2` might return a different result; checkout **Notes on V2** for more information.

Once a user creates a bucketlist, the created bucketlist will appear with all relevant information (id, name, date created, etc).

An optional params `q` can be included with this request to search and return only bucketlists that match the param

> ?q=val


```
Note: For now, bucketlists will have their contained items embedded with them. Future support for this feature in v1 is not guaranteed. Plans are ongoing to ensure that all requests made on v1 will carry out single operation and return only single results. If you will like to continue retrieving bucketlists with the items embedded, make sure to use v2
```

[List bucketlist documentation](http://pl-an.herokuapp.com/docs/1.0/bucketlists/index.html)

### Create bucketlist

This require a valid name (between 2 and 100 characters in length). If successful, the result will comprise amongst other relevant information, the `bucketlist id` with can be used for making other bucketlist requests including the bucketlist items.

[Create bucketlist documentation](http://pl-an.herokuapp.com/docs/1.0/bucketlists/create.html)

### Show bucketlist
This returns details of the requested bucketlist using the `bucketlist id`. Common errors with this query range from invalid `id` to `unauthorized access`.

[Show bucketlist documentation](http://pl-an.herokuapp.com/docs/1.0/bucketlists/show.html)

### Create item
Bucketlists contain items. Creating an item in a bucketlist requires the `id` of the bucketlist and a valid `entry` for the item.

Optionally the item's `done` status can also be included. Note that `done` can only be either `true` or `false`.

[Create item documentation](http://pl-an.herokuapp.com/docs/1.0/items/create.html)
### List items

This returns the items in the requested bucketlist. Empty bucketlists will, expectedly, return an empty result (*varies for v2*).

An optional params, `status` can be included with the request to fetch either `done` items or `pending` items only.
> ?status=pending or ?status=done

The most likely errors that could occur include invalid `bucketlist id`, `unauthorized access`

[List item documentation](http://pl-an.herokuapp.com/docs/1.0/items/index.html)
### Show item
This serves to provide more information on a single bucketlist item. inclusive of the errors outline above, it is also prone to invalid `item id` error.

[Show item documentation](http://pl-an.herokuapp.com/docs/1.0/items/show.html)

### Update Item
Updating the details of an item requires a **valid** `name` and/or `done` status.

```
done can be either true or false
```

Be mindful of the `errors` highlighted above while using this query.

[Update item documentation](http://pl-an.herokuapp.com/docs/1.0/items/update.html)

### Delete Item

Items can be deleted from a bucketlist using this request.  It requires the `id` of the item and that of the bucketlist that contains it.

[Delete Item documentation](http://pl-an.herokuapp.com/docs/1.0/items/destroy.html)

### Update bucketlist
With a valid `bucketlist id`, this request is used to change the name of a bucketlist. Request will be subject to **validation** of the provided name as pointed out earlier.

[Update bucketlist documentation](http://pl-an.herokuapp.com/docs/1.0/bucketlists/update.html)
### Delete bucketlist

This request deletes a bucketlist and the items it contain. A `204` status signifies a successful transaction.

[Delete bucketlist documentation](http://pl-an.herokuapp.com/docs/1.0/bucketlists/destroy.html)

### Update user information

User `email`, `password` and/or `name` can be updated using this request. The provided update entries must meet the validation for their respective categories.

[Update user information](http://pl-an.herokuapp.com/docs/1.0/users/update.html)

### Logout user

Log out a user restricts their access to the service even if their `token` is not expired. Once logged out, a user will need to `log in` to use the service again.

[Logout documentation](http://pl-an.herokuapp.com/docs/1.0/users/logout.html)

### Pagination
The response for a (successful) `list bucketlist` and/or `list items` request is paginated. You can specify these using `limit` and/or `page` params. The `limit` specifies the number of results per page while `page` specifies the page to return. See the documentation for samples.

Note that the **maximum limit is 100** and the **minimum is 1**. The default however is *20*

### About Authentication

Aside the endpoints for registering a new user and login, **every** other endpoint requires that each request be accompanied with a **valid** token. The API utilizes [JWT](http://jwt.io) token for authentication and it's gotten at a successful login.

The token is included as part of the header of a request:
> AUTHORIZATION: TOKEN your_valid_token

Note that tokens expire **24hrs** after they are issued.

### Notes on v2

** Experimental version **

V2 extends V1 with some awesome features. Notably,
* `list` and `show` bucketlist requests are no longer scoped to the `current user` but rather it returns all available bucketlists
* `list` and `show` items requests are no longer scoped to the `current user` but rather it returns all available bucketlist items
* requests can be customized to return only results specfic, and/or not specific to the `current user` using the `o` params
```
scoped request
?o=user
?o=not_user
```
* search query can be scoped to any desired owner criteria
```
  scoped search
  ?q=search_query&&o=user
  ?q=search_query&&o=not_user
```

For now, other API actions on `v2`, aside the ones listed above behave exactly like `v1`. Infact, `v2` doesn't handle those requests but routes them to `v1`

The default API version is **v1**. Specific version can be requested either by specifying the version in the _request path_ or in the _request header_

```
version request using path
/v1/bucketlists
/v2/bucketlists
```
```
version request using headers
Accept: application/vnd.plans; version=1
Accept: application/vnd.plans; version=2
```

### Documentation

* User documentation `/docs/1.0/users.html`
* Bucketlist documentation `/docs/1.0/bucketlists.html`
* Items documentation `/docs/1.0/bucketlists.html`

A pretty encompassing documentation of the API inclusive of numerous sample usage and outcome is available at the project root_path `/docs`. The documentation is generated using the *awesome* `apipie gem`.

In order to make for a clean presentation of the project, I've removed the needed controller codes for generating the documentation. And in their place, the cache copies are served on request. The codes can easily be regenerated by deleting the cached copies in the public folder and running:
> APIPIE_RECORD=params rake test

Nevertheless, the generated codes might require further modifications to accurately describe the controller actions and requirements. Checkout `commit` `b8e993b` to view a semblance of an accurate representation.

> git checkout b8e993b

### Caveat

This API is built (mainly) for 3rd party apps that will want to extend the bucketlist management services and not regular users of the bucketlist services.

I'm working on developing, with `mithril js`, a minimalistic UI that can be used to interact with the API. [Check it out](http://pl-an.herokuapp.com). The UI is part of my progress in learning the `mithril` framework as such it's stability, future support and overall efficiency is not guaranteed.

## Using the application

### Dependencies
**Plans** is built with version 0.4.0 of Rails API framework using the Ruby programming language (version 2.1.7). Chances are you already have Ruby and Rails installed. You can run __which ruby__ and __which rails__ to check for their installation.

*   if Ruby is not installed checkout the [ruby installation guide](https://www.ruby-lang.org/en/downloads/) for guidelines to setup Ruby on your machine
*   if Rails is not installed checkout the [Rails installation guide](http://rubyonrails.org/download/) for guidelines to setup rails on you machine.

Also check for and confirm the [installation of gem](http://guides.rubygems.org/rubygems-basics/) and [bundler](http://rubygems.org) on your machine. These will allow you install other libraries ( _gems_ ) required by Plans.

### Running the application

First [clone this repo](clone). Then from your terminal (or command prompt) navigate to the folder where you have cloned *Plans*( __cd path/to/plans/__ ).

*   Run __bundle install__ to install all *Plans* dependencies.
*   Run __rake db:migrate__ to setup the app database
*   Run __rails server__ to start the rails server

You are now good to go. [**Postman**](https://www.getpostman.com/docs) will come in handy for trying out the application.

To get you started, you can copy and run the following code in `rails console`

```
# populate db with users
5.times { User.create(name: Faker::Name.name, email: Faker::Internet.email, password: Faker::Lorem.word(2)) }

# create bucketlist for each User
User.all.each do |user|
  rand(1..10).times { user.bucketlists.create(name: Faker::Lorem.word(10)) }
end

# create bucketlist items
Bucketlist.all.each do |list|
  rand(1..10).times { list.items.create(name: Faker::Lorem.word(10)) }
end
```

### Running the tests

**Plans** spots a pretty strong integration test suite using `MiniTest`, [`FactoryGirl`](https://github.com/thoughtbot/factory_girl), [faker](https://github.com/stympy/faker) gems.

To start the test, first migrate the test database by running __rake db:migrate__. Next run __rake test__ to run all tests. You can also specify a particular test from the test folder to run.

## Contributing
1. Fork the repo.
2. Run the tests. We only take pull requests with passing tests, and it's great
to know that you have a clean slate: `bundle && bundle exec rake`
3. Add a test for your change. Only refactoring and documentation changes
require no new tests. If you are adding functionality or fixing a bug, we need
a test!
4. Make sure the test pass.
5. Push to your fork and submit a pull request.

#####Syntax:

* Two spaces, no tabs.
* No trailing whitespace. Blank lines should not have any space.
* Prefer `&&`, `||` over `and`, `or`.
* `MyClass.my_method(my_arg)` not `my_method( my_arg )` or `my_method my_arg`.
* `a = b` and not `a=b`.
* Follow the conventions you see used in the source already.
