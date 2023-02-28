# GDSC Infra

This folder contains the infrastructure for the GDSC website, currently including only Firebase emulators.

## Getting Started

### Without Docker

1. Pre-requisites:

- `firebase-tools` installed
- Java version 11 or above installed

2. Login and start the emulators **(in `/firebase` directory)**

```bash
firebase login
firebase emulators:start --import=./baseline-data --export-on-exit
```

If you want to export the data from the emulators, you can use the `--export-on-exit` flag.
Or you can use the `firebase emulators:export ./baseline-data` command to export the data manually.

### With Docker

1. Pre-requisites:

- Docker Desktop installed

2. Just run **(in `/infra` directory)**

```bash
docker-compose up
```

It doesn't export on exit by default, but you can use the `firebase emulators:export ./baseline-data` command in Docker terminal to export the data manually.

## Interacting with the Emulators

Firebase Emulators UI will be available at [http://localhost:4000](http://localhost:4000).
And Firestore API endpoint will be available at [http://localhost:8080](http://localhost:8080).
