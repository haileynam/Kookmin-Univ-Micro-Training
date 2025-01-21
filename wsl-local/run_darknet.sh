#!/bin/bash

# Define the default directory for local files (volume-mounted path)
DEFAULT_INPUT_DIR="/darknet/output"

# Check if FILE environment variable is set
if [ -z "$FILE" ]; then
    echo "Error: FILE environment variable not set."
    exit 1
fi

# Check if FILE is a URL
if [[ "$FILE" =~ ^https?:// ]]; then
    echo "Detected URL. Downloading input image from $FILE..."
    wget -O input.jpg "$FILE" || { echo "Failed to download image."; exit 1; }
else
    # Assume FILE is a file name; prepend DEFAULT_INPUT_DIR if it's not an absolute path
    if [[ "$FILE" != /* ]]; then
        FILE="$DEFAULT_INPUT_DIR/$FILE"
    fi

    # Check if the local file exists
    if [ -f "$FILE" ]; then
        echo "Using local file: $FILE"
        cp "$FILE" input.jpg || { echo "Failed to copy local file."; exit 1; }
    else
        echo "Error: Local file $FILE not found."
        ls "$DEFAULT_INPUT_DIR"  # List available files for debugging
        exit 1
    fi
fi

# Run Darknet detection
echo "Running Darknet detection..."
./darknet detect cfg/yolov3.cfg yolov3.weights input.jpg > /darknet/output/result.txt || { echo "Darknet detection failed."; exit 1; }

# Move predictions.jpg to output directory
echo "Moving predictions.jpg to output directory..."
mv predictions.jpg /darknet/output/ || { echo "Failed to move predictions.jpg."; exit 1; }

echo "Processing complete. Results saved to /darknet/output."

# Keep the container interactive
exec /bin/bash
