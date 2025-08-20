local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Backpack = LocalPlayer:WaitForChild("Backpack")

-- อ่านค่า TargetPets และ WebhookURL จากฝั่งผู้ใช้
local targetPets = _G.TargetPets or {}
local webhookURL = WebhookURL

-- รายชื่อสัตว์ทั้งหมดในเกม
local AllPets = {
    "Starfish","Crab","Seagull","Bunny","Dog","Golden Lab","Dairy Cow","Bee","Bacon Pig","Jackalope",
    "Flamingo","Toucan","Sea Turtle","Orangutan","Seal","Honey Bee","Wasp","Grey Mouse","Tarantula Hawk",
    "Caterpillar","Snail","Petal Bee","Moth","Scarlet Macaw","Ostrich","Peacock","Capybara","Hotdog Daschund",
    "Brown Mouse","Giant Ant","Praying Mantis","Red Giant Ant","Squirrel","Bear Bee","Butterfly","Pack Bee",
    "Mimic Octopus","Golem","Red Fox","Dragonfly","Disco Bee","Queen Bee","Lobster Thermidor","Golden Goose",
    "Bagel Bunny","Black Bunny","Cat","Chicken","Deer","Maneki neko","Sunny Side Chicken","Kiwi","Hedgehog",
    "Monkey","Orange Tabby","Pig","Rooster","Spotted Deer","Nihonzaru","Tsuchinoko","Pancake Mole","Cow",
    "Polar Bear","Sea Otter","Silver Monkey","Panda","Blood Hedgehog","Frog","Mole","Moon Cat","Bald Eagle",
    "Turtle","Sand Snake","Meerkat","Parasaurolophus","Iguanodon","Pachycephalosaurus","Raptor","Triceratops",
    "Stegosaurus","Football","Kodama","Corrupted Kodama","Tanuki","Tanchozuru","Sushi Bear","Hamster",
    "Chicken Zombie","Owl","Echo Frog","Cooked Owl","Blood Kiwi","Night Owl","Hyacinth Macaw","Axolotl",
    "Dilophosaurus","Ankylosaurus","Pterodactyl","Brontosaurus","Kappa","Koi","Spaghetti Sloth","Mochi Mouse",
    "Junkbot","Gorilla Chef","Raiju","Blood Owl","Raccoon","Fennec Fox","Spinosaurus","T-Rex",
    "French Fry Ferret","Firefly","Golden Bee","Red Dragon"
}

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
        request({
            Url = webhookURL,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(data)
        })
    end)
end

sendWebhook()
