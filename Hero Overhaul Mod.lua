local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = game:GetService("Players").LocalPlayer
local chr = player.Character
if not chr or not chr.Parent then
    chr = player.CharacterAdded:Wait()
end
local pGui = player.PlayerGui
local mouse = player:GetMouse()
local playerlist = game:GetService("CoreGui").PlayerList.PlayerListMaster.OffsetFrame.PlayerScrollList.SizeOffsetFrame["ScrollingFrameContainer"]

local function checkPlayer(input)
    for i,v in pairs(game:GetService("Players"):GetChildren()) do
        if string.match(input, tostring(v)) or string.match(input, v.DisplayName) then
            return v
        end
    end
    return false
end

local function blinkUI(text, color)
    local tmp = Instance.new("ScreenGui")
    tmp.Name = "tmp"
    tmp.Parent = pGui

    local tmp2 = Instance.new("TextLabel")
    tmp2.BackgroundTransparency = 1
    tmp2.Size = UDim2.new(1, 0, .3, 0)
    tmp2.Position = UDim2.new(0, 0, .3, 0)
    tmp2.Font = "GothamBold"
    tmp2.TextColor3 = color
    tmp2.Text = text
    tmp2.TextSize = 30
    tmp2.Parent = tmp
    task.wait(.5)
    tmp:Destroy()
end

local function Darkseid()
    local function boomTube(pos)
        local _, yRot, _ = pos:ToOrientation()
        pos = CFrame.new(pos.Position) * CFrame.fromOrientation(0, yRot, 0)
        local args = {
            [1] = "Breach",
            [2] = pos
        }
        
        player.Character.Darkseid.Remote:FireServer(unpack(args))
    end

    local beamBounce = false
    local function omegaBeam(pos, cheatMode)
        if not beamBounce or cheatMode then
            local args = {
                [1] = "OmegaBeams",
                [2] = pos
            }
            
            game:GetService("Players").LocalPlayer.Character.Darkseid.Remote:FireServer(unpack(args))
            if not cheatMode then
                task.spawn(function()
                    beamBounce = true
                    task.wait(3)
                    beamBounce = false
                end)
            end
        end
    end

    local function makeUI(template)
        if playerlist:FindFirstChild("PlayerDropDown") then
            local template = template or playerlist.PlayerDropDown.InnerFrame.InspectButton

            playerlist.PlayerDropDown.Size = playerlist.PlayerDropDown.Size + UDim2.new(0, 0, 0, (56*2))

            local boomOption = template:Clone()
            boomOption.Name = "boomOption"
            boomOption.HoverBackground.Text.Text = "Open Boom Tube"
            boomOption.HoverBackground.Icon.Image = "rbxassetid://12322345384"
            boomOption.HoverBackground.Icon.ImageRectOffset = Vector2.new(0,0)
            boomOption.HoverBackground.Icon.ImageRectSize = Vector2.new(0,0)
            boomOption.Parent = template.Parent

            local zapOption = boomOption:Clone()
            zapOption.Name = "zapOption"
            zapOption.HoverBackground.Text.Text = "Homing Omega Beams"
            zapOption.HoverBackground.Icon.Image = "rbxassetid://12324101732"
            zapOption.HoverBackground.Icon.ImageColor3 = Color3.fromRGB(255, 0, 0)
            zapOption.Parent = template.Parent

            boomOption.MouseEnter:Connect(function()
                boomOption.BackgroundColor3 = Color3.fromRGB(45, 47, 49)
            end)

            boomOption.MouseLeave:Connect(function()
                boomOption.BackgroundColor3 = Color3.fromRGB(25, 27, 29)
            end)

            boomOption.MouseButton1Click:Connect(function()
                local target = checkPlayer(string.gsub(playerlist.PlayerDropDown.InnerFrame.PlayerHeader.Background.TextContainerFrame.PlayerName.Text, "^@?", ""))
                if target then
                    local targetChr = target.Character
                    if targetChr and targetChr.Parent then
                        local targetRoot = targetChr:WaitForChild("HumanoidRootPart")
                        local pos = targetRoot.CFrame - (targetRoot.CFrame.LookVector * 10)
                        pos = pos + Vector3.new(0, 2.5, 0)
                        boomTube(pos)
                    end
                end
            end)

            zapOption.MouseEnter:Connect(function()
                zapOption.BackgroundColor3 = Color3.fromRGB(45, 47, 49)
            end)

            zapOption.MouseLeave:Connect(function()
                zapOption.BackgroundColor3 = Color3.fromRGB(25, 27, 29)
            end)

            local cheatMode
            zapOption.MouseButton1Click:Connect(function()
                local target = checkPlayer(string.gsub(playerlist.PlayerDropDown.InnerFrame.PlayerHeader.Background.TextContainerFrame.PlayerName.Text, "^@?", ""))
                if target then
                    local targetChr = target.Character
                    if targetChr and targetChr.Parent then
                        local targetRoot = targetChr:WaitForChild("HumanoidRootPart")
                        local targetPos = targetRoot.CFrame + targetRoot.AssemblyLinearVelocity
                        if cheatMode then
                            omegaBeam(targetPos, true)
                        else
                            omegaBeam(targetPos)
                        end
                    end
                end
            end)

            zapOption.MouseButton2Click:Connect(function()
                cheatMode = not cheatMode
                if cheatMode then
                    zapOption.HoverBackground.Text.TextColor3 = Color3.new(0, 255, 0)
                    zapOption.HoverBackground.Text.Text = "Cheat Mode Activated"
                    task.wait(.5)
                    zapOption.HoverBackground.Text.TextColor3 = Color3.fromRGB(255,255,255)
                    zapOption.HoverBackground.Text.Text = "Homing Omega Beams"
                else
                    zapOption.HoverBackground.Text.TextColor3 = Color3.new(255, 0, 0)
                    zapOption.HoverBackground.Text.Text = "Cheat Mode Deactivated"
                    task.wait(.5)
                    zapOption.HoverBackground.Text.TextColor3 = Color3.fromRGB(255,255,255)
                    zapOption.HoverBackground.Text.Text = "Homing Omega Beams"
                end
            end)
        end
    end

    local tubeDtct
    tubeDtct = mouse.Button1Down:Connect(function()
        if UIS:IsKeyDown(Enum.KeyCode.G) then
            local cords = mouse.Hit + Vector3.new(0, 5.5, 0)
            boomTube(cords)
        end
    end)

    local lstDtct
    lstDtct = playerlist.ChildAdded:Connect(function(child)
        if child.Name == "PlayerDropDown" then
            makeUI(child.InnerFrame.InspectButton)
        end
    end)

    player.Character:WaitForChild("Humanoid").Died:Connect(function()
        tubeDtct:Disconnect()
        lstDtct:Disconnect()
        if playerlist:FindFirstChild("PlayerDropDown") then
            for i,v in pairs(playerlist.PlayerDropDown:GetDescendants()) do
                if v.Name == "boomOption" or v.Name == "zapOption" then
                    v:Destroy()
                end
            end
        end
    end)

    makeUI(nil)
    return true
end

local function Cicada()
    local customWeapons = {
        ["Sentient Blade"] = {Enum.KeyCode.Five, false, false},
        ["Knife Swarm"] = {Enum.KeyCode.Six, false, false}
    }

    local function changeWeapon(weapon)
        for i,v in pairs(customWeapons) do
            if i ~= weapon then
                v[2] = false
            end
        end
    end

    local cheatMode
    local function sentientBlade(pos)
        if not customWeapons["Sentient Blade"][3] or cheatMode then
            local target
            local proximity = math.huge
            for i,v in pairs(game:GetService("Players"):GetPlayers()) do
                local targetChr = v.Character
                if targetChr and targetChr.Parent and targetChr:FindFirstChild("HumanoidRootPart") then
                    local distance = (pos - targetChr.HumanoidRootPart.Position).Magnitude
                    if distance <= proximity then
                    proximity = distance
                    target = v
                    end
                end
            end
            local args = {
                [1] = "ThrowDagger",
                [2] = target.Character.HumanoidRootPart.Position,
                [3] = target.Character.HumanoidRootPart
            }
            
            game:GetService("Players").LocalPlayer.Character.Cicada.Remote:FireServer(unpack(args))
        end
    end

    local function knifeSwarm(range, knives, flare)
        if not customWeapons["Knife Swarm"][3] or cheatMode then
            local targets = {}
            for i,v in pairs(game:GetService("Players"):GetPlayers()) do
                local targetChr = v.Character
                if targetChr and targetChr.Parent and targetChr:FindFirstChild("HumanoidRootPart") and targetChr ~= chr then
                    local distance = (chr:WaitForChild("HumanoidRootPart").Position - targetChr.HumanoidRootPart.Position).Magnitude
                    if distance <= range then
                        table.insert(targets, v)
                    end
                end
            end

            for i = 1, flare do
                local target = player
                local args = {
                    [1] = "ThrowDagger",
                    [2] = target.Character.HumanoidRootPart.Position,
                    [3] = target.Character.HumanoidRootPart
                }
                
                game:GetService("Players").LocalPlayer.Character.Cicada.Remote:FireServer(unpack(args))
                task.wait()
            end

            for i = 1, knives do
                if #targets == 0  then
                    target = player
                else
                    target = targets[math.random(1, #targets)]
                end
                local args = {
                    [1] = "ThrowDagger",
                    [2] = target.Character.HumanoidRootPart.Position,
                    [3] = target.Character.HumanoidRootPart
                }
                
                game:GetService("Players").LocalPlayer.Character.Cicada.Remote:FireServer(unpack(args))
                task.wait()
            end
        end
    end

    local function switchUI(text)
        task.spawn(function()
            local tmp = RS.GUIs.AttackGui:Clone()
            if customWeapons[text][2] then
                tmp.Frame.TextLabel.Text = text
            else
                tmp.Frame.TextLabel.Text = "None"
            end
            tmp.Parent = pGui
            task.wait(1)
            tmp:Destroy()
        end)
    end

    local iDtct
    iDtct = UIS.InputBegan:Connect(function(iObj, GPE)
        local nonCustom = {
            Enum.KeyCode.One,
            Enum.KeyCode.Two,
            Enum.KeyCode.Three,
            Enum.KeyCode.Four,
        }
        if GPE then return end
        if iObj.KeyCode == customWeapons["Sentient Blade"][1] then
            task.spawn(function()
                local num = 0
                while UIS:IsKeyDown(customWeapons["Sentient Blade"][1]) and num < 5 do
                    task.wait(1)
                    num = num + 1
                end
                if num >= 3 then
                    num = 0
                    cheatMode = not cheatMode
                    if cheatMode then
                        blinkUI("Cheat Mode Activated", Color3.fromRGB(0, 255, 0))
                    else
                        blinkUI("Cheat Mode Deactivated", Color3.fromRGB(255, 0, 0))
                    end
                end
            end)
            customWeapons["Sentient Blade"][2] = not customWeapons["Sentient Blade"][2]
            changeWeapon("Sentient Blade")
            local mDtct
            mDtct = mouse.Button1Down:Connect(function()
                if customWeapons["Sentient Blade"][2] then
                    sentientBlade(mouse.Hit.Position)
                    if not cheatMode then
                        local changeDtct
                        changeDtct = player.Character.Morph.RightHand1.MeshPart1:GetPropertyChangedSignal("Transparency"):Connect(function()
                            if player.Character.Morph.RightHand1.MeshPart1.Transparency == 1 then
                                changeDtct:Disconnect()
                                customWeapons["Sentient Blade"][3] = true

                                task.spawn(function()
                                    repeat
                                        task.wait()
                                    until player.Character.Morph.RightHand1.MeshPart1.Transparency == 0
                                    customWeapons["Sentient Blade"][3] = false
                                end)
                            end
                        end)
                    end
                else
                    mDtct:Disconnect()
                end
            end)
            switchUI("Sentient Blade")
        elseif iObj.KeyCode == customWeapons["Knife Swarm"][1] then
            customWeapons["Knife Swarm"][2] = not customWeapons["Knife Swarm"][2]
            changeWeapon("Knife Swarm")
            local mDtct
            mDtct = mouse.Button1Down:Connect(function()
                if customWeapons["Knife Swarm"][2] then
                    knifeSwarm(30, 10, 10)
                    if not cheatMode then
                        customWeapons["Knife Swarm"][3] = true
                        task.spawn(function()
                            task.wait(10)
                            customWeapons["Knife Swarm"][3] = false
                        end)
                    end
                else
                    mDtct:Disconnect()
                end
            end)
            switchUI("Knife Swarm")
        elseif table.find(nonCustom, iObj.KeyCode) then
            for i,v in pairs(customWeapons) do
                v[2] = false
            end
        end
    end)

    player.Character:WaitForChild("Humanoid").Died:Connect(function()
        iDtct:Disconnect()
        cheatMode = false
        for i,v in pairs(customWeapons) do
            v[2],v[3] = false, false
        end
    end)
    return true
end

local function loadCharacter(name, demoMode)
    if name ~= "" or nil then
        local lower = string.lower(name)
        local valid
        if string.match(lower, "darkseid") then
            valid = Darkseid()
        elseif string.match(lower, "cicada") then
            valid = Cicada()
        end

        if valid then
            repeat
                task.wait()
            until pGui.LoadingScreen.Loading.Visible == false
            local tmp = Instance.new("ScreenGui")
            tmp.Name = "tmp"
            tmp.Parent = pGui

            local tmp2 = Instance.new("TextLabel")
            tmp2.BackgroundTransparency = 1
            tmp2.Size = UDim2.new(1, 0, .3, 0)
            tmp2.Position = UDim2.new(0, 0, .3, 0)
            tmp2.Font = "GothamBold"
            tmp2.TextColor3 = Color3.fromRGB(255, 255, 255)
            tmp2.Text = name .. " Mod Active"
            tmp2.TextSize = 30
            tmp2.Parent = tmp
            task.wait(2)

            if demoMode then
                for i,v in pairs(playerlist.ScrollingFrameClippingFrame:GetDescendants()) do
                    if v:IsA("TextLabel") and v.Text == tostring(player) then
                        local alpha = {"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"}
                        local encrypt = ""
                        for i = 1,10 do
                            encrypt = encrypt .. alpha[math.random(1,26)]
                        end
                        v.Font = "Gotham"
                        v.TextTransparency = 0.3
                        v.Text = encrypt
                        v.Parent.Parent:FindFirstChildOfClass("ImageLabel").Image = ""
                    end
                end

                local tmp3 = tmp2:Clone()
                tmp3.TextTransparency = 1
                tmp3.Size = UDim2.new(0, 0, .3, 0)
                tmp3.Position = UDim2.new(.5, 0, .3, 30)
                tmp3.Text = "-- Demo Mode --"
                tmp3.TextSize = 0
                tmp3.Parent = tmp

                local tween = TweenService:Create(tmp3, TweenInfo.new(1), {Size = UDim2.new(1, 0, .3, 0), Position = UDim2.new(0, 0, .3, 30), TextTransparency = 0, TextSize = 25})
                tween:Play()
                tween.Completed:Wait()
                task.wait(2)

                local tween2 = TweenService:Create(tmp2, TweenInfo.new(1), {TextTransparency = 1})
                local tween3 = TweenService:Create(tmp3, TweenInfo.new(1), {TextTransparency = 1})

                tween2:Play()
                tween3:Play()
                tween3.Completed:Wait()
            else
                local tween = TweenService:Create(tmp2, TweenInfo.new(1), {TextTransparency = 1})
                tween:Play()
                tween.Completed:Wait()
            end
            tmp:Destroy()
        end
    end
end

local cName
local old
old = hookmetamethod(game, "__namecall", function(self, ...)
  local args = {...}
  if not(checkcaller()) and self.Name == "MorphEvent" and args[1] then
    task.spawn(function()
        cName = args[1]
    end)
  end
  return old(self, ...)
end)

local demoMode = true
player.CharacterAdded:Connect(function(character)
    chr = character
    if cName then
        loadCharacter(cName, demoMode)
        cName = ""
    end
end)

if demoMode then
    task.spawn(function()
        while demoMode do
            local garrble = ""
            for i = 1,5 do
                garrble = garrble .. tostring(math.random(0,9))
            end
            pGui:WaitForChild("Main").TB.Flashcoins.TextLabel.Text = garrble
            task.wait()
        end
    end)
end