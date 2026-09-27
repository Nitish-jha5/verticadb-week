# Initial Load

The initial order load used Vertica `COPY` with rejected-record and exception files.

## Load result

- Source file: `/tmp/meridian/orders_2025.csv`
- Rows successfully loaded: 11
- Rows rejected: 1
- Rejected order: `10012`

The rejected row contained:

```text
10012,102,203,2025-12-18,not_a_number,129.00,0.00,COMPLETED,WEB,2025-12-18 09:00:00
