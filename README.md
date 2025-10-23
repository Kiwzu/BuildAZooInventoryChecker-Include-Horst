# 🎒 Inventory Checker (No GUI)

เครื่องมือตรวจสอบ Inventory อัตโนมัติสำหรับเกม Roblox แบบไม่มี GUI

## 🚀 วิธีใช้งาน

### วิธีที่ 1: ใช้ผ่าน Loadstring (แนะนำ)

```lua
-- ตั้งค่าก่อน
getgenv().InventoryCheckerConfig = {
    RequiredItems = {
        Pets = {},
        Eggs = {
            ["HalloweenEgg"] = 6,
        },
        Fruits = {}
    },
    DescriptionTemplate = "🥚 Eggs: {eggs} | 💎 Diamond: 500",
    CheckInterval = 5,
    DebugMode = true
}

-- โหลดสคริปต์
loadstring(game:HttpGet("https://raw.githubusercontent.com/YourUsername/InventoryChecker/main/main.lua"))()
```

### วิธีที่ 2: ใช้ผ่าน Pastebin

```lua
getgenv().InventoryCheckerConfig = { ... }
loadstring(game:HttpGet("https://pastebin.com/raw/YOUR_CODE"))()
```

## ⚙️ การตั้งค่า

### RequiredItems

กำหนดจำนวนไอเทมที่ต้องการเช็ค:

```lua
RequiredItems = {
    Pets = {
        ["Cerberus"] = 5,      -- ต้องการ Cerberus 5 ตัว
        ["Phoenix"] = 2,        -- ต้องการ Phoenix 2 ตัว
    },
    
    Eggs = {
        ["HalloweenEgg"] = 6,   -- ต้องการ HalloweenEgg 6 ฟอง
        ["DragonEgg"] = 3,      -- ต้องการ DragonEgg 3 ฟอง
    },
    
    Fruits = {
        ["GoldMango"] = 10,     -- ต้องการ GoldMango 10 ผล
        ["Durian"] = 5,         -- ต้องการ Durian 5 ผล
    }
}
```

### DescriptionTemplate

กำหนดข้อความที่จะแสดงเมื่อครบเงื่อนไข:

```lua
-- ใช้ {eggs} เป็น placeholder สำหรับรายการไข่
DescriptionTemplate = "🥚 Eggs: {eggs} | 💎 Diamond: 500 | ⚔️ Class: Cyborg"
```

**ผลลัพธ์:** 
```
🥚 Eggs: HalloweenEgg(6), DragonEgg(3) | 💎 Diamond: 500 | ⚔️ Class: Cyborg
```

### CheckInterval

กำหนดระยะเวลาในการเช็คซ้ำ (วินาที):

```lua
CheckInterval = 5  -- เช็คทุก 5 วินาที
```

### DebugMode

เปิด/ปิดการแสดง debug message:

```lua
DebugMode = true   -- เปิด
DebugMode = false  -- ปิด
```

## 📋 ตัวอย่างการใช้งาน

### ตัวอย่าง 1: เช็คแค่ไข่

```lua
getgenv().InventoryCheckerConfig = {
    RequiredItems = {
        Pets = {},
        Eggs = {
            ["HalloweenEgg"] = 6,
        },
        Fruits = {}
    },
    DescriptionTemplate = "🥚 {eggs}",
    CheckInterval = 5,
    DebugMode = true
}
loadstring(game:HttpGet("YOUR_URL"))()
```

### ตัวอย่าง 2: เช็คหลายอย่างพร้อมกัน

```lua
getgenv().InventoryCheckerConfig = {
    RequiredItems = {
        Pets = {
            ["Cerberus"] = 5,
        },
        Eggs = {
            ["HalloweenEgg"] = 6,
            ["DragonEgg"] = 3,
        },
        Fruits = {
            ["GoldMango"] = 10,
        }
    },
    DescriptionTemplate = "🥚 {eggs} | 🔥 Ready",
    CheckInterval = 3,
    DebugMode = false
}
loadstring(game:HttpGet("YOUR_URL"))()
```

### ตัวอย่าง 3: แสดงไข่ทั้งหมดโดยไม่เช็คเงื่อนไข

```lua
getgenv().InventoryCheckerConfig = {
    RequiredItems = {
        Pets = {},
        Eggs = {},
        Fruits = {}
    },
    DescriptionTemplate = "🎒 Inventory: {eggs}",
    CheckInterval = 10,
    DebugMode = true
}
loadstring(game:HttpGet("YOUR_URL"))()
```

## 🔧 ฟีเจอร์

- ✅ เช็คสัตว์เลี้ยง (Pets)
- ✅ เช็คไข่ (Eggs) พร้อมแสดงรายละเอียด
- ✅ เช็คผลไม้/ไอเทม (Fruits)
- ✅ ส่ง status เมื่อครบเงื่อนไข (_G.Horst_AccountChangeDone)
- ✅ ตั้งค่า Description อัตโนมัติ (_G.Horst_SetDescription)
- ✅ Debug mode
- ✅ ตั้งค่าได้จากภายนอก

## 📝 หมายเหตุ

- สคริปต์จะทำงานต่อเนื่องจนกว่าจะครบเงื่อนไข
- เมื่อครบเงื่อนไข จะหยุดทำงานอัตโนมัติ
- รองรับการใช้งานกับ Remote Executor (LotteryRE)

## 🐛 การแก้ไขปัญหา

### Error: attempt to index nil with 'PlayerGui'
- สคริปต์จะรอให้ Player โหลดอัตโนมัติ
- หากยังเกิดปัญหา ให้เพิ่มเวลารอใน `task.wait(3)`

### ไม่แสดง Debug Message
- ตรวจสอบว่า `DebugMode = true`
- เปิด Developer Console (F9) เพื่อดู log

### ไม่ส่ง Status/Description
- ตรวจสอบว่ามี `_G.Horst_AccountChangeDone` และ `_G.Horst_SetDescription`
- ต้องโหลดสคริปต์หลักก่อน

## 📄 License

MIT License - ใช้งานได้ฟรี

## 👨‍💻 Author

สร้างโดย: [Kiwzu]

---

⭐ ถ้าชอบอย่าลืมกด Star ด้วยนะครับ!
