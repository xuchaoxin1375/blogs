[toc]

## abstract

Git 配置文件是用于配置 Git 的行为和设置的文件。Git 的配置文件主要有三个层级：**系统级（system level）**、**用户级（global level）**和**仓库级（repository level）**。每个级别的配置文件可以覆盖上一个级别的配置，从而允许更细粒度的控制。

### Git 配置文件的层级

1. **系统级配置文件**：
   - 位置：`/etc/gitconfig`（在 Windows 上可能是 `C:\Program Files\Git\etc\gitconfig`）
   - 作用范围：对系统上所有用户和所有仓库生效。
   - 设置方法：使用 `git config --system` 命令设置（需要管理员权限）。

2. **用户级配置文件**：
   - 位置：`~/.gitconfig` 或 `~/.config/git/config`（在 Windows 上可能是 `C:\Users\你的用户名\.gitconfig`）
   - 作用范围：对当前用户的所有仓库生效。
   - 设置方法：使用 `git config --global` 命令设置。

3. **仓库级配置文件**：
   - 位置：仓库目录下的 `.git/config`
   - 作用范围：仅对当前仓库生效。
   - 设置方法：使用 `git config --local` 命令设置（这是默认的设置级别）。

### 常见的 Git 配置选项

Git 配置文件中可以设置很多选项，以下是一些常见的配置：

| 配置选项             | 说明                                                         | 示例命令                                                  |
| -------------------- | ------------------------------------------------------------ | --------------------------------------------------------- |
| `user.name`          | 设置提交代码时显示的用户名。                                 | `git config --global user.name "Your Name"`               |
| `user.email`         | 设置提交代码时显示的电子邮件地址。                           | `git config --global user.email "your_email@example.com"` |
| `core.editor`        | 设置默认的文本编辑器，通常用于编写提交信息。                 | `git config --global core.editor "vim"`                   |
| `core.autocrlf`      | 处理换行符的转换方式，通常用于 Windows 和 Unix 系统之间的兼容。 | `git config --global core.autocrlf true`                  |
| `alias.<alias-name>` | 设置 Git 命令的别名，可以方便快捷地执行常用的 Git 命令。     | `git config --global alias.co checkout`                   |
| `merge.tool`         | 设置合并冲突时使用的工具。                                   | `git config --global merge.tool vimdiff`                  |
| `diff.tool`          | 设置比较差异时使用的工具。                                   | `git config --global diff.tool vimdiff`                   |
| `color.ui`           | 启用或禁用颜色输出，`auto` 是常用值，它会根据终端环境自动决定是否使用颜色。 | `git config --global color.ui auto`                       |

### 查看和编辑 Git 配置

- **查看配置**：你可以使用 `git config --list` 查看当前所有生效的配置。可以通过指定级别来查看特定级别的配置，例如 `git config --global --list` 查看全局配置。
- **编辑配置文件**：你可以直接使用文本编辑器打开配置文件进行编辑。例如，`vim ~/.gitconfig` 可以编辑用户级的配置文件。

```
git config --global --list
```



### 实用示例

如果你想设置一个 Git 提交时常用的用户信息，可以执行以下命令：

```bash
git config --global user.name "John Doe"
git config --global user.email "john.doe@example.com"
```

这样，所有在这个用户环境下的 Git 提交都会使用设置的用户名和邮箱。

### 结论

通过 Git 配置文件，你可以方便地自定义 Git 的行为，使其更符合你的工作习惯和需求。了解并合理配置这些选项可以显著提高你的工作效率。

根据你的描述，当你 push 到 Gitee 时，总是弹出一个窗口让你选择凭据助手（credential helper），这通常是因为 Git 的凭据助手配置有冲突或者不明确。

## 凭据助手

示例配置

```bash
PS> git config --global --list
user.email=838808930@qq.com
user.name=cxxu
init.defaultbranch=main
safe.directory=*
credential.https://gitee.com.provider=generic
credential.helperselector.selected=wincred
credential.helper=manager
```



### 解决方案

上述配置中，有多个与凭据助手相关的设置：

1. `credential.helperselector.selected=wincred`
2. `credential.helper=manager`
3. `credential.https://gitee.com.provider=generic`

这些配置可能会导致 Git 不知道应该使用哪个凭据助手，因此在你 push 时弹出选择窗口。以下是一些可能的解决方法：

#### 1. 确保只使用一个凭据助手

要解决此问题，你需要选择一个凭据助手，并在 Git 配置中保持一致。例如，如果你想使用 `wincred`，可以执行以下命令来更新配置：

```powershell
git config --global credential.helper wincred
```

如果你想使用 `manager`（通常是 Git Credential Manager Core），可以使用以下命令：

```powershell
git config --global credential.helper manager
```

#### 2. 移除无关的凭据配置

你也可以清理一下配置文件，移除所有其他与凭据助手相关的设置，只保留你选择的一个。例如，要移除 `credential.helperselector.selected` 和 `credential.https://gitee.com.provider`，你可以执行：

```powershell
git config --global --unset credential.helperselector.selected
git config --global --unset credential.https://gitee.com.provider
```

#### 3. 检查和清理凭据缓存

有时候，凭据助手可能已经缓存了一些过时或无效的凭据，这也可能导致弹出窗口。

你可以清除这些缓存的凭据：(不一定可用)

```powershell
git credential-manager-core erase
```

然后，当你下次 push 时，Git 会要求你重新输入凭据，并将其缓存。

#### 4. 强制使用凭据助手

如果你已经决定使用 `manager`（Git Credential Manager Core），可以通过以下命令强制它用于 Gitee：

```powershell
git config --global credential.https://gitee.com.helper manager
```

这样，Git 会在连接到 `https://gitee.com` 时始终使用 `manager`。

#### 5. 确保 Git 和 Git Credential Manager 是最新版本

确保你的 Git 和 Git Credential Manager 是最新版本。有时，旧版本的工具可能存在兼容性问题或者 bug，升级到最新版本可能解决问题。

### 总结

以上步骤应该能帮助你解决 push 到 Gitee 时弹出选择窗口的问题。选择一个你想要的凭据助手并确保配置的一致性是关键。如果问题仍然存在，可以尝试清除凭据缓存或者更新 Git 和凭据管理工具。

选择哪种 Git 凭据助手（credential helper）更好，取决于你的操作系统、使用场景、以及对安全性和便捷性的要求。下面我们来比较一下几种常见的凭据助手：

| Helper 名称                                          | 操作系统支持          | 优势                                                         | 劣势                                                         | 适用场景                                         |
| ---------------------------------------------------- | --------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------ |
| `wincred`                                            | Windows               | 集成 Windows 凭据管理器，简单易用                            | 仅限 Windows 使用，不支持跨平台                              | 适合所有 Windows 用户                            |
| `manager` 或 `manager-core` (Git Credential Manager) | Windows、macOS、Linux | 提供更强的功能和跨平台支持，支持多种身份验证方式，如 OAuth 和 PAT（Personal Access Token） | 设置和使用可能稍微复杂一点                                   | 需要跨平台支持，或者使用高级身份验证的用户       |
| `osxkeychain`                                        | macOS                 | 集成 macOS 钥匙串，简单易用                                  | 仅限 macOS 使用                                              | 适合所有 macOS 用户                              |
| `cache`                                              | 所有平台              | 临时缓存凭据，适用于短期存储                                 | 凭据存储在内存中，Git 进程结束或超时后凭据失效，不适合长期使用 | 适用于临时工作，或者不希望长期存储凭据的场景     |
| `store`                                              | 所有平台              | 凭据以明文存储在磁盘上，简单易用                             | 安全性低，凭据以明文形式存储在 `~/.git-credentials` 文件中   | 适合本地开发，或者无需担心凭据泄漏的内部开发环境 |
| `libsecret`                                          | Linux (GNOME)         | 集成 GNOME 密钥环，安全性较高                                | 仅限 GNOME 桌面环境使用，配置较复杂                          | 使用 GNOME 桌面环境的 Linux 用户，重视凭据安全性 |

## 各种凭据助手的特点和选择建议

1. **Git Credential Manager (`manager` 或 `manager-core`)**:
   - **推荐使用场景**：如果你在 Windows、macOS 或 Linux 上工作，并且需要更安全和灵活的凭据管理（例如支持多因素身份验证、OAuth 或 Personal Access Token），`Git Credential Manager Core` 是一个很好的选择。它能够在多个平台上提供一致的体验和增强的安全性。
   - **特点**：支持 Windows（Git Credential Manager for Windows）和跨平台版本（Git Credential Manager Core），与 Windows 凭据管理器和 macOS 钥匙串集成良好，同时支持 Linux 系统。支持多种身份验证方式（例如，OAuth 和 PAT）。

2. **Windows Credential Manager (`wincred`)**:
   - **推荐使用场景**：如果你仅在 Windows 环境下工作，并且不需要高级认证方式，这个助手提供了简单且无缝的体验。
   - **特点**：直接与 Windows 凭据管理器集成，使用起来非常简单，无需额外配置。但仅适用于 Windows 环境，无法跨平台。

3. **macOS Keychain (`osxkeychain`)**:
   - **推荐使用场景**：如果你在 macOS 上工作，`osxkeychain` 是个不错的选择，简单易用，并且直接与 macOS 的钥匙串服务集成，确保了凭据的安全性。
   - **特点**：仅适用于 macOS 平台，简单安全，但没有跨平台支持。

4. **Credential Cache (`cache`)**:
   - **推荐使用场景**：适用于短期任务或不需要长时间存储凭据的场景，例如在公共电脑上进行一次性操作时使用。
   - **特点**：凭据临时存储在内存中，安全性较好但不适合长期使用。每次重启 Git 进程或超时时，缓存的凭据都会失效。

5. **Credential Store (`store`)**:
   - **推荐使用场景**：适用于安全性要求不高的场景，例如内部开发或个人项目，可以使用明文凭据存储方便操作。
   - **特点**：凭据明文存储在磁盘文件中，易于配置和使用，但存在严重的安全风险。适用于不担心凭据泄露的环境。

6. **Libsecret (`libsecret`)**:
   - **推荐使用场景**：适用于使用 GNOME 桌面环境的 Linux 用户，重视凭据的安全性。
   - **特点**：凭据存储在 GNOME 的安全密钥环中，安全性高，但仅适用于 GNOME 桌面环境，配置相对复杂。

### 结论

综合来看，如果你在 **Windows 上工作**并希望有简单的体验，`wincred` 是不错的选择；如果你希望有 **跨平台支持**，并且使用 **高级认证功能**，`Git Credential Manager Core` 是更好的选择；在 **macOS** 上使用 `osxkeychain`，在 **GNOME 环境的 Linux** 上使用 `libsecret`，可以保证凭据的安全和方便性。

根据你的情况（Windows 环境且不需要复杂身份验证），**使用 `wincred`** 可能是最佳选择。你可以通过下面的命令切换到 `wincred`：

```powershell
git config --global credential.helper wincred
```

如果你对 `Git Credential Manager Core` 感兴趣，可以安装它并使用以下命令设置：

```powershell
git config --global credential.helper manager-core
```

这将确保在 Gitee 上 push 时不再弹出选择窗口，并使用你选定的凭据助手。