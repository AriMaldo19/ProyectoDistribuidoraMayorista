import pandas as pd  # se importa pandas para trabajar con datos en formato tabla
import matplotlib.pyplot as plt  # se importa matplotlib para generar gráficos
import matplotlib.dates as mdates  # se importa soporte para manejo de fechas en gráficos

# 1. Leer CSV
df = pd.read_csv(
    "../data/evolucion_mensual_ventas_ganancias.csv",
    sep=";",  # se indica que el archivo está separado por punto y coma
    header=None,  # se aclara que el CSV no tiene encabezados
    names=["Anio", "Mes", "Facturacion_Total", "Ganancia_Total"],  # se asignan manualmente los nombres de columnas
    encoding="utf-8-sig"  # se define la codificación para evitar errores con caracteres especiales
)  # se cargan los datos de facturación y ganancia por mes

# 2. Crear columna de fecha
df["Fecha"] = pd.to_datetime(df["Anio"].astype(str) + "-" + df["Mes"].astype(str).str.zfill(2) + "-01")  
# se construye una fecha con formato YYYY-MM-01 para poder ordenar y graficar correctamente

df = df.sort_values("Fecha")  
# se ordenan los registros de forma cronológica

# 3. Convertir a millones
df["Facturacion_M"] = df["Facturacion_Total"] / 1_000_000  
# se convierte la facturación a millones para mejorar la lectura

df["Ganancia_M"] = df["Ganancia_Total"] / 1_000_000  
# se convierte la ganancia a millones

# 4. Diccionario de meses en español
meses_espanol = {
    1: 'Ene', 2: 'Feb', 3: 'Mar', 4: 'Abr', 5: 'May', 6: 'Jun',
    7: 'Jul', 8: 'Ago', 9: 'Sep', 10: 'Oct', 11: 'Nov', 12: 'Dic'
}  
# se definen abreviaturas en español para mostrar en el eje X

df["Etiqueta"] = df.apply(lambda row: f"{meses_espanol[row['Mes']]}\n{row['Anio']}", axis=1)  
# se genera una etiqueta combinando mes abreviado y año

# 5. Crear gráfico
plt.figure(figsize=(14, 6))  
# se define un tamaño amplio para que los meses se visualicen con claridad

plt.plot(df["Fecha"], df["Facturacion_M"], 
         marker='o', linewidth=2, markersize=4, color='#1f77b4', label='Facturación')  
# se grafica la línea de facturación

plt.plot(df["Fecha"], df["Ganancia_M"], 
         marker='s', linewidth=2, markersize=4, color='#ff7f0e', label='Ganancia')  
# se grafica la línea de ganancia

# 6. Etiquetas de valor para todos los puntos
for _, row in df.iterrows():
    # se agrega etiqueta superior para facturación
    if row["Facturacion_M"] < 1:
        plt.text(row["Fecha"], row["Facturacion_M"] + 15, 
                 f'{row["Facturacion_M"]:.1f}M', 
                 ha='center', va='bottom', fontsize=8, fontweight='bold',
                 color='#1f77b4', 
                 bbox=dict(boxstyle="round,pad=0.2", facecolor="white", alpha=0.9, edgecolor='#1f77b4'))  
        # se destaca con recuadro cuando el valor es muy bajo
    else:
        plt.text(row["Fecha"], row["Facturacion_M"] + 25, 
                 f'{row["Facturacion_M"]:.0f}M', 
                 ha='center', va='bottom', fontsize=8, fontweight='bold',
                 color='#1f77b4', alpha=0.9)  
        # se muestra etiqueta simple para valores normales
    
    # se agrega etiqueta inferior para ganancia
    if row["Ganancia_M"] < 1:
        plt.text(row["Fecha"], row["Ganancia_M"] - 25, 
                 f'{row["Ganancia_M"]:.1f}M', 
                 ha='center', va='top', fontsize=8, fontweight='bold',
                 color='#ff7f0e',
                 bbox=dict(boxstyle="round,pad=0.2", facecolor="white", alpha=0.9, edgecolor='#ff7f0e'))  
        # se destaca con recuadro cuando el valor es muy bajo
    else:
        plt.text(row["Fecha"], row["Ganancia_M"] - 35, 
                 f'{row["Ganancia_M"]:.0f}M', 
                 ha='center', va='top', fontsize=8, fontweight='bold',
                 color='#ff7f0e', alpha=0.9)  
        # se muestra etiqueta simple para valores normales

# 7. Anotación para enero 2025
ene_2025 = df[(df["Anio"] == 2025) & (df["Mes"] == 1)].iloc[0]  
# se identifica el registro correspondiente a enero 2025

plt.annotate('Caída atípica', 
             xy=(ene_2025["Fecha"], ene_2025["Facturacion_M"]),
             xytext=(ene_2025["Fecha"] + pd.Timedelta(days=30), 200),
             arrowprops=dict(arrowstyle='->', color='gray', lw=0.8, alpha=0.7),
             fontsize=9, color='gray', fontweight='normal',
             bbox=dict(boxstyle="round,pad=0.2", facecolor="white", alpha=0.7, edgecolor='gray'))  
# se señala visualmente el comportamiento atípico

# 8. Eje X con etiquetas cada dos meses
indices_mostrar = range(0, len(df), 2)  
# se selecciona un mes intermedio para evitar saturar el eje

df_filtrado = df.iloc[indices_mostrar]

plt.xticks(df_filtrado["Fecha"], df_filtrado["Etiqueta"], 
           rotation=0, ha='center', fontsize=9)  
# se aplican etiquetas limpias y centradas

# 9. Líneas divisorias por año
for año in df["Anio"].unique():
    fecha_inicio = pd.Timestamp(f"{año}-01-01")
    plt.axvline(x=fecha_inicio, color='gray', linestyle=':', alpha=0.2, linewidth=0.5)  
    # se dibuja una línea vertical suave para separar años
    
    plt.text(fecha_inicio, plt.ylim()[1] * 0.98, f'{año}', 
             ha='center', fontsize=10, fontweight='bold', color='gray', alpha=0.5)  
    # se muestra el año en la parte superior del gráfico

# 10. Configuración final
plt.ylabel("Millones de ARS", fontsize=11, fontweight='bold')  
# se define etiqueta del eje Y indicando moneda y unidad

plt.title("Evolución Mensual: Facturación vs Ganancia (2023-2025)", 
          fontsize=13, fontweight='bold', pad=15)  
# se establece título principal del gráfico

plt.legend(loc='upper left', fontsize=10)  
# se muestra la leyenda

plt.grid(True, alpha=0.15, linestyle='--', linewidth=0.5)  
# se agrega una grilla tenue para facilitar la lectura

max_val = max(df["Facturacion_M"].max(), df["Ganancia_M"].max())
plt.ylim(0, max_val * 1.12)  
# se ajusta el límite superior dejando espacio para etiquetas

plt.tight_layout()  
# se acomodan automáticamente los márgenes

plt.savefig("../img/evolucion_mensual_final.png", dpi=300, bbox_inches='tight')  
# se guarda la imagen en alta resolución

plt.show()  
# se muestra el gráfico en pantalla

# 11. Verificación rápida
print("Gráfico generado correctamente")
print(f"Enero 2025: Facturación {ene_2025['Facturacion_M']:.1f}M - Ganancia {ene_2025['Ganancia_M']:.1f}M")  
# se imprime un control simple para validar los valores del mes atípico
