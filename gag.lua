local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Backpack = LocalPlayer:WaitForChild("Backpack")

local targetPets = _G.TargetPets or {}
local webhookURL = WebhookURL

local function countTargetPets()
    local petCounts = {}
    for _, petName in ipairs(targetPets) do
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
        HttpService:PostAsync(webhookURL, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
    end)
end

sendWebhook()
