type Opcode* = enum 
    PSH = 1,    # PSH [value]  - push a value to the stack
    ADD = 2,    # ADD          - add the two topmost values on the stack, push
    MUL = 3,    # MUL          - multiply the two topmost values on the stack, push 
    PRT = 4     # PRT          - pop the topmost value on the stack and print it
    ECH = 5     # ECH          - print the topmost value on the stack without popping

