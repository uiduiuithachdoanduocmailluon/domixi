repeat task.wait() until game:IsLoaded()
if not game:IsLoaded() then game:IsLoaded():Wait(5) end
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")


local Initialize = function()
	UserInputService.WindowFocusReleased:Connect(WindowFocusReleasedFunction)
	UserInputService.WindowFocused:Connect(WindowFocusedFunction)
	return
end
Initialize()
UserSettings():GetService("UserGameSettings").MasterVolume = 0
local decalsyeeted = true
local g = game
local w = g.Workspace
local l = g.Lighting
local t = w.Terrain
sethiddenproperty(l,"Technology",2)
sethiddenproperty(t,"Decoration",false)
t.WaterWaveSize = 0
t.WaterWaveSpeed = 0
t.WaterReflectance = 0
t.WaterTransparency = 0
l.GlobalShadows = 0
l.FogEnd = 9e9
l.Brightness = 0
settings().Rendering.QualityLevel = "Level01"
for i, v in pairs(w:GetDescendants()) do
    if v:IsA("BasePart") and not v:IsA("MeshPart") then
        v.Material = "Plastic"
        v.Reflectance = 0
    elseif (v:IsA("Decal") or v:IsA("Texture")) and decalsyeeted then
        v.Transparency = 1
    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
        v.Lifetime = NumberRange.new(0)
    elseif v:IsA("Explosion") then
        v.BlastPressure = 1
        v.BlastRadius = 1
    elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
        v.Enabled = false
    elseif v:IsA("MeshPart") and decalsyeeted then
        v.Material = "Plastic"
        v.Reflectance = 0
        v.TextureID = 10385902758728957
    elseif v:IsA("SpecialMesh") and decalsyeeted  then
        v.TextureId=0
    elseif v:IsA("ShirtGraphic") and decalsyeeted then
        v.Graphic=1
    elseif (v:IsA("Shirt") or v:IsA("Pants")) and decalsyeeted then
        v[v.ClassName.."Template"]=1
    end
end
for i = 1,#l:GetChildren() do
    e=l:GetChildren()[i]
    if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
        e.Enabled = false
    end
end
w.DescendantAdded:Connect(function(v)
   if v:IsA("BasePart") and not v:IsA("MeshPart") then
        v.Material = "Plastic"
        v.Reflectance = 0
    elseif v:IsA("Decal") or v:IsA("Texture") and decalsyeeted then
        v.Transparency = 1
    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
        v.Lifetime = NumberRange.new(0)
    elseif v:IsA("Explosion") then
        v.BlastPressure = 1
        v.BlastRadius = 1
    elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
        v.Enabled = false
    elseif v:IsA("MeshPart") and decalsyeeted then
        v.Material = "Plastic"
        v.Reflectance = 0
        v.TextureID = 10385902758728957
    elseif v:IsA("SpecialMesh") and decalsyeeted then
        v.TextureId=0
    elseif v:IsA("ShirtGraphic") and decalsyeeted then
        v.ShirtGraphic=1
    elseif (v:IsA("Shirt") or v:IsA("Pants")) and decalsyeeted then
        v[v.ClassName.."Template"]=1
            end
        end)

  for i, v in next, workspace:GetDescendants() do
        pcall(function()
            v.Transparency = 1
        end)
    end  
    a = workspace
    a.DescendantAdded:Connect(function(v)
        pcall(function()
            v.Transparency = 1
        end)
    end)

-- ===============================
-- FAST MODE + DISABLE VFX
-- ===============================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- ========= FAST MODE =========
local function EnableFastMode()
    if _G.FastMode then return end

    _G.FastMode = true
    _G.reducing = true
    _G.FastModeCache = {}

    local Map = workspace:WaitForChild("Map")
    local Unloaded = ReplicatedStorage:WaitForChild("Unloaded")
    local SmoothPlastic = Enum.Material.SmoothPlastic

    local function optimize(descendants)
        local start = os.clock()
        for _, obj in ipairs(descendants) do
            if obj:IsA("BasePart") then
                _G.FastModeCache[obj] = obj.Material
                obj.Material = SmoothPlastic
            elseif obj:IsA("Texture") and not obj:GetAttribute("Offset") then
                obj:Destroy()
            end

            if os.clock() - start > 0.008 then
                task.wait()
                start = os.clock()
            end
        end
    end

    optimize(Map:GetDescendants())
    optimize(Unloaded:GetDescendants())

    local Optimizer = LocalPlayer.PlayerScripts:FindFirstChild("OptimizerClientActor")
    if Optimizer and Optimizer.SendMessage then
        Optimizer:SendMessage("Optimize", true)
    end

    warn("⚡ FastMode ENABLED")
end

-- ========= DISABLE ALLY VFX =========
local function DisableVFX()
    LocalPlayer:SetAttribute("DisableAllyEffects", true)
    warn("❌ Ally VFX DISABLED")
end

-- ========= DISABLE CAMERA SHAKE =========
local function DisableCameraShake()
    pcall(function()
        local cs1 = require(ReplicatedStorage.Util.CameraShake)
        if cs1.SetEnabled then
            cs1:SetEnabled(false)
        end
    end)

    pcall(function()
        local cs2 = require(ReplicatedStorage.Util.CameraShaker)
        if cs2.SetEnabled then
            cs2:SetEnabled(false)
        end
    end)

    pcall(function()
        ReplicatedStorage.Remotes.ChangeSetting:FireServer("CameraShake", false)
    end)

    warn("❌ CameraShake DISABLED")
end

-- ========= DISABLE BACKGROUND MUSIC =========
local function DisableMusic()
    pcall(function()
        game.ReplicatedStorage.Events.ToggleMusic.Event:Fire(true)
    end)

    for _, s in pairs(workspace._WorldOrigin.Sounds.Locations:GetChildren()) do
        if s:IsA("Sound") then
            s:Pause()
        end
    end

    warn("🔇 Background Music DISABLED")
end

-- ========= RUN ALL =========
EnableFastMode()
DisableVFX()
DisableCameraShake()
DisableMusic()
