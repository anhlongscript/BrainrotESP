
--// 🧠 BrainHub v3 - Cướp 1 Brainrot | Full Auto Tele | HUD xịn mịn | by anhlongscript

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

--// Vars
local TeleportEnabled = true
local HucEnabled = true
local LastTeleported = 0
local DelayBetweenTele = 1.5
local Cooldown = false

--// GUI Setup (OrionLib)
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local Window = OrionLib:MakeWindow({
    Name = "🧠 BrainHub v3 | Cướp 1 Brainrot",
    HidePremium = false,
    SaveConfig = false,
    IntroText = "BrainHub v3 Loaded!",
    ConfigFolder = "BrainHubv3"
})

--// ESP Handler
local function createESP(part)
    if part:FindFirstChild("BrainESP") then return end
    local esp = Instance.new("BoxHandleAdornment")
    esp.Name = "BrainESP"
    esp.Size = part.Size
    esp.Color3 = Color3.fromRGB(255, 0, 0)
    esp.Transparency = 0.4
    esp.AlwaysOnTop = true
    esp.ZIndex = 5
    esp.Adornee = part
    esp.Parent = part
end

local function scanESP()
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("Tool") and v.Name:lower():find("brain") then
            local handle = v:FindFirstChild("Handle")
            if handle then createESP(handle) end
        end
    end
end

workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("Tool") and obj.Name:lower():find("brain") then
        local handle = obj:FindFirstChild("Handle")
        if handle then createESP(handle) end
    end
end)

task.spawn(scanESP)

--// Húc Animation
local function playHucAnimation()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://6561188520" -- animation đấm
        local track = humanoid:LoadAnimation(anim)
        track:Play()
    end
end

--// Húc Hiệu Ứng
local function effectBoom()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then
        local part = Instance.new("Part", workspace)
        part.Size = Vector3.new(4, 4, 4)
        part.Position = root.Position
        part.Anchored = true
        part.BrickColor = BrickColor.new("Bright red")
        part.Material = Enum.Material.Neon
        part.CanCollide = false
        game.Debris:AddItem(part, 0.3)
    end
end

--// Kiểm tra đang cầm Brainrot
local function holdingBrain()
    local char = LocalPlayer.Character
    if not char then return false end
    local tool = char:FindFirstChildOfClass("Tool")
    return tool and tool.Name:lower():find("brain") ~= nil
end

--// Tele ngẫu nhiên
local function randomTeleport()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local x = math.random(-200, 200)
    local z = math.random(-200, 200)
    local y = 10
    hrp.CFrame = CFrame.new(x, y, z)
end

--// Hệ thống Teleport thông minh
task.spawn(function()
    while task.wait(0.25) do
        if TeleportEnabled and holdingBrain() and not Cooldown then
            Cooldown = true
            if HucEnabled then
                playHucAnimation()
                effectBoom()
                task.wait(0.4)
            end
            randomTeleport()
            task.wait(DelayBetweenTele)
            Cooldown = false
        end
    end
end)

--// GUI Toggle
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

MainTab:AddToggle({
    Name = "🔁 Auto Teleport khi cướp",
    Default = true,
    Callback = function(Value)
        TeleportEnabled = Value
    end
})

MainTab:AddToggle({
    Name = "💥 Húc khi Teleport",
    Default = true,
    Callback = function(Value)
        HucEnabled = Value
    end
})

MainTab:AddLabel("🎯 BrainHub v3 - anhlongscript")

OrionLib:Init()
