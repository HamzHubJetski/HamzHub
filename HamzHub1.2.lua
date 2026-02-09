--// HamzHub - Fish It (Stabil Version)

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

--// Window
local Window = Rayfield:CreateWindow({
   Name = "HamzHub - Blatant Instant",
   LoadingTitle = "HamzHub",
   LoadingSubtitle = "Fish It Blatant",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "HamzHub",
      FileName = "Config"
   },
   KeySystem = false
})

--// Tabs
local MainTab = Window:CreateTab("Main", 4483362458)
local TeleTab = Window:CreateTab("Teleports", 4483362458)

--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character, humanoidRootPart

--// Character handler (ANTI ERROR PAS MATI)
local function setupCharacter(char)
   character = char
   humanoidRootPart = char:WaitForChild("HumanoidRootPart", 5)
end

setupCharacter(player.Character or player.CharacterAdded:Wait())
player.CharacterAdded:Connect(setupCharacter)

--// Remotes
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local CastLine = Remotes:WaitForChild("CastLine")
local ReelIn = Remotes:WaitForChild("ReelIn")
local ShakeRemote = Remotes:WaitForChild("Shake")

--// State
local autoFish = false
local instantFishing = false
local blatantMode = false
local fishingThread = false

--// Teleport Locations
local TPs = {
   Spawn = Vector3.new(0, 12, 0),
   Merchant = Vector3.new(-50, 8, 100),
   BestSpot1 = Vector3.new(200, 8, -300), -- Ghostfin
   BestSpot2 = Vector3.new(-150, 8, 250),
   Island1 = Vector3.new(500, 55, 0)
}

--// Safe Teleport
local function teleport(pos)
   if humanoidRootPart then
      humanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 2, 0))
   end
end

--// Auto Fishing Loop (ANTI DOUBLE LOOP)
local function startFishing()
   if fishingThread then return end
   fishingThread = true

   task.spawn(function()
      while autoFish do
         pcall(function()
            CastLine:FireServer()
            task.wait(0.15)

            if blatantMode then
               ReelIn:FireServer()
               ShakeRemote:FireServer("Perfect")
               task.wait(0.1)

            elseif instantFishing then
               ReelIn:FireServer()
               ShakeRemote:FireServer("Perfect")
               task.wait(0.45)

            else
               task.wait(math.random(1, 2))
               ReelIn:FireServer()
            end
         end)
         task.wait(0.1)
      end
      fishingThread = false
   end)
end

--// UI - Toggles
MainTab:CreateToggle({
   Name = "Auto Fishing",
   CurrentValue = false,
   Flag = "AutoFish",
   Callback = function(v)
      autoFish = v
      if v then startFishing() end
   end
})

MainTab:CreateToggle({
   Name = "Instant Fishing (Perfect)",
   CurrentValue = false,
   Flag = "InstantFish",
   Callback = function(v)
      instantFishing = v
      if v then blatantMode = false end
   end
})

MainTab:CreateToggle({
   Name = "Blatant Mode (Super Fast)",
   CurrentValue = false,
   Flag = "Blatant",
   Callback = function(v)
      blatantMode = v
      if v then instantFishing = false end
   end
})

--// Teleport Buttons
for name, pos in pairs(TPs) do
   TeleTab:CreateButton({
      Name = "Teleport to " .. name,
      Callback = function()
         teleport(pos)
      end
   })
end

--// Notify
Rayfield:Notify({
   Title = "HamzHub Loaded",
   Content = "Auto Fish + Instant + Teleport siap. Jangan rakus bro 😏",
   Duration = 4
})
