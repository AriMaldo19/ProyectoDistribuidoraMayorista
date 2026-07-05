import pandas as pd  # se importa pandas para manipular los datos en formato tabla
import matplotlib.pyplot as plt  # se importa matplotlib para generar los gráficos
import numpy as np  # se importa numpy para trabajar con posiciones numéricas
from pathlib import Path  # se importa pathlib para resolver rutas de forma portable

BASE_DIR = Path(__file__).resolve().parent.parent
DATA_DIR = BASE_DIR / "data"
IMG_DIR = BASE_DIR / "img" / "graficos"
IMG_DIR.mkdir(parents=True, exist_ok=True)

# 1. Leer CSV
df = pd.read_csv(
    DATA_DIR / "a4.productos_mas_vendidos_vs_mas_rentables.csv",
    sep=";",  # se indica que el separador del archivo es punto y coma
    header=None,  # se aclara que el archivo no trae encabezados
    names=["ID_Producto", "Nombre_Producto", "Unidades_Vendidas", "Ganancia_Total"],  
    # se asignan manualmente los nombres de columnas
    encoding="utf-8-sig"  # se define la codificación para evitar errores con acentos
)  # se cargan los datos de productos

# 2. Convertir ganancia a millones
df["Ganancia_M"] = df["Ganancia_Total"] / 1_000_000  
# se convierte la ganancia total a millones para facilitar la lectura en el gráfico

# 3. Crear dos rankings
top5_vendidos = df.nlargest(5, "Unidades_Vendidas").copy()  
# se seleccionan los 5 productos con mayor cantidad vendida

top5_rentables = df.nlargest(5, "Ganancia_M").copy()  
# se seleccionan los 5 productos con mayor ganancia

# 4. Acortar nombres (MÁS CORTO PARA EVITAR SUPERPOSICIÓN)
def acortar_nombre(nombre, max_len=18):
    # se define una función para limitar la longitud del nombre
    if len(nombre) > max_len:
        return nombre[:max_len-3] + "..."  # se recorta el texto y se agregan puntos suspensivos
    return nombre  # se devuelve el nombre original si no supera el límite

top5_vendidos["Nombre_Corto"] = top5_vendidos["Nombre_Producto"].apply(acortar_nombre)  
# se genera una versión corta del nombre para el ranking de vendidos

top5_rentables["Nombre_Corto"] = top5_rentables["Nombre_Producto"].apply(acortar_nombre)  
# se genera una versión corta del nombre para el ranking de rentables

# 5. Ordenar ascendente
top5_vendidos = top5_vendidos.sort_values("Unidades_Vendidas", ascending=True)  
# se ordenan los más vendidos de menor a mayor para gráfico horizontal

top5_rentables = top5_rentables.sort_values("Ganancia_M", ascending=True)  
# se ordenan los más rentables de menor a mayor

# 6. Crear figura
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 5))  
# se crea una figura con dos gráficos lado a lado

# ============================================================================
# GRÁFICO 1: TOP 5 MÁS VENDIDOS
# ============================================================================
y1 = np.arange(len(top5_vendidos))  
# se generan posiciones numéricas para el eje Y

bars1 = ax1.barh(y1, top5_vendidos["Unidades_Vendidas"], 
                 color='#2E86AB', edgecolor='black', linewidth=0.8, height=0.6, alpha=0.9)  
# se dibujan las barras horizontales de unidades vendidas

# Etiquetas de valor - DESPLAZADAS MÁS A LA DERECHA
max_unidades = top5_vendidos["Unidades_Vendidas"].max()  
# se obtiene el valor máximo para ajustar posiciones de texto

for i, (bar, unidades) in enumerate(zip(bars1, top5_vendidos["Unidades_Vendidas"])):
    ax1.text(bar.get_width() + max_unidades * 0.03, 
             bar.get_y() + bar.get_height()/2,
             f'{unidades:,.0f}', ha='left', va='center', 
             fontsize=9, fontweight='bold', color='#2E86AB')  
    # se agrega etiqueta numérica a la derecha de cada barra
    
    ax1.text(-max_unidades * 0.12, i,
             f'#{i+1}', ha='center', va='center',
             fontsize=8, fontweight='bold',
             bbox=dict(boxstyle="circle", facecolor="white", edgecolor='gray', pad=0.2))  
    # se agrega indicador visual del ranking a la izquierda

ax1.set_yticks(y1)  
# se definen las posiciones del eje Y

ax1.set_yticklabels(top5_vendidos["Nombre_Corto"], fontsize=9)  
# se asignan los nombres abreviados como etiquetas

ax1.set_xlabel("Unidades Vendidas", fontsize=10, fontweight='bold')  
# se define el título del eje X

ax1.set_title("TOP 5: MAS VENDIDOS", fontsize=11, fontweight='bold', pad=5)  
# se establece el título del primer gráfico

ax1.grid(axis='x', linestyle='--', alpha=0.3)  
# se agrega una grilla suave horizontal

ax1.set_xlim(-max_unidades * 0.15, max_unidades * 1.25)  
# se amplían los límites para dar espacio a ranking y etiquetas

# ============================================================================
# GRÁFICO 2: TOP 5 MÁS RENTABLES
# ============================================================================
y2 = np.arange(len(top5_rentables))  
# se generan posiciones numéricas para el segundo gráfico

bars2 = ax2.barh(y2, top5_rentables["Ganancia_M"], 
                 color='#A23B72', edgecolor='black', linewidth=0.8, height=0.6, alpha=0.9)  
# se dibujan las barras horizontales de ganancia

# Etiquetas de valor - DESPLAZADAS MÁS A LA DERECHA
max_ganancia = top5_rentables["Ganancia_M"].max()  
# se obtiene la ganancia máxima para ajustar textos

for i, (bar, ganancia) in enumerate(zip(bars2, top5_rentables["Ganancia_M"])):
    ax2.text(bar.get_width() + max_ganancia * 0.03, 
             bar.get_y() + bar.get_height()/2,
             f'{ganancia:.1f}M', ha='left', va='center', 
             fontsize=9, fontweight='bold', color='#A23B72')  
    # se agrega etiqueta de valor en millones
    
    ax2.text(-max_ganancia * 0.12, i,
             f'#{i+1}', ha='center', va='center',
             fontsize=8, fontweight='bold',
             bbox=dict(boxstyle="circle", facecolor="white", edgecolor='gray', pad=0.2))  
    # se agrega indicador visual del ranking

ax2.set_yticks(y2)  
# se definen posiciones del eje Y

ax2.set_yticklabels(top5_rentables["Nombre_Corto"], fontsize=9)  
# se asignan los nombres abreviados

ax2.set_xlabel("Ganancia (Millones ARS)", fontsize=10, fontweight='bold')  
# se define el eje X indicando moneda y unidad

ax2.set_title("TOP 5: MAS RENTABLES", fontsize=11, fontweight='bold', pad=5)  
# se establece el título del segundo gráfico

ax2.grid(axis='x', linestyle='--', alpha=0.3)  
# se agrega grilla suave

ax2.set_xlim(-max_ganancia * 0.15, max_ganancia * 1.25)  
# se ajustan límites para que no se superpongan elementos

plt.tight_layout()  
# se ajustan automáticamente los márgenes

plt.savefig(IMG_DIR / "03_productos_vendidos_vs_rentables.png", dpi=300, bbox_inches='tight')  
# se guarda la imagen en alta calidad

plt.show()  
# se muestra el gráfico en pantalla
