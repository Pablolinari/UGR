import argparse
import sys
from datetime import datetime

import matplotlib.pyplot as plt
import numpy as np
from scipy.integrate import solve_ivp


# Expresiones por defecto si el usuario no escribe nada.
CURVATURA_POR_DEFECTO = "1.2 + 0.2*cos(0.7*s)"
TORSION_POR_DEFECTO = "0.6 + 0.3*sin(0.5*s)"


# Conjunto de funciones permitidas para evaluar expresiones de forma controlada.
ENTORNO_SEGURO = {
    "sin": np.sin,
    "cos": np.cos,
    "tan": np.tan,
    "exp": np.exp,
    "log": np.log,
    "sqrt": np.sqrt,
    "abs": np.abs,
    "sinh": np.sinh,
    "cosh": np.cosh,
    "tanh": np.tanh,
    "pi": np.pi,
    "np": np,
}


def leer_argumentos():
    """Define y lee los argumentos de linea de comandos."""
    parser = argparse.ArgumentParser(
        description="Reconstruye una curva 3D a partir de curvatura kappa(s) y torsion tau(s)."
    )
    parser.add_argument("--kappa", default=None, help="Expresion de kappa(s), ej: 1+0.2*cos(0.7*s)")
    parser.add_argument("--tau", default=None, help="Expresion de tau(s), ej: 0.6+0.3*sin(0.5*s)")
    parser.add_argument("--s0", type=float, default=0.0, help="Inicio del parametro s")
    parser.add_argument("--s1", type=float, default=20.0, help="Fin del parametro s")
    parser.add_argument("--samples", type=int, default=2000, help="Numero de muestras")
    parser.add_argument("--out", default=None, help="Nombre del PNG de salida")
    parser.add_argument("--show", action="store_true", help="Muestra la figura en pantalla")
    parser.epilog = (
        "Ejemplo: python curva_desde_curvatura_torsion.py "
        "--kappa \"2 + cos(s)\" --tau \"sin(s)\" --out curva.png"
    )

    # Si se ejecuta sin argumentos, mostramos ayuda y salimos.
    if len(sys.argv) == 1:
        parser.print_help()
        print("\nDebes indicar al menos --kappa y --tau para ejecutar el programa.")
        print(
            "Ejemplo rapido: python curva_desde_curvatura_torsion.py "
            "--kappa \"2 + cos(s)\" --tau \"sin(s)\" --out curva.png"
        )
        sys.exit(0)

    return parser.parse_args()


def crear_funcion_desde_expresion(expresion, nombre_funcion):
    """Convierte una expresion de texto en una funcion f(s)."""
    expresion_compilada = compile(expresion, "<expr>", "eval")

    def funcion(s):
        # Se crea el contexto local con la variable s y las funciones permitidas.
        contexto_local = {"s": s}
        contexto_local.update(ENTORNO_SEGURO)
        try:
            # Evaluamos sin builtins para limitar el alcance.
            return eval(expresion_compilada, {"__builtins__": {}}, contexto_local)
        except Exception as exc:
            raise ValueError(
                f"No se pudo evaluar {nombre_funcion}(s)='{expresion}': {exc}"
            ) from exc

    return funcion


def sistema_frenet(s, estado, funcion_kappa, funcion_tau):
    """Define el sistema de EDO de Frenet-Serret usado para reconstruir la curva."""
    # estado = [alpha(3), t(3), n(3), b(3)]
    tangente = estado[3:6]
    normal = estado[6:9]
    binormal = estado[9:12]

    valor_kappa = funcion_kappa(s)
    valor_tau = funcion_tau(s)

    # Ecuaciones:
    # alpha' = t
    # t' = kappa n
    # n' = -kappa t - tau b
    # b' = tau n
    derivada_alpha = tangente
    derivada_tangente = valor_kappa * normal
    derivada_normal = -valor_kappa * tangente - valor_tau * binormal
    derivada_binormal = valor_tau * normal

    return np.hstack([derivada_alpha, derivada_tangente, derivada_normal, derivada_binormal])


def integrar_curva(funcion_kappa, funcion_tau, s0, s1, muestras):
    """Integra el sistema y devuelve los puntos alpha(s) de la curva en R3."""
    valores_s = np.linspace(s0, s1, muestras)

    # Comprobamos la hipotesis del teorema: kappa(s) > 0.
    valores_kappa = np.asarray(funcion_kappa(valores_s), dtype=float)
    if np.any(valores_kappa <= 0):
        raise ValueError("kappa(s) debe ser estrictamente positiva en todo el intervalo.")

    # Condiciones iniciales canonicas.
    alpha_inicial = np.array([0.0, 0.0, 0.0])
    tangente_inicial = np.array([1.0, 0.0, 0.0])
    normal_inicial = np.array([0.0, 1.0, 0.0])
    binormal_inicial = np.array([0.0, 0.0, 1.0])
    estado_inicial = np.hstack([alpha_inicial, tangente_inicial, normal_inicial, binormal_inicial])

    solucion = solve_ivp(
        lambda s, y: sistema_frenet(s, y, funcion_kappa, funcion_tau),
        (s0, s1),
        estado_inicial,
        t_eval=valores_s,
        rtol=1e-8,
        atol=1e-10,
    )
    if not solucion.success:
        raise RuntimeError(f"Fallo la integracion: {solucion.message}")

    # Devolvemos solo alpha(s) = (x,y,z).
    return solucion.y[0:3, :]


def fijar_misma_escala_en_ejes(ax, x, y, z):
    """Ajusta limites para que los ejes x,y,z tengan la misma escala visual."""
    rango_maximo = np.array([x.max() - x.min(), y.max() - y.min(), z.max() - z.min()]).max()
    x_medio, y_medio, z_medio = x.mean(), y.mean(), z.mean()
    medio_rango = rango_maximo / 2

    ax.set_xlim(x_medio - medio_rango, x_medio + medio_rango)
    ax.set_ylim(y_medio - medio_rango, y_medio + medio_rango)
    ax.set_zlim(z_medio - medio_rango, z_medio + medio_rango)


def dibujar_y_guardar(curva_alpha, expresion_kappa, expresion_tau, ruta_salida, mostrar):
    """Dibuja la curva 3D y la guarda en PNG."""
    figura = plt.figure(figsize=(9, 7))
    eje = figura.add_subplot(111, projection="3d")

    x, y, z = curva_alpha[0], curva_alpha[1], curva_alpha[2]
    eje.plot(x, y, z, lw=2, color="#1f77b4", label="Curva alpha(s)")
    eje.scatter(x[0], y[0], z[0], s=35, color="#d62728", label="Punto inicial")

    eje.set_title(f"Curva desde kappa(s)={expresion_kappa} y tau(s)={expresion_tau}")
    eje.set_xlabel("x")
    eje.set_ylabel("y")
    eje.set_zlabel("z")
    eje.legend()

    fijar_misma_escala_en_ejes(eje, x, y, z)
    plt.tight_layout()

    figura.savefig(ruta_salida, dpi=180)
    print(f"PNG guardado en: {ruta_salida}")

    if mostrar:
        plt.show()
    else:
        plt.close(figura)


def obtener_expresiones(argumentos):
    """Obtiene kappa(s) y tau(s) desde argumentos o desde entrada interactiva."""
    if argumentos.kappa is None or argumentos.tau is None:
        raise ValueError(
            "Debes proporcionar ambas expresiones con --kappa y --tau. "
            "Ejemplo: --kappa \"2+cos(s)\" --tau \"sin(s)\""
        )

    return argumentos.kappa, argumentos.tau


def main():
    """Punto de entrada: valida parametros, reconstruye curva, dibuja y guarda PNG."""
    argumentos = leer_argumentos()

    # Validaciones basicas de entrada.
    if argumentos.s1 <= argumentos.s0:
        raise ValueError("Se requiere s1 > s0.")
    if argumentos.samples < 10:
        raise ValueError("Usa al menos 10 muestras.")

    # Leemos/creamos funciones de curvatura y torsion.
    expresion_kappa, expresion_tau = obtener_expresiones(argumentos)
    funcion_kappa = crear_funcion_desde_expresion(expresion_kappa, "kappa")
    funcion_tau = crear_funcion_desde_expresion(expresion_tau, "tau")

    # Reconstruimos la curva en R3.
    curva_alpha = integrar_curva(
        funcion_kappa,
        funcion_tau,
        argumentos.s0,
        argumentos.s1,
        argumentos.samples,
    )

    # Si no se especifica nombre, se usa uno con fecha/hora.
    ruta_salida = argumentos.out or f"curva_{datetime.now().strftime('%Y%m%d_%H%M%S')}.png"

    # Se dibuja y guarda la imagen.
    dibujar_y_guardar(
        curva_alpha,
        expresion_kappa,
        expresion_tau,
        ruta_salida,
        argumentos.show,
    )


if __name__ == "__main__":
    main()
