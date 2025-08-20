local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Backpack = LocalPlayer:WaitForChild("Backpack")

local function countTargetPets()
    local petCounts = {}
    for _, petName in ipairs(_G.TargetPets) do
        petCounts[petName] = 0
    end

    for _, item in ipairs(Backpack:GetChildren()) do
        local baseName = item.Name:match("^(.-) %[") or item.Name
        if petCounts[baseName] ~= nil then
            petCounts[baseName] = petCounts[baseName] + 1
        end
    end

    return petCounts
end

local function sendWebhook()
    local counts = countTargetPets()
    local petList = ""
    for petName, count in pairs(counts) do
        petList = petList .. petName .. " x" .. tostring(count) .. "\n"
    end

    if petList == "" then
        petList = "No selected pets found."
    end

    local data = {
        content = nil,
        embeds = {{
            color = 3447003,
            fields = {
                { name = " ⚠️  Name :", value = "`" .. LocalPlayer.Name .. "`" },
                { name = " 🧺  Show Pets :", value = "`" .. petList .. "`" }
            }
        }},
        attachments = {}
    }

    pcall(function()
        request({
            Url = WebhookURL,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(data)
        })
    end)
end

sendWebhook()
