"""Ejecuta todos los scripts de visualizacion en orden."""
import subprocess
import sys
from pathlib import Path

SCRIPTS = [
    "grafico_evolucion_mensual.py",
    "grafico_top10_clientes.py",
    "productos_vendidos_vs_rentables.py",
    "grafico_rentabilidad_tipo_comercio.py",
    "grafico_ticket_promedio_anual.py",
    "grafico_estacionalidad.py",
]

def main():
    base = Path(__file__).resolve().parent
    print("Generando graficos en img/graficos/\n")

    for script in SCRIPTS:
        print(f"-> {script}")
        result = subprocess.run([sys.executable, str(base / script)], cwd=base)
        if result.returncode != 0:
            print(f"Error al ejecutar {script}")
            sys.exit(result.returncode)

    print("\nListo. Abri la carpeta img/graficos/ para ver los PNG generados.")

if __name__ == "__main__":
    main()
