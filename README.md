# Rapido Data Analytics | End-to-End Data Engineering Project

## Overview
An end-to-end modern data engineering pipeline built to ingest, model, transform, and analyze **100,000+ Rapido trip records**. The pipeline extracts raw trip logs, applies dimensional modeling in Python to structure a Star Schema (1 Fact table and 7 Dimension tables), orchestrates ETL workflows via **Mage.ai**, loads curated datasets into **Google BigQuery**, and powers interactive KPI reporting in **Looker Studio**.

---

## System Architecture

```mermaid
flowchart LR
    A[("Raw Dataset\n(rapido_data.xlsx\n100K+ Records)")] --> B["Cloud Storage\n(GCS / GitHub Raw)"]
    B --> C["Google Compute Engine\n(Linux VM)"]
    subgraph Mage ["Mage.ai ETL Pipeline"]
        D["extract.py\n(Data Loader)"] --> E["transform.py\n(Star Schema Modeling)"]
        E --> F["load.py\n(BigQuery Exporter)"]
    end
    C --- Mage
    F --> G[("Google BigQuery\n(Star Schema:\n1 Fact + 7 Dims)")]
    G --> H["analytics_query.sql\n(Denormalized tbl_analytics)"]
    H --> I["Looker Studio\n(KPI Scorecards, Filters & Maps)"]
```

---

## Data Model (Star Schema)

```mermaid
erDiagram
    FACT_TABLE ||--|| DATETIME_DIM : "datetime_id"
    FACT_TABLE ||--|| PASSENGER_COUNT_DIM : "passenger_count_id"
    FACT_TABLE ||--|| TRIP_DISTANCE_DIM : "trip_distance_id"
    FACT_TABLE ||--|| RATE_CODE_DIM : "rate_code_id"
    FACT_TABLE ||--|| PICKUP_LOCATION_DIM : "pickup_location_id"
    FACT_TABLE ||--|| DROPOFF_LOCATION_DIM : "dropoff_location_id"
    FACT_TABLE ||--|| PAYMENT_TYPE_DIM : "payment_type_id"

    FACT_TABLE {
        int trip_id PK
        int VendorID
        int datetime_id FK
        int passenger_count_id FK
        int trip_distance_id FK
        int rate_code_id FK
        string store_and_fwd_flag
        int pickup_location_id FK
        int dropoff_location_id FK
        int payment_type_id FK
        float fare_amount
        float extra
        float mta_tax
        float tip_amount
        float tolls_amount
        float improvement_surcharge
        float total_amount
    }

    DATETIME_DIM {
        int datetime_id PK
        datetime tpep_pickup_datetime
        int pick_hour
        int pick_day
        int pick_month
        int pick_year
        int pick_weekday
        datetime tpep_dropoff_datetime
        int drop_hour
        int drop_day
        int drop_month
        int drop_year
        int drop_weekday
    }

    RATE_CODE_DIM {
        int rate_code_id PK
        int RatecodeID
        string rate_code_name
    }

    PAYMENT_TYPE_DIM {
        int payment_type_id PK
        int payment_type
        string payment_type_name
    }

    PICKUP_LOCATION_DIM {
        int pickup_location_id PK
        float pickup_latitude
        float pickup_longitude
    }

    DROPOFF_LOCATION_DIM {
        int dropoff_location_id PK
        float dropoff_latitude
        float dropoff_longitude
    }

    PASSENGER_COUNT_DIM {
        int passenger_count_id PK
        int passenger_count
    }

    TRIP_DISTANCE_DIM {
        int trip_distance_id PK
        float trip_distance
    }
```

---

## Tech Stack
- **Storage Layer:** Google Cloud Storage (GCS) / GitHub Raw Data Store
- **Compute & Orchestration:** Google Compute Engine (VM) & **Mage.ai**
- **Data Transformation:** Python (`Pandas`, `OpenPyXL`, `Requests`)
- **Data Warehouse:** **Google BigQuery** (Star Schema + Denormalized Analytics Layer)
- **Business Intelligence:** **Looker Studio**

## Repository Structure
```text
├── data/
│   └── rapido_data.xlsx           # Raw Rapido trip dataset (100,000 records)
├── mage-files/
│   ├── extract.py                 # Mage Data Loader block
│   ├── transform.py               # Mage Transformer block (Star Schema modeling)
│   └── load.py                    # Mage Data Exporter block (BigQuery)
├── Rapido_Data_Pipeline.ipynb     # Exploratory analysis & local Star Schema prototype
├── analytics_query.sql            # BigQuery SQL script creating tbl_analytics
├── commands.txt                   # VM environment & Mage.ai setup commands
└── README.md
```

## How to Run Locally
1. Install dependencies:
   ```bash
   pip install pandas openpyxl nbclassic
   ```
2. Launch Classic Jupyter Notebook (`jupyter nbclassic`) and run `Rapido_Data_Pipeline.ipynb` to validate the Star Schema transformation (`(100000, 17)` fact table).
