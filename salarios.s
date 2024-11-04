.data
salarios: .word 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000, 12000  # Declara os salarios com valores de 2000 a 12000

.text

main:
    li $a0, 10              # Define o tamanho do array para 10 funcionários (que são dos 10 salarios)
    la $a1, salarios        # Carrega o endereço base do array de salários em $a1 (local onde o primeiro salario esta armazenado)

    jal benefits            # Chama a função benefits

    move $a0, $v0           # Move o resultado da soma total dos salarios e beneficios adicionados para $a0 para exibição
    li $v0, 1               # Syscall para imprimir inteiro
    syscall                 # Exibe a soma total dos salários com benefícios

    li $v0, 10              # Syscall para encerrar o programa
    syscall

# Função benefits
benefits:
    li $t0, 0               # Inicializa o índice $t0 com 0 (índice para acessar cada elemento do array.)
    li $t2, 0               # Inicializa o acumulador de soma $t2 com 0 (acumulador para a soma total dos salários com os benefícios.)

loop:
    beq $t0, $a0, end       # Se índice $t0 == tamanho do array (10), sai do loop

    # Carrega o salário atual
    sll $t3, $t0, 2         # Calcula a posição na memória do elemento multiplicando o índice por 4 (cada word tem 4 bytes)
    add $t4, $a1, $t3       # Calcula o endereço do salário atual
    lw $t5, 0($t4)          # Carrega o salário atual em $t5

    # Acrescenta 900 reais de vale-alimentação
    addi $t5, $t5, 900      

    # Acrescenta 300 reais de vale-transporte se o salário for menor que 5000
    blt $t5, 5000, add_transport
    j skip_transport		#pulaa a adição de R$ 300 se o salário for igual ou maior que 5000.

add_transport:
    addi $t5, $t5, 300      

skip_transport:
    # Atualiza o salário no array com os benefícios adicionados
    sw $t5, 0($t4)          

    # Adiciona o salário atualizado ao acumulador de soma
    add $t2, $t2, $t5       

    # Incrementa o índice para ver o proximo salario
    addi $t0, $t0, 1        
    j loop                  

end:
    move $v0, $t2           # Coloca o resultado da soma em $v0 para o retorno
    jr $ra                  # Retorna para o chamador que é a main
