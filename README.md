# Elearnio Ruby on Rails Challenge

You are responsible for implementing a new API. The customer requires an app that
handles online courses, its author and talents. The API includes CRUD operations
for all these items. The development team already established which
language/platform is going to be used, the app should use Ruby on Rails 6.0 on the
backend and access a Postgres database. Since it is a prototype, no frontend is
required. The customer also required that you provide the documentation regarding
the deployment procedure and application details.

## Relationships and limitations

A course can have 0 to n talents and must have 1 author, a talent can be in 0 to n courses,
an author can have 0 to n courses. A talent in one course can be the author of another course.
One important feature is that when deleting an author, the course has to be transferred to
another author.

## Technical requirements

* to have an API:
  * Using the JSONAPI (https://jsonapi.org)
  * Using the JSONAPI::Resources (https://jsonapi-resources.com)
* Have a postman collection of the API (optional)
* No authentication methods for this test version
* Rspec for testing

## Definition of done

* Seed data is fed to the database (optional)
* Client can CRUD the data on the API with the provided postman collection
* no errors
* documentation with the required information

---

## Requirements

* Ruby version 3.0.x

* Start a local version of Postgres database in the separate terminal window
  (on Mac: `/usr/local/opt/postgresql@14/bin/postgres -D /usr/local/var/postgresql@14`)

## Installation

* Update Ruby gem manager
  - Run in terminal: `gem update --system`

* Update gems
  - Run in terminal: `gem update`

* Clone the current repository, checkout the `main` branch and then run in terminal inside its folder `bundle`

* Database initialization
  - Run in terminal (inside project folder): `bundle exec rake db:drop`, WARNING: the existing DB in the project folder will be deleted
  - Run in terminal: `bundle exec rake db:create`
  - Run in terminal: `bundle exec rake db:migrate`
  - Run in terminal: `bundle exec rake db:seed`
  - Now you have successfully populated your local development environment with test data

## Usage

* Application start
  - Run in terminal: `bundle exec rails server`
  - Now the application is ready to respond to the incoming requests on http://localhost:3000/

* Application usage
  - all the possible sample requests are saved into `elearnio.postman_collection.json` file, please use Postman to load the collection and use any single queries to test the api.

* Decisions made during the implementation
  - limit the allowed Name value for User (Talents and Authors) model to 255 characters and prohibit using symbols, other than latin letters and spaces
  - Email of User (Talents and Authors) should be unique
  - limit the allowed Email value for User model to 255 characters and allow using only valid email schema
  - limit the allowed Title value for Course model to 255 characters and allow using symbols from [.,-:] range, have numbers and spaces

