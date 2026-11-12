
# NutriWash-AI — Ingredients Dataset

## Project Overview
This repository contains the ingredient dataset component of NutriWash-AI.

The dataset is extracted from Open Food Facts product records and linked with the product dataset prepared by Tasmiya.

## Objectives
- Extract raw ingredient information.
- Organize unique ingredient records.
- Preserve product barcodes and ingredient sequence.
- Collect available ingredient tags, allergens and additives.
- Prepare structured CSV and JSON files for future MySQL integration.

## Data Sources
- Open Food Facts API
- Tasmiya's Pakistani packaged food products dataset

## Project Structure

```text
NutriWash_Ingredients/
├── data/
│   ├── raw/
│   │   ├── Pakistani_Products.csv
│   │   └── api_responses/
│   ├── processed/
│   └── output/
├── scripts/
├── requirements.txt
└── README.md
```

## Generated Datasets
- ingredients_master.csv / JSON
- product_ingredients.csv / JSON
- product_allergens.csv / JSON
- product_additives.csv / JSON
- missing_ingredient_products.csv
- api_collection_report.csv

## Technologies
- Python
- Pandas
- Requests
- Open Food Facts API
- JSON
- CSV

## Data Processing
1. Read product records.
2. Fetch available product information from Open Food Facts.
3. Extract ingredient text.
4. Split ingredients into product-level records.
5. Generate a provisional ingredient master dataset.
6. Extract available allergen and additive tags.
7. Export structured CSV and JSON files.

## Data Quality
- Duplicate product barcodes are checked.
- Ingredient relationships preserve product barcodes.
- Missing information is not fabricated.
- API errors and unavailable records are tracked.
- Canonical names, aliases and descriptions require further verification.

## Installation

```bash
pip install -r requirements.txt
```

## Run

```bash
python scripts/inspect_data.py
python scripts/fetch_api_data.py
python scripts/extract_ingredients.py
python scripts/build_ingredient_master.py
python scripts/extract_allergens_additives.py
```

## Future Work
- Verify canonical ingredient names and alternative names.
- Add reliable ingredient descriptions and categories.
- Validate nested ingredients and additive references.
- Complete dataset validation.
- Integrate datasets into the NutriWash-AI MySQL database.

## Team
Zainab — Ingredients Dataset  
Tasmiya — Consumable Products Dataset
