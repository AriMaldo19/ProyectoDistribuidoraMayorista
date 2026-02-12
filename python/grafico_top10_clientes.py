import pandas as pd  # se importa pandas para trabajar con datos en tablas
import matplotlib.pyplot as plt  # se importa matplotlib para generar gráficos
import numpy as np  # se importa numpy para cálculos numéricos y posiciones en el eje

# 1. Leer CSV
df = pd.read_csv(
    "../data/top10_clientes_facturacion.csv",
    sep=";",  # se indica que el archivo está separado por punto y coma
    header=None,  # se aclara que el archivo no tiene encabezados
    names=["ID_Cliente", "Razon_Social", "Facturacion_Total", "Ganancia_Total", "Ranking"],  
    # se asignan manualmente los nombres de las columnas
    encoding="utf-8-sig"  # se define la codificación para evitar problemas con caracteres especiales
)  # se cargan los datos del top 10 clientes

# 2. Ordenar por ranking
df = df.sort_values("Ranking")  
# se ordenan los clientes según su posición en el ranking

# 3. Convertir a millones
df["Facturacion_M"] = df["Facturacion_Total"] / 1_000_000  
# se convierte la facturación a millones para facilitar la lectura

df["Ganancia_M"] = df["Ganancia_Total"] / 1_000_000  
# se convierte la ganancia a millones

# 4. Acortar nombres largos para mejor visualización
def acortar_nombre(nombre, max_len=25):
    # se define una función para limitar la longitud del nombre
    if len(nombre) > max_len:
        return nombre[:max_len-3] + "..."  # se recorta y se agregan puntos suspensivos
    return nombre  # se devuelve el nombre original si no supera el límite

df["Razon_Social_Short"] = df["Razon_Social"].apply(acortar_nombre)  
# se aplica la función para generar una versión corta del nombre

# 5. Crear gráfico de barras horizontales
plt.figure(figsize=(12, 7))  
# se define un tamaño amplio para que los nombres se lean correctamente

y_pos = np.arange(len(df))  
# se generan posiciones numéricas para ubicar las barras

height = 0.35  
# se define el grosor de cada barra

# Barras de facturación
bars_fact = plt.barh(y_pos + height/2, df["Facturacion_M"], height, 
                     label='Facturación', color='#1f77b4', 
                     edgecolor='black', linewidth=0.8, alpha=0.9)  
# se dibujan las barras de facturación

# Barras de ganancia
bars_gan = plt.barh(y_pos - height/2, df["Ganancia_M"], height, 
                    label='Ganancia', color='#ff7f0e', 
                    edgecolor='black', linewidth=0.8, alpha=0.9)  
# se dibujan las barras de ganancia

# 6. Agregar etiquetas de valor
for i, (fact, gan) in enumerate(zip(df["Facturacion_M"], df["Ganancia_M"])):
    # se agrega etiqueta para facturación
    plt.text(fact + max(df["Facturacion_M"]) * 0.01, i + height/2, 
             f'{fact:.0f}M', va='center', ha='left', 
             fontsize=9, fontweight='bold', color='#1f77b4')
    
    # se agrega etiqueta para ganancia
    plt.text(gan + max(df["Facturacion_M"]) * 0.01, i - height/2, 
             f'{gan:.0f}M', va='center', ha='left', 
             fontsize=9, fontweight='bold', color='#ff7f0e')
    
    # se agrega indicador visual del ranking
    plt.text(-max(df["Facturacion_M"]) * 0.08, i, 
             f'#{i+1}', va='center', ha='center', 
             fontsize=9, fontweight='bold', color='black',
             bbox=dict(boxstyle="circle", facecolor="white", edgecolor='gray', pad=0.3))

# 7. Configurar eje Y
plt.yticks(y_pos, df["Razon_Social_Short"], fontsize=10)  
# se asignan los nombres de clientes en el eje vertical

plt.xlabel("Millones de ARS", fontsize=12, fontweight='bold')  
# se define el eje X indicando moneda y unidad

plt.title("TOP 10 CLIENTES: Facturación vs Ganancia", 
          fontsize=14, fontweight='bold', pad=15)  
# se establece el título principal del gráfico

# 8. Agregar línea de promedio
prom_fact = df["Facturacion_M"].mean()  
# se calcula el promedio de facturación

prom_gan = df["Ganancia_M"].mean()  
# se calcula el promedio de ganancia

plt.axvline(x=prom_fact, color='#1f77b4', linestyle='--', alpha=0.5, linewidth=1)  
# se dibuja línea vertical para el promedio de facturación

plt.axvline(x=prom_gan, color='#ff7f0e', linestyle='--', alpha=0.5, linewidth=1)  
# se dibuja línea vertical para el promedio de ganancia

# 9. Leyenda y grid
plt.legend(loc='lower right', fontsize=10)  
# se muestra la leyenda en la parte inferior derecha

plt.grid(axis='x', linestyle='--', alpha=0.3)  
# se agrega grilla horizontal suave para facilitar la lectura

# 10. Ajustar límites
max_val = df["Facturacion_M"].max()  
# se obtiene el valor máximo para ajustar el eje

plt.xlim(-max_val * 0.15, max_val * 1.2)  
# se deja espacio a la izquierda para el ranking y a la derecha para etiquetas

plt.tight_layout()  
# se ajustan automáticamente los márgenes

plt.savefig("../img/top10_clientes_facturacion.png", dpi=300, bbox_inches='tight')  
# se guarda la imagen en alta resolución

plt.show()  
# se muestra el gráfico en pantalla

# 11. Mostrar tabla resumen
print("\n" + "="*80)
print("TOP 10 CLIENTES - RANKING DE FACTURACIÓN")
print("="*80)
print(f"{'Rank':<6} {'Cliente':<30} {'Facturación':>15} {'Ganancia':>15} {'Margen':>10}")
print("-"*80)

for i, row in df.iterrows():
    margen = (row["Ganancia_M"] / row["Facturacion_M"] * 100)  
    # se calcula el margen porcentual por cliente
    
    print(f"#{row['Ranking']:<5} {row['Razon_Social_Short'][:28]:<30} "
          f"{row['Facturacion_M']:>13.0f}M {row['Ganancia_M']:>13.0f}M {margen:>9.1f}%")

print("="*80)
print(f"{'PROMEDIO':<36} {prom_fact:>13.0f}M {prom_gan:>13.0f}M")
print("="*80)
