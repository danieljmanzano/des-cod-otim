import timeit

# função para calcular a soma dos valores das pedras entre os índices i e j (inclusive)
def soma_total(i, j, somas_prefixas):
    if i > j:
        return 0
    if i == 0:
        return somas_prefixas[j]
    return somas_prefixas[j] - somas_prefixas[i-1]

# função recursiva para resolver o problema usando dp (versão "correta" do código força bruta (forca_bruta.py) com memoização)
def resolver_pd(pedras, i, j, somas_prefixas, memo):
    # caso base: não há mais pedras para escolher
    if i > j:
        return 0

    # verifica o memo para verificar se o estado está calculado. caso sim, poupa processamento
    if memo[i][j] != -1:
        return memo[i][j]

    # lógica principal igual do força bruta
    pontos_oponente_1 = resolver_pd(pedras, i + 1, j, somas_prefixas, memo)
    valor_opcao_1 = pedras[i] + (soma_total(i + 1, j, somas_prefixas) - pontos_oponente_1)
    pontos_oponente_2 = resolver_pd(pedras, i, j - 1, somas_prefixas, memo)
    valor_opcao_2 = pedras[j] + (soma_total(i, j - 1, somas_prefixas) - pontos_oponente_2)

    # o jogador atual escolhe a opção que maximiza sua pontuação
    resultado = max(valor_opcao_1, valor_opcao_2)

    # guarda o resultado do estado antes de retornar
    memo[i][j] = resultado
    
    return resultado

# função para fazer a entrada de cada caso teste
def entrada():
    pedras_no_caso = int(input()) 
    
    linha_pedras = input() # lê a linha inteira com as pedras. ex: "(3,6) (6,6) (6,0) (0,3)"
    pedras_formatadas = linha_pedras.split(' ') # separa a string pelos espaço, resultado: ['(3,6)', '(6,6)', '(6,0)', '(0,3)']

    pedras = []
    for p_str in pedras_formatadas:
        p_sem_parenteses = p_str.strip('()') # remove os parênteses da string. ex: '(3,6)' -> '3,6'
        lado_a, lado_b = p_sem_parenteses.split(',') # separa os dois números pela vírgula. ex: '3,6' -> ['3', '6']
        valor_pedra = int(lado_a) + int(lado_b) # converte os números para inteiro, soma e adiciona na lista final
        pedras.append(valor_pedra)

    return pedras

def main():
    casos_teste = int(input())
    
    for _ in range(casos_teste):
        pedras = entrada()
        n_pedras = len(pedras)
        
        # "somas_prefixas" é uma lista que armazena a soma dos valores das pedras até o índice i. ajuda a calcular a soma de um intervalo
        # ex.: pedras = [1, 2, 3, 4] -> somas_prefixas = [1, 3, 6, 10]
        somas_prefixas = [0] * n_pedras 
        if n_pedras > 0:
            somas_prefixas[0] = pedras[0]
            for k in range(1, n_pedras):
                somas_prefixas[k] = somas_prefixas[k-1] + pedras[k]

        memo = [[-1 for _ in range(n_pedras)] for _ in range(n_pedras)] # matriz de memoização NxN inicializada com -1

        start_time = timeit.default_timer()
        pontuacao_jogador_1 = resolver_pd(pedras, 0, n_pedras - 1, somas_prefixas, memo)
        end_time = timeit.default_timer()
        print(pontuacao_jogador_1) # "jogador 1" é o jogador que começa a partida
        print(f"Tempo de execução: {end_time - start_time} segundos")

if __name__ == "__main__":
    main()