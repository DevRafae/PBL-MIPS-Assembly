.data        
precos: .space 40        #area dos dados para armazenar os preços. Cada preço tm 4 bytes
msg_inserir: .asciiz "Insira o preço do produto: "
msg_final: .asciiz "Preços ordenados: "

.text
.globl main

main:
jal #inserir preços
jal #função do desconto
jal # ordem dos produtos
jal # motrar os preços

li $v0, 10        #finaliza o programa
syscall


#função para inserir os preços

insereprecos:
li $t0, 0 

loopinserir:
li $v0, 4
la $a0,msg_inserir
syscall

li $v0, 5
syscall
sll $t1, t0, 2
la $t2, precos      #carrega o endereço base do array

add $t3
