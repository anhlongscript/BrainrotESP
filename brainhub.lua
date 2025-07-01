--[[
    Brainrot Hack GUI v1.1 by dai_ca 🧠
    - ESP Brainrot item
    - Auto Teleport to random spot after steal
    - Anti-Kick system
    - Adjustable Speed & Jump
    - Designed for Godwave Executor
--]]

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- LIBRARY
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local Window = OrionLib:MakeWindow({Name="🧠 BrainrotGodHub", HidePremium=false, SaveConfig=false, IntroText="Loaded by dai_ca"})

-- VARS
local ESP_ENABLED = false
local AUTO_TELE_ENABLED = false
local ANTI_KICK_ENABLED = false
local SPEED = 16
local JUMP = 50
local Highlighted = {}

-- FUNCTIONS
local function teleportRandom()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local x = math.random(-200, 200)
    local z = math.random(-200, 200)
    local y = 10
    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(x, y, z)
end

local function hasBrainrotTool()
    local char = LocalPlayer.Character
    if not char then return false end
    local tool = char:FindFirstChildOfClass("Tool")
    return tool and tool.Name:lower():find("brain") ~= nil
end

local function highlightObject(obj)
    if not ESP_ENABLED or Highlighted[obj] then return end
    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.new(1, 0, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.new(1, 1, 0)
    highlight.OutlineTransparency = 0
    highlight.Adornee = obj
    highlight.Parent = CoreGui
    Highlighted[obj] = highlight
end

-- RENDER LOOP
RunService.RenderStepped:Connect(function()
    -- ESP
    if ESP_ENABLED then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Tool") and obj.Name:lower():find("brain") then
                highlightObject(obj)
            end
        end
    end
    -- Auto Teleport
    if AUTO_TELE_ENABLED and hasBrainrotTool() then
        teleportRandom()
        task.wait(1.5)
    end
end)

-- ANTI KICK
RunService.Stepped:Connect(function()
    if ANTI_KICK_ENABLED and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        if hrp.Velocity.Magnitude > 100 then
            hrp.Velocity = Vector3.new(0, hrp.Velocity.Y, 0)
        end
    end
end)

-- GUI
local tab = Window:MakeTab({Name="Brainrot Tools", Icon="rbxassetid://6031075930", PremiumOnly=false})

tab:AddToggle({
    Name = "ESP Brainrot",
    Default = false,
    Callback = function(v) ESP_ENABLED = v end
})

tab:AddToggle({
    Name = "Auto Teleport khi cướp",
    Default = false,
    Callback = function(v) AUTO_TELE_ENABLED = v end
})

tab:AddToggle({
    Name = "Anti-Kick",
    Default = false,
    Callback = function(v) ANTI_KICK_ENABLED = v end
})

tab:AddButton({
    Name = "Teleport ngẫu nhiên",
    Callback = teleportRandom
})

tab:AddSlider({
    Name = "Speed",
    Min = 16,
    Max = 120,
    Default = 16,
    Callback = function(v)
        SPEED = v
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = v
        end
    end
})

tab:AddSlider({
    Name = "Jump Power",
    Min = 50,
    Max = 200,
    Default = 50,
    Callback = function(v)
        JUMP = v
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = v
        end
    end
})

OrionLib:Init()
