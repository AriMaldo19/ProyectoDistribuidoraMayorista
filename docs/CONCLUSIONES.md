# Conclusiones del Análisis — Distribuidora Mayorista (2023–2025)

Documento complementario al informe principal. Los gráficos asociados están en `img/graficos/`.

---

## 1. Modelo de negocio mayorista validado

- Promedio de **75 unidades por venta** (mínimo 2, máximo 359).
- Ticket promedio: **$290.473** (2023) → **$840.813** (2025).
- **Gráfico:** `05_ticket_promedio_anual.png`

## 2. Crecimiento con estacionalidad marcada

- Picos en **marzo, abril y mayo** (otoño, hemisferio sur).
- Otoño: **19.742 ventas** y **$11.484 M** en facturación (~56 % del total).
- Verano: estación más débil (**3.633 ventas**).
- **Gráficos:** `01_evolucion_mensual_ventas_ganancias.png`, `06_estacionalidad_ventas.png`

## 3. Calidad operativa estable

- Ventas confirmadas: **94,8 % – 95,4 %** anual.
- Cancelaciones bajas y estables (~768 en 2023, ~876 en 2024, ~469 en 2025 parcial).

## 4. Clientes recurrentes y concentrados en supermercados

- Top 10: todos **supermercados**, ~**$140 M** de facturación cada uno.
- Margen del Top 10: **62,4 % – 63,5 %**.
- Base activa clasificada casi en su totalidad como **Recurrente** (≥ 90 % frecuencia).
- **Gráfico:** `02_top10_clientes_facturacion.png`

## 5. Rentabilidad por tipo de comercio

| Tipo        | Margen  | Facturación total |
|-------------|---------|-------------------|
| Restaurante | 63,9 %  | $2.969 M          |
| Rotisería   | 63,7 %  | $2.711 M          |
| Supermercado| 62,8 %  | $11.368 M         |
| Almacén     | 61,2 %  | $2.297 M          |
| Kiosco      | 59,9 %  | $460 M            |

- **Gráfico:** `04_rentabilidad_tipo_comercio.png`

## 6. Productos: volumen ≠ rentabilidad

**Más vendidos (unidades):** Filet de Merluza, Morcilla, Apio Congelado.  
**Más rentables (ganancia):** Camarones, Filet de Merluza, Corvina.

- **Gráfico:** `03_productos_vendidos_vs_rentables.png`

## 7. Medios de pago

- **Tarjeta de crédito:** > 90 % de la facturación en todos los años.
- Transferencia, débito y efectivo: participación marginal y similar.

## 8. Optimización con índices

Índice en `Detalle_Ventas(ID_Venta)`:

| Métrica           | Sin índice | Con índice | Mejora   |
|-------------------|------------|------------|----------|
| Lecturas lógicas  | 1.078      | 662        | −38 %    |
| Tiempo ejecución  | 360 ms     | 302 ms     | −16 %    |
| Plan              | Clustered Index Scan | Index Scan | — |

- **Capturas:** `img/4.índices/`

---

## Recomendaciones

1. Planificar stock y campañas comerciales para **otoño (mar–may)**.
2. Potenciar **mariscos y pescados premium** en la estrategia comercial.
3. Programas de fidelización para el **Top 10 de supermercados**.
4. Mantener índices en columnas de JOIN frecuente en producción.
