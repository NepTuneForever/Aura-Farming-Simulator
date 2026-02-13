local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Networker = require(ReplicatedStorage.Packages.Networker)
local CombatUtils = require(ReplicatedStorage.Shared.Services.CombatService.CombatUtils)

type CombatClient = {
    networker: any,
    Began: RBXScriptConnection?,
    ComboCount: number,
    LastAttackTime: number,
    IsAttacking: boolean,
    Animations: {Animation},
    AnimationTracks: {AnimationTrack},
    ComboResetConnection: RBXScriptConnection?,
    SetupClick: (self: CombatClient) -> (),
    SetupUI: (self: CombatClient) -> (),
    LoadAnimations: (self: CombatClient) -> (),
    PerformAttack: (self: CombatClient) -> (),
    PlayComboAnimation: (self: CombatClient, comboIndex: number) -> (),
    ResetCombo: (self: CombatClient) -> (),
    CheckComboReset: (self: CombatClient) -> (),
    ClearUpConnection: (self: CombatClient) -> {},
    init: (self: CombatClient) -> CombatClient,
}

local CombatClient: CombatClient = {} :: any

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local hotBar = PlayerGui:WaitForChild("Main"):FindFirstChild("Hotbar", true) :: CombatUtils.hotbar

function CombatClient.LoadAnimations(self: CombatClient)
    local character = Player.Character or Player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid") :: Humanoid
    
    self.Animations = {}
    self.AnimationTracks = {}
    
    for i, animId in ipairs(CombatUtils.ComboConfig.AnimationIds) do
        local animation = Instance.new("Animation")
        animation.AnimationId = animId
        animation.Name = "ComboAttack" .. i
        
        local animTrack = humanoid:FindFirstChildOfClass('Animator'):LoadAnimation(animation)
        animTrack.Priority = Enum.AnimationPriority.Action

        table.insert(self.Animations, animation)
        table.insert(self.AnimationTracks, animTrack)
    end
end

function CombatClient.PlayComboAnimation(self: CombatClient, comboIndex: number)
    if self.AnimationTracks[comboIndex] then
        for _, track in ipairs(self.AnimationTracks) do
            if track.IsPlaying then
                track:Stop(0.2)
            end
        end
        
        self.AnimationTracks[comboIndex]:Play(0.2)
    end
end

function CombatClient.PerformAttack(self: CombatClient)
    if self.IsAttacking then
        return
    end
    
    self.IsAttacking = true
    
    self.ComboCount += 1
    
    if self.ComboCount > CombatUtils.ComboConfig.MaxCombo then
        self.ComboCount = 1
    end
    
    self:PlayComboAnimation(self.ComboCount)
    
    -- Enviar ataque para o servidor para validação e dano
    self.networker:fire("PerformAttack", self.ComboCount)
    
    self.LastAttackTime = tick()
    
    if self.ComboCount == CombatUtils.ComboConfig.MaxCombo then
        task.wait(0.5)
        self:ResetCombo()
    end
    
    task.spawn(function()
        local success, delays = pcall(function()
            return self.networker:fetch('GetDelays')
        end)
        
        if success and delays then
            task.wait(delays.Attack)
        else
            task.wait(0.1)
        end
        
        self.IsAttacking = false
    end)
end

function CombatClient.ResetCombo(self: CombatClient)
    self.ComboCount = 0
    self.LastAttackTime = 0
end

function CombatClient.CheckComboReset(self: CombatClient)
    if self.ComboCount > 0 then
        local timeSinceLastAttack = tick() - self.LastAttackTime
        
        if timeSinceLastAttack >= CombatUtils.ComboConfig.ComboResetTime then
            self:ResetCombo()
        end
    end
end

function CombatClient.SetupClick(self: CombatClient)
    self.Began = UserInputService.InputBegan:Connect(function(input: InputObject, gp: boolean)
        if gp then
            return
        end
        
        if input.UserInputType == Enum.UserInputType.MouseButton1 
            or input.UserInputType == Enum.UserInputType.Touch then
            self:PerformAttack()
        end
    end)
    
    self.ComboResetConnection = RunService.Heartbeat:Connect(function()
        self:CheckComboReset()
    end)
end

function CombatClient.SetupUI(self: CombatClient)
end

function CombatClient.ClearUpConnection(self: CombatClient)
    if self.Began then
        self.Began:Disconnect()
    end
    
    if self.ComboResetConnection then
        self.ComboResetConnection:Disconnect()
    end
    
    for _, track in ipairs(self.AnimationTracks or {}) do
        if track.IsPlaying then
            track:Stop()
        end
    end
    
    return {}
end

function CombatClient.init(self: CombatClient)
    self.networker = Networker.client.new("CombatService", self, {
        self.SetupUI,
    })

    self.ComboCount = 0
    self.LastAttackTime = 0
    self.IsAttacking = false
    
    if Player.Character then
        self:LoadAnimations()
    end
    
    Player.CharacterAdded:Connect(function()
        self:ResetCombo()
        task.wait(0.1)
        self:LoadAnimations()
    end)
    
    self:SetupClick()

    Players.PlayerRemoving:Connect(function(playerRemoving: Player)
        if playerRemoving == Player then
            self:ClearUpConnection()
        end
    end)

    return self
end

return CombatClient