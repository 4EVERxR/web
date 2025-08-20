-- Losting เวอร์ชันตรวจสอบสัตว์และส่ง Webhook

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Backpack = LocalPlayer:WaitForChild("Backpack")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- ฟังก์ชันเก็บสัตว์ทั้งหมดจาก Backpack + Character
local function getAllPets()
    local pets = {}
    for _, item in ipairs(Backpack:GetChildren()) do
        table.insert(pets, item)
    end
    for _, item in ipairs(Character:GetChildren()) do
        table.insert(pets, item)
    end
    return pets
end

-- นับสัตว์ตาม _G.TargetPets
local function countTargetPets()
    local petCounts = {}
    for _, name in ipairs(_G.TargetPets) do
        petCounts[name] = 0
    end

    for _, item in ipairs(getAllPets()) do
        for _, target in ipairs(_G.TargetPets) do
            if item.Name:find(target) then
                petCounts[target] = petCounts[target] + 1
            end
        end
    end
    return petCounts
end

-- ส่ง Webhook
local function sendWebhook()
    local counts = countTargetPets()
    local petList = ""
    local hasPet = false

    for name, count in pairs(counts) do
        if count > 0 then hasPet = true end
        petList = petList .. name .. " x" .. tostring(count) .. "\n"
        print("ตรวจเจอ:", name, "จำนวน:", count)
    end

    if not hasPet then
        petList = "No selected pets found."
        print(petList)
    end

    local data = {
        content = nil,
        embeds = {{
            color = 3447003, -- สีฟ้า
            fields = {
                { name = " ⚠️  Name :", value = "`" .. LocalPlayer.Name .. "`" },
                { name = " 🧺  Show Pets :", value = "`" .. petList .. "`" }
            }
        }},
        attachments = {}
    }

    local requestFunc = http_request or request or (syn and syn.request)
    if _G.WebhookURL and typeof(requestFunc) == "function" then
        pcall(function()
            requestFunc({
                Url = _G.WebhookURL,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = HttpService:JSONEncode(data)
            })
            print("ส่ง Webhook เรียบร้อย")
        end)
    end
end

-- เรียกส่งผลลัพธ์ตอนเริ่ม
sendWebhook()

-- เชื่อมต่อ event สำหรับ Backpack และ Character
Backpack.ChildAdded:Connect(sendWebhook)
Character.ChildAdded:Connect(sendWebhook)
