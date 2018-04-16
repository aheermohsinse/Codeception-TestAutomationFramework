## Test Automation Framework - Codeception

You can perform end to end testing with this framework mainly:
- Functional Testing
- API Testing
- Unit Testing
- Acceptance Testing

## Installation

- Clone the repository 
- Run `composer install`
- Follow the blog

### Phpunit

### Run tests

To run all tests:

``
./vendor/codeception/codeception/codecept run
``

To run only tests

``
./vendor/codeception/codeception/codecept run api 
``

``
./vendor/codeception/codeception/codecept run functional 
``

``
./vendor/codeception/codeception/codecept run acceptance 
``

To run only unit tests

``
./vendor/codeception/codeception/codecept run unit 
``

To run specific tests you may specify the test class name:

``
./vendor/codeception/codeception/codecept run tests/unit/Modules/Test/Models/BasicTest.php
``
