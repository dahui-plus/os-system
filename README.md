# Simple OS System.

This repository is used to build a simple operating system. It will contain the following features:

- [ ] Kernel Initialization: Set up basic hardware, initialize data structures, and start other system components.
- [ ] Memory Management: Handle physical and virtual memory, including paging and segmentation.
- [ ] Process Management: Create, schedule, and manage processes and threads.
- [ ] Interrupt Handling: Respond to hardware and software interrupts, including IRQ and exception handling.
- [ ] I/O Management: Manage input and output operations, including drivers for various hardware.
- [ ] File System: Provide a way to store, retrieve, and organize files on disk.
- [ ] System Calls: Interface for user programs to interact with the OS kernel.
- [ ] Scheduler: Decide which process or thread runs at a given time.


## Usage


Before running this OS System you should install the development tools:
```bash
sudo apt-get update
sudo apt-get install qemu nasm gcc
```

Run the following command:

```bash
# Run OS on the qemu
make qemu

# Build the OS image. You can remove the "all" parameter
make all
```

To clean up build files:
```bash
make clean
```