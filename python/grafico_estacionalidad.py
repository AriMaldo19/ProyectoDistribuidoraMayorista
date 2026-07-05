import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent
DATA_DIR = BASE_DIR / "data"
IMG_DIR = BASE_DIR / "img" / "graficos"
IMG_DIR.mkdir(parents=True, exist_ok=True)

df = pd.read_csv(
    DATA_DIR / "b6.ventas_segun_estacion_año.csv",
    sep=";",
    header=None,
    names=["Estacion", "Cantidad_Ventas", "Facturacion_Total"],
    encoding="utf-8-sig",
)

orden_estaciones = ["Verano", "Otoño", "Invierno", "Primavera"]
df["Estacion"] = pd.Categorical(df["Estacion"], categories=orden_estaciones, ordered=True)
df = df.sort_values("Estacion")
df["Facturacion_M"] = df["Facturacion_Total"] / 1_000_000_000

colores = {"Verano": "#FFD166", "Otoño": "#EF476F", "Invierno": "#118AB2", "Primavera": "#06D6A0"}
bar_colors = [colores[e] for e in df["Estacion"]]

fig, ax1 = plt.subplots(figsize=(10, 6))

x = np.arange(len(df))
width = 0.35

bars1 = ax1.bar(x - width / 2, df["Cantidad_Ventas"], width, label="Cantidad de ventas", color=bar_colors, edgecolor="black", linewidth=0.6, alpha=0.85)
ax1.set_ylabel("Cantidad de ventas", fontsize=11, fontweight="bold")
ax1.set_xticks(x)
ax1.set_xticklabels(df["Estacion"], fontsize=11)
ax1.grid(axis="y", linestyle="--", alpha=0.3)

ax2 = ax1.twinx()
bars2 = ax2.bar(
    x + width / 2,
    df["Facturacion_M"],
    width,
    label="Facturación (miles de M ARS)",
    color=bar_colors,
    edgecolor="black",
    linewidth=0.6,
    alpha=0.55,
)
ax2.set_ylabel("Facturación (miles de millones ARS)", fontsize=11, fontweight="bold")

for bar, val in zip(bars1, df["Cantidad_Ventas"]):
    ax1.text(bar.get_x() + bar.get_width() / 2, bar.get_height() + 200, f"{val:,}", ha="center", fontsize=9, fontweight="bold")

for bar, val in zip(bars2, df["Facturacion_M"]):
    ax2.text(bar.get_x() + bar.get_width() / 2, bar.get_height() + 0.15, f"{val:.1f}B", ha="center", fontsize=9, fontweight="bold")

ax1.set_title("Estacionalidad de Ventas (Hemisferio Sur)", fontsize=13, fontweight="bold", pad=15)

lines1, labels1 = ax1.get_legend_handles_labels()
lines2, labels2 = ax2.get_legend_handles_labels()
ax1.legend(lines1 + lines2, labels1 + labels2, loc="upper right", fontsize=9)

plt.tight_layout()
plt.savefig(IMG_DIR / "06_estacionalidad_ventas.png", dpi=300, bbox_inches="tight")
plt.show()

print("Gráfico generado: 06_estacionalidad_ventas.png")
