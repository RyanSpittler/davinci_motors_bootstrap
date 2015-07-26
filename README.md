# README
## DaVinci Motors

You can visit the [deployed website for this project online](http://stormy-tundra-4599.herokuapp.com/).  
This project is for practice. Many of the strategies used here were learned from the class, "Building the Toolbelt of a Junior Ruby on Rails Developer" taught by [Jason Noble](http://jasonnoble.org) offered by [Davinci Coders](http://www.davincicoders.com/) in Spring of 2015.

------

### Features

* Users can sign up and return to the site.
* Users can create cars. They must already be on an internal list of makes and models.
* When signed in, users can claim cars, and newly created cars are already claimed.
* Users can see their claimed cars on their page.
* Users can edit and delete cars that they have claimed.
* Users can unclaim cars.
* When the list of cars is long enough, only ten cars are shown on each page.

------

### Specifications

* Ruby version: 2.1.5

* Database: Development and Test use SQLite, Production uses PostGres

* Test Suite: RSpec with Capybara, FactoryGirlRails, and Faker 
-- You can view the tests by running `dotenv guard` on the command line.

* Front End: Bootstrap

* Pagination: Will_Paginate

* Environmental Key Management: DotEnv

------

### Deployment instructions

* Clone the repo
* Create the database: `rake db:create db:migrate`
* Run: `cp copy_of.env .env` and insert keys in the newly created file
* For the server: `dotenv rails s` will use your keys in your new `.env` file
* Run: `dotenv guard` to run guard and see the test results
