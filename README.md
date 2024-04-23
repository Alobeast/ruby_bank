# Rails Banking App

## Start the app locally
1. Setup the application `bin/setup`
2. Start the application `bin/dev`
3. Access the app on your browser at `http://localhost:3000/`

## Create a user via the console:

```
User.create_user_with_account([email],[password])
```
**[email] must be in a correct format** `example: "example@example.com"`\
**[password] must be more than 6 characters long** `example: "password123"`\
Creating a user will also create its associated account

## Credit a user's account via the console:

```
user = User.find_by(email: [email])
user.account.credit([amount])
```
## Request account's balance history at a given date via the console:

```
user.account.balance_history([date])
```
**[date] must be in a correct "DD-MM-YY" format** `example: "28-02-24"`\
Outputs a hash with following info at given date:

* :credit
* :debit
* :balance
* :transactions_list

## Run Unit and Integration tests via the terminal
```
bin/rails test
```

Tests can be found
* [app/test/models/account_test.rb](https://github.com/Alobeast/ruby_bank/blob/master/test/models/account_test.rb)
* [app/test/models/user_test.rb](https://github.com/Alobeast/ruby_bank/blob/master/test/models/user_test.rb)
* [app/test/integration/transfer_test.rb](https://github.com/Alobeast/ruby_bank/blob/master/test/integration/transfer_test.rb)
* [app/test/integration/user_access_test.rb](https://github.com/Alobeast/ruby_bank/blob/master/test/integration/user_access_test.rb)
