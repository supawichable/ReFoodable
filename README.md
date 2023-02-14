# gdsctokyo

A new Flutter project.

## Getting Started

### About `debug.dart`

Currently, we don't have an official home page, but to facilitate individual development, I decided to create a debug page that will contain all the routes to the pages that are currently being developed. Therefore, you can watch the changes in hot reload.

Just follow the instructions in the `debug.dart` file.

### Setting Up Environmental Variables

Please refer to instructions on `.env.example` file.

### Setting Up Firebase Emulators (if needed)

Please refer to instructions on `infra/README.md` file.

## Running the App in Development Mode

Make sure you have Flutter installed and configured.
Check if there are any problems by running:

```bash
flutter doctor
```

Then, if VS Code has Flutter extension installed, you can run

```bash
flutter run
```

## Testing

To run tests, run the following command

```bash
flutter test
```

To run individual test, run the following command

```bash
flutter test test/<path_to_test_file>
```

## Standards and Naming Conventions

Use `snake_case` for JSON and `camelCase` for variable names.
