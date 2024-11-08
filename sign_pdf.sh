#!/bin/bash

# Variables - adjust these paths to point to your actual files
INPUT_PDF="input.pdf"          # The PDF to sign
OUTPUT_PDF="$(System.DefaultWorkingDirectory)/signed_output.pdf"  # Use pipeline's default working directory
CERTIFICATE="certificate.pem"   # Your certificate file
PRIVATE_KEY="private_key.pem"   # Your private key file

# Check that all required files exist
if [[ ! -f "$INPUT_PDF" ]]; then
  echo "Error: Input PDF ($INPUT_PDF) does not exist."
  exit 1
fi
if [[ ! -f "$CERTIFICATE" ]]; then
  echo "Error: Certificate file ($CERTIFICATE) does not exist."
  exit 1
fi
if [[ ! -f "$PRIVATE_KEY" ]]; then
  echo "Error: Private key file ($PRIVATE_KEY) does not exist."
  exit 1
fi

# Create a hash of the PDF content to sign
HASH_FILE="pdf_hash.txt"
openssl dgst -sha256 -binary "$INPUT_PDF" > "$HASH_FILE"

# Sign the hash with the private key to create the signature
SIGNATURE_FILE="signature.bin"
openssl rsautl -sign -inkey "$PRIVATE_KEY" -in "$HASH_FILE" -out "$SIGNATURE_FILE"

# Use qpdf to add the signature as an annotation in the PDF
qpdf --replace-input --object-streams=generate \
  --sign "$CERTIFICATE" "$PRIVATE_KEY" \
  --signature "$SIGNATURE_FILE" "$INPUT_PDF" "$OUTPUT_PDF"

# Cleanup intermediate files
rm -f "$HASH_FILE" "$SIGNATURE_FILE"

echo "PDF has been signed and saved as $OUTPUT_PDF."
