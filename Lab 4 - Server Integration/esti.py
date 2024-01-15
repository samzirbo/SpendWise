from sympy import symbols, Eq, solve

# Definim variabila simbolică α
α = symbols('α')

# Definim variabilele și probabilitățile date
valori_X = [-5, 'a', 2, 3]
probabilitati_X = [0.3, 0.2, 0.1, 0.4]

# Definim dispersia dată
dispersia_data = 11.61

# Calculăm dispersia
dispersia = sum([p * (x - α)**2 for x, p in zip(valori_X, probabilitati_X)])

# Ecuția dispersiei
ecuatie = Eq(dispersia, dispersia_data)

# Rezolvăm ecuația pentru α
sol = solve(ecuatie, α)

# Afișăm rezultatul
print(f"Valoarea parametrului real negativ α este: {sol[0]:.2f}")
