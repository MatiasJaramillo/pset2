# PSet 02 — Pipeline NYC TLC con Mage + dbt + PostgreSQL

## 1. Arquitectura (bronze / silver / gold) + diagrama textual

Este proyecto implementa un pipeline de datos completo usando **Mage** para la orquestación, **PostgreSQL** como data warehouse y **dbt** para las transformaciones y pruebas de calidad.

La arquitectura sigue el enfoque **medallion architecture**:

- **Bronze**: capa raw con los datos aterrizados desde el dataset oficial NYC TLC.
- **Silver**: capa curated con limpieza, tipificación, estandarización y enriquecimiento.
- **Gold**: capa marts con modelo estrella orientado a análisis.

### Bronze

La capa **bronze** aterriza los datos crudos del dataset oficial **NYC TLC Trip Record Data** (Yellow + Green) en PostgreSQL.

Tabla principal:

- `bronze.trips_raw`

Cada fila incluye los metadatos mínimos de ingesta:

- `ingest_ts`
- `source_month`
- `service_type`

También se carga el dataset auxiliar:

- `bronze.taxi_zone_lookup`

---

### Silver

La capa **silver** se construye con **dbt** y se materializa como **views**.

Responsabilidades:

- tipificación correcta de columnas (`timestamps`, `numerics`)
- reglas mínimas de calidad
- limpieza y estandarización
- enriquecimiento con Taxi Zone Lookup
- incorporación de `service_type`

Objetos principales:

- `silver.silver_trips_clean`
- `silver.silver_taxi_zone_lookup_clean`

---

### Gold

La capa **gold** se modela como un **esquema estrella** y se materializa como **tablas**.

Granularidad objetivo:

**1 fila = 1 viaje**

Tabla de hechos:

- `gold.fct_trips`

Dimensiones:

- `gold.dim_date`
- `gold.dim_zone`
- `gold.dim_service_type`
- `gold.dim_payment_type`
- `gold.dim_vendor`

---

### Diagrama textual del flujo

NYC TLC Trip Record Data  
→ Mage `ingest_bronze`  
→ PostgreSQL `bronze.*`  
→ Mage `dbt_build_silver`  
→ dbt `silver.*`  
→ Mage `dbt_build_gold`  
→ PostgreSQL `gold.*`  
→ Mage `quality_checks`  
→ `data_analysis.ipynb`

---

# 2. Tabla de cobertura por mes y servicio

La ingesta se implementó de forma **mensual e idempotente**.

| year_month | service_type | status | row_count |
|---|---|---|---|
| 2022-01 | yellow | loaded | ... |
| 2022-01 | green | loaded | ... |
| 2022-02 | yellow | loaded | ... |
| 2022-02 | green | loaded | ... |
| ... | ... | ... | ... |
| 2025-12 | yellow | loaded | ... |
| 2025-12 | green | loaded | ... |

Consulta utilizada:

```sql
SELECT
    source_month AS year_month,
    service_type,
    'loaded' AS status,
    COUNT(*) AS row_count
FROM bronze.trips_raw
GROUP BY 1,2
ORDER BY 1,2;
```

---

# 3. Cómo levantar el stack

### Requisitos

- Docker
- Docker Compose

### Comando

```bash
docker compose up
```

### Servicios

Se levantan:

- contenedor PostgreSQL
- contenedor Mage

### Accesos

Mage  
```
http://localhost:6789
```

PostgreSQL  
configurado mediante `.env`

---

# 4. Nombres de pipelines de Mage

## ingest_bronze

Pipeline de ingesta mensual hacia la capa Bronze.

Responsabilidades:

- descargar dataset NYC TLC
- cargar Yellow y Green trips
- cargar taxi zone lookup
- insertar en `bronze.trips_raw`
- añadir metadatos de ingesta
- soportar reejecuciones sin duplicados

---

## dbt_build_silver

Pipeline que construye la capa Silver.

Responsabilidades:

- limpiar datos
- tipificar timestamps
- validar reglas mínimas
- enriquecer con Taxi Zone Lookup
- crear views Silver

---

## dbt_build_gold

Pipeline que construye la capa Gold.

Responsabilidades:

- ejecutar scripts SQL de particionamiento
- crear tablas particionadas
- cargar dimensiones
- cargar tabla de hechos

---

## quality_checks

Pipeline de validación de calidad.

Responsabilidades:

- ejecutar `dbt test`
- validar unicidad
- validar relaciones
- validar valores aceptados

---

# 5. Triggers

## ingest_monthly

Tipo:

Schedule

Ejecuta:

```
ingest_bronze
```

Frecuencia:

Hora especifica

---

## dbt_after_ingest

Encadena pipelines después de Bronze.

Orden:

1. dbt_build_silver  
2. dbt_build_gold  
3. quality_checks  

---

# 6. Gestión de secretos

Los secretos se administran en **Mage Secrets**.

Lista de secretos:

- `POSTGRES_HOST`
- `POSTGRES_PORT`
- `POSTGRES_USER`
- `POSTGRES_PASSWORD`
- `POSTGRES_DB`

Política:

- `.env.example` está versionado
- `.env` está ignorado
- no se suben credenciales reales

---

# 7. Particionamiento

El particionamiento se implementó usando **PostgreSQL declarative partitioning**.

---

## 7.1 Fact table — RANGE

Tabla:

```
gold.fct_trips
```

Particionada por:

```
pickup_date
```

Consulta:

```sql
\d+ gold.fct_trips
```

Evidencia esperada:

- Partition key: RANGE (pickup_date)
- particiones mensuales

---

## 7.2 Dimensión — HASH

Tabla:

```
gold.dim_zone
```

Consulta:

```sql
\d+ gold.dim_zone
```

Evidencia:

```
Partition key: HASH (zone_key)
```

---

## 7.3 Dimensiones — LIST

Tabla:

```
gold.dim_service_type
```

Consulta:

```sql
\d+ gold.dim_service_type
```

Tabla:

```
gold.dim_payment_type
```

Consulta:

```sql
\d+ gold.dim_payment_type
```

Evidencia esperada:

```
Partition key: LIST (...)
```

---

# 7.4 Partition pruning

## Consulta 1

```sql
EXPLAIN (ANALYZE, BUFFERS)
SELECT COUNT(*)
FROM gold.fct_trips
WHERE pickup_date >= DATE '2024-01-01'
AND pickup_date < DATE '2024-02-01';
```

Explicación:

PostgreSQL accede únicamente a la partición correspondiente a enero 2024, demostrando **partition pruning**.

---

## Consulta 2

```sql
EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM gold.dim_zone
WHERE zone_key = 161;
```

Explicación:

PostgreSQL accede solo a la partición hash relevante.

---

# 8. dbt

## Materializations

Silver

```
view
```

Gold

```
table
```

---

## dbt run Silver

Comando equivalente:

```
dbt run --select silver
```

---

## dbt build Gold

Ejecutado dentro del pipeline:

```
dbt_build_gold
```

---

## quality checks

Comando:

```
dbt test --select gold
```

---

# 9. Troubleshooting

## Problema 1 — Error conexión dbt

Síntoma:

dbt no podía conectarse a PostgreSQL.

Solución:

verificar secretos Mage y configuración del perfil.

---

## Problema 2 — Crash de ingesta Bronze

Síntoma:

archivos grandes causaban problemas de memoria.

Solución:

descarga streaming + inserciones en batch.

---

## Problema 3 — Gold vacío

Síntoma:

`gold.fct_trips` tenía 0 filas.

Solución:

corregir orden del pipeline de particiones y carga.

---

## Problema 4 — Tests fallando

Síntoma:

errores en relaciones de dimensiones.

Solución:

reconstruir dimensiones y recargar fact table.

---

# Checklist final

- [x] Docker Compose levanta PostgreSQL + Mage
- [x] Credenciales manejadas por Mage Secrets
- [x] Pipeline ingest_bronze mensual e idempotente
- [x] dbt corre dentro de Mage
- [x] Silver materialized = views
- [x] Gold materialized = tables
- [x] Star schema completo
- [x] Particionamiento RANGE / HASH / LIST
- [x] Evidencia de partition pruning
- [x] dbt test pasa
- [x] Notebook responde 20 preguntas con gold.*
- [x] Triggers configurados