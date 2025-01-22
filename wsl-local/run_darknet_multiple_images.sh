#!/bin/bash

# Directory where input images are located
INPUT_DIR="/darknet/output/input_images"
OUTPUT_DIR="/darknet/output"

echo "Darknet Multiple Image Prediction Script"
echo "========================================"

# Ensure the input directory exists
if [ ! -d "$INPUT_DIR" ]; then
    echo "Error: Input directory $INPUT_DIR does not exist."
    exit 1
fi

if [ -n "$FILE" ]; then
    # Batch mode: Process files in the $FILE variable
    echo "Processing file(s) from FILE environment variable: $FILE"
    for INPUT in $FILE; do
        if [[ "$INPUT" == http* ]]; then
            FILE_NAME=$(basename "$INPUT")
            echo "Downloading image from URL: $INPUT"
            wget -O "$FILE_NAME" "$INPUT" 2>/dev/null
            if [ $? -ne 0 ]; then
                echo "Error: Failed to download $INPUT. Skipping."
                continue
            fi
            INPUT="$FILE_NAME"
        fi

        if [ ! -f "$INPUT" ]; then
            echo "Error: Local file $INPUT not found. Skipping."
            continue
        fi

        echo "Processing $INPUT..."
        ./darknet detect cfg/yolov3.cfg yolov3.weights "$INPUT"
        if [ -f predictions.jpg ]; then
            OUTPUT_NAME=$(basename "$INPUT" | sed 's/\.[^.]*$//')
            mv predictions.jpg "/darknet/output/result_${OUTPUT_NAME}.jpg"
            echo "Saved result as /darknet/output/result_${OUTPUT_NAME}.jpg"
        fi

        ./darknet detect cfg/yolov3.cfg yolov3.weights "$INPUT" >> /darknet/output/result.txt
    done

else
    # Interactive mode: Prompt the user for inputsS
    echo "Darknet interactive prediction tool"
    while true; do
        echo -n "Enter Image Path or URL (leave blank to exit): "
        read FILE

        # Exit on blank input
        if [ -z "$FILE" ]; then
            echo "Exiting the prediction loop."
            break
        fi

        # Check if the input is a URL (starts with http or https)
        if [[ "$FILE" =~ ^https?:// ]]; then
            # Download the image from the URL
            IMAGE_PATH="$INPUT_DIR/$(basename $FILE)"
            wget -O "$IMAGE_PATH" "$FILE"

            if [ $? -ne 0 ]; then
                echo "Error: Failed to download $FILE."
                continue
            fi
        else
            # Treat the input as a local file name and prepend the input directory path
            IMAGE_PATH="$INPUT_DIR/$FILE"

            if [ ! -f "$IMAGE_PATH" ]; then
                echo "Error: Local file $IMAGE_PATH not found."
                continue
            fi
        fi

        # Run darknet prediction
        ./darknet detect cfg/yolov3.cfg yolov3.weights "$IMAGE_PATH"

        # Rename the predictions.jpg to include the original file name
        BASE_NAME=$(basename "$IMAGE_PATH" .jpg)
        mv predictions.jpg "$OUTPUT_DIR/result_${BASE_NAME}.jpg"

        # Append results to result.txt
        echo "Results for $IMAGE_PATH:" >> "$OUTPUT_DIR/result.txt"
        ./darknet detect cfg/yolov3.cfg yolov3.weights "$IMAGE_PATH" >> "$OUTPUT_DIR/result.txt"
    done

echo "All predictions completed. Results saved in $OUTPUT_DIR."
