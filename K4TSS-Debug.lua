-- K4TSS DEBUG — cari bagian mana yang error
-- Lihat notifikasi / console untuk tahu sampai mana berhasil

local function log(msg)
    print("[K4TSS DEBUG] " .. msg)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "K4TSS Debug",
            Text = msg,
            Duration = 6,
        })
    end)
end

-- TEST 1: Services
local ok1 = pcall(function()
    local _ = game:GetService("Players")
    local _ = game:GetService("UserInputService")
    local _ = game:GetService("TweenService")
end)
log(ok1 and "1 Services OK" or "1 Services GAGAL")
task.wait(0.3)

-- TEST 2: LocalPlayer & Character
local ok2 = pcall(function()
    local LP = game:GetService("Players").LocalPlayer
    assert(LP ~= nil)
    if not LP.Character then LP.CharacterAdded:Wait() end
    assert(LP.Character ~= nil)
end)
log(ok2 and "2 Character OK" or "2 Character GAGAL")
task.wait(0.3)

-- TEST 3: ScreenGui ke PlayerGui
local ok3 = pcall(function()
    local LP = game:GetService("Players").LocalPlayer
    local sg = Instance.new("ScreenGui")
    sg.Name = "K4TSSDebugGui"
    sg.ResetOnSpawn = false
    sg.Parent = LP.PlayerGui
    task.wait(0.1)
    sg:Destroy()
end)
log(ok3 and "3 PlayerGui OK" or "3 PlayerGui GAGAL")
task.wait(0.3)

-- TEST 4: ScreenGui ke CoreGui
local ok4 = pcall(function()
    local sg = Instance.new("ScreenGui")
    sg.Name = "K4TSSDebugGui2"
    sg.ResetOnSpawn = false
    sg.Parent = game:GetService("CoreGui")
    task.wait(0.1)
    sg:Destroy()
end)
log(ok4 and "4 CoreGui OK" or "4 CoreGui GAGAL")
task.wait(0.3)

-- TEST 5: Buat Frame + Label (GUI nyata)
local ok5 = pcall(function()
    local LP = game:GetService("Players").LocalPlayer
    local sg = Instance.new("ScreenGui")
    sg.Name = "K4TSSDebugFrame"
    sg.ResetOnSpawn = false
    sg.DisplayOrder = 999
    sg.IgnoreGuiInset = true

    local f = Instance.new("Frame", sg)
    f.Size = UDim2.new(0, 220, 0, 50)
    f.Position = UDim2.new(0.5, -110, 0, 10)
    f.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)

    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, 0, 1, 0)
    l.BackgroundTransparency = 1
    l.TextColor3 = Color3.fromRGB(80, 220, 100)
    l.Font = Enum.Font.GothamBold
    l.TextSize = 13
    l.Text = "GUI BERFUNGSI - K4TSS DEBUG"

    local parented = false
    pcall(function() sg.Parent = LP.PlayerGui; parented = true end)
    if not parented then sg.Parent = game:GetService("CoreGui") end

    task.delay(8, function() pcall(function() sg:Destroy() end) end)
end)
log(ok5 and "5 Frame+Label OK - lihat layar!" or "5 Frame GAGAL")
task.wait(0.3)

-- TEST 6: TweenService
local ok6 = pcall(function()
    local ts = game:GetService("TweenService")
    local f = Instance.new("Frame")
    f.Size = UDim2.new(0,10,0,10)
    f.BackgroundColor3 = Color3.fromRGB(255,0,0)
    local tw = ts:Create(f, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0,255,0)})
    tw:Play()
    f:Destroy()
end)
log(ok6 and "6 TweenService OK" or "6 TweenService GAGAL")
task.wait(0.3)

-- TEST 7: UIListLayout + ScrollingFrame
local ok7 = pcall(function()
    local f = Instance.new("ScrollingFrame")
    f.Size = UDim2.new(0,100,0,100)
    f.CanvasSize = UDim2.new(0,0,0,0)
    f.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local ul = Instance.new("UIListLayout", f)
    ul.SortOrder = Enum.SortOrder.LayoutOrder
    f:Destroy()
end)
log(ok7 and "7 ScrollingFrame OK" or "7 ScrollingFrame GAGAL")
task.wait(0.3)

-- TEST 8: UIStroke
local ok8 = pcall(function()
    local f = Instance.new("Frame")
    local st = Instance.new("UIStroke", f)
    st.Color = Color3.fromRGB(255,0,0)
    st.Thickness = 1
    f:Destroy()
end)
log(ok8 and "8 UIStroke OK" or "8 UIStroke GAGAL")
task.wait(0.3)

log("SELESAI! Screenshot semua notifikasi dan kirim.")
