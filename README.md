# Weird-Sized Integers on Windows (x64, NASM)

## Objective
Learn how integers are stored in memory and practice bitwise ops and shifts. Store and retrieve **5-byte** integers from an array, reconstruct into `RAX`, and verify

## Toolchain
- **NASM** for assembling (`nasm.exe`)
- **MSVC Linker** for linking (`link.exe`) with Windows SDK’s `kernel32.lib`
- Launch the **“x64 Native Tools Command Prompt for VS”** to get env vars

## Build & Run
```bat
nasm -f win64 weird5_win.asm -o weird5_win.obj
link /subsystem:console /entry:main /nodefaultlib weird5_win.obj kernel32.lib
weird5_win.exe & echo ExitCode=%ERRORLEVEL%
