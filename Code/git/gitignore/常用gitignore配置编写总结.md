[toc]



## Gitignore 文件编写总结

## 通用基础模板

```bash
# 操作系统生成文件
.DS_Store
Thumbs.db
*.swp

# 编辑器/IDE 目录和文件
.idea/
.vscode/
*.suo
*.ntvs*
*.njsproj
*.sln
*.sw?

# 日志文件
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# 依赖目录
node_modules/
bower_components/
jspm_packages/

# 缓存目录
.temp/
.cache/

# 构建输出目录
dist/
build/
out/
*.exe
*.dll
*.so
*.dylib

# 测试相关
coverage/
*.lcov

# 环境文件
.env
.env.local
.env.development
.env.test
.env.production

# 调试文件
*.pdb
*.idb
*.ilk
```

## 按项目类型补充内容

### 1. 前端项目 (React/Vue/Angular等)

```
# 前端项目补充
.sass-cache/
*.css.map
*.js.map
*.tsbuildinfo

# 包管理器
package-lock.json
yarn.lock
pnpm-lock.yaml

# 框架特定
.next/
.nuxt/
.cache/
.vuepress/dist/
```

### 2. Node.js 后端项目

```
# Node.js 补充
logs/
*.pid
*.seed
*.tgz

# TypeScript
*.tsbuildinfo

# 数据库
*.db
*.sqlite
```

### 3. Python 项目🎈

```
# Python 补充
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
env/
venv/
ENV/
env.bak/
venv.bak/

# 打包文件
*.egg
*.egg-info/
dist/
build/
eggs/
parts/
var/
sdist/
develop-eggs/
.installed.cfg
lib/
lib64/

# 安装日志
pip-log.txt
pip-delete-this-directory.txt

# 单元测试/覆盖率
htmlcov/
.tox/
.coverage
.coverage.*
.cache
nosetests.xml
coverage.xml
*.cover
.hypothesis/
.pytest_cache/
```

### 4. Java 项目

```
# Java 补充
*.class
*.jar
*.war
*.ear
*.nar
hs_err_pid*

# 构建工具
target/
build/
.gradle/
.apt_generated/

# Eclipse
.settings/
.project
.classpath
.metadata/
bin/
tmp/

# IntelliJ
*.iml
*.ipr
*.iws
out/
```

### 5. C/C++ 项目

```
# C/C++ 补充
*.o
*.ko
*.obj
*.elf
*.ilk
*.map
*.exp
*.pch
*.pdb
*.lib
*.dll
*.exe
*.out
*.app
*.i*86
*.x86_64
*.hex
*.su
*.idb
*.pdb
*.sln
*.vcxproj
*.vcxproj.filters
*.vcxproj.user
Debug/
Release/
x64/
x86/
build/
```

### 6. Go 项目

```
# Go 补充
bin/
pkg/
*.exe
*.test
*.prof
vendor/
```

### 7. Rust 项目

```
# Rust 补充
/target/
**/*.rs.bk
Cargo.lock
```

### 8. PHP 项目

```
# PHP 补充
vendor/
composer.lock
.phpunit.result.cache
.phan/
.php_cs
.php_cs.cache
```

### 9. Ruby/Rails 项目

```
# Ruby 补充
*.gem
.bundle/
.ruby-version
.rvmrc
Gemfile.lock
/.config
/coverage/
/spec/tmp/
*.rbc
capybara-*.html
.rspec
/log/*
/tmp/*
!/log/.keep
!/tmp/.keep
```

### 10. Android 项目

```
# Android 补充
*.apk
*.ap_
*.dex
*.class
bin/
gen/
build/
.gradle/
local.properties
*.keystore
*.jks
*.hprof
captures/
.externalNativeBuild/
.cxx/
```

### 11. iOS/macOS 项目

```
# iOS/macOS 补充
**/*.xcuserstate
**/xcuserdata/
**/DerivedData/
*.ipa
*.dSYM.zip
*.dSYM
Pods/
Podfile.lock
fastlane/report.xml
fastlane/Preview.html
fastlane/screenshots
fastlane/test_output
```

## 最佳实践建议

1. **分层管理**:
   - 使用全局 gitignore (`git config --global core.excludesfile ~/.gitignore_global`)
   - 结合项目特定 gitignore

2. **注释说明**:
   - 为每个部分添加注释说明
   - 特别是不常见的忽略规则

3. **定期审查**:
   - 随着项目发展更新 gitignore
   - 删除不再需要的忽略规则

4. **测试验证**:
   - 添加规则后运行 `git status` 验证
   - 确保不会忽略必要的文件

5. **考虑环境**:
   - 区分开发环境和生产环境需要的文件
   - 确保不会忽略构建产物中必要的文件

6. **版本控制**:
   - 将 gitignore 文件纳入版本控制
   - 作为项目标准配置的一部分