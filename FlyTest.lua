-- FLY TOGGLE SIMPLE by K4TSS
-- Tekan F = Fly ON/OFF
-- WASD = gerak, Space = naik, LeftShift = turun

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

local flyOn = false
local flySpeed = 50
local bv, bg = nil, nil
local flyThread = nil

local function getHRP()
    local c = LP.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function getHum()
    local c = LP.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function stopFly()
    flyOn = false
    if flyThread then task.cancel(flyThread); flyThread = nil end
    if bv and bv.Parent then bv:Destroy() end
    if bg and bg.Parent then bg:Destroy() end
    bv, bg = nil, nil
    local h = getHum()
    if h then h.PlatformStand = false end
    print("[FLY] OFF")
end

local function startFly()
    local hrp = getHRP()
    local hum = getHum()
    if not hrp or not hum then print("[FLY] Karakter belum siap!"); return end

    flyOn = true
    hum.PlatformStand = true

    bv = Instance.new("BodyVelocity", hrp)
    bv.Velocity = Vector3.zero
    bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)

    bg = Instance.new("BodyGyro", hrp)
    bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    bg.P = 1e4
    bg.CFrame = hrp.CFrame

    print("[FLY] ON — WASD gerak, Space naik, Shift turun")

    flyThread = task.spawn(function()
        local cam = workspace.CurrentCamera
        while flyOn do
            local hrp2 = getHRP()
            if not hrp2 then stopFly(); break end

            local dir = Vector3.zero
            local cf = cam.CFrame

            if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cf.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cf.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cf.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cf.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space)     then dir += Vector3.new(0,1,0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then dir -= Vector3.new(0,1,0) end

            bv.Velocity = dir.Magnitude > 0 and dir.Unit * flySpeed or Vector3.zero
            bg.CFrame = CFrame.new(hrp2.Position, hrp2.Position + cf.LookVector)

            task.wait()
        end
    end)
end

-- Toggle dengan tombol F
UIS.InputBegan:Connect(function(inp, proc)
    if proc then return end
    if inp.KeyCode == Enum.KeyCode.F then
        if flyOn then stopFly() else startFly() end
    end
end)

-- Stop fly saat respawn
LP.CharacterAdded:Connect(function()
    if flyOn then stopFly() end
end)

print("[FLY SCRIPT] Loaded! Tekan F untuk toggle fly.")
