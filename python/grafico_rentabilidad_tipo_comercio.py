import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent
DATA_DIR = BASE_DIR / "data"
IMG_DIR = BASE_DIR / "img" / "graficos"
IMG_DIR.mkdir(parents=True, exist_ok=True)

df = pd.read_csv(
    DATA_DIR / "a3.rentabilidad_promedio_tipo_comercio.csv",
    sep=";",
    header=None,
    names=["Tipo_Comercio", "Facturacion_Total", "Ganancia_Total", "Margen_Porcentual"],
    encoding="utf-8-sig",
)

df = df.sort_values("Margen_Porcentual", ascending=True)
df["Facturacion_M"] = df["Facturacion_Total"] / 1_000_000

fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 5))

colors = plt.cm.Blues(np.linspace(0.45, 0.85, len(df)))
bars = ax1.barh(df["Tipo_Comercio"], df["Margen_Porcentual"], color=colors, edgecolor="black", linewidth=0.6)

for bar, margen in zip(bars, df["Margen_Porcentual"]):
    ax1.text(
        bar.get_width() + 0.3,
        bar.get_y() + bar.get_height() / 2,
        f"{margen:.1f}%",
        va="center",
        ha="left",
        fontsize=9,
        fontweight="bold",
    )

ax1.set_xlabel("Margen (%)", fontsize=10, fontweight="bold")
ax1.set_title("Margen por Tipo de Comercio", fontsize=11, fontweight="bold")
ax1.grid(axis="x", linestyle="--", alpha=0.3)
ax1.set_xlim(58, df["Margen_Porcentual"].max() + 2)

y_pos = np.arange(len(df))
ax2.bar(y_pos, df["Facturacion_M"], color="#2E86AB", edgecolor="black", linewidth=0.6, alpha=0.9)
ax2.set_xticks(y_pos)
ax2.set_xticklabels(df["Tipo_Comercio"], rotation=25, ha="right", fontsize=9)
ax2.set_ylabel("Facturación (Millones ARS)", fontsize=10, fontweight="bold")
ax2.set_title("Facturación Total por Segmento", fontsize=11, fontweight="bold")
ax2.grid(axis="y", linestyle="--", alpha=0.3)

for i, val in enumerate(df["Facturacion_M"]):
    ax2.text(i, val + 200, f"{val:,.0f}M", ha="center", fontsize=8, fontweight="bold")

plt.suptitle("Rentabilidad y Facturación por Tipo de Comercio", fontsize=13, fontweight="bold", y=1.02)
plt.tight_layout()
plt.savefig(IMG_DIR / "04_rentabilidad_tipo_comercio.png", dpi=300, bbox_inches="tight")
plt.show()

print("Gráfico generado: 04_rentabilidad_tipo_comercio.png")
