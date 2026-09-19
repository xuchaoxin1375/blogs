[toc]



# 一个大 class 拆成等价代码：完整案例

## 先打个比方

一个上千行的大 class，就像一个**夫妻店老板**：既当收银、又当厨师、又当采购、又当客服。

你想改"收银"逻辑，结果发现它和"采购"代码缠在一起，动一下怕崩。

拆分的本质就是：**开成公司，分部门，每个部门只管一件事，部门之间用"接口"对接。**

下面用一个具体例子，从前到后演一遍。

---

## 一、拆分前：一个 800 行的上帝类

假设是个电商小系统，`ShopService` 什么都干：

```python
# app.py
import smtplib
import logging

class ShopService:
    """上帝类：用户、商品、订单、支付、通知，全在这"""
    def __init__(self, db, redis):
        self.db = db
        self.redis = redis
        self.logger = logging.getLogger("shop")
        self.smtp = smtplib.SMTP("smtp.example.com")

    # ---------- 用户 ----------
    def register_user(self, name, email, password):
        if self.db.query("select 1 from users where email=?", email):
            raise ValueError("邮箱已存在")
        uid = self.db.insert("users", {"name": name, "email": email, "password": password})
        self.logger.info("新用户注册: %s", uid)
        self.send_email(email, "欢迎", f"你好 {name}")
        return uid

    def get_user(self, uid):
        cached = self.redis.get(f"user:{uid}")
        if cached:
            return cached
        u = self.db.query("select * from users where id=?", uid)
        self.redis.set(f"user:{uid}", u, ex=60)
        return u

    def change_password(self, uid, old, new):
        u = self.get_user(uid)
        if u["password"] != old:
            raise ValueError("旧密码错误")
        self.db.update("users", uid, {"password": new})
        self.redis.delete(f"user:{uid}")
        self.send_email(u["email"], "密码已修改", "如果不是你操作请尽快联系客服")

    # ---------- 商品 ----------
    def add_product(self, name, price, stock):
        pid = self.db.insert("products", {"name": name, "price": price, "stock": stock})
        self.logger.info("上架商品: %s", pid)
        return pid

    def off_shelf(self, pid):
        self.db.update("products", pid, {"on_shelf": False})
        self.redis.delete(f"product:{pid}")

    # ---------- 订单 ----------
    def create_order(self, uid, pid, qty):
        p = self.db.query("select * from products where id=?", pid)
        if not p or not p["on_shelf"]:
            raise ValueError("商品不存在或已下架")
        if p["stock"] < qty:
            raise ValueError("库存不足")

        total = p["price"] * qty
        oid = self.db.insert("orders", {
            "user_id": uid, "product_id": pid, "qty": qty,
            "total": total, "status": "pending",
        })
        self.db.update("products", pid, {"stock": p["stock"] - qty})
        self.logger.info("创建订单: %s", oid)
        self.send_email(self.get_user(uid)["email"], "订单已创建", f"订单号 {oid}")
        return oid

    def cancel_order(self, oid):
        o = self.db.query("select * from orders where id=?", oid)
        if o["status"] != "pending":
            raise ValueError("当前状态不可取消")
        self.db.update("orders", oid, {"status": "cancelled"})
        p = self.db.query("select * from products where id=?", o["product_id"])
        self.db.update("products", o["product_id"], {"stock": p["stock"] + o["qty"]})
        self.send_email(self.get_user(o["user_id"])["email"], "订单已取消", f"订单号 {oid}")

    # ---------- 支付 ----------
    def pay(self, oid, amount):
        o = self.db.query("select * from orders where id=?", oid)
        if o["total"] != amount:
            raise ValueError("金额不符")
        self.db.update("orders", oid, {"status": "paid"})
        self.logger.info("订单支付成功: %s", oid)

    def refund(self, oid):
        o = self.db.query("select * from orders where id=?", oid)
        if o["status"] != "paid":
            raise ValueError("只有已支付订单可退款")
        self.db.update("orders", oid, {"status": "refunded"})
        self.send_email(self.get_user(o["user_id"])["email"], "退款成功", f"订单号 {oid}")

    # ---------- 通知 ----------
    def send_email(self, to, subject, body):
        self.smtp.sendmail("noreply@shop.com", to, f"Subject: {subject}\n\n{body}")
        self.logger.info("邮件已发送: %s", to)

    def send_sms(self, phone, text):
        ...
```

### 问题在哪？

| 问题           | 具体表现                                                     |
| -------------- | ------------------------------------------------------------ |
| **职责混杂**   | 下单逻辑里，一半在管订单，一半在管邮件、库存、用户           |
| **内部强耦合** | `create_order` 里直接 `self.send_email(...)`、`self.get_user(...)` |
| **难测试**     | 想测 `create_order`，必须先准备 SMTP、Redis、DB              |
| **状态共享**   | `self.smtp`、`self.redis` 谁都能碰，出问题难定位             |

---

## 二、拆分后：按职责分成 5 个类

### 1. 基础设施层（本来就不该在业务类里 new）

```python
# infra.py
class Db:
    def query(self, sql, *args): ...
    def insert(self, table, data): ...
    def update(self, table, id_, data): ...

class Cache:
    def get(self, k): ...
    def set(self, k, v, ex=60): ...
    def delete(self, k): ...

class Mailer:
    def send(self, to, subject, body): ...
```

### 2. 通知服务（谁要发消息，找它）

```python
# services/notify.py
class NotifyService:
    def __init__(self, mailer: Mailer):
        self.mailer = mailer

    def email(self, to, subject, body):
        self.mailer.send(to, subject, body)

    def sms(self, phone, text):
        ...
```

### 3. 用户服务

```python
# services/user.py
class UserService:
    def __init__(self, db: Db, cache: Cache, notify: NotifyService):
        self.db = db
        self.cache = cache
        self.notify = notify

    def register(self, name, email, password):
        if self.db.query("select 1 from users where email=?", email):
            raise ValueError("邮箱已存在")
        uid = self.db.insert("users", {"name": name, "email": email, "password": password})
        self.notify.email(email, "欢迎", f"你好 {name}")
        return uid

    def get(self, uid):
        cached = self.cache.get(f"user:{uid}")
        if cached:
            return cached
        u = self.db.query("select * from users where id=?", uid)
        self.cache.set(f"user:{uid}", u, ex=60)
        return u

    def change_password(self, uid, old, new):
        u = self.get(uid)
        if u["password"] != old:
            raise ValueError("旧密码错误")
        self.db.update("users", uid, {"password": new})
        self.cache.delete(f"user:{uid}")
        self.notify.email(u["email"], "密码已修改", "如果不是你操作请尽快联系客服")
```

### 4. 商品服务

```python
# services/product.py
class ProductService:
    def __init__(self, db: Db, cache: Cache):
        self.db = db
        self.cache = cache

    def add(self, name, price, stock):
        return self.db.insert("products", {"name": name, "price": price, "stock": stock})

    def off_shelf(self, pid):
        self.db.update("products", pid, {"on_shelf": False})
        self.cache.delete(f"product:{pid}")
```

### 5. 支付服务

```python
# services/pay.py
class PayService:
    def __init__(self, db: Db):
        self.db = db

    def pay(self, oid, amount):
        o = self.db.query("select * from orders where id=?", oid)
        if o["total"] != amount:
            raise ValueError("金额不符")
        self.db.update("orders", oid, {"status": "paid"})

    def refund(self, oid):
        o = self.db.query("select * from orders where id=?", oid)
        if o["status"] != "paid":
            raise ValueError("只有已支付订单可退款")
        self.db.update("orders", oid, {"status": "refunded"})
        return o["user_id"]   # 返回给上层去通知
```

### 6. 订单服务

```python
# services/order.py
class OrderService:
    def __init__(self, db: Db, product: ProductService,
                 user: UserService, pay: PayService, notify: NotifyService):
        self.db = db
        self.product = product
        self.user = user
        self.pay = pay
        self.notify = notify

    def create(self, uid, pid, qty):
        p = self.db.query("select * from products where id=?", pid)
        if not p or not p["on_shelf"]:
            raise ValueError("商品不存在或已下架")
        if p["stock"] < qty:
            raise ValueError("库存不足")

        total = p["price"] * qty
        oid = self.db.insert("orders", {
            "user_id": uid, "product_id": pid, "qty": qty,
            "total": total, "status": "pending",
        })
        self.db.update("products", pid, {"stock": p["stock"] - qty})
        self.notify.email(self.user.get(uid)["email"], "订单已创建", f"订单号 {oid}")
        return oid

    def cancel(self, oid):
        o = self.db.query("select * from orders where id=?", oid)
        if o["status"] != "pending":
            raise ValueError("当前状态不可取消")
        self.db.update("orders", oid, {"status": "cancelled"})
        p = self.db.query("select * from products where id=?", o["product_id"])
        self.db.update("products", o["product_id"], {"stock": p["stock"] + o["qty"]})
        self.notify.email(self.user.get(o["user_id"])["email"], "订单已取消", f"订单号 {oid}")

    def refund(self, oid):
        uid = self.pay.refund(oid)
        self.notify.email(self.user.get(uid)["email"], "退款成功", f"订单号 {oid}")
```

### 7. 组装（把零件拼起来，只在这一个地方做）

```python
# container.py
class Container:
    def __init__(self, db: Db, cache: Cache, mailer: Mailer):
        notify = NotifyService(mailer)
        self.notify = notify
        self.user = UserService(db, cache, notify)
        self.product = ProductService(db, cache)
        self.pay = PayService(db)
        self.order = OrderService(db, self.product, self.user, self.pay, notify)

# 使用
c = Container(Db(), Cache(), Mailer())
c.order.create(1, 2, 3)
c.order.refund(oid)
```

---

## 三、对比：变化到底在哪？

**核心变化只有一个：**

> 原来 `self.send_email(...)` 是"自己动手"，
> 现在 `self.notify.email(...)` 是"叫专业的人来干"。

| 维度       | 拆分前                             | 拆分后                   |
| ---------- | ---------------------------------- | ------------------------ |
| 下单逻辑   | 又要查库存、又要发邮件、又要查用户 | 只关心订单，其余委托出去 |
| 测试       | 要连 SMTP、Redis                   | 传个假的 `notify` 就行   |
| 改邮件模板 | 改 `ShopService`                   | 只改 `NotifyService`     |
| 定位 bug   | 800 行里翻                         | 直接进对应文件           |

---

## 四、如果不想改调用方？加一层门面（Facade）

旧代码里全是 `shop.create_order(...)`，不想全改：

```python
# facade.py
class ShopFacade:
    """对外保持旧接口，内部转发到新服务"""
    def __init__(self, db, cache, mailer):
        c = Container(db, cache, mailer)
        self._c = c

    # 名字和旧的一模一样，调用方无感
    def register_user(self, name, email, password):
        return self._c.user.register(name, email, password)

    def create_order(self, uid, pid, qty):
        return self._c.order.create(uid, pid, qty)

    def cancel_order(self, oid):
        return self._c.order.cancel(oid)

    def pay(self, oid, amount):
        return self._c.pay.pay(oid, amount)

    def refund(self, oid):
        return self._c.order.refund(oid)
```

这样**行为完全等价，调用方一行不用改**，等你慢慢迁移完再删 Facade。

---

## 五、在 FastAPI 里怎么接？

```python
# deps.py
from functools import lru_cache
from fastapi import Depends

@lru_cache
def get_container() -> Container:
    return Container(Db(), Cache(), Mailer())

def get_order_service(c: Container = Depends(get_container)) -> OrderService:
    return c.order

# routers/order.py
from fastapi import APIRouter, Depends

router = APIRouter(prefix="/orders", tags=["orders"])

@router.post("/")
def create_order(uid: int, pid: int, qty: int,
                 svc: OrderService = Depends(get_order_service)):
    return {"order_id": svc.create(uid, pid, qty)}

@router.post("/{oid}/refund")
def refund(oid: int, svc: OrderService = Depends(get_order_service)):
    svc.refund(oid)
    return {"ok": True}
```

```python
# app.py
from fastapi import FastAPI
from routers import order, user, product

app = FastAPI()
app.include_router(order.router)
app.include_router(user.router)
app.include_router(product.router)
```

原来的 `app.py` 从 800 行变成 10 行。

---

## 六、拆分三步法（照做就行）

1. **先加冒烟测试**，跑一遍所有接口，存下"金标准"。
2. **拆文件不拆类**：如果暂时不敢动结构，先用 Mixin 把方法分到不同文件（过渡方案）。
3. **按业务域拆 Service**，把 `self.xxx()` 的内部调用，换成构造注入的协作对象。
4. **加一层 Facade** 保持旧接口，调用方零改动。
5. 迁移完成后删掉旧类和 Facade。

---

## 总结一句话

> **大 class 的拆法，不是"把方法搬出去"，而是"把内部调用变成依赖注入"。**

`self.send_email()` → `self.notify.email()`，这一个变化，就带来了可测试、可替换、可并行的所有好处。

**拆分前：**

```python
class ShopService:
    def __init__(self, db, redis):
        self.smtp = smtplib.SMTP("smtp.example.com")   # ← 自己造
    
    def send_email(self, to, subject, body):
        self.smtp.sendmail("noreply@shop.com", to, f"Subject: {subject}\n\n{body}")  # ← 内部自己调
        self.logger.info("邮件已发送: %s", to)
    
    def create_order(self, ...):
        self.send_email(...)  
```

**拆分后：**

```python
class OrderService:
    def __init__(self, db, product, user, notify):   # ← 别人递给我
        self.notify = notify
    def create(self, ...):
        self.notify.email(...)   # ← 用递进来的
```

**这个"把 notify 从构造参数传进来"的动作，就是依赖注入。**

