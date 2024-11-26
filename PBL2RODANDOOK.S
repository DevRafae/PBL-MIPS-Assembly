.data
# Declarando a área de dados para armazenar os preços
precos: .space 40        # Array para armazenar 10 preços (4 bytes por preço)
msg_inserir: .asciiz "Insira o preco do produto: "
msg_final: .asciiz "Precos ordenados: "

.text
.globl main

main:
    # Função principal: Chama as outras funções
    jal InserePrecos       # Chama a função InserePrecos
    jal AplicaDesconto     # Chama a função AplicaDesconto
    jal OrdenaProdutos     # Chama a função OrdenaProdutos
    jal ImprimePrecos      # Chama a função ImprimePrecos
    li $v0, 10             # Finaliza o programa
    syscall

# Função InserePrecos: Lê 10 preços via entrada do teclado
InserePrecos:
    li $t0, 0              # Índice inicial (contador)
loop_inserir:
    li $v0, 4              # Print string syscall
    la $a0, msg_inserir    # Carrega a mensagem de inserir
    syscall

    li $v0, 5              # Leitura de inteiro syscall
    syscall
    sll $t1, $t0, 2        # Calcula o offset (t0 * 4)
    la $t2, precos         # Carrega o endereço base do array
    add $t3, $t2, $t1      # Calcula o endereço do índice atual
    sw $v0, 0($t3)         # Armazena o preço no array

    addi $t0, $t0, 1       # Incrementa o índice
    li $t4, 10             # Número total de preços
    bne $t0, $t4, loop_inserir  # Continua até inserir todos os preços
    jr $ra                 # Retorna para a função main

# Função AplicaDesconto: Aplica desconto de R$15 a preços > 100
AplicaDesconto:
    la $t0, precos         # Carrega o endereço base do array
    li $t1, 10             # Tamanho do array
    li $t2, 100            # Limite para desconto
    li $t3, 15             # Valor do desconto
    li $t4, 0              # Índice inicial
loop_desconto:
    lw $t5, 0($t0)         # Carrega o preço atual
    bgt $t5, $t2, aplica   # Se o preço for maior que 100, aplica o desconto
    j proximo
aplica:
    sub $t5, $t5, $t3      # Aplica o desconto
    sw $t5, 0($t0)         # Atualiza o valor no array
proximo:
    addi $t0, $t0, 4       # Move para o próximo elemento
    addi $t4, $t4, 1       # Incrementa o índice
    bne $t4, $t1, loop_desconto  # Continua até percorrer todo o array
    jr $ra                 # Retorna para a função main

# Função OrdenaProdutos: Ordena os preços em ordem crescente
OrdenaProdutos:
    la $t0, precos         # Carrega o endereço base do array
    li $t1, 10             # Tamanho do array
    li $t2, 0              # Índice i inicial
loop_ordena_i:
    li $t3, 0              # Índice j inicial
loop_ordena_j:
    # Carrega os preços nos índices i e j
    sll $t4, $t2, 2        # Calcula o offset de i (i * 4)
    add $t5, $t0, $t4      # Endereço do preço[i]
    lw $t6, 0($t5)         # Carrega preço[i] em t6

    sll $t7, $t3, 2        # Calcula o offset de j (j * 4)
    add $t8, $t0, $t7      # Endereço do preço[j]
    lw $t9, 0($t8)         # Carrega preço[j] em t9

    # Compara os preços e faz a troca, se necessário
    bge $t6, $t9, proximo_j # Se preço[i] >= preço[j], não troca
    # Troca os preços
    sw $t9, 0($t5)         # Armazena preço[j] em preço[i]
    sw $t6, 0($t8)         # Armazena preço[i] em preço[j]

proximo_j:
    addi $t3, $t3, 1       # Incrementa j
    bne $t3, $t1, loop_ordena_j  # Continua até o final da lista
    addi $t2, $t2, 1       # Incrementa i
    bne $t2, $t1, loop_ordena_i  # Continua até o final da lista
    jr $ra                 # Retorna para a função main

# Função ImprimePrecos: Imprime os preços ordenados
ImprimePrecos:
    li $t0, 0              # Índice inicial
    la $t1, precos         # Carrega o endereço base do array
    li $v0, 4              # Print string syscall
    la $a0, msg_final      # Carrega a mensagem de final
    syscall
loop_imprimir:
    li $v0, 1              # Print integer syscall
    lw $a0, 0($t1)         # Carrega o valor de preço
    syscall

    addi $t1, $t1, 4       # Move para o próximo valor no array
    addi $t0, $t0, 1       # Incrementa o índice
    li $t2, 10             # Número total de preços
    bne $t0, $t2, loop_imprimir # Continua até imprimir todos os preços
    jr $ra                 # Retorna para a função main
