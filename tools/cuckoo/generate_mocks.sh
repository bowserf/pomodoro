#!/usr/bin/env bash

TARGET_NAME="pomodoro"
TARGET_TEST_NAME="pomodoroTests"

DIR_NAME=$(dirname "$0")
OUTPUT_FILE="${DIR_NAME}/../../${TARGET_TEST_NAME}/GeneratedMocks.swift"
INPUT_DIR="${DIR_NAME}/../../${TARGET_NAME}"

echo "Generating Mocks File from ${INPUT_DIR} into ${OUTPUT_FILE}"

# Generate mock files, include as many input files as you'd like to create mocks for.
# Please try to keep this list order alphabetically :)
"${DIR_NAME}/cuckoo_generator" generate --testable "${TARGET_NAME}" \
--output "${OUTPUT_FILE}" \
"${INPUT_DIR}/home/entity/PomodoroStorage.swift" \
"${INPUT_DIR}/home/interactor/SelectPomodoroInteractorIO.swift"
# ... and so forth, the last line should never end with a backslash
