# gdsctokyo

A new Flutter project.

## Getting Started

### Setting Up Environmental Variables

Please refer to instructions on `.env.example` file.

## Running the App in Development Mode

Make sure you have Flutter installed and configured.
Check if there are any problems by running:

```bash
flutter doctor
```
Make sure you run the following command to generate the files needed for the app to run:

```bash
flutter pub run build_runner build
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