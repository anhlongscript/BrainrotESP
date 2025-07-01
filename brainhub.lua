--[[
    Brainrot Hack GUI v1.0 by dai_ca 🧠
    - ESP (Highlight Brainrot item / player holding it)
    - Auto Teleport to random location when player holds Brainrot
    - GUI Sidebar style like MagmaHub
--]]

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Highlighted = {}

-- UI LIB
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local Window = OrionLib:MakeWindow({Name="🧠 BrainrotHub", HidePremium=false, SaveConfig=false, IntroText="dai_ca script"})

-- CONFIG
local AUTO_TELE_ENABLED = false
local ESP_ENABLED = false

-- FUNCTION: Teleport to random location
local function teleportRandom()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local x = math.random(-200, 200)
    local z = math.random(-200, 200)
    local y = 10
    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(x, y, z)
end

-- FUNCTION: Check if player is holding Brainrot
local function hasBrainrotTool()
    local char = LocalPlayer.Character
    if not char then return false end
    local tool = char:FindFirstChildOfClass("Tool")
    return tool and tool.Name:lower():find("brain") ~= nil
end

-- ESP FUNCTION
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

-- AUTO TELEPORT CHECK LOOP
RunService.RenderStepped:Connect(function()
    if AUTO_TELE_ENABLED and hasBrainrotTool() then
        teleportRandom()
        task.wait(1.5) -- cooldown để không bị spam
    end
end)

-- ESP LOOP
RunService.RenderStepped:Connect(function()
    if not ESP_ENABLED then return end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Tool") and obj.Name:lower():find("brain") then
            highlightObject(obj)
        end
    end
end)

-- GUI: ESP Tab
local espTab = Window:MakeTab({Name="ESP + Tele", Icon="rbxassetid://6031075930", PremiumOnly=false})
espTab:AddToggle({
    Name = "ESP Brainrot",
    Default = false,
    Callback = function(v)
        ESP_ENABLED = v
    end
})
espTab:AddToggle({
    Name = "Auto Teleport khi cướp",
    Default = false,
    Callback = function(v)
        AUTO_TELE_ENABLED = v
    end
})
espTab:AddButton({
    Name = "Teleport ngẫu nhiên",
    Callback = teleportRandom
})

OrionLib:Init()
