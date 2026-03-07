version: 2

models:
  - name: dim_date
    description: "Date dimension for taxi trips"
    columns:
      - name: date_key
        tests:
          - not_null
          - unique

  - name: dim_zone
    description: "Zone dimension"
    columns:
      - name: zone_key
        tests:
          - not_null
          - unique

  - name: dim_service_type
    description: "Service type dimension"
    columns:
      - name: service_type
        tests:
          - not_null
          - unique

  - name: dim_payment_type
    description: "Payment type dimension"
    columns:
      - name: payment_type
        tests:
          - not_null
          - unique

  - name: dim_vendor
    description: "Vendor dimension"
    columns:
      - name: vendor_key
        tests:
          - not_null
          - unique

  - name: fct_trips
    description: "Trip fact table, 1 row = 1 trip"
    columns:
      - name: trip_key
        tests:
          - not_null
          - unique
      - name: pu_zone_key
        tests:
          - relationships:
              to: ref('dim_zone')
              field: zone_key
      - name: do_zone_key
        tests:
          - relationships:
              to: ref('dim_zone')
              field: zone_key
      - name: pickup_date_key
        tests:
          - relationships:
              to: ref('dim_date')
              field: date_key
      - name: service_type_key
        tests:
          - relationships:
              to: ref('dim_service_type')
              field: service_type
      - name: payment_type_key
        tests:
          - relationships:
              to: ref('dim_payment_type')
              field: payment_type