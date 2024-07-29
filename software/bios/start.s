.section    .start
.global     _start

_start:
    li      sp, 0x10000ff0
    jal     main
