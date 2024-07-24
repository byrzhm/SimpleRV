test:
    add x1, x0, 5 # x1 <= 5
    add x2, x1, 5 # x2 <= 5 + 5, RAW
    sw  x2, 0(x0) # Mem[0] <= 10
    lw  x3, 0(x0) # x3 <= Mem[0]
    nop
    nop
    nop
