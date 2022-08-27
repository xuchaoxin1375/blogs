\[toc\]

## Contents

- [1**Hardware implementation**](https://en.wikipedia.org/wiki/Program_counter#Hardware_implementation)
- [2**Consequences in machine architecture**](https://en.wikipedia.org/wiki/Program_counter#Consequences_in_machine_architecture)
- [3**Consequences in high-level programming**](https://en.wikipedia.org/wiki/Program_counter#Consequences_in_high-level_programming)
- [4**Symbol**](https://en.wikipedia.org/wiki/Program_counter#Symbol)
- [5**See also**](https://en.wikipedia.org/wiki/Program_counter#See_also)

## synopsis

- The **program counter** (**PC**), commonly called the **instruction pointer** (**IP**) in [Intel](https://en.wikipedia.org/wiki/Intel) [x86](https://en.wikipedia.org/wiki/X86) and [Itanium](https://en.wikipedia.org/wiki/Itanium) [microprocessors](https://en.wikipedia.org/wiki/Microprocessor), and sometimes called the **instruction address register** (**IAR**),[\[1\]](https://en.wikipedia.org/wiki/Program_counter#cite_note-Mead_1980-1) the **instruction counter**,[\[2\]](https://en.wikipedia.org/wiki/Program_counter#cite_note-IBM_1953-2) or just part of the instruction sequencer,[\[3\]](https://en.wikipedia.org/wiki/Program_counter#cite_note-Katzan_1971-3) is a [processor register](https://en.wikipedia.org/wiki/Processor_register) that indicates where a [computer](https://en.wikipedia.org/wiki/Computer) is in its [program](https://en.wikipedia.org/wiki/Computer_program) sequence.[\[nb 1\]](https://en.wikipedia.org/wiki/Program_counter#cite_note-NB1-4)
- Usually, the PC is incremented after fetching an [instruction](<https://en.wikipedia.org/wiki/Instruction_(computer_science)>), and holds the [memory address](https://en.wikipedia.org/wiki/Memory_address) of ("[points](<https://en.wikipedia.org/wiki/Pointer_(computer_programming)>) to") the next instruction that would be executed.[[4]](https://en.wikipedia.org/wiki/Program_counter#cite_note-Silberschatz_2018-5)[[nb 2]](https://en.wikipedia.org/wiki/Program_counter#cite_note-NB2-7)
- Processors usually fetch instructions sequentially from memory, but _control transfer_ instructions change the sequence by placing a new value in the PC. These include [branches](<https://en.wikipedia.org/wiki/Branch_(computer_science)>) (sometimes called jumps), [subroutine](https://en.wikipedia.org/wiki/Subroutine) calls, and [returns](https://en.wikipedia.org/wiki/Return_statement). A transfer that is conditional on the truth of some assertion lets the computer follow a different sequence under different conditions.
- A branch provides that the next instruction is fetched from elsewhere in memory. A subroutine call not only branches but saves the preceding contents of the PC somewhere. A return retrieves the saved contents of the PC and places it back in the PC, resuming sequential execution with the instruction following the subroutine call.
