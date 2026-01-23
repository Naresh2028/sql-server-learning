# INDEX VS CLUSTERED INDEX VS NON CLUSTERED INDEX


# ⚔️ Comparison: SQL Index Concepts

| Feature | Index (General Concept) | Clustered Index | Non-Clustered Index |
| :--- | :--- | :--- | :--- |
| **Definition** | An on-disk structure associated with a table to speed up row retrieval. | Sorts and stores the **actual data rows** of the table based on the key. | A **separate structure** containing specific key columns and pointers to the data rows. |
| **Analogy** | **Library Catalog** (Finds location without searching every shelf). | **Phone Book** (The book itself is organized alphabetically; you can't have two physical sorts). | **Textbook Index** (A list of keywords at the back pointing to specific page numbers). |
| **Quantity** | N/A (This is the category). | **Max 1** per table (Data can only be physically sorted one way). | **Many** per table (Up to 999; you can have many logical sort orders). |
| **Storage** | Consumes disk space (stored as B-Tree). | It **IS** the table data. Leaf nodes contain the actual data pages. | It is a **Copy**. Leaf nodes contain the Index Key + a Pointer (RID or Clustered Key). |
| **Retrieval Speed** | Generally faster than a Table Scan. | **Fastest.** Once you find the key, you have the full row instantly. | **Fast.** But often requires a second step ("Key Lookup") to fetch missing columns. |
| **Write Impact** | Slows down `INSERT`/`UPDATE` (Maintenance cost). | **High Cost** if the Key changes (Row must be physically moved to a new page). | **Moderate Cost.** Updates require modifying the index structure, but not moving the data row. |
| **Best Use Case** | Columns frequently used in `WHERE`, `JOIN`, `ORDER BY`. | **Primary Keys**, Range Queries (Dates), Sorted output. | **Foreign Keys**, High-traffic Search Fields (Email, Phone), Covering Queries. |
