import pandas as pd
import matplotlib.pyplot as plt
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent
DATA_DIR = BASE_DIR / "data"
IMG_DIR = BASE_DIR / "img" / "graficos"
IMG_DIR.mkdir(parents=True, exist_ok=True)

df = pd.read_csv(
    DATA_DIR / "b5.ticket_promedio_por_anio.csv",
    sep=";",
    header=None,
    names=["Anio", "Ventas_Confirmadas", "Ticket_Promedio"],
    encoding="utf-8-sig",
)

df["Ticket_M"] = df["Ticket_Promedio"] / 1_000_000

fig, ax1 = plt.subplots(figsize=(10, 6))

bars = ax1.bar(
    df["Anio"].astype(str),
    df["Ticket_M"],
    color=["#1f77b4", "#ff7f0e", "#2ca02c"],
    edgecolor="black",
    linewidth=0.8,
    width=0.5,
    alpha=0.9,
)

for bar, ticket in zip(bars, df["Ticket_M"]):
    ax1.text(
        bar.get_x() + bar.get_width() / 2,
        bar.get_height() + 0.02,
        f"{ticket:.2f}M",
        ha="center",
        va="bottom",
        fontsize=11,
        fontweight="bold",
    )

ax1.set_ylabel("Ticket Promedio (Millones ARS)", fontsize=11, fontweight="bold")
ax1.set_xlabel("Anio", fontsize=11, fontweight="bold")
ax1.set_title("Evolucion del Ticket Promedio por Anio (Ventas Confirmadas)", fontsize=13, fontweight="bold", pad=15)
ax1.grid(axis="y", linestyle="--", alpha=0.3)
ax1.set_ylim(0, df["Ticket_M"].max() * 1.15)

ax2 = ax1.twinx()
ax2.plot(
    df["Anio"].astype(str),
    df["Ventas_Confirmadas"],
    color="#d62728",
    marker="o",
    linewidth=2,
    markersize=8,
    label="Ventas confirmadas",
)
ax2.set_ylabel("Cantidad de ventas confirmadas", fontsize=10, color="#d62728")
ax2.tick_params(axis="y", labelcolor="#d62728")
ax2.legend(loc="upper right")

crecimiento = (df["Ticket_M"].iloc[-1] / df["Ticket_M"].iloc[0] - 1) * 100
ax1.annotate(
    f"+{crecimiento:.0f}% vs 2023",
    xy=(2, df["Ticket_M"].iloc[-1]),
    xytext=(1.5, df["Ticket_M"].iloc[-1] * 0.85),
    arrowprops=dict(arrowstyle="->", color="gray", lw=0.8),
    fontsize=10,
    color="gray",
    bbox=dict(boxstyle="round,pad=0.3", facecolor="white", edgecolor="gray", alpha=0.8),
)

plt.tight_layout()
plt.savefig(IMG_DIR / "05_ticket_promedio_anual.png", dpi=300, bbox_inches="tight")
plt.show()

print("Grafico generado: 05_ticket_promedio_anual.png")
