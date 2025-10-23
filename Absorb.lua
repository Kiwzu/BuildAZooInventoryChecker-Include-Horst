

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait() and Players.LocalPlayer


if not localPlayer then
    repeat task.wait() until Players.LocalPlayer
    localPlayer = Players.LocalPlayer
end

repeat task.wait() until localPlayer.PlayerGui

print("[Inventory Checker] Player loaded successfully!")


local CONFIG = getgenv().InventoryCheckerConfig or {
    RequiredItems = {
        Pets = {},
        Eggs = {},
        Fruits = {}
    },
    DescriptionTemplate = "🥚 Eggs: {eggs}",
    CheckInterval = 5,
    DebugMode = true
}



local function getDataFolder()
    return localPlayer.PlayerGui:FindFirstChild("Data")
end

local function debugPrint(message)
    if CONFIG.DebugMode then
        print("[Inventory Checker] " .. message)
    end
end


local function getPetCount(dataContainer, petType)
    local count = 0
    local petDataFolder = dataContainer and dataContainer:FindFirstChild("Pets")
    
    if petDataFolder then
        for _, petData in ipairs(petDataFolder:GetChildren()) do
            if petData:IsA("Configuration") and not petData:GetAttribute("D") then
                local pType = petData:GetAttribute("T")
                if pType == petType then
                    count = count + 1
                end
            end
        end
    end
    
    return count
end

local function getEggCount(dataContainer, eggType)
    local count = 0
    local eggDataFolder = dataContainer and dataContainer:FindFirstChild("Egg")
    
    if eggDataFolder then
        for _, eggData in ipairs(eggDataFolder:GetChildren()) do
            if eggData:IsA("Configuration") and not eggData:GetAttribute("D") then
                local eType = eggData:GetAttribute("T")
                if eType == eggType then
                    count = count + 1
                end
            end
        end
    end
    
    return count
end

local function getTotalEggCount(dataContainer)
    local totalEggs = 0
    local eggDataFolder = dataContainer and dataContainer:FindFirstChild("Egg")
    
    if eggDataFolder then
        for _, eggData in ipairs(eggDataFolder:GetChildren()) do
            if eggData:IsA("Configuration") and not eggData:GetAttribute("D") then
                local eType = eggData:GetAttribute("T")
                if eType then
                    totalEggs = totalEggs + 1
                end
            end
        end
    end
    
    return totalEggs
end

local function getAllEggTypes(dataContainer)
    local eggCounts = {}
    local eggDataFolder = dataContainer and dataContainer:FindFirstChild("Egg")
    
    if eggDataFolder then
        for _, eggData in ipairs(eggDataFolder:GetChildren()) do
            if eggData:IsA("Configuration") and not eggData:GetAttribute("D") then
                local eggType = eggData:GetAttribute("T")
                if eggType then
                    eggCounts[eggType] = (eggCounts[eggType] or 0) + 1
                end
            end
        end
    end
    
    return eggCounts
end

local function getFruitCount(dataContainer, fruitName)
    local assetData = dataContainer and dataContainer:FindFirstChild("Asset")
    
    if assetData then
        local count = assetData:GetAttribute(fruitName)
        if type(count) == "number" then
            return count
        end
    end
    
    return 0
end


local function checkInventory()
    local dataFolder = getDataFolder()
    
    if not dataFolder then
        debugPrint("Waiting for game data to load...")
        return false, 0, {}
    end
    
    local allRequirementsMet = true
    local totalEggs = getTotalEggCount(dataFolder)
    local allEggTypes = getAllEggTypes(dataFolder)
    
   
    if CONFIG.RequiredItems.Pets and type(CONFIG.RequiredItems.Pets) == "table" then
        local hasPets = false
        for _ in pairs(CONFIG.RequiredItems.Pets) do
            hasPets = true
            break
        end
        
        if hasPets then
            debugPrint("=== Checking Pets ===")
            for petType, requiredCount in pairs(CONFIG.RequiredItems.Pets) do
                local currentCount = getPetCount(dataFolder, petType)
                debugPrint(string.format("%s: %d/%d", petType, currentCount, requiredCount))
                
                if currentCount < requiredCount then
                    allRequirementsMet = false
                end
            end
        end
    end
    
   
    if CONFIG.RequiredItems.Eggs and type(CONFIG.RequiredItems.Eggs) == "table" then
        local hasEggs = false
        for _ in pairs(CONFIG.RequiredItems.Eggs) do
            hasEggs = true
            break
        end
        
        if hasEggs then
            debugPrint("=== Checking Eggs ===")
            for eggType, requiredCount in pairs(CONFIG.RequiredItems.Eggs) do
                local currentCount = getEggCount(dataFolder, eggType)
                debugPrint(string.format("%s: %d/%d", eggType, currentCount, requiredCount))
                
                if currentCount < requiredCount then
                    allRequirementsMet = false
                end
            end
        end
    end
    
    debugPrint(string.format("Total Eggs in Inventory: %d", totalEggs))
    
   
    if CONFIG.RequiredItems.Fruits and type(CONFIG.RequiredItems.Fruits) == "table" then
        local hasFruits = false
        for _ in pairs(CONFIG.RequiredItems.Fruits) do
            hasFruits = true
            break
        end
        
        if hasFruits then
            debugPrint("=== Checking Fruits ===")
            for fruitName, requiredCount in pairs(CONFIG.RequiredItems.Fruits) do
                local currentCount = getFruitCount(dataFolder, fruitName)
                debugPrint(string.format("%s: %d/%d", fruitName, currentCount, requiredCount))
                
                if currentCount < requiredCount then
                    allRequirementsMet = false
                end
            end
        end
    end
    
    return allRequirementsMet, totalEggs, allEggTypes
end



print("[Inventory Checker] Starting checker (NO GUI mode)...")
print("[Inventory Checker] Config loaded from getgenv().InventoryCheckerConfig")

task.spawn(function()
    task.wait(3) -- รอให้เกมโหลดเพิ่มขึ้น
    
    -- ตรวจสอบว่า PlayerGui พร้อมใช้งาน
    if not localPlayer or not localPlayer.PlayerGui then
        warn("[Inventory Checker] PlayerGui not found! Retrying...")
        repeat task.wait(1) until localPlayer and localPlayer.PlayerGui
    end
    
    debugPrint("PlayerGui ready, starting inventory check...")
    
    while true do
        local success, result1, result2, result3 = pcall(checkInventory)
        local requirementsMet = result1
        local eggCount = result2
        local eggTypes = result3
        
        if success and requirementsMet then
            debugPrint("ALL REQUIREMENTS MET!")
            
           
            local eggList = {}
            if eggTypes and type(eggTypes) == "table" then
                for eggName, count in pairs(eggTypes) do
                    table.insert(eggList, string.format("%s(%d)", eggName, count))
                end
            end
            
            local eggText = #eggList > 0 and table.concat(eggList, ", ") or "None"
            
           
            local descriptionMessage = CONFIG.DescriptionTemplate:gsub("{eggs}", eggText)
            
            
            if _G.Horst_AccountChangeDone then
                _G.Horst_AccountChangeDone()
                debugPrint("Sent Done status!")
            end
            
            
            if _G.Horst_SetDescription then
                _G.Horst_SetDescription(descriptionMessage)
                debugPrint("Set description: " .. descriptionMessage)
            end
            
            break 
        elseif not success then
            debugPrint("Error: " .. tostring(result1))
        else
            debugPrint(" Requirements not met yet, checking again in " .. CONFIG.CheckInterval .. " seconds...")
        end
        
        task.wait(CONFIG.CheckInterval)
    end
    
    debugPrint("Checker finished!")
end)
