[toc]

- [Generic Boot Partition  | Android Open Source Project](https://source.android.com/docs/core/architecture/partitions/generic-boot?hl=en)

# 分区的基本概念

- [Overview  | Android Open Source Project](https://source.android.com/docs/core/architecture/partitions?hl=en)

## Standard partitions

**Note:** Devices that support [seamless updates](https://source.android.com/docs/core/ota/ab) need one slot per partition for `boot`, `system`, `vendor`, and `radio`.

- **`boot` partition.** This partition contains a kernel image and is created using `mkbootimg`. You can use a virtual partition to flash either image directly without flashing a new boot partition. This partition also contains the generic ramdisk in devices launched before Android 13.

  - *kernel.* The virtual `kernel` partition overwrites the kernel (`zImage`, `zImage-dtb`, `Image.gz-dtb`) by writing the new kernel image over the old kernel image. If the development kernel supplied is incompatible, you might need to update the `vendor`, `system`, or `dtb` partition (if present) with associated kernel modules.
  - *ramdisk.* The virtual `ramdisk` partition overwrites the ramdisk by writing the new ramdisk image over the old ramdisk image.

  The overwrite operation determines the start location of the existing image in eMMC and copies the new image to that location. The new image (kernel or ramdisk) might be larger than the existing one; to make space, the bootloader can move data following the image or abandon the operation with an error.

- **`init_boot` partition.** This partition contains the generic ramdisk for devices launching with Android 13 and beyond.

- **`system` partition.** This partition contains the <u>Android framework</u>.

- **`odm` partition.** This partition contains original design manufacturer (ODM) customizations to system-on-chip (SoC) vendor board-support packages (BSPs). Such customizations enable ODMs to replace or customize SoC components, and implement kernel modules for board-specific components, daemons, and ODM-specific features on hardware abstraction layers (HALs). This partition is optional; typically, it's used to contain customizations so that devices can use a single vendor image for multiple hardware SKUs. For details, see [ODM Partitions](https://source.android.com/docs/core/architecture/bootloader/partitions/odm-partitions).

- **`odm_dlkm` partition.** This partition is dedicated to storing ODM kernel modules. Storing ODM kernel modules in the `odm_dlkm` partition (as opposed to the `odm` partition) makes it possible to update ODM kernel modules without updating the `odm` partition.

- **`recovery` partition.** This partition stores the recovery image, which is booted during the OTA process. Devices that support [seamless updates](https://source.android.com/docs/core/ota/ab) can store the recovery images as a ramdisk contained in the `boot` or `init_boot` image (rather than a separate image).

- **`cache` partition.** This partition stores temporary data and is optional if a device uses seamless updates. The cache partition doesn't need to be writable from the bootloader, but does need to be erasable. The partition size depends on the device type and the availability of space on `userdata`; typically, 50 MB–100 MB is sufficient.

- **`misc` partition.** This partition is used by the recovery partition and is 4 KB or larger.

- **`userdata` partition.** This partition contains user-installed apps and data, including customization data.

- **`metadata` partition.** This partition is used to store the metadata encryption key when the device uses [metadata encryption](https://source.android.com/docs/security/features/encryption/metadata). The size is 16 MB or larger. It is not encrypted and its data is not snapshotted. It is erased when the device is factory reset. Usage of this partition is strictly limited.

- **`vendor` partition.** This partition contains any binary that isn't distributable to AOSP. If the device doesn't contain proprietary information, you can omit this partition.

- **`vendor_dlkm` partition.** This partition is dedicated to storing vendor kernel modules. Storing vendor kernel modules in the `vendor_dlkm` partition (as opposed to the `vendor` partition) makes it possible to update kernel modules without updating the `vendor` partition.

- **`radio` partition.** This partition contains the radio image and is needed only for devices that include a radio with radio-specific software in a dedicated partition.

- **`tos` partition.** This partition stores the binary image of the Trusty OS and is used only if the device includes Trusty. For details, see [TOS Partitions](https://source.android.com/docs/core/architecture/bootloader/partitions/tos-partitions).

- 标准分区 注意：支持无缝更新的设备需要为<u>boot、system、vendor和radio</u>分区每个分区都提供一个插槽。

  - 引导分区：该分区包含内核镜像，并使用mkbootimg创建。您可以使用虚拟分区直接刷写其中的镜像，而无需刷写新的引导分区。在Android 13之前发布的设备中，该分区还包含通用的ramdisk。

  - 内核：虚拟内核分区通过将新内核镜像覆写到旧内核镜像上来进行更新（zImage、zImage-dtb、Image.gz-dtb）。如果提供的开发内核不兼容，则可能需要使用相关的内核模块更新供应商、系统或dtb分区（如果存在）。

  - ramdisk：虚拟ramdisk分区通过将新的ramdisk镜像覆写到旧ramdisk镜像上来进行更新。覆写操作确定eMMC中现有镜像的起始位置，并将新镜像复制到该位置。新镜像（内核或ramdisk）可能比现有镜像更大；为了腾出空间，引导加载程序可以移动镜像后的数据或中止操作并报错。

  - init_boot分区：该分区包含从Android 13开始发布的设备的通用ramdisk。

  - system分区：该分区包含Android框架。

  - odm分区：该分区包含原始设计制造商（ODM）对片上系统（SoC）供应商板支持包（BSP）的定制。此类定制使ODM能够替换或定制SoC组件，并在硬件抽象层（HAL）上为特定于板的组件、守护进程和ODM特定功能实现内核模块。该分区是可选的；通常用于包含定制内容，以便设备可以使用单个供应商镜像适用于多个硬件SKU。有关详细信息，请参阅ODM分区。

  - odm_dlkm分区：该分区专用于存储ODM内核模块。将ODM内核模块存储在odm_dlkm分区（而不是odm分区）中，可以在不更新odm分区的情况下更新ODM内核模块。

  - recovery分区：该分区存储恢复镜像，在OTA过程中引导。支持无缝更新的设备可以将恢复镜像存储为包含在引导或init_boot镜像中的ramdisk（而不是单独的镜像）。

  - cache分区：该分区存储临时数据，如果设备使用无缝更新，则是可选的。引导加载程序不需要对缓存分区进行写操作，但需要能够擦除。分区大小取决于设备类型和userdata上的可用空间；通常，50 MB-100 MB足够了。

  - “misc”分区。该分区由恢复分区使用，大小为4 KB或更大。
  - “userdata”分区。该分区包含用户安装的应用程序和数据，包括定制数据。
  - “metadata”分区。当设备使用元数据加密时，该分区用于存储元数据加密密钥。大小为16 MB或更大。它没有加密，其数据不受快照保护，当设备出厂重置时，该分区将被擦除。该分区的使用严格受限。
  - “vendor”分区。该分区包含任何不可分发给AOSP的二进制文件。如果设备不包含专有信息，则可以省略此分区。
  - “vendor_dlkm”分区。该分区专门用于存储供应商内核模块。将供应商内核模块存储在“vendor_dlkm”分区中（而不是“vendor”分区）可以更新内核模块而无需更新“vendor”分区。
  - “radio”分区。该分区包含无线电镜像，仅适用于包含具有专用分区中的无线电特定软件的无线电的设备。
  - “tos”分区。此分区存储Trusty OS的二进制映像，仅在设备包含Trusty时使用。有关详细信息，请参见TOS分区。

# 重点概念

### ramdisk

- 在Android系统中，Ramdisk是指Android设备在引导过程中使用的初始文件系统，它位于启动镜像中。Ramdisk在设备启动时被加载到内存中，并提供了一些关键的系统文件和初始化脚本，用于配置和准备设备的硬件和软件环境。
- Android的Ramdisk包含了一系列文件和目录，例如设备节点（device nodes）、初始脚本（init scripts）、配置文件、权限设置等。它的主要目的是在系统引导过程中设置基本的系统参数、初始化设备驱动和加载核心系统组件。一旦Ramdisk加载完成，Android系统就可以顺利启动，并且进一步加载和运行其他关键组件，如Android Framework和应用程序。
- Ramdisk在Android系统中起到了重要的作用，它负责设备的初始化和启动阶段的一些关键任务，确保系统正常运行。它提供了一个临时的文件系统，允许系统进行一些初始化配置、加载驱动程序和执行必要的操作，为后续的系统启动和运行做好准备。一旦Android系统完全启动，Ramdisk的作用就不再需要，因此它会被释放，而系统会转移到使用根文件系统（root filesystem）进行正常的运行。
- 早期的ramdisk:[Ramdisk Partitions  | Android Open Source Project](https://source.android.com/docs/core/architecture/partitions/ramdisk-partitions?hl=en)



### GKI

- 在Android中，GKI代表通用内核镜像（Generic Kernel Image）。它是一个通用的、标准化的内核镜像，旨在提供一致性和可移植性，以支持不同类型的Android设备。

  GKI包含了Android操作系统的内核部分，即操作系统的核心代码。内核负责管理硬件资源、提供驱动程序接口、处理系统调用和执行底层操作。通常，不同的设备需要适配特定的内核版本和配置，这导致了Android设备之间的内核差异。

  为了解决这个问题，Android引入了GKI的概念。GKI提供了一种标准化的内核镜像，其中包含了通用的内核代码和功能。这意味着设备制造商可以使用相同的GKI作为基础，无论设备类型或品牌如何，从而减少对内核的修改和维护工作。这为Android生态系统带来了更好的一致性、更快的更新速度和更广泛的设备支持。

  通过使用GKI，Android设备可以共享通用的内核层，同时仍然保留各自的硬件特定性和设备驱动程序。这有助于提高Android平台的稳定性、安全性和性能，并简化了开发者、设备制造商和供应商之间的合作和兼容性问题。

### 关联

- Ramdisk和GKI之间有密切的关系，同时它们都与启动过程中的boot（引导）相关。
- Ramdisk是在Android设备引导过程中使用的初始文件系统。它包含了启动过程中所需的关键文件和配置，用于初始化设备和准备系统环境。Ramdisk位于启动镜像中，其中还包括了内核（kernel）。
- GKI是通用内核镜像（Generic Kernel Image），它是一个标准化的内核镜像，包含了通用的内核代码和功能。GKI的目标是提供一致性和可移植性，使不同类型的Android设备可以共享相同的内核基础。
- 在启动过程中，首先加载的是bootloader（引导加载程序），它是设备上的第一个软件程序，负责初始化硬件并引导操作系统的加载。
  - bootloader会加载启动镜像，其中包括了GKI和ramdisk。
  - GKI内核被加载到内存中，成为操作系统的核心，处理底层的硬件和系统操作。
  - 同时，ramdisk也被加载到内存中，提供了初始文件系统和必要的配置文件，以支持系统的引导和初始化过程。
- 因此，ramdisk和GKI是启动过程中两个重要的组成部分，ramdisk提供了初始的文件系统和配置，而GKI则是操作系统的核心，负责处理底层的系统操作。它们共同协作，确保Android设备能够成功启动和运行。

## 自android13开始的变换

- [通用引导分区  | Android 开源项目  | Android Open Source Project](https://source.android.com/docs/core/architecture/partitions/generic-boot?hl=zh-cn)

- In Android 12, the generic `boot` image, referred to as [Generic Kernel Image (GKI)](https://source.android.com/docs/core/architecture/kernel/generic-kernel-image), contains the generic ramdisk and the GKI kernel.

  For devices launching with Android 13, the generic ramdisk is removed from the `boot` image and placed in a separate `init_boot` image. This change leaves the `boot` image with only the GKI kernel.

  For upgrading devices that continue to use Android 12 or older kernel versions, the generic ramdisk remains where it was with no requirement for a new `init_boot` image.

  To build a generic ramdisk, move vendor-specific resources out of the ramdisk such that the generic ramdisk contains only first stage `init` and a property file that contains timestamp information.

  On devices that:

  - Don't use a dedicated `recovery` partition, all recovery bits move from the generic ramdisk to `vendor_boot` ramdisk.
  - Do use a dedicated `recovery` partition, no change in the `recovery` ramdisk is needed because the `recovery` ramdisk is self-contained.

- 在Android 12中，通用启动镜像（boot image也称为Generic Kernel Image，GKI镜像）包含通用ramdisk和GKI内核。

- 然而，在Android 13中推出的设备上，通用ramdisk已从启动镜像`boot`中移除，并放置在一个单独的`init_boot`镜像中。这个改变使得启动镜像仅包含GKI内核。

- 对于继续使用Android 12或更早版本内核的设备进行升级，通用ramdisk仍然保持在原来的位置，不需要新的init_boot镜像。

- 为了构建一个通用ramdisk，需要将特定于供应商的资源移出ramdisk，使得通用ramdisk仅包含第一阶段初始化和包含时间戳信息的属性文件。

  - 对于不使用专用恢复分区的设备，所有恢复相关的内容将从通用ramdisk移至`vendor_boot` ramdisk。

  - 而对于使用专用恢复分区的设备，恢复ramdisk不需要进行任何更改，因为恢复ramdisk是独立的。

### 架构

- The following diagrams illustrate the architecture for devices running Android 12 and above. Device launching with Android 13 have a new `init_boot` image containing the generic ramdisk. Devices upgrading from Android 12 to Android 13 use the same architecture as they did with Android 12.

### Boot images contents

- [Generic Boot Partition  | Android Open Source Project](https://source.android.com/docs/core/architecture/partitions/generic-boot?hl=en#boot-images-contents)

## 重要概念

- Android的动态分区、AB分区和VAB分区是与Android系统的<u>存储分区和系统更新</u>相关的概念。

### AB分区

- AB分区（A/B Partitioning）： AB分区是Android系统在Android 7.0 Nougat版本中引入的一项技术，也称为"系统更新分区"。
- AB分区将设备的存储划分为**两个完全独立的分区**，分别被称为"A分区"和"B分区"。每个分区都包含**完整的操作系统**和**用户数据**。

- AB分区的目的是实现**无缝的系统更新**。当新的系统更新可用时，它将被下载到非活动分区中，并在后台进行验证和安装。在下一次重启时，设备会自动切换到更新后的非活动分区，并启动更新后的系统。这种方式可以保证在更新过程中的最小停机时间，并且即使更新失败，也可以回滚到之前的稳定版本。

### 动态分区

- 动态分区（Dynamic Partitions）： 动态分区是Android 10及其更高版本引入的一项技术。
- 在传统的分区方案中，Android系统将**系统分区**和**供应商分区**作为**静态分区**进行划分，这限制了系统更新的灵活性。
- 而动态分区允许将系统分区和供应商分区<u>以逻辑方式划分为多个动态分区</u>，这样可以更有效地管理空间和系统更新。

- 动态分区的主要优势是可以在<u>不影响用户数据的情况下进行系统更新</u>。通过将系统更新文件写入一个不活动的分区，系统可以在后台进行更新。在下一次重启时，系统将<u>自动切换到更新后的分区</u>，并继续正常运行。这种方式避免了传统分区方案下需要将用户数据备份和还原的麻烦过程。

### VAB分区

- VAB分区（Virtual A/B Partitioning）： VAB分区是在Android 11版本中引入的一项改进，它是对AB分区的进一步扩展和改进。
- VAB分区采用了动态分区的概念，并将系统更新分区划分为更多的**虚拟分区**。

- VAB分区的主要优势是可以实现更灵活和可靠的系统更新。它允许系统在后台进行更新，并通过创建虚拟分区来保持设备的可用性。在更新过程中，系统将自动创建虚拟分区，并将更新应用到虚拟分区中。
- 一旦更新完成并验证通过，系统将切换到更新后的虚拟分区，并启动更新后的系统。
- 这种方式减少了对设备分区表的更改，并提供了更好的系统稳定性和可靠性。

## 出场android13的8gen2以及之后的设备root

- [How to Root Redmi K60 Pro via Magisk Patched boot_init (droidwin.com)](https://droidwin.com/how-to-root-redmi-k60-pro-via-magisk-patched-boot_init/#STEP_5_Get_Redmi_K60_Pro_Stock_Init_Bootimg)
- 某些设备虽然也是出场搭载android13,但是可能依然使用老的架构(boot.img中的ramdisk没有被拆分出去,也就是没有init_boot.img)









