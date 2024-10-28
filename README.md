# CommonCLI.sh
![CleanShot 2024-10-28 at 14 15 30](https://github.com/user-attachments/assets/5b5d3277-fc0d-4a81-a420-9c0ba568afd8)
## Overview
`CommonCLI.sh` is a Bash script that utilizes the Common Crawl Index API to search for historical records of a specified domain (e.g., `nasa.gov`) across multiple Common Crawl indexes. It outputs each matching URL record, including key information like the URL, timestamp, and HTTP status. The script offers options for color-coded, readable formatting and can save results to a file.

---

## Main Features and Options

1. **Domain Search Option** (`--domain <domain>`):
   - This required argument specifies the target domain (e.g., `nasa.gov`) to search within the Common Crawl index.
   - The script uses the domain to query multiple Common Crawl indexes and retrieve URL records containing references to the domain.

2. **Optional Save Option** (`--save <filename>`):
   - This optional argument allows users to save the output in a specified JSON file.
   - When provided, the script stores valid URL records in the file for later analysis.

3. **Colorized and Readable Output**:
   - Results are displayed in a color-coded and structured format for improved readability.
   - Each URL entry includes the `URL`, `Timestamp`, and `Status` fields, with separators to distinguish each entry.

---

## Step-by-Step

1. **Initialize Variables and Colors**:
   - Sets up colors (e.g., green, blue, red) for readability and defines variables to handle inputs.

2. **Parse Command-Line Options**:
   - Processes the `--domain` (required) and `--save` (optional) arguments. If `--domain` is missing, it displays usage instructions and exits.

3. **Loop Through Common Crawl Indexes**:
   - Uses a predefined list of Common Crawl index snapshots to check each index for records of the specified domain.
   - For each index, the script:
     - Constructs a URL for the API query.
     - Retrieves the API response, reading line-by-line to handle cases where each JSON object is a separate line.

4. **Process and Display Results**:
   - For each JSON line, the script checks for required fields (`url`, `timestamp`, `status`). If valid, it extracts and displays each field with colorized labels.
   - Each displayed URL entry includes:
     - **URL**: The specific URL found in the Common Crawl index.
     - **Timestamp**: The date the record was captured.
     - **Status**: The HTTP status code (e.g., `200`, `301`, `404`).

5. **Save Results to JSON File (Optional)**:
   - If the `--save` option is used, valid entries are appended to an array and written to the specified JSON file.

6. **Final Output**:
   - Prints a message confirming the completion of each index search and, if applicable, the location of the saved file.

---

## Ideal Use Cases
This script is beneficial for researchers, web analysts, and bug bounty hunters who need an efficient way to retrieve archived web data from Common Crawl for a specific domain. The colorized formatting and organized output enhance readability, making it easy to analyze historical web records.

---

## Example Usage
To run the script for a domain and display results in the terminal:

```bash
./CommonCLI.sh --domain nasa.gov
```

---

## To save results in a JSON file
```bash
./CommonCLI.sh --domain nasa.gov --save results.json
```
