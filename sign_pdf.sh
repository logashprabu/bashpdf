#!/bin/bash

# Check if qpdf is installed
if ! command -v qpdf &> /dev/null
then
    echo "qpdf could not be found, please install it."
    exit 1
fi

# Variables
INPUT_PDF="input.pdf"  # Replace with your PDF file
OUTPUT_PDF="signed_output.pdf"
CERTIFICATE="certificate.pem"
PRIVATE_KEY="private_key.pem"

# Check if required files exist
if [[ ! -f "$INPUT_PDF" || ! -f "$CERTIFICATE" || ! -f "$PRIVATE_KEY" ]]; then
    echo "Error: Required files (PDF, certificate, private key) are missing."
    exit 1
fi

# Use qpdf to add the signature (simplified)
qpdf --encrypt "" "" 256 \
    --extract=y \
    --sign "$CERTIFICATE" "$PRIVATE_KEY" "$OUTPUT_PDF" "$INPUT_PDF"

echo "PDF has been signed and saved as $OUTPUT_PDF."
