# FOS Project 2025

This project is a custom Operating System implementation focusing on Memory Management, Scheduling, and Process Management.

## Implemented Features

### 1. Memory Management

#### User Heap Management
*   **`malloc`**: Implemented using a **Custom Fit** strategy.
    *   **Strategy**: It first checks for an **Exact Fit** hole. If not found, it uses **Worst Fit** (largest hole). If no suitable hole exists, it extends the heap break.
*   **`free`**: Implements memory deallocation with **coalescing**. It merges adjacent free blocks and, if freed blocks are at the top of the heap, it shrinks the heap break (`brk`) to return memory to the system.
*   **User Memory Operations**:
    *   `allocate_user_mem`: Allocates pages for user environments and maps them with `PERM_UHPAGE`.
    *   `free_user_mem`: Unmaps pages, removes them from the page file, and updates the working set.

#### Page Replacement Algorithms
The system supports multiple page replacement strategies to handle page faults, configurable in `fault_handler`:
*   **LRU (Least Recently Used) Approximation**: Implemented using an "Aging" mechanism (`update_WS_time_stamps`). It tracks page usage via timestamps to evict the least recently used pages.
*   **Clock Algorithm**: Implements the standard Clock algorithm (Second Chance) using the `PERM_USED` bit to cycle through the working set.
*   **Modified Clock Algorithm**: An enhanced version of the Clock algorithm that prefers evicting unmodified pages over modified ones, reducing disk I/O.
*   **Optimal**: Implemented as a simulation for performance comparison to calculate the minimum possible number of faults for a given reference string.
*   **Placement**: Handles loading pages into the working set when space is available or replacing pages when the working set is full.

### 2. Process Management

#### Scheduling
*   **Round Robin (RR)**: The default scheduler. It distributes CPU time equally among processes using a fixed time quantum.
    *   **Context Switching**: Full context switching logic (`fos_scheduler`) to save and restore environment states (`Trapframe`).

#### Environment Lifecycle
*   **Creation**: `env_create` fully initializes new environments, loading program segments into memory and initializing the page directory and working set.
*   **Exit & Cleanup**: `env_free` ensures complete resource reclamation when a process terminates. It cleans up:
    *   Page Working Set.
    *   Page Tables and Page Directory.
    *   User Heap and Page File entries.

### 3. Fault Handling
*   **Page Fault Handler**: Robust handling of page faults (`fault_handler`), delegating to specific replacement policies (LRU, Clock, etc.) and handling stack growth or invalid access permissions.

## Project Structure

*   **`kern/`**: Kernel source code.
    *   `mem/`: Memory management (paging, heap, etc.).
    *   `proc/`: Process management and scheduling.
    *   `trap/`: Interrupt and fault handling (including `fault_handler.c`).
    *   `conc/`: Concurrency primitives (Semaphores, Locks - *Partial/Template*).
    *   `disk/`: Page file management.
*   **`user/`**: User-space programs and tests.
*   **`lib/`**: Standard libraries available to user programs (e.g., `uheap.c`, `syscall.c`).
*   **`inc/`**: Header files defining interfaces and constants.

## Getting Started

### Prerequisites
*   **Cross-Compiler**: A GCC cross-compiler for i386 (often provided in the lab environment).
*   **Simulator**: Bochs or QEMU for running the OS.

### Building and Running
1.  **Environment Setup**:
    Run the setup script to configure your path:
    ```bat
    FOS_Developer_Console.bat
    ```

2.  **Build**:
    Use `make` to compile the kernel and user programs.
    ```bash
    make
    ```

3.  **Run**:
    Start the simulator (Bochs):
    ```bash
    bochs -q
    # OR run the batch file if available
    bochscon.bat
    ```

## Development Verification
*   Tests are located in `user/`.
*   Kernel tests can be run by configuring the `fos_scheduler` to run specific user programs.
