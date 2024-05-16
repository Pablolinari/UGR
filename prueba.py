
def samuelson(y_0,y_1,alpha, beta, g, n):
    if n == 0:
        return y_0
    elif n == 1:
        return y_1
    else:
        return alpha*(1+beta)*samuelson(y_0,y_1,alpha,beta,g,n-1) - alpha*beta*samuelson(y_0,y_1,alpha,beta,g,n-2) + g

result = samuelson(1.0,2.0,0.8,0.5,3,5)
print(result)


def solve_recurrence(y0, y1, alpha, beta, G, n):

    sequence = [y0, y1]
    for i in range(2, n):
        yn = alpha * (1 + beta) * sequence[i-1] - beta * alpha * sequence[i-2] + G
        sequence.append(yn)
    return sequence

# Ejemplo de uso
y0 = 1.0
y1 = 2.0
alpha = 0.8
beta = 0.5
G = 3.0
n_terms = 5

result = solve_recurrence(y0, y1, alpha, beta, G, n_terms)
print("Secuencia generada:")
print(result)
