local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Hàm kiểm tra có cầm Brainrot
local function holdingBrain()
    local char = LocalPlayer.Character
    if not char then return false end
    local tool = char:FindFirstChildOfClass("Tool")
    return tool and tool.Name:lower():find("brain") ~= nil
end

-- Hàm teleport ngẫu nhiên
local function randomTeleport()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = LocalPlayer.Character.HumanoidRootPart
    local x = math.random(-200, 200)
    local z = math.random(-200, 200)
    local y = 10
    hrp.CFrame = CFrame.new(x, y, z)
end

-- Vòng lặp kiểm tra liên tục
while true do
    if holdingBrain() then
        wait(0.75) -- chờ 1 tí để đảm bảo đã cướp xong
        randomTeleport()
        wait(1.5) -- delay giữa mỗi lần teleport
    end
    wait(0.25)
end
