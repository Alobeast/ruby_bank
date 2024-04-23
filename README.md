# Rails Banking App

## Start the app locally
1. Run database migrations `bin/rails db:migrate`
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
