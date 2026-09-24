import numpy as np
import pandas as pd

FICHERO_A = "mareas_series_temporales.csv"
FICHERO_B = "sp500rep.csv"

# Cómo igualar longitudes al comparar series de distinto tamaño:
#   "truncar"   -> se corta la serie larga a la longitud de la corta
#   "remuestrear" -> se interpola la serie larga a la longitud de la corta
AJUSTE_LONGITUD = "truncar"

# Si es True, cada serie se z-normaliza (media 0, desviación 1) antes de medir
Z_NORMALIZAR = True 


def cargar_series(path):
    """Cada fila del CSV es una serie temporal (separador ';', decimal ',').
    Si tras la serie hay columnas de metadatos (texto), se descartan a partir
    de la primera columna no numérica."""
    df = pd.read_csv(path, sep=";", decimal=",", header=None)
    numerico = df.apply(pd.to_numeric, errors="coerce")
    no_num = numerico.isna().any()
    fin = no_num.values.argmax() if no_num.any() else df.shape[1]
    return numerico.iloc[:, :fin].to_numpy(dtype=float)


def z_norm(s):
    return (s - s.mean()) / s.std()


def igualar_longitud(a, b):
    n = min(len(a), len(b))
    if AJUSTE_LONGITUD == "truncar":
        return a[:n], b[:n]
    x = np.linspace(0, 1, n)
    a = np.interp(x, np.linspace(0, 1, len(a)), a)
    b = np.interp(x, np.linspace(0, 1, len(b)), b)
    return a, b


def preparar(a, b):
    if Z_NORMALIZAR:
        a, b = z_norm(a), z_norm(b)
    if len(a) != len(b):
        a, b = igualar_longitud(a, b)
    return a, b


def euclidea(a, b):
    a, b = preparar(a, b)
    return np.sqrt(np.sum((a - b) ** 2))


def manhattan(a, b):
    a, b = preparar(a, b)
    return np.sum(np.abs(a - b))

def manhattan(a, b):
    if Z_NORMALIZAR:
        a, b = z_norm(a), z_norm(b)
    if len(a) != len(b):
        a, b = igualar_longitud(a, b)
    return np.sum(np.abs(a - b))


def distancias_por_pares(series, nombre):
    print(f"\n=== {nombre}: distancias por pares (1-2, 3-4, ...) ===")
    print(f"  {'Par':<20}{'Euclídea':>14}{'Manhattan':>14}")
    eucl, manh = [], []
    for i in range(0, len(series) - 1, 2):
        a, b = series[i], series[i + 1]
        eucl.append(euclidea(a, b))
        manh.append(manhattan(a, b))
        par = f"Serie {i + 1} vs Serie {i + 2}"
        print(f"  {par:<20}{eucl[-1]:>14.4f}{manh[-1]:>14.4f}")
    imprimir_media(eucl, manh)


def distancias_entre_ficheros(series_a, series_b, nombre_a, nombre_b):
    print(f"\n=== {nombre_a} vs {nombre_b}: serie i con serie i ===")
    print(f"  {'Serie':<20}{'Euclídea':>14}{'Manhattan':>14}")
    eucl, manh = [], []
    for i, (a, b) in enumerate(zip(series_a, series_b), start=1):
        eucl.append(euclidea(a, b))
        manh.append(manhattan(a, b))
        print(f"  {'Serie ' + str(i):<20}{eucl[-1]:>14.4f}{manh[-1]:>14.4f}")
    imprimir_media(eucl, manh)


def imprimir_media(eucl, manh):
    print(f"  {'-' * 48}")
    print(f"  {'Media':<20}{np.mean(eucl):>14.4f}{np.mean(manh):>14.4f}")


if __name__ == "__main__":
    A = cargar_series(FICHERO_A)
    B = cargar_series(FICHERO_B)
    print(f"{FICHERO_A}: {A.shape[0]} series de longitud {A.shape[1]}")
    print(f"{FICHERO_B}: {B.shape[0]} series de longitud {B.shape[1]}")

    distancias_por_pares(A, FICHERO_A)
    distancias_por_pares(B, FICHERO_B)

    if A.shape[1] != B.shape[1]:
        print(f"\n(Longitudes distintas: se aplica '{AJUSTE_LONGITUD}' "
              f"a {min(A.shape[1], B.shape[1])} puntos)")
    distancias_entre_ficheros(A, B, FICHERO_A, FICHERO_B)
