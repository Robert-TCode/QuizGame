## QuizGame

A simple iOS app developed following TDD practices and with focus on the system architecture.

The idea of the app is a simple quiz game with single or multiple answer questions.
At the end the score and a summary of the correct and wrong aswers is presented.

## System Architecture

Modularisation was one key when developing the architecture, and SOLID priciples were applied.
The ideal was having as less dependencies as possible between modules so they can be replaced without requiring changes  in many places throughout the codebase or changing behaviour.

`QEngine` is a separate framework and can be found [here](https://github.com/Robert-TCode/QuizEngine).

Protocols and generics played an important part in achieving the desired result.
There is only one singleton in the app: `NetworkReachability`.
As UI design pattern was used MVC.

The diagram containing the architecture with dependencies and creations:

![alt text](https://github.com/Robert-TCode/QuizGame/blob/main/architecture.png?raw=true)

## TDD

Every new module was created following TDD, the accent being more on unit tests rather than integration tests.
The app has a ~95% test coverage.

## Upgrades

Main aspects of the app that could be improvement further are:
- creating a Model layer (could include `Question` and `Result`)
- expand the Networking module to be able to use a remote database
- create a pleasant UI

