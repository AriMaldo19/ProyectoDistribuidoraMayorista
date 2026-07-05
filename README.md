# Proyecto SQL Server + Python  
## Análisis de una Distribuidora Mayorista de Alimentos (2023–2025)

![Evolución mensual](img/graficos/01_evolucion_mensual_ventas_ganancias.png)

Proyecto de análisis de datos orientado a una distribuidora mayorista simulada, utilizando **SQL Server** para modelado relacional y consultas analíticas, y **Python (Matplotlib)** para visualización de insights clave.

**Skills demostradas:** modelado relacional · consultas SQL analíticas (JOIN, CTE, window functions) · agregaciones y segmentación · optimización con índices · exportación de resultados · visualización con Python · documentación de hallazgos de negocio.

---

## Objetivo

Analizar el desempeño comercial de una distribuidora mayorista, evaluando ventas, rentabilidad, comportamiento de clientes y evolución temporal del negocio.

El proyecto se centra en la correcta formulación de preguntas de negocio, el uso eficiente de SQL para el análisis de datos y la representación visual de los principales hallazgos.

---

## Tecnologías utilizadas

- SQL Server
- Python (Pandas, Matplotlib, NumPy)
- Git & GitHub

---

## Estructura del repositorio

```
├── sql/
│   ├── 02_Carga_Masiva_Datos.sql
│   ├── 03_Consultas_Basicas.sql
│   ├── 04_Consultas_Avanzadas.sql
│   └── 05_Indices_y_Performance.sql
│
├── data/
│   ├── a1.*.csv … a6.*.csv    # Resultados consultas avanzadas
│   └── b1.*.csv … b7.*.csv    # Resultados consultas básicas
│
├── python/
│   ├── grafico_evolucion_mensual.py
│   ├── grafico_top10_clientes.py
│   ├── productos_vendidos_vs_rentables.py
│   ├── grafico_rentabilidad_tipo_comercio.py
│   ├── grafico_ticket_promedio_anual.py
│   ├── grafico_estacionalidad.py
│   └── requirements.txt
│
├── img/
│   ├── graficos/              # Gráficos generados con Matplotlib
│   ├── 2.cargadatos/          # Capturas de carga y validación
│   └── 4.índices/             # Planes de ejecución e IO (con/sin índice)
│
├── docs/
│   ├── Simulación y Análisis Distribuidora Mayorista.docx
│   └── CONCLUSIONES.md          # Resumen ejecutivo de hallazgos
│
└── README.md
```

---

## Análisis realizados

### Análisis básicos (`03_Consultas_Basicas.sql`)

| Consulta | Archivo CSV |
|----------|-------------|
| Unidades promedio por venta | `b1.unidades_totales_por_venta.csv` |
| Estado de ventas por año | `b2.estado_ventas_por_año.csv` |
| Método de pago más usado | `b3.metodo_pago_mas_usado_anual.csv` |
| Clientes según antigüedad | `b4.cantidad_clientes_segun_antiguedad.csv` |
| Ticket promedio por año | `b5.ticket_promedio_por_año.csv` |
| Ventas por estación | `b6.ventas_segun_estacion_año.csv` |
| Días con mayor volumen | `b7.dias_mes_mayor_volumen_ventas.csv` |

### Análisis avanzados (`04_Consultas_Avanzadas.sql`)

| Consulta | Archivo CSV |
|----------|-------------|
| Evolución mensual ventas y ganancias | `a1.evolucion_mensual_ventas_ganancias.csv` |
| Top 10 clientes por facturación | `a2.ranking_clientes_que_mas_facturan_ganancias_asociadas.csv` |
| Rentabilidad por tipo de comercio | `a3.rentabilidad_promedio_tipo_comercio.csv` |
| Productos más vendidos vs rentables | `a4.productos_mas_vendidos_vs_mas_rentables.csv` |
| Ventas mensuales por categoría | `a5.ventas_mensuales_por_categoria_producto.csv` |
| Segmentación por frecuencia de compra | `a6.clasificar_clientes_segun_frecuencia_compra.csv` |

### Optimización (`05_Indices_y_Performance.sql`)

Prueba comparativa de una consulta de evolución mensual **antes y después** de crear un índice en `Detalle_Ventas(ID_Venta)`. Capturas en `img/4.índices/`.

---

## Visualizaciones

Los gráficos se generan desde la carpeta `python/` y se guardan en `img/graficos/`:

| Script | Gráfico | Insight principal |
|--------|---------|-------------------|
| `grafico_evolucion_mensual.py` | `01_evolucion_mensual_ventas_ganancias.png` | Tendencia y estacionalidad 2023–2025 |
| `grafico_top10_clientes.py` | `02_top10_clientes_facturacion.png` | Concentración en supermercados |
| `productos_vendidos_vs_rentables.py` | `03_productos_vendidos_vs_rentables.png` | Volumen ≠ rentabilidad |
| `grafico_rentabilidad_tipo_comercio.py` | `04_rentabilidad_tipo_comercio.png` | Margen por segmento |
| `grafico_ticket_promedio_anual.py` | `05_ticket_promedio_anual.png` | Crecimiento del ticket |
| `grafico_estacionalidad.py` | `06_estacionalidad_ventas.png` | Picos en otoño (hemisferio sur) |

![Top 10 clientes](img/graficos/02_top10_clientes_facturacion.png)

### Cómo ejecutar y ver los gráficos (guía detallada)

Hay **dos formas** de ver los gráficos: abrir los PNG ya generados, o volver a crearlos con Python.

#### Opción A — Ver los gráficos directamente (sin ejecutar nada)

1. Abrí el Explorador de archivos de Windows.
2. Navegá a la carpeta del proyecto:
   ```
   C:\Users\USUARIO\Desktop\Proyectos\Proyecto- Distribuidora Mayorista\img\graficos
   ```
3. Hacé doble clic en cualquier PNG (se abre con Fotos o el visor predeterminado).

Archivos disponibles:

| Archivo | Qué muestra |
|---------|-------------|
| `01_evolucion_mensual_ventas_ganancias.png` | Facturación vs ganancia mes a mes |
| `02_top10_clientes_facturacion.png` | Ranking de clientes |
| `03_productos_vendidos_vs_rentables.png` | Volumen vs rentabilidad de productos |
| `04_rentabilidad_tipo_comercio.png` | Margen por tipo de comercio |
| `05_ticket_promedio_anual.png` | Ticket promedio 2023–2025 |
| `06_estacionalidad_ventas.png` | Ventas por estación del año |

#### Opción B — Regenerar los gráficos con Python

**Requisitos previos (solo la primera vez):**
- Python 3 instalado en Windows ([python.org](https://www.python.org/downloads/)). Al instalar, marcá **"Add Python to PATH"**.
- Terminal: PowerShell o la terminal integrada de Cursor/VS Code.

**Paso 1 — Abrí una terminal**  
En Cursor: menú **Terminal → New Terminal** (o `` Ctrl+` ``).

**Paso 2 — Entrá a la carpeta `python` del proyecto**

```powershell
cd "C:\Users\USUARIO\Desktop\Proyectos\Proyecto- Distribuidora Mayorista\python"
```

**Paso 3 — Instalá las dependencias (solo la primera vez)**

```powershell
pip install -r requirements.txt
```

Si `pip` no funciona, probá:

```powershell
py -3 -m pip install -r requirements.txt
```

**Paso 4 — Generá todos los gráficos de una vez**

```powershell
py -3 generar_todos_graficos.py
```

O uno por uno:

```powershell
py -3 grafico_evolucion_mensual.py
py -3 grafico_top10_clientes.py
py -3 productos_vendidos_vs_rentables.py
py -3 grafico_rentabilidad_tipo_comercio.py
py -3 grafico_ticket_promedio_anual.py
py -3 grafico_estacionalidad.py
```

**Paso 5 — Dónde quedan los archivos**  
Cada script guarda el PNG en `img/graficos/`. También puede abrirse una ventana con el gráfico (`plt.show()`) si tenés entorno gráfico disponible.

**Paso 6 — Ver el resultado**  
Volvé a `img/graficos/` en el Explorador o en Cursor (panel de archivos a la izquierda → `img` → `graficos` → clic en el PNG).

#### Solución de problemas frecuentes

| Problema | Solución |
|----------|----------|
| `'python' no se reconoce` | Usá `py -3` en lugar de `python` |
| `'pip' no se reconoce` | Usá `py -3 -m pip install -r requirements.txt` |
| Error al leer CSV | Ejecutá siempre desde la carpeta `python/` |
| No se abre ventana del gráfico | Normal en algunas terminales; el PNG igual se guarda en `img/graficos/` |

#### Desde Cursor / VS Code

También podés abrir cualquier `.py` en `python/`, clic derecho → **Run Python File in Terminal**, siempre que la terminal esté en la carpeta `python`.

---

## Conclusiones del análisis

### 1. Modelo de negocio mayorista validado

El volumen promedio por operación es de **75 unidades** (rango 2–359), coherente con un modelo B2B y no minorista. El ticket promedio creció de **$290 mil** (2023) a **$841 mil** (2025), lo que indica operaciones de mayor valor por transacción a lo largo del período.

### 2. Crecimiento sostenido con estacionalidad marcada

La facturación mensual muestra una tendencia alcista entre 2023 y 2025, con picos recurrentes en **marzo, abril y mayo** (otoño en el hemisferio sur). El otoño concentra el **56 %** de las ventas del período analizado, mientras que el verano es la estación más débil. Esto sugiere planificar stock, logística y campañas comerciales con anticipación hacia el tercer trimestre del año calendario.

### 3. Calidad operativa estable

Las ventas confirmadas representan entre **94,8 % y 95,4 %** del total anual, con una tasa de cancelación baja y estable. El negocio mantiene un proceso comercial sólido sin deterioro aparente en el período.

### 4. Clientes: alta recurrencia y concentración en supermercados

El **Top 10** de clientes está integrado exclusivamente por **supermercados**, con facturación muy homogénea (~$140 M ARS c/u). Casi la totalidad de la base activa se clasifica como **Recurrente** (frecuencia de compra ≥ 90 %), lo que indica una cartera fidelizada. El segmento **Supermercado** aporta la mayor facturación absoluta, aunque no el margen más alto.

### 5. Rentabilidad por segmento: márgenes estables, diferencias moderadas

Los márgenes oscilan entre **59,9 %** (Kiosco) y **63,9 %** (Restaurante). La dispersión es acotada (~4 puntos porcentuales), lo que indica una política de precios relativamente uniforme entre tipos de comercio. Restaurantes y rotiserías combinan buen margen con volumen relevante.

### 6. Productos: lo más vendido no siempre es lo más rentable

Los productos líderes en **unidades** (Filet de Merluza, Morcilla, Apio Congelado) no coinciden del todo con los de mayor **ganancia** (Camarones, Filet de Merluza, Corvina). Los mariscos y pescados premium concentran la rentabilidad, mientras que congelados y carnes mueven volumen. Esto abre oportunidades para promociones cruzadas y revisión de mix comercial.

### 7. Medios de pago: dominio de tarjeta de crédito

La **tarjeta de crédito** concentra más del **90 %** de las ventas confirmadas en facturación. Transferencia, débito y efectivo tienen participación marginal y similar entre sí. Cualquier negociación con procesadores de pago impacta directamente en la mayoría de los ingresos.

### 8. Optimización con índices

La creación de un índice no agrupado sobre `Detalle_Ventas(ID_Venta)` redujo las lecturas lógicas de **1.078 a 662** (−38 %) y el tiempo de ejecución de **360 ms a 302 ms** (−16 %). El plan pasó de *Clustered Index Scan* a *Index Scan*, demostrando el impacto de índices en consultas con JOIN y agregaciones sobre tablas de detalle.

### Recomendaciones

1. **Planificación estacional**: reforzar inventario y fuerza comercial en otoño (mar–may).
2. **Mix de productos**: priorizar mariscos y pescados premium en estrategia comercial; usar productos de alto volumen como ancla de relación con clientes.
3. **Retención B2B**: la base recurrente es un activo clave; conviene programas de fidelización para supermercados del Top 10.
4. **Performance**: mantener índices en columnas de JOIN frecuentes (`ID_Venta`, `ID_Cliente`, `Fecha_Venta`) en entornos con crecimiento de datos.

---

## Documentación

- **`docs/Simulación y Análisis Distribuidora Mayorista.docx`** — Informe completo (modelo relacional, consultas, índices).
- **`docs/CONCLUSIONES.md`** — Resumen ejecutivo de hallazgos con referencias a cada gráfico.
- **`docs/texto indice.txt`** — Notas sobre la prueba de optimización con índices.

---

## Equipo

- Maldonado, Ariana – [LinkedIn](https://www.linkedin.com/in/ariana-maldonado/)
- Ramirez, Maray – [LinkedIn](https://www.linkedin.com/in/maray-data-analytics/)
