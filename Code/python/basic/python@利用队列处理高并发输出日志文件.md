[toc]



## 完整的CSV上传日志记录示例

下面是一个完整的典型例子，展示了如何使用队列和后台线程高效记录CSV上传日志：

```python
import csv
import queue
import threading
from datetime import datetime
import time
import random

# 日志队列和工作者线程设置
log_queue = queue.Queue()

def log_worker():
    """后台日志记录线程"""
    while True:
        log_entry = log_queue.get()
        if log_entry is None:  # 终止信号
            break
        try:
            with open('upload_log.csv', 'a', newline='', encoding='utf-8') as f:
                writer = csv.writer(f)
                # 如果文件为空，写入标题行
                if f.tell() == 0:
                    writer.writerow(['Timestamp', 'RecordID', 'Status', 'Details', 'ProcessingTime'])
                writer.writerow(log_entry)
        except Exception as e:
            print(f"日志写入失败: {e}")
        finally:
            log_queue.task_done()

# 启动后台线程
log_thread = threading.Thread(target=log_worker, daemon=True)
log_thread.start()

def simulate_csv_upload(data_chunk):
    """模拟CSV数据上传处理"""
    successful_records = []
    
    for record in data_chunk:
        try:
            # 模拟处理时间
            processing_time = random.uniform(0.01, 0.1)
            time.sleep(processing_time)
            
            # 模拟90%成功率
            if random.random() < 0.9:
                successful_records.append(record)
                # 记录成功日志
                log_upload_success(record, processing_time)
            else:
                # 记录失败日志
                log_upload_failure(record, "模拟随机失败")
        except Exception as e:
            log_upload_failure(record, str(e))
    
    return successful_records

def log_upload_success(data, processing_time):
    """记录成功上传日志"""
    log_entry = [
        datetime.now().isoformat(),
        data.get('id', 'N/A'),
        'Success',
        str(data),
        f"{processing_time:.3f}s"
    ]
    log_queue.put(log_entry)

def log_upload_failure(data, error_msg):
    """记录失败上传日志"""
    log_entry = [
        datetime.now().isoformat(),
        data.get('id', 'N/A'),
        'Failed',
        f"{str(data)} | Error: {error_msg}",
        'N/A'
    ]
    log_queue.put(log_entry)

def cleanup():
    """清理函数，等待队列处理完成并停止工作线程"""
    log_queue.join()  # 等待所有日志项处理完成
    log_queue.put(None)  # 发送终止信号
    log_thread.join()  # 等待线程结束
    print("日志线程已停止")

# 示例使用
if __name__ == "__main__":
    # 模拟一批CSV数据
    test_data = [
        {'id': 1001, 'name': '产品A', 'price': 29.99},
        {'id': 1002, 'name': '产品B', 'price': 39.99},
        {'id': 1003, 'name': '产品C', 'price': 49.99},
        {'id': 1004, 'name': '产品D', 'price': 59.99},
        {'id': 1005, 'name': '产品E', 'price': 69.99},
    ]
    
    print("开始模拟CSV上传处理...")
    successful_uploads = simulate_csv_upload(test_data)
    print(f"处理完成，成功上传 {len(successful_uploads)}/{len(test_data)} 条记录")
    
    # 清理
    cleanup()
```

## 关键点说明

1. **日志工作者线程**：
   - 持续从队列获取日志条目
   - 首次写入时自动添加CSV标题行
   - 处理异常情况

2. **模拟上传处理**：
   - 随机成功率模拟真实场景
   - 记录处理时间用于性能分析
   - 区分成功和失败日志

3. **日志记录函数**：
   - `log_upload_success()` 记录成功上传
   - `log_upload_failure()` 记录失败情况

4. **清理过程**：
   - 等待队列处理完成
   - 优雅停止工作线程

## 生成的日志文件示例

生成的`upload_log.csv`文件内容类似：

```
Timestamp,RecordID,Status,Details,ProcessingTime
2023-05-15T14:30:22.123456,1001,Success,"{'id': 1001, 'name': '产品A', 'price': 29.99}",0.045s
2023-05-15T14:30:22.234567,1002,Success,"{'id': 1002, 'name': '产品B', 'price': 39.99}",0.078s
2023-05-15T14:30:22.345678,1003,Failed,"{'id': 1003, 'name': '产品C', 'price': 49.99} | Error: 模拟随机失败",N/A
2023-05-15T14:30:22.456789,1004,Success,"{'id': 1004, 'name': '产品D', 'price': 59.99}",0.032s
2023-05-15T14:30:22.567890,1005,Success,"{'id': 1005, 'name': '产品E', 'price': 69.99}",0.089s
```

这个实现提供了高效、线程安全的日志记录，适合生产环境使用。

