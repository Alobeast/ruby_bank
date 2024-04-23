# Rails Banking App

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
