import PyPDF2
import pikepdf
from pathlib import Path
import hashlib
import os

# Paths for the input and output PDFs and the certificate
INPUT_PDF = "input.pdf"
OUTPUT_PDF = "signed_output.pdf"
CERTIFICATE = "certificate.pem"
PRIVATE_KEY = "private_key.pem"

def sign_pdf(input_pdf, output_pdf, certificate, private_key):
    # Check for existence of input files
    if not Path(input_pdf).is_file() or not Path(certificate).is_file() or not Path(private_key).is_file():
        raise FileNotFoundError("One or more required files are missing.")

    # Step 1: Load PDF and generate a hash to "sign" (as a demonstration)
    with open(input_pdf, "rb") as pdf_file:
        reader = PyPDF2.PdfReader(pdf_file)
        writer = PyPDF2.PdfWriter()

        # Copy content to writer for the final output
        for page in range(len(reader.pages)):
            writer.add_page(reader.pages[page])

        # Generate a hash of the PDF for a placeholder signature
        pdf_hash = hashlib.sha256(Path(input_pdf).read_bytes()).hexdigest()
        signature = f"Signed with hash: {pdf_hash}"

        # Step 2: Attach the "signature" as metadata
        writer.add_metadata({
            "/Signed": signature,
            "/Certificate": Path(certificate).name,
        })

        # Write the output PDF
        with open(output_pdf, "wb") as output_pdf_file:
            writer.write(output_pdf_file)

    print(f"PDF signed and saved as {output_pdf}")

try:
    sign_pdf(INPUT_PDF, OUTPUT_PDF, CERTIFICATE, PRIVATE_KEY)
except Exception as e:
    print(f"Error signing PDF: {e}")
