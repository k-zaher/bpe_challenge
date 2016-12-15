# BPE Challenge
The Project consists of a rails API app (MW) and an angular app that consumes the API provided by the MW

## Database Structure
The MW app consists of three models:

* User
	* **Attributes:** Name(string), Email(string), Password Hash(string), Admin(boolean)
	* Includes **BCrypt** to encrypt the password in the database
	* Interfaces **authenticated?** method to validate the user credentials
* Vehicle
	* **Attributes:** Name(string), Desc(text), state_id(integer)
* State
	* **Attributes:** Name(string), Order(integer)
	* Interfaces scope **ordered** to retrieve the states in order

## API
API is namespaced under "ng" and then versioned for "v1"

`/ng/v1/[:controller]`

API uses Basic Authentication where it expects an Authorization Header in the following format: 

`Basic [:Token]`

The token is a compination of "email:password" encoded Base64

All Controllers inherit from Ng::V1::BaseController which authenticates the user by decoding the request headers and validating the user credentials

```
def authenticate_user
    basic = ActionController::HttpAuthentication::Basic
    email, password = basic.decode_credentials(request).split(':')
    render status: :unauthorized and return unless (@current_user = User.authenticated?(email, password))
  end
```

Note: Ng::V1::SessionsController skips authenticate_user 

## Stories

* User:
	* As a user, I can login with my email and password.
	* As a user, I can see all vehicles on the system.
	* As a user, I can change the state of a certain vehicle to it's next state.

* Admin:
	* As an admin, I can login with my email and password.
	* As an admin, I can see all vehicles on the system.
	* As an admin, I can change the state of a certain vehicle to it's next state.
	* As an admin, I can see all states on the system.
	* As an admin, I can change the order of the possible states in the system by drag and drop.
	* As an admin, I can create and edit a state.
	* As an admin, I can delete a sate only if it doesn't have any vehicles.

## Developmemt
`git clone https://github.com/kimooz/bpe_challenge.git`

### MW

`cd [project]/mw`

* `bundle`
* Setup your database.yml
* `rails db:create; rails db:migrate; rails db:seed`
* `rails s`

To run Tests

Just run `rspec`, it will prepare and seed the test DB

### Angular

`cd [project]/ng_app`

* `npm install`
* `bower install`
* `gulp serve`

![Angular app Screenshot](https://s28.postimg.org/xomsiom7h/Screen_Shot_2016_12_15_at_6_31_44_PM.png)

**Admin View**

![Angular app Screenshot](https://s28.postimg.org/epl22j4xp/Screen_Shot_2016_12_15_at_6_35_24_PM.png)
![Angular app Screenshot](https://s28.postimg.org/5vu5lfhz1/Screen_Shot_2016_12_15_at_6_35_32_PM.png)

##TODO##

* Require HTTPS

* Use Token Authentication instead of Basic Authentication

* Serialize the JSON sent to the client using active_model_serializers

* Add option in for the user to logout on the client app

* Write Unit Tests and increate test coverage

* Dispatch expensive operations to a worker "Async" as reshuffling states order after state deletion


## Why I haven't used:

* **Devise**: The project is too simple to install a heavy gem as Devise, especially that most of its modules as Confirmable, Recoverable and Registerable won't be used.

* **StateMachine gem**: Well I actually used it at the begining but I found that it is build failing and hasn't been supported for some time. I even found a fork that supports rails 5, however I decided to remove it as having dynamic states will require meta-programming and this won't be scalable. It also saves the state in a column as string which will add an overhead while updating the name of the state.


**Enjoy**
