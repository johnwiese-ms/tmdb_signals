# tmdb_signals

This project is a work in progress that will demonstrate how to use a number of packages and techniques for building a Flutter application. The application will use the free API provided by [The Movie Database](https://www.themoviedb.org/). While building the application we will focus on many topics, including:
- Using signals_flutter for state management
- Using rhttp for HTTP requests
- Using go_router for routing
- Using flex_color_scheme for theming
- Using very_good_analysis for linting
- Using flutter_dotenv for environment variables
- Proper error handling
- Logging
- Testing
- Handling app state & restoration
- and many more... 


## Getting Started

# Project Setup
1. Create a new project
2. Add the following dependencies to the pubspec.yaml file:
    - flutter_dotenv: ^6.0.0
    - go_router: ^17.2.0
    - rhttp: ^0.16.0
    - signals_flutter: ^6.3.0
3. Run `flutter pub get`
4. Create a free account at [The Movie Database](https://www.themoviedb.org/)
5. Get your API key
6. Create a tmdb.env file in the root of the project
7. Add the following line to the .env file:
    - API_KEY=your_api_key
    - READ_ACCESS_TOKEN=your_read_access_token
8. (**Highly Recommended**) Add the following line to the .gitignore file:
    - *.env
