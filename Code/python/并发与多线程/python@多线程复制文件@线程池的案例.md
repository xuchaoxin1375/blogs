[toc]



# Python线程池实现多文件复制

下面我将展示如何使用Python的`concurrent.futures`线程池来并行复制100个文件，使用5个工作线程。

## 基本实现方案

```python
import os
import shutil
from concurrent.futures import ThreadPoolExecutor

def copy_file(src_path, dst_path):
    """复制单个文件的函数"""
    try:
        shutil.copy2(src_path, dst_path)  # copy2会保留元数据
        print(f"Copied: {src_path} -> {dst_path}")
        return True
    except Exception as e:
        print(f"Failed to copy {src_path}: {str(e)}")
        return False

def batch_copy_files(file_pairs, max_workers=5):
    """批量复制文件"""
    with ThreadPoolExecutor(max_workers=max_workers) as executor:
        # 提交所有复制任务到线程池
        futures = [
            executor.submit(copy_file, src, dst) 
            for src, dst in file_pairs
        ]
        
        # 等待所有任务完成（可选）
        for future in concurrent.futures.as_completed(futures):
            future.result()  # 可以在这里获取返回值或处理异常

if __name__ == "__main__":
    # 准备100个文件的源路径和目标路径
    source_dir = "/path/to/source"
    dest_dir = "/path/to/destination"
    
    # 假设我们有一组文件名列表
    file_names = [f"file_{i}.txt" for i in range(100)]
    
    # 创建(源路径, 目标路径)对的列表
    file_pairs = [
        (os.path.join(source_dir, name), os.path.join(dest_dir, name))
        for name in file_names
    ]
    
    # 开始复制，使用5个工作线程
    batch_copy_files(file_pairs, max_workers=5)
```

## 增强版实现（带进度显示和错误处理）

```python
import os
import shutil
from concurrent.futures import ThreadPoolExecutor, as_completed
from tqdm import tqdm  # 需要安装：pip install tqdm

def copy_file(src_path, dst_path):
    """复制单个文件的函数，带更详细的错误处理"""
    try:
        # 确保目标目录存在
        os.makedirs(os.path.dirname(dst_path), exist_ok=True)
        
        # 执行复制
        shutil.copy2(src_path, dst_path)
        return (True, src_path, dst_path, None)
    except Exception as e:
        return (False, src_path, dst_path, str(e))

def batch_copy_files_enhanced(file_pairs, max_workers=5):
    """批量复制文件，带进度条和错误统计"""
    total_files = len(file_pairs)
    success_count = 0
    error_count = 0
    error_messages = []
    
    with ThreadPoolExecutor(max_workers=max_workers) as executor:
        # 提交所有任务
        futures = {
            executor.submit(copy_file, src, dst): (src, dst)
            for src, dst in file_pairs
        }
        
        # 使用tqdm显示进度
        with tqdm(total=total_files, desc="Copying files") as pbar:
            for future in as_completed(futures):
                src, dst = futures[future]
                try:
                    success, src_path, dst_path, error = future.result()
                    if success:
                        success_count += 1
                    else:
                        error_count += 1
                        error_messages.append(f"{src_path}: {error}")
                except Exception as e:
                    error_count += 1
                    error_messages.append(f"{src}: Unexpected error: {str(e)}")
                finally:
                    pbar.update(1)
    
    # 打印摘要
    print(f"\nCopy complete. Success: {success_count}, Failed: {error_count}")
    if error_messages:
        print("\nError details:")
        for msg in error_messages[:10]:  # 只显示前10个错误
            print(f" - {msg}")
        if len(error_messages) > 10:
            print(f"... and {len(error_messages)-10} more errors")

if __name__ == "__main__":
    # 示例用法
    source_dir = "/path/to/source"
    dest_dir = "/path/to/destination"
    file_names = [f"file_{i}.txt" for i in range(100)]
    
    file_pairs = [
        (os.path.join(source_dir, name), os.path.join(dest_dir, name))
        for name in file_names
    ]
    
    batch_copy_files_enhanced(file_pairs, max_workers=5)
```

## 方案说明

1. **线程池管理**：
   - 使用`ThreadPoolExecutor`创建包含5个工作线程的池
   - 每个文件复制任务作为一个独立的线程任务提交

2. **文件复制**：
   - 使用`shutil.copy2()`保留文件元数据（如修改时间）
   - 自动创建目标目录（如果不存在）

3. **错误处理**：
   - 捕获并记录复制过程中的异常
   - 提供详细的错误报告

4. **进度显示**：
   - 使用`tqdm`库显示进度条
   - 显示成功/失败统计

5. **扩展性**：
   - 可以轻松调整工作线程数量
   - 支持大规模文件列表

## 性能考虑

1. **I/O密集型 vs CPU密集型**：
   - 文件复制主要是I/O密集型操作
   - Python的GIL不会成为瓶颈
   - 5个线程是合理的起点，可以根据实际硬件调整

2. **磁盘性能**：
   - 对于机械硬盘，过多线程可能导致磁头频繁寻道，反而降低性能
   - SSD则可以受益于更多并行线程

3. **网络位置**：
   - 如果源或目标是网络位置，考虑网络带宽限制

## 替代方案

如果复制大量小文件，也可以考虑：

1. **多进程池**（适合CPU密集型操作）：
   ```python
   from concurrent.futures import ProcessPoolExecutor
   # 只需将ThreadPoolExecutor替换为ProcessPoolExecutor
   ```

2. **异步IO**（Python 3.7+）：
   ```python
   import asyncio
   import aiofiles
   
   async def async_copy(src, dst):
       async with aiofiles.open(src, 'rb') as f_src:
           content = await f_src.read()
       async with aiofiles.open(dst, 'wb') as f_dst:
           await f_dst.write(content)
   ```

根据您的具体场景和文件特性，可以选择最适合的方案。